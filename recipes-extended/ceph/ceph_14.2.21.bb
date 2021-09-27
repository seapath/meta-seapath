# This file was import from git.yoctoproject.org/meta-virtualization

SUMMARY = "User space components of the Ceph file system"
LICENSE = "LGPLv2.1 & GPLv2 & Apache-2.0 & MIT"
LIC_FILES_CHKSUM = "file://COPYING-LGPL2.1;md5=fbc093901857fcd118f065f900982c24 \
                    file://COPYING-GPL2;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://COPYING;md5=601c21a554d728c3038ca292b83b8af0 \
"
inherit cmake python3native python3-dir systemd useradd
# Disable python pybind support for ceph temporary, when corss compiling pybind,
# pybind mix cmake and python setup environment, would case a lot of errors.

SRC_URI = "http://download.ceph.com/tarballs/ceph-${PV}.tar.gz \
           file://0001-ceph-fix-build-errors-for-cross-compile.patch \
           file://0001-Add-LDFLAGS-when-linking-cython-libraries.patch \
"
SRC_URI[md5sum] = "80c75b5421665fd1e412d29ce74313a2"
SRC_URI[sha256sum] = "bcedc6a89dd660728b61299e8e12556e3782565c44a75e270016a9736bee0dc2"

def limit_parallel(limit):
   import multiprocessing
   nproc = min(multiprocessing.cpu_count(), int(limit))
   return "-j{}".format(nproc)

PARALLEL_MAKE = "${@limit_parallel(8)}"

DEPENDS = "boost bzip2 curl expat gperf-native \
           keyutils libaio libibverbs lz4 \
           nspr nss \
           oath openldap openssl \
           python3-cython-native python3-setuptools-native rabbitmq-c rocksdb snappy udev \
           valgrind xfsprogs zlib boost \
"

USERADD_PACKAGES= "${PN}"
USERADD_PARAM_${PN} = "--system --no-create-home --home-dir /var/lib/ceph \
    --shell /bin/nologin --user-group -c 'Ceph daemons' ceph"


SYSTEMD_SERVICE_${PN} = " \
	ceph-radosgw@.service \
	ceph-radosgw.target \
        ceph-mon@.service \
	ceph-mon.target \
        ceph-mds@.service \
	ceph-mds.target \
        ceph-osd@.service \
	ceph-osd.target \
        ceph.target \
	ceph-rbd-mirror@.service \
	ceph-rbd-mirror.target \
	ceph-volume@.service \
	ceph-mgr@.service \
	ceph-mgr.target \
	ceph-crash.service \
	rbdmap.service \
"
OECMAKE_GENERATOR = "Unix Makefiles"

EXTRA_OECMAKE = "-DWITH_MANPAGE=OFF \
                 -DWITH_FUSE=OFF \
                 -DWITH_SPDK=OFF \
                 -DWITH_LEVELDB=OFF \
                 -DWITH_LTTNG=OFF \
                 -DWITH_BABELTRACE=OFF \
                 -DWITH_TESTS=OFF \
                 -DWITH_MGR=ON \
                 -DWITH_MGR_DASHBOARD_FRONTEND=OFF \
                 -DWITH_SYSTEM_BOOST=ON \
                 -DWITH_SYSTEM_ROCKSDB=ON \
                 -DWITH_RDMA=OFF \
                 -DWITH_RADOSGW_AMQP_ENDPOINT=OFF \
                 -DWITH_RADOSGW_KAFKA_ENDPOINT=OFF \
                 -DENABLE_GIT_VERSION=OFF \
                 -DMGR_PYTHON_VERSION=3.8 \
                 -DWITH_PYTHON3=3.8 \
"

do_configure_prepend () {
	echo "set( CMAKE_SYSROOT \"${RECIPE_SYSROOT}\" )" >> ${WORKDIR}/toolchain.cmake
	echo "set( CMAKE_DESTDIR \"${D}\" )" >> ${WORKDIR}/toolchain.cmake
	echo "set( PYTHON_SITEPACKAGES_DIR \"${PYTHON_SITEPACKAGES_DIR}\" )" >> ${WORKDIR}/toolchain.cmake
}

do_install_append () {
	sed -i -e 's:${WORKDIR}.*python3:${bindir}/python3:' ${D}${bindir}/ceph
	sed -i -e 's:${WORKDIR}.*python3:${bindir}/python3:' ${D}${bindir}/ceph-crash
	sed -i -e 's:${WORKDIR}.*python3:${bindir}/python3:' ${D}${bindir}/ceph-volume
	sed -i -e 's:${WORKDIR}.*python3:${bindir}/python3:' ${D}${bindir}/ceph-volume-systemd
	find ${D} -name SOURCES.txt | xargs sed -i -e 's:${WORKDIR}::'
	install -d ${D}${sysconfdir}/ceph
	install -d ${D}${systemd_unitdir}
	mv ${D}${libexecdir}/systemd/system ${D}${systemd_unitdir}
	mv ${D}${libexecdir}/ceph/ceph-osd-prestart.sh ${D}${libdir}/ceph
	mv ${D}${libexecdir}/ceph/ceph_common.sh ${D}${libdir}/ceph
	# WITH_FUSE is set to OFF, remove ceph-fuse related units
	rm ${D}${systemd_unitdir}/system/ceph-fuse.target ${D}${systemd_unitdir}/system/ceph-fuse@.service
	for directory in / mon osd mds tmp radosgw bootstrap-rgw bootstrap-mgr \
		bootstrap-mds bootstrap-osd bootstrap-rbd bootstrap-rbd-mirror
	do
		install -m 0755 -d ${D}${localstatedir}/lib/ceph/${directory}
	done
	install -m 0755 -d ${D}${localstatedir}/log/ceph
	chown ceph:ceph ${D}${localstatedir}/log/ceph ${D}${localstatedir}/lib/ceph
	sed -i 's/sbin/bin/' ${D}${systemd_unitdir}/system/ceph-volume@.service
	for ceph_service in crash "mon@" "osd@" "mgr@" ; do
		echo '[Service]\nSystemCallFilter=@system-service' \
		>> ${D}${systemd_unitdir}/system/ceph-${ceph_service}.service
	done
}

do_install_append_class-target () {
	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/tmpfiles.d
		echo "d /var/lib/ceph/crash/ 0750 ceph ceph - -" > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
		echo "d /var/lib/ceph/crash/posted/ 0750 ceph ceph - -" > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
		echo "d /var/run/ceph/ 0750 ceph ceph - -" >> ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
	fi

	if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/default/volatiles
		echo "d ceph ceph 0750 /var/lib/ceph/crash none" > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
		echo "d ceph ceph 0750 /var/lib/ceph/crash/posted none" > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
		echo "d /var/run/ceph/ 0750 ceph ceph - -" >> ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
	fi
}

pkg_postinst_${PN}() {
	if [ -z "$D" ] && [ -e ${sysconfdir}/init.d/populate-volatile.sh ] ; then
		${sysconfdir}/init.d/populate-volatile.sh update
	fi
}

FILES_${PN} += "\
		${libdir}/rados-classes/*.so.* \
		${libdir}/ceph/compressor/*.so \
		${libdir}/rados-classes/*.so \
		${libdir}/ceph/*.so \
"

FILES_${PN} += " \
    /etc/tmpfiles.d/ceph-placeholder.conf \
    /etc/default/volatiles/99_ceph-placeholder \
"

FILES_${PN}-python3 = "\
                ${PYTHON_SITEPACKAGES_DIR}/* \
"
RDEPENDS_${PN} += "\
		python3 \
		python3-core \
		python3-misc \
		python3-modules \
		python3-prettytable \
		python3-setuptools \
		python3-six \
		${PN}-python3 \
		boost-python \
		lvm2 \
"
COMPATIBLE_HOST = "(x86_64).*"
PACKAGES += " \
${PN}-python3 \
"
INSANE_SKIP_${PN}-python += "ldflags"
INSANE_SKIP_${PN} += "dev-so"
CCACHE_DISABLE = "1"

CVE_PRODUCT = "ceph ceph_storage ceph_storage_mon ceph_storage_osd"
