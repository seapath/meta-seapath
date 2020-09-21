DESCRIPTION = "Intel(r) Data Plane Development Kit"
HOMEPAGE = "http://dpdk.org"

STABLE = ""

S = "${WORKDIR}/${PN}${STABLE}-${PV}"

SRC_URI = " \
        https://fast.dpdk.org/rel/dpdk-${PV}.tar.xz;name=libtar \
        file://dpdk-16.04-add-RTE_KERNELDIR_OUT-to-split-kernel-bu.patch \
        file://dpdk-16.07-add-sysroot-option-within-app-makefile.patch \
"

COMPATIBLE_MACHINE = "null"
COMPATIBLE_HOST_libc-musl_class-target = "null"
COMPATIBLE_HOST_linux-gnux32 = "null"

# dpdk example apps dpdk_qat and vhost have dependancy on fuse and qat.
# fuse is in meta-filesystems and qat is not yet upstreamed.
# So adding mechanism to explicitly disable the use of fuse and qat.
# To enable, uncomment the below line or include in .bbappend.
# PACKAGECONFIG ?= " dpdk_qat vhost libvirt"

PACKAGECONFIG[dpdk_qat] = ",,virtual/qat"
PACKAGECONFIG[vhost] = ",,fuse"
PACKAGECONFIG[libvirt] = ",,libvirt"
PACKAGECONFIG[numa] = ",,numactl"

export CONFIG_EXAMPLE_DPDK_QAT = "${@bb.utils.contains('PACKAGECONFIG', 'dpdk_qat', 'y', 'n', d)}"
export CONFIG_EXAMPLE_VM_POWER_MANAGER = "${@bb.utils.contains('PACKAGECONFIG', 'libvirt', 'y', 'n', d)}"
export CONFIG_VHOST_ENABLED = "${@bb.utils.contains('PACKAGECONFIG', 'vhost', 'y', 'n', d)}"
export CONFIG_HAVE_NUMA = "${@bb.utils.contains('PACKAGECONFIG', 'numa', 'y', 'n', d)}"

# Don't use the default value of datadir and let the dpdk set it to a dpdk
# specific directory
datadir[unexport] = "1"

RDEPENDS_${PN} += "python3-core"
DEPENDS = "virtual/kernel"
do_configure[depends] += "virtual/kernel:do_shared_workdir"

inherit module

export MODULE_DIR="${nonarch_base_libdir}/modules/${KERNEL_VERSION}/kernel/drivers/net"
export RTE_SDK = "${S}"

export ICP_ROOT = "${PKG_CONFIG_SYSROOT_DIR}/usr/include"
export ICP_LIB_ROOT= "${PKG_CONFIG_SYSROOT_DIR}/usr/lib"
export RTE_KERNELDIR = "${STAGING_KERNEL_DIR}"
export RTE_KERNELDIR_OUT = "${STAGING_KERNEL_BUILDDIR}"
export INSTALL_PATH = "${prefix}/share/dpdk"
export RTE_OUTPUT = "${S}/${RTE_TARGET}"
export ETHTOOL_LIB_PATH = "${S}/examples/ethtool/lib/${RTE_TARGET}/"
export SYSROOTPATH = "--sysroot=${STAGING_DIR_HOST}"
export DPDK_TARGET_MACH = "${@get_dpdk_target_mach(bb,d)}"
export ICP_LAC_API_DIR = "${STAGING_DIR_TARGET}${includedir}/lac"

export EXAMPLES_BUILD_DIR = "${RTE_TARGET}"
export ARCHDIR = "generic"

DPDK_RTE_TARGET_x86-64 = "x86_64-native-linuxapp-gcc"
DPDK_RTE_TARGET_x86 = "i686-native-linuxapp-gcc"
DPDK_RTE_TARGET_aarch64 = "arm64-${DPDK_TARGET_MACH}-linuxapp-gcc"
export RTE_TARGET = "${DPDK_RTE_TARGET}"

CONFIG_NAME = "common_linux"
TEST_DIR = "test"

# The list of intel Comms platforms and their target machine
# process mapping. The supported target machine is listed under
# dpdk/mk/machine
def get_dpdk_target_mach(bb, d):
    target_arch = d.getVar('DPDK_TARGET_MACHINE', True)
    if target_arch:
            return target_arch
    return "default"

do_configure () {
	#############################################################
	### default value for prefix is "usr", unsetting it, so it
	### will not be concatenated in ${RTE_TARGET}/Makefile
	### which will cause compilation failure
	#############################################################
	unset prefix

	# Fix-up CONFIG_RTE_MACHINE based on target machine
	sed -e "s#CONFIG_RTE_MACHINE=\"native\"#CONFIG_RTE_MACHINE=\"${DPDK_TARGET_MACH}\"#" -i ${S}/config/defconfig_${RTE_TARGET}

	# Fix-up vhost configs based on package config
	sed -e "s#CONFIG_RTE_KNI_VHOST=n#CONFIG_RTE_KNI_VHOST=${CONFIG_VHOST_ENABLED}#" -i ${S}/config/${CONFIG_NAME}
	sed -e "s#CONFIG_RTE_KNI_VHOST_VNET_HDR_EN=n#CONFIG_RTE_KNI_VHOST_VNET_HDR_EN=${CONFIG_VHOST_ENABLED}#" -i ${S}/config/${CONFIG_NAME}
	sed -e "s#CONFIG_RTE_LIBRTE_VHOST=n#CONFIG_RTE_LIBRTE_VHOST=${CONFIG_VHOST_ENABLED}#" -i ${S}/config/${CONFIG_NAME}
	sed -e "s#CONFIG_RTE_LIBRTE_VHOST_NUMA=.*#CONFIG_RTE_LIBRTE_VHOST_NUMA=${CONFIG_HAVE_NUMA}#" -i ${S}/config/${CONFIG_NAME}
	sed -e "s#CONFIG_RTE_EAL_NUMA_AWARE_HUGEPAGES=.*#CONFIG_RTE_EAL_NUMA_AWARE_HUGEPAGES=${CONFIG_HAVE_NUMA}#" -i ${S}/config/${CONFIG_NAME}

	# Fix-up CONFIG_RTE_LIBRTE_POWER based on package config for libvirt
	sed -e "s#CONFIG_RTE_LIBRTE_POWER=y#CONFIG_RTE_LIBRTE_POWER=${CONFIG_EXAMPLE_VM_POWER_MANAGER}#" -i ${S}/config/${CONFIG_NAME}

	make O=$RTE_TARGET T=$RTE_TARGET config
}

do_compile () {
	unset LDFLAGS TARGET_LDFLAGS BUILD_LDFLAGS

	cd ${S}/${RTE_TARGET}
	oe_runmake EXTRA_LDFLAGS="-L${STAGING_LIBDIR} --hash-style=gnu" \
		   EXTRA_CFLAGS="${HOST_CC_ARCH} ${TOOLCHAIN_OPTIONS} -I${STAGING_INCDIR}" \
		   CROSS="${TARGET_PREFIX}" \
		   prefix=""  LDFLAGS="${TUNE_LDARGS}"  WERROR_FLAGS="-w" V=1

	cd ${S}/examples/
	oe_runmake EXTRA_LDFLAGS="-L${STAGING_LIBDIR} --hash-style=gnu -fuse-ld=bfd" \
		   EXTRA_CFLAGS="${HOST_CC_ARCH} ${TOOLCHAIN_OPTIONS} -O3 -I${STAGING_INCDIR}" \
		   CROSS="${TARGET_PREFIX}" O="${S}/examples/$@/"

	cd ${S}/${TEST_DIR}/
	oe_runmake EXTRA_LDFLAGS="-L${STAGING_LIBDIR} --hash-style=gnu -fuse-ld=bfd" \
		   EXTRA_CFLAGS="${HOST_CC_ARCH} ${TOOLCHAIN_OPTIONS} -O3 -I${STAGING_INCDIR}" \
		   CROSS="${TARGET_PREFIX}" O="${S}/${TEST_DIR}/$@/"
}

do_install () {
	oe_runmake O=${RTE_OUTPUT} T= install-runtime DESTDIR=${D}
	oe_runmake O=${RTE_OUTPUT} T= install-kmod DESTDIR=${D} kerneldir=${MODULE_DIR}
	oe_runmake O=${RTE_OUTPUT} T= install-sdk DESTDIR=${D}

	# Install examples
	for dirname in ${S}/examples/*
	do
		install -m 0755 -d ${D}/${INSTALL_PATH}/examples/`basename ${dirname}`

		for appname in `find ${dirname} -regex ".*${EXAMPLES_BUILD_DIR}\/app\/[-0-9a-zA-Z0-9/_]*$"`
		do
			install -m 755 ${appname}	${D}/${INSTALL_PATH}/examples/`basename ${dirname}`/
		done
	done

	# Install test
	for dirname in ${S}/${TEST_DIR}/app/*
	do
		install -m 0755 -d ${D}/${INSTALL_PATH}/test

		for appname in `find ${dirname} -regex ".*test\/app\/[-0-9a-zA-Z0-9/_]*$"`
		do
			install -m 755 ${appname} ${D}/${INSTALL_PATH}/test
		done
	done

	cp -r ${S}/mk ${D}${INSTALL_PATH}/

	for ss in $(find ${D} -type f -name "*.py"); do
		sed -i -e "1s,#!.*python.*,#!${USRBINPATH}/env python3," ${ss}
	done
}

PACKAGES += "${PN}-examples ${PN}-test"

FILES_${PN}-dbg += " \
	${INSTALL_PATH}/.debug \
	${INSTALL_PATH}/examples/*/.debug \
	"

FILES_${PN}-doc += "\
	${INSTALL_PATH}/doc \
	"

FILES_${PN}-dev += " \
	${INSTALL_PATH}/${RTE_TARGET}/.config \
	${includedir} \
	${includedir}/${ARCHDIR} \
	${includedir}/exec-env \
	${INSTALL_PATH}/buildtools/ \
	${INSTALL_PATH}/${RTE_TARGET}/include \
	${INSTALL_PATH}/${RTE_TARGET}/lib \
	${INSTALL_PATH}/mk \
	"

FILES_${PN} += " ${INSTALL_PATH}/usertools/ \
		 ${prefix}/sbin/ \
		 ${prefix}/bin/ \
		 ${libdir}/ \
		 "
FILES_${PN}-examples += " \
	${INSTALL_PATH}/examples/* \
	"

FILES_${PN}-test += " \
	${INSTALL_PATH}/test \
	"

CVE_PRODUCT = "data_plane_development_kit"
