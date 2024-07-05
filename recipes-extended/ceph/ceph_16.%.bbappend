# Copyright (C) 2022-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-fix-cross-compilation-with-python-cython-modules.patch \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
"

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
    -DWITH_ZSTD=ON \
    -DWITH_LZ4=ON \
    -DWITH_ZLIB=ON \
"

PACKAGE_BEFORE_PN = "\
    ${PN}-mgr-dashboard \
    ${PN}-mgr-restful \
    ${PN}-mgr-cephadm \
    ${PN}-mgr-prometheus \
    ${PN}-mgr-rook \
    ${PN}-mgr-zabbix \
    ${PN}-mgr-telegraf \
    ${PN}-mgr-influx \
    ${PN}-mgr-alert \
    ${PN}-mgr-diskprediction_cloud \
    ${PN}-mgr-insights \
    ${PN}-mgr-k8sevents \
    ${PN}-mgr-localpool \
    ${PN}-mgr-osd_support \
    ${PN}-mgr-selftest \
    ${PN}-mgr-test_orchestrator \
"


def limit_parallel(d):
    import multiprocessing
    return "-j{}".format(d.getVar("SEAPATH_PARALLEL_MAKE",
                                  multiprocessing.cpu_count()))

PARALLEL_MAKE = "${@limit_parallel(d)}"

do_install:append () {
    install -m 0755 -d ${D}${localstatedir}/lib/ceph
    for directory in mon osd mds tmp radosgw bootstrap-rgw bootstrap-mgr \
        bootstrap-mds bootstrap-osd bootstrap-rbd bootstrap-rbd-mirror
    do
        install -m 0755 -d ${D}${localstatedir}/lib/ceph/${directory}
    done

    install -m 0755 -d ${D}${localstatedir}/log/ceph
    chown ceph:ceph ${D}${localstatedir}/log/ceph ${D}${localstatedir}/lib/ceph

    for ceph_service in crash "mon@" "osd@" "mgr@" ; do
        echo '[Service]\nSystemCallFilter=@system-service' \
            >> ${D}${systemd_system_unitdir}/ceph-${ceph_service}.service
    done

    # ceph-ansible 16 needs some scripts stored in /usr/lib/ceph directory, but
    # look for them in /usr/libexec/ceph directory. Ceph tools also use these
    # scripts but look for them in /usr/lib/ceph directory.So, we create a
    # symlink to the scripts from /usr/lib/ceph to /usr/libexec/ceph.
    install -m 0755 -d ${D}/${libexecdir}/ceph
    for ceph_script in ceph-osd-prestart.sh ceph_common.sh ; do
        ln -sf /usr/lib/ceph/${ceph_script} ${D}/${libexecdir}/ceph/${ceph_script}
    done
}

do_install:append:class-target () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}
    then
        install -d ${D}${sysconfdir}/tmpfiles.d
        echo "d ${localstatedir}/lib/ceph/crash/ 0750 ceph ceph - -" \
            > ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
        echo "d ${localstatedir}/lib/ceph/crash/posted/ 0750 ceph ceph - -" \
            >> ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
        echo "d ${localstatedir}/run/ceph/ 0750 ceph ceph - -" \
            >> ${D}${sysconfdir}/tmpfiles.d/ceph-placeholder.conf
    fi

    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}
    then
        install -d ${D}${sysconfdir}/default/volatiles
        echo "d ceph ceph 0750 ${localstatedir}/lib/ceph/crash none" \
            > ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
        echo "d ceph ceph 0750 ${localstatedir}/lib/ceph/crash/posted none" \
            >> ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
        echo "d ${localstatedir}/run/ceph/ 0750 ceph ceph - -" \
            >> ${D}${sysconfdir}/default/volatiles/99_ceph-placeholder
    fi
}

FILES:${PN}-mgr-dashboard = "${datadir}/ceph/mgr/dashboard"
FILES:${PN}-mgr-restful = "${datadir}/ceph/mgr/restful"
FILES:${PN}-mgr-cephadm = "${datadir}/ceph/mgr/cephadm"
FILES:${PN}-mgr-prometheus = "${datadir}/ceph/mgr/prometheus"
FILES:${PN}-mgr-rook = "${datadir}/ceph/mgr/rook"
FILES:${PN}-mgr-zabbix = "${datadir}/ceph/mgr/zabbix"
FILES:${PN}-mgr-telegraf = "${datadir}/ceph/mgr/telegraf"
FILES:${PN}-mgr-influx = "${datadir}/ceph/mgr/influx"
FILES:${PN}-mgr-alert = "${datadir}/ceph/mgr/alert"
FILES:${PN}-mgr-diskprediction_cloud = "${datadir}/ceph/mgr/diskprediction_cloud"
FILES:${PN}-mgr-insights = "${datadir}/ceph/mgr/insights"
FILES:${PN}-mgr-k8sevents = "${datadir}/ceph/mgr/k8sevents"
FILES:${PN}-mgr-localpool = "${datadir}/ceph/mgr/localpool"
FILES:${PN}-mgr-osd_support = "${datadir}/ceph/mgr/osd_support"
FILES:${PN}-mgr-selftest = "${datadir}/ceph/mgr/selftest"
FILES:${PN}-mgr-test_orchestrator = "${datadir}/ceph/mgr/test_orchestrator"

RDEPENDS:${PN} += "\
    lvm2 \
    python3-dateutil \
    python3-requests \
"

RDEPENDS:${PN}-mgr-dashboard = "${PN}-mgr-restful"

RDEPENDS:${PN}-mgr-restful = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-cephadm = "\
    ${PN} \
    ${PN}-python \
    python3-jinja2 \
"

RDEPENDS:${PN}-mgr-prometheus = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-rook = "\
    ${PN} \
    ${PN}-python \
    python3-jsonpatch \
"

RDEPENDS:${PN}-mgr-zabbix = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-telegraf = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-influx = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-alert = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-diskprediction_cloud = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-insights = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-k8sevents = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-localpool = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-osd_support = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-selftest = "\
    ${PN} \
    ${PN}-python \
"

RDEPENDS:${PN}-mgr-test_orchestrator = "\
    ${PN} \
    ${PN}-python \
"

REQUIRED_DISTRO_FEATURES:append = "systemd"
