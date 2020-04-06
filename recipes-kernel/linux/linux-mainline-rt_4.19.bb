require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=git;name=machine;tag=v4.19.106-rt44;nobranch=1; \
        file://defconfig; \
        file://kvm_guest_tuning.cfg \
        file://networking.cfg \
        file://openvswitch.cfg \
        file://virtualization.cfg \
"

LINUX_VERSION ?= "4.19"
LINUX_VERSION_EXTENSION_append = "-mainline-rt"

S = "${WORKDIR}/git"
PV = "${LINUX_VERSION}+git${SRCPV}"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(votp)"
