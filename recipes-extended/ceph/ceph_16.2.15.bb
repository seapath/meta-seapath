# SPDX-License-Identifier: Apache-2.0
# Based on ceph_18.2.2.bb from meta-virtualization commit e5878c864aacd24fe8f09ab7221f0ada13cd22d3
# https://git.yoctoproject.org/meta-virtualization/plain/recipes-extended/ceph/ceph_18.2.2.bb?h=scarthgap&id=e5878c864aacd24fe8f09ab7221f0ada13cd22d3

SUMMARY = "User space components of the Ceph file system"
LICENSE = "LGPL-2.1-only & GPL-2.0-only & Apache-2.0 & MIT"
LIC_FILES_CHKSUM = "file://COPYING-LGPL2.1;md5=fbc093901857fcd118f065f900982c24 \
                    file://COPYING-GPL2;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://COPYING;md5=d140fb1fedb53047f0d0830883e7af9f \
"
inherit cmake pkgconfig python3native python3-dir systemd useradd
# Disable python pybind support for ceph temporary, when corss compiling pybind,
# pybind mix cmake and python setup environment, would case a lot of errors.

SRC_URI = "http://download.ceph.com/tarballs/ceph-${PV}.tar.gz \
           file://0001-avoid-to_string-error.patch \
           file://0001-delete-install-layout-deb.patch \
           file://0002-cmake-allow-use-libzstd-in-system.patch \
           file://0001-ceph-fix-missing-fix-missing-headers.patch \
"

SRC_URI[sha256sum] = "8c480ecbae9b8231de4abf49b14fac4c4f727459c53034c5682fe6125680a4cc"

DEPENDS = "boost bzip2 curl cryptsetup expat gperf-native \
           keyutils libaio libibverbs lua lz4 \
           nspr nss ninja-native \
           oath openldap openssl \
           python3 python3-native python3-cython-native python3-pyyaml-native \
	   rabbitmq-c rocksdb snappy thrift udev \
           valgrind xfsprogs zlib libgcc zstd re2 \
"

OECMAKE_C_COMPILER = "${@oecmake_map_compiler('CC', d)[0]} --sysroot=${RECIPE_SYSROOT}"
OECMAKE_CXX_COMPILER = "${@oecmake_map_compiler('CXX', d)[0]} --sysroot=${RECIPE_SYSROOT}"
USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "--system --user-group --home-dir /var/lib/ceph --shell /sbin/nologin ceph"

SYSTEMD_SERVICE:${PN} = " \
        ceph-radosgw@.service \
        ceph-radosgw.target \
        ceph-mon@.service \
        ceph-mon.target \
        ceph-mds@.service \
        ceph-mds.target \
        ceph-osd@.service \
        ceph-osd.target \
        cephfs-mirror@.service \
        cephfs-mirror.target \
        ceph.target \
        ceph-rbd-mirror@.service \
        ceph-rbd-mirror.target \
        ceph-volume@.service \
        ceph-mgr@.service \
        ceph-mgr.target \
        ceph-crash.service \
        rbdmap.service \
        ceph-immutable-object-cache@.service \
        ceph-immutable-object-cache.target \
"

EXTRA_OECMAKE += "-DWITH_MANPAGE=OFF \
                 -DWITH_JAEGER=OFF \
                 -DWITH_SYSTEM_ZSTD=ON \
                 -DWITH_FUSE=OFF \
                 -DWITH_SPDK=OFF \
                 -DWITH_LEVELDB=OFF \
                 -DWITH_LTTNG=OFF \
                 -DWITH_BABELTRACE=OFF \
                 -DWITH_TESTS=OFF \
                 -DWITH_RADOSGW_SELECT_PARQUET=OFF \
                 -DWITH_RADOSGW_ARROW_FLIGHT=OFF \
                 -DWITH_MGR=OFF \
                 -DWITH_MGR_DASHBOARD_FRONTEND=OFF \
                 -DWITH_SYSTEM_BOOST=ON \
                 -DWITH_SYSTEM_ROCKSDB=ON \
                 -DWITH_RDMA=OFF \
                 -DWITH_RADOSGW_AMQP_ENDPOINT=OFF \
                 -DWITH_RADOSGW_KAFKA_ENDPOINT=OFF \
                 -DWITH_REENTRANT_STRSIGNAL=ON \
                 -DWITH_PYTHON3=3.12 \
                 -DPYTHON_DESIRED=3 \
                 -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${WORKDIR}/toolchain.cmake \
"

do_configure:prepend () {
	echo "set( CMAKE_SYSROOT \"${RECIPE_SYSROOT}\" )" >> ${WORKDIR}/toolchain.cmake
	echo "set( CMAKE_DESTDIR \"${D}\" )" >> ${WORKDIR}/toolchain.cmake
	echo "set( PYTHON_SITEPACKAGES_DIR \"${PYTHON_SITEPACKAGES_DIR}\" )" >> ${WORKDIR}/toolchain.cmake
	# echo "set( CMAKE_C_COMPILER_WORKS TRUE)" >> ${WORKDIR}/toolchain.cmake
	# echo "set( CMAKE_CXX_COMPILER_FORCED TRUE)" >> ${WORKDIR}/toolchain.cmake
	echo "set( CMAKE_C_COMPILER_FORCED TRUE )" >> ${WORKDIR}/toolchain.cmake
}

do_install:append () {
	sed -i -E -e 's:^#!.*python[3]?:#!'"${bindir}/python3:" \
		${D}${bindir}/ceph ${D}${bindir}/ceph-crash \
		${D}${bindir}/cephfs-top \
		${D}${sbindir}/ceph-volume ${D}${sbindir}/ceph-volume-systemd
	find ${D} -name SOURCES.txt | xargs sed -i -e 's:${WORKDIR}::'
	install -d ${D}${sysconfdir}/ceph
	install -d ${D}${systemd_unitdir}
	mv ${D}${libexecdir}/systemd/system ${D}${systemd_unitdir}
	mv ${D}${libexecdir}/ceph/ceph-osd-prestart.sh ${D}${libdir}/ceph
	mv ${D}${libexecdir}/ceph/ceph_common.sh ${D}${libdir}/ceph
	# WITH_FUSE is set to OFF, remove ceph-fuse related units
	rm ${D}${systemd_unitdir}/system/ceph-fuse.target ${D}${systemd_unitdir}/system/ceph-fuse@.service
}

do_install:append:class-target () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/tmpfiles.d
		echo "d /var/lib/ceph/crash/posted 0755 root root - -" > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/default/volatiles
		echo "d root root 0755 /var/lib/ceph/crash/posted none" > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
	fi
}

pkg_postinst:${PN}() {
	if [ -z "$D" ] && [ -e ${sysconfdir}/init.d/populate-volatile.sh ] ; then
		${sysconfdir}/init.d/populate-volatile.sh update
	fi
}

FILES:${PN} += "\
		${libdir}/rados-classes/*.so.* \
		${libdir}/ceph/compressor/*.so \
		${libdir}/rados-classes/*.so \
		${libdir}/ceph/*.so \
		${libdir}/libcephsqlite.so \
"

FILES:${PN} += "\
/etc/tmpfiles.d/ceph-placeholder.conf \
    /etc/default/volatiles/99_ceph-placeholder \
"

FILES:${PN}-dev = "\
    ${includedir} \
    ${libdir}/libcephfs.so \
    ${libdir}/librados*.so \
    ${libdir}/librbd.so \
    ${libdir}/librgw.so \
"

FILES:${PN}-python = "\
                ${PYTHON_SITEPACKAGES_DIR}/* \
"
RDEPENDS:${PN} += "\
		python3-core \
		python3-misc \
		python3-modules \
		python3-prettytable \
		${PN}-python \
		gawk \
		bash \
"
COMPATIBLE_HOST = "(x86_64).*"
PACKAGES += "\
	${PN}-python \
"
INSANE_SKIP:${PN}-python += "ldflags buildpaths"
INSANE_SKIP:${PN} += "dev-so"
INSANE_SKIP:${PN}-dbg += "buildpaths"

CVE_PRODUCT = "ceph ceph_storage ceph_storage_mon ceph_storage_osd"
