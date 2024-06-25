inherit useradd

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "\
    --system --no-create-home \
    --home-dir ${localstatedir}/lib/ceph \
    --shell /bin/nologin \
    --user-group \
    -c 'Ceph daemons' ceph"

EXTRA_OECMAKE += "\
    -DWITH_MGR=ON \
    -DWITH_MGR_DASHBOARD_FRONTEND=OFF \
"

def limit_parallel(d):
    import multiprocessing
    return "-j{}".format(d.getVar("SEAPATH_PARALLEL_MAKE",
                                  multiprocessing.cpu_count()))

PARALLEL_MAKE = "${@limit_parallel(d)}"

do_install:append () {
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

do_install:append:class-target () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}
    then
        install -d ${D}${sysconfdir}/tmpfiles.d
        echo "d ${localstatedir}/lib/ceph/crash/ 0750 ceph ceph - -" \
            > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
        echo "d ${localstatedir}/lib/ceph/crash/posted/ 0750 ceph ceph - -" \
            > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
        echo "d ${localstatedir}/run/ceph/ 0750 ceph ceph - -" \
            >> ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}
    then
        install -d ${D}${sysconfdir}/default/volatiles
        echo "d ceph ceph 0750 ${localstatedir}/lib/ceph/crash none" \
            > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
        echo "d ceph ceph 0750 ${localstatedir}/lib/ceph/crash/posted none" \
            > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
        echo "d ${localstatedir}/run/ceph/ 0750 ceph ceph - -" \
            >> ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
    fi
}

RDEPENDS:${PN} += "\
    lvm2 \
    python3-dateutil \
    python3-requests \
"
