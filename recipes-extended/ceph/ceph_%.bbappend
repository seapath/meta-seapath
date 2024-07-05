# Copyright (C) 2022-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit useradd

USERADD_PACKAGES= "${PN}"
USERADD_PARAM:${PN} = "--system --no-create-home --home-dir /var/lib/ceph \
    --shell /bin/nologin --user-group -c 'Ceph daemons' ceph"


SRC_URI += "file://0001-mgr-Define-PY_SSIZE_T_CLEAN-ahead-of-every-Python.h.patch"

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
    return "-j{}".format(d.getVar("SEAPATH_PARALLEL_MAKE", multiprocessing.cpu_count()))

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
		python3-dateutil \
		python3-requests \
		lvm2 \
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

