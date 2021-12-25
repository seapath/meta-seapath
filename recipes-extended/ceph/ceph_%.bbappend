inherit useradd

USERADD_PACKAGES= "${PN}"
USERADD_PARAM_${PN} = "--system --no-create-home --home-dir /var/lib/ceph \
    --shell /bin/nologin --user-group -c 'Ceph daemons' ceph"

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
                 -DPYTHON_INSTALL_DIR=${PYTHON_SITEPACKAGES_DIR} -DPYTHON_DESIRED=3 \
                 -DPython3_EXECUTABLE=${PYTHON} \
                 -DWITH_RADOSGW_KAFKA_ENDPOINT=OFF \
"

do_install_append () {
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

RDEPENDS_${PN} += "\
		python3-dateutil \
		lvm2 \
"
