# Copyright (C) 2022-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SRC_URI:append = " \
    file://0001-fix-cross-compilation-with-python-cython-modules.patch \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
"
include ceph.inc


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
