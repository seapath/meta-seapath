# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/ceph-18:"

SRC_URI:append = " \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
    file://0021-remove-usage-of-distutils.patch \
    file://py313-compat/0001-mgr-stop-using-deprecated-API-to-initialize-Python.patch \
    file://py313-compat/0002-mgr-set-argv-for-python-in-PyModuleRegistry.patch \
    file://py313-compat/0003-mgr-add-site-package-paths-in-PyModuleRegistry.patch \
    file://py313-compat/0004-Revert-Merge-pull-request-55436-from-tchaikov-mgr-py.patch \
    file://py313-compat/0005-mgr-do-not-require-NOTIFY_TYPES-in-python-modules.patch \
    file://py313-compat/0007-mgr-stop-using-deprecated-API-to-initialize-Python.patch \
    file://py313-compat/0008-mgr-set-argv-for-python-in-PyModuleRegistry.patch \
    file://py313-compat/0009-mgr-add-site-package-paths-in-PyModuleRegistry.patch \
    file://py313-compat/0010-ceph-volume-fix-importlib.metadata-compat.patch \
    file://0001-fix-cross-compilation-with-python-cython-modules-18.patch \
"

CEPH_USER_PACKAGE = "${PN}-common"
CEPHADM_PACKAGE = "${PN}-cephadm"

include ceph.inc

inherit features_check

DEPENDS:append = " patchelf-native"

do_install:append() {
    # Fix python3 shebangs in ceph-node-proxy
    sed -i '1 s|^#!.*|#!/usr/bin/env python3|' ${D}${sbindir}/ceph-node-proxy
    # udev rules
    install -v -D -m 644 ${S}/udev/50-rbd.rules ${D}${nonarch_base_libdir}/udev/rules.d/50-rbd.rules

    # rbdmap config
    install -v -D -m 644 ${S}/src/etc-rbdmap ${D}${sysconfdir}/ceph/rbdmap

    # sysctl config for OSD
    install -v -D -m 644 ${S}/etc/sysctl/90-ceph-osd.conf ${D}${sysconfdir}/sysctl.d/30-ceph-osd.conf

    # sudoers for smartctl
    install -d -m 0750 ${D}/${sysconfdir}/sudoers.d
    install -v -D -m 440 ${S}/sudoers.d/ceph-smartctl ${D}${sysconfdir}/sudoers.d/ceph-smartctl

    # ceph_common.sh script
    install -v -D -m 755 ${S}/src/ceph_common.sh ${D}${libdir}/ceph/ceph_common.sh

    # ceph-osd-prestart.sh script
    install -v -D -m 755 ${S}/src/ceph-osd-prestart.sh ${D}${libdir}/ceph/ceph-osd-prestart.sh

    # prometheus alerts
    install -v -D -m 644 ${S}/monitoring/ceph-mixin/prometheus_alerts.yml \
        ${D}${sysconfdir}/prometheus/ceph/ceph_default_alerts.yml

    # Default config
    install -v -D -m 644 ${S}/etc/default/ceph ${D}${sysconfdir}/default/ceph

    # tmpfiles.d
    install -v -D -m 644 ${S}/systemd/ceph.tmpfiles.d ${D}${nonarch_libdir}/tmpfiles.d/ceph.conf

    # remove /etc/ceph/ceph.conf
    rm -vf ${D}${sysconfdir}/ceph/ceph.conf


    # Remove runpath and .gnu_debuglink section which contains reference to
    # TMPDIR for every cython module
    # FIXME patch Distutils.cmake and setup.py to not add TMPDIR
    for so in ${D}${PYTHON_SITEPACKAGES_DIR}/*.cpython*.so; do
        if [ -f "$so" ]; then
            echo "Remove rpath and .gnu_debuglink from $so"
            patchelf --remove-rpath "$so"
            objcopy --remove-section=.gnu_debuglink "$so"
        fi
    done

    # Remove broken dependency_links.txt files in python packages
    for dep in \
        ${D}${PYTHON_SITEPACKAGES_DIR}/ceph_node_proxy-*.egg-info/dependency_links.txt \
        ${D}${PYTHON_SITEPACKAGES_DIR}/ceph_volume-*.egg-info/dependency_links.txt
    do
        rm -v ${dep}
        touch ${dep}
    done

    # Remove generated cython files from source tree to avoid packaging them
    for mod in rados rbd cephfs rgw; do
        rm -fv ${S}/src/pybind/${mod}/${mod}.c
        cp ${B}/src/pybind/${mod}/pyrex/${mod}.c ${B}/src/pybind/${mod}/${mod}.c
    done
}


# Reset all packages to remove original .bb PACKAGES definition
PACKAGES = " \
    ${PN}-cephadm \
    ${PN}-mgr-cephadm \
    ${PN}-mgr-dashboard \
    ${PN}-mgr-k8sevents \
    ${PN}-mgr-rook \
    ${PN}-mgr-modules-core \
    ${PN}-mgr \
    ${PN}-mon \
    ${PN}-osd \
    ${PN}-mds \
    ${PN}-volume \
    ${PN}-immutable-object-cache \
    ${PN}-exporter \
    cephfs-mirror \
    cephfs-shell \
    cephfs-top \
    radosgw \
    rbd-fuse \
    rbd-mirror \
    rbd-nbd \
    ${PN}-grafana-dashboards \
    ${PN}-prometheus-alerts \
    ${PN}-resource-agents \
    ${PN}-test \
    libcephfs-dev \
    libcephfs-jni \
    libcephfs-java \
    libcephfs2 \
    librados-dev \
    libradospp-dev \
    librados2 \
    libradosstriper-dev \
    libradosstriper1 \
    librbd-dev \
    librbd1 \
    librgw-dev \
    librgw2 \
    libsqlite3-mod-ceph-dev \
    libsqlite3-mod-ceph \
    rados-objclass-dev \
    python3-ceph-argparse \
    python3-ceph-common \
    python3-cephfs \
    python3-rados \
    python3-rbd \
    python3-rgw \
    python3-${PN} \
    ${PN}-base \
    ${PN}-common \
    ${PN} \
    ${PN}-dev \
    ${PN}-staticdev \
    ${PN}-doc \
    ${PN}-dbg \
"

ALLOW_EMPTY:${PN} = "1"
RDEPENDS:${PN} = "${PN}-mon ${PN}-osd ${PN}-mgr"
FILES:${PN} = ""

# =============================================================================
# ceph-common: Common utilities to mount and interact with a ceph cluster
# =============================================================================
FILES:${PN}-common = " \
    ${sysconfdir}/ceph \
    ${sysconfdir}/bash_completion.d/ceph \
    ${sysconfdir}/bash_completion.d/rados \
    ${sysconfdir}/bash_completion.d/radosgw-admin \
    ${sysconfdir}/bash_completion.d/rbd \
    ${sysconfdir}/default/ceph \
    ${sysconfdir}/ceph/rbdmap \
    ${sysconfdir}/tmpfiles.d/ceph-placeholder.conf \
    ${bindir}/ceph \
    ${bindir}/ceph-authtool \
    ${bindir}/ceph-conf \
    ${bindir}/ceph-dencoder \
    ${bindir}/ceph-rbdnamer \
    ${bindir}/ceph-syn \
    ${bindir}/cephfs-data-scan \
    ${bindir}/cephfs-journal-tool \
    ${bindir}/cephfs-table-tool \
    ${bindir}/crushdiff \
    ${bindir}/rados \
    ${bindir}/radosgw-admin \
    ${bindir}/rgw-gap-list \
    ${bindir}/rgw-gap-list-comparator \
    ${bindir}/rgw-orphan-list \
    ${bindir}/rgw-restore-bucket-index \
    ${bindir}/rgw-policy-check \
    ${bindir}/rbd \
    ${bindir}/rbdmap \
    ${bindir}/rbd-replay \
    ${bindir}/rbd-replay-many \
    ${bindir}/ceph-post-file \
    ${base_sbindir}/mount.ceph \
    ${sbindir}/mount.ceph \
    ${libdir}/ceph/compressor/libceph_*.so* \
    ${libdir}/ceph/crypto/libceph_*.so* \
    ${libdir}/ceph/denc/*.so \
    ${nonarch_base_libdir}/udev/rules.d/50-rbd.rules \
    ${systemd_system_unitdir}/ceph.target \
    ${systemd_system_unitdir}/rbdmap.service \
    ${nonarch_libdir}/tmpfiles.d/ceph.conf \
    ${datadir}/ceph/known_hosts_drop.ceph.com \
    ${datadir}/ceph/id_rsa_drop.ceph.com \
    ${datadir}/ceph/id_rsa_drop.ceph.com.pub \
    ${localstatedir}/lib/ceph \
    ${localstatedir}/log/ceph \
"

RDEPENDS:${PN}-common = " \
    gawk \
    bash \
    librbd1 \
    python3-core \
    python3-ceph-argparse \
    python3-ceph-common \
    python3-cephfs \
    python3-rados \
    python3-rbd \
    python3-prettytable \
    python3-requests \
"

CONFFILES:${PN}-common = " \
    ${sysconfdir}/ceph/rbdmap \
"


# =============================================================================
# ceph-base: Common ceph daemon libraries and management tools
# =============================================================================

FILES:${PN}-base = " \
    ${sysconfdir}/sudoers.d/ceph-smartctl \
    ${bindir}/ceph-crash \
    ${bindir}/ceph-kvstore-tool \
    ${bindir}/ceph-run \
    ${bindir}/crushtool \
    ${bindir}/monmaptool \
    ${bindir}/osdmaptool \
    ${sbindir}/ceph-create-keys \
    ${sbindir}/ceph-node-proxy \
    ${libdir}/ceph/ceph_common.sh \
    ${libdir}/ceph/erasure-code/libec_*.so \
    ${libdir}/ceph/extblkdev/*.so \
    ${libdir}/rados-classes/libcls_*.so* \
    ${libdir}/ceph/ceph_common.sh \
    ${libexecdir}/ceph/ceph_common.sh \
    ${systemd_system_unitdir}/ceph-crash.service \
    ${localstatedir}/lib/ceph/bootstrap-mds \
    ${localstatedir}/lib/ceph/bootstrap-mgr \
    ${localstatedir}/lib/ceph/bootstrap-osd \
    ${localstatedir}/lib/ceph/bootstrap-rbd \
    ${localstatedir}/lib/ceph/bootstrap-rbd-mirror \
    ${localstatedir}/lib/ceph/bootstrap-rgw \
    ${localstatedir}/lib/ceph/crash \
    ${localstatedir}/lib/ceph/crash/posted \
    ${localstatedir}/lib/ceph/tmp \
"

RDEPENDS:${PN}-base = " \
    ${CEPH_USER_PACKAGE} \
    ${PN}-common \
    python3-core \
    cryptsetup \
    e2fsprogs \
    hdparm \
    logrotate \
    parted \
    psmisc \
    smartmontools \
    util-linux \
    xfsprogs \
"

# =============================================================================
# ceph-mon: Monitor server for the ceph storage system
# =============================================================================
FILES:${PN}-mon = " \
    ${bindir}/ceph-mon \
    ${bindir}/ceph-monstore-tool \
    ${systemd_system_unitdir}/ceph-mon.target \
    ${systemd_system_unitdir}/ceph-mon@.service \
    ${localstatedir}/lib/ceph/mon \
"

RDEPENDS:${PN}-mon = "${PN}-common"

# =============================================================================
# ceph-osd: OSD server for the ceph storage system
# =============================================================================
FILES:${PN}-osd = " \
    ${sysconfdir}/sysctl.d/30-ceph-osd.conf \
    ${bindir}/ceph-bluestore-tool \
    ${bindir}/ceph-clsinfo \
    ${bindir}/ceph-erasure-code-tool \
    ${bindir}/ceph-objectstore-tool \
    ${bindir}/ceph-osd \
    ${bindir}/ceph-osdomap-tool \
    ${libdir}/ceph/ceph-osd-prestart.sh \
    ${libexecdir}/ceph/ceph-osd-prestart.sh \
    ${nonarch_base_libdir}/udev/rules.d/60-ceph-by-parttypeuuid.rules \
    ${nonarch_base_libdir}/udev/rules.d/95-ceph-osd.rules \
    ${systemd_system_unitdir}/ceph-osd.target \
    ${systemd_system_unitdir}/ceph-osd@.service \
    ${localstatedir}/lib/ceph/osd \
"

RDEPENDS:${PN}-osd = " \
    ${PN}-base \
    ${PN}-volume \
    lvm2 \
    sudo \
"

# =============================================================================
# ceph-mds: Metadata server for the ceph distributed file system
# =============================================================================
FILES:${PN}-mds = " \
    ${bindir}/ceph-mds \
    ${systemd_system_unitdir}/ceph-mds.target \
    ${systemd_system_unitdir}/ceph-mds@.service \
    ${localstatedir}/lib/ceph/mds \
"

RDEPENDS:${PN}-mds = "${PN}-common"

# =============================================================================
# ceph-mgr: Manager for the ceph distributed file system
# =============================================================================
FILES:${PN}-mgr = " \
    ${bindir}/ceph-mgr \
    ${datadir}/ceph/mgr/mgr_module.* \
    ${datadir}/ceph/mgr/mgr_util.* \
    ${datadir}/ceph/mgr/object_format.* \
    ${systemd_system_unitdir}/ceph-mgr.target \
    ${systemd_system_unitdir}/ceph-mgr@.service \
    ${localstatedir}/lib/ceph/mgr \
"

RDEPENDS:${PN}-mgr = " \
    ${CEPH_USER_PACKAGE} \
    ${PN}-common \
    ${PN}-mgr-modules-core \
    libsqlite3-mod-ceph \
    python3-bcrypt \
    python3-ceph-argparse \
    python3-cephfs \
    python3-requests \
    python3-werkzeug \
"

# =============================================================================
# ceph-mgr-modules-core: Core ceph-mgr modules (always enabled)
# =============================================================================
FILES:${PN}-mgr-modules-core = " \
    ${datadir}/ceph/mgr/alerts \
    ${datadir}/ceph/mgr/balancer \
    ${datadir}/ceph/mgr/crash \
    ${datadir}/ceph/mgr/devicehealth \
    ${datadir}/ceph/mgr/diskprediction_local \
    ${datadir}/ceph/mgr/influx \
    ${datadir}/ceph/mgr/insights \
    ${datadir}/ceph/mgr/iostat \
    ${datadir}/ceph/mgr/localpool \
    ${datadir}/ceph/mgr/mds_autoscaler \
    ${datadir}/ceph/mgr/mirroring \
    ${datadir}/ceph/mgr/nfs \
    ${datadir}/ceph/mgr/orchestrator \
    ${datadir}/ceph/mgr/osd_perf_query \
    ${datadir}/ceph/mgr/osd_support \
    ${datadir}/ceph/mgr/pg_autoscaler \
    ${datadir}/ceph/mgr/progress \
    ${datadir}/ceph/mgr/prometheus \
    ${datadir}/ceph/mgr/rbd_support \
    ${datadir}/ceph/mgr/restful \
    ${datadir}/ceph/mgr/rgw \
    ${datadir}/ceph/mgr/selftest \
    ${datadir}/ceph/mgr/snap_schedule \
    ${datadir}/ceph/mgr/stats \
    ${datadir}/ceph/mgr/status \
    ${datadir}/ceph/mgr/telegraf \
    ${datadir}/ceph/mgr/telemetry \
    ${datadir}/ceph/mgr/test_orchestrator \
    ${datadir}/ceph/mgr/volumes \
    ${datadir}/ceph/mgr/zabbix \
"

RDEPENDS:${PN}-mgr-modules-core = " \
    python3-dateutil \
    python3-natsort \
    python3-packaging \
    python3-requests \
    python3-werkzeug \
"

# =============================================================================
# ceph-mgr-cephadm: Cephadm orchestrator module
# =============================================================================
FILES:${PN}-mgr-cephadm = " \
    ${datadir}/ceph/mgr/cephadm \
"

RDEPENDS:${PN}-mgr-cephadm = " \
    ${PN}-mgr \
    ${PN}-cephadm \
    openssh-ssh \
    python3-cryptography \
    python3-jinja2 \
"

# =============================================================================
# ceph-mgr-dashboard: Dashboard plugin for ceph-mgr
# =============================================================================
FILES:${PN}-mgr-dashboard = " \
    ${datadir}/ceph/mgr/dashboard \
"

RDEPENDS:${PN}-mgr-dashboard = " \
    ${PN}-common \
    ${PN}-mgr \
    python3-bcrypt \
    python3-more-itertools \
    python3-prettytable \
    python3-requests \
    python3-werkzeug \
"

# =============================================================================
# ceph-mgr-k8sevents: Kubernetes events plugin for ceph-mgr
# =============================================================================
FILES:${PN}-mgr-k8sevents = " \
    ${datadir}/ceph/mgr/k8sevents \
"

RDEPENDS:${PN}-mgr-k8sevents = " \
    ${PN}-mgr \
"

# =============================================================================
# ceph-mgr-rook: Rook plugin for ceph-mgr
# =============================================================================
FILES:${PN}-mgr-rook = " \
    ${datadir}/ceph/mgr/rook \
"

RDEPENDS:${PN}-mgr-rook = " \
    ${PN}-mgr \
    python3-jsonpatch \
"

# =============================================================================
# ceph-volume: Tool to facilitate OSD deployment
# =============================================================================
FILES:${PN}-volume = " \
    ${sbindir}/ceph-volume \
    ${sbindir}/ceph-volume-systemd \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_volume \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_volume-*.egg-info \
    ${systemd_system_unitdir}/ceph-volume@.service \
"

RDEPENDS:${PN}-volume = " \
    cryptsetup \
    e2fsprogs \
    lvm2 \
    parted \
    xfsprogs \
    python3-core \
    python3-packaging \
"

# =============================================================================
# cephadm: Utility to bootstrap ceph daemons with systemd and containers
# =============================================================================
include cephadm.inc

FILES:${PN}-cephadm:append = " \
    ${sbindir}/cephadm \
    ${sysconfdir}/sudoers.d/cephadm \
"

# =============================================================================
# ceph-immutable-object-cache: Daemon for immutable object cache
# =============================================================================
FILES:${PN}-immutable-object-cache = " \
    ${bindir}/ceph-immutable-object-cache \
    ${systemd_system_unitdir}/ceph-immutable-object-cache.target \
    ${systemd_system_unitdir}/ceph-immutable-object-cache@.service \
"

RDEPENDS:${PN}-immutable-object-cache = " \
    ${PN}-common \
    librados2 \
"

# =============================================================================
# ceph exporter: Prometheus exporter for Ceph metrics
# =============================================================================
FILES:${PN}-exporter = " \
    ${bindir}/ceph-exporter \
    ${systemd_system_unitdir}/ceph-exporter.service \
"

# =============================================================================
# cephfs-mirror: Daemon for mirroring CephFS directory snapshots
# =============================================================================
FILES:cephfs-mirror = " \
    ${bindir}/cephfs-mirror \
    \
    ${systemd_system_unitdir}/cephfs-mirror.target \
    ${systemd_system_unitdir}/cephfs-mirror@.service \
"

RDEPENDS:cephfs-mirror = " \
    ${PN}-common \
    libcephfs2 \
    librados2 \
"

# =============================================================================
# cephfs-shell: Interactive shell for the Ceph distributed file system
# =============================================================================
FILES:cephfs-shell = " \
    ${bindir}/cephfs-shell \
    ${PYTHON_SITEPACKAGES_DIR}/cephfs_shell-*.egg-info \
"

RDEPENDS:cephfs-shell = "python3-cephfs"

# =============================================================================
# cephfs-top: Top-like utility for Ceph filesystem
# =============================================================================
FILES:cephfs-top = " \
    ${bindir}/cephfs-top \
    ${PYTHON_SITEPACKAGES_DIR}/cephfs_top-*.egg-info \
"

RDEPENDS:cephfs-top = "python3-core"

# =============================================================================
# radosgw: REST gateway for RADOS distributed object store
# =============================================================================
FILES:radosgw = " \
    ${bindir}/ceph-diff-sorted \
    ${bindir}/radosgw \
    ${bindir}/radosgw-es \
    ${bindir}/radosgw-object-expirer \
    ${bindir}/radosgw-token \
    ${systemd_system_unitdir}/ceph-radosgw.target \
    ${systemd_system_unitdir}/ceph-radosgw@.service \
    ${localstatedir}/lib/ceph/radosgw \
"

RDEPENDS:radosgw = " \
    ${CEPH_USER_PACKAGE} \
    ${PN}-common \
    librgw2 \
"

# =============================================================================
# rbd-fuse: FUSE-based rbd client
# =============================================================================
FILES:rbd-fuse = " \
    ${bindir}/rbd-fuse \
"

RDEPENDS:rbd-fuse = "fuse3"

# =============================================================================
# rbd-mirror: Daemon for mirroring RBD images
# =============================================================================
FILES:rbd-mirror = " \
    ${bindir}/rbd-mirror \
    ${systemd_system_unitdir}/ceph-rbd-mirror.target \
    ${systemd_system_unitdir}/ceph-rbd-mirror@.service \
"

RDEPENDS:rbd-mirror = " \
    ${PN}-common \
    librados2 \
"

# =============================================================================
# rbd-nbd: NBD-based rbd client
# =============================================================================
FILES:rbd-nbd = " \
    ${bindir}/rbd-nbd \
    ${libexecdir}/rbd-nbd/rbd-nbd_quiesce \
"


# =============================================================================
# ceph-grafana-dashboards: Grafana dashboards for the ceph dashboard
# =============================================================================
FILES:${PN}-grafana-dashboards = " \
    ${sysconfdir}/grafana/dashboards/ceph-dashboard \
"

# =============================================================================
# ceph-prometheus-alerts: Prometheus alerts for the ceph dashboard
# =============================================================================
FILES:${PN}-prometheus-alerts = " \
    ${sysconfdir}/prometheus/ceph/ceph_default_alerts.yml \
"

# =============================================================================
# ceph-resource-agents: OCF-compliant resource agents for Ceph
# =============================================================================
FILES:${PN}-resource-agents = " \
    ${libdir}/ocf/resource.d/ceph \
"

RDEPENDS:${PN}-resource-agents = " \
    resource-agents \
"

# =============================================================================
# ceph-test: Test and benchmarking tools
# =============================================================================
FILES:${PN}-test = " \
    ${bindir}/ceph-client-debug \
    ${bindir}/ceph-coverage \
    ${bindir}/ceph-dedup-tool \
    ${bindir}/ceph_bench_log \
    ${bindir}/ceph_erasure_code_benchmark \
    ${bindir}/ceph_multi_stress_watch \
    ${bindir}/ceph_omapbench \
    ${bindir}/ceph_perf_local \
    ${bindir}/ceph_perf_msgr_client \
    ${bindir}/ceph_perf_msgr_server \
    ${bindir}/ceph_perf_objectstore \
    ${bindir}/ceph_psim \
    ${bindir}/ceph_radosacl \
    ${bindir}/ceph_rgw_jsonparser \
    ${bindir}/ceph_rgw_multiparser \
    ${bindir}/ceph_scratchtool \
    ${bindir}/ceph_scratchtoolpp \
    ${bindir}/ceph_test_* \
    ${datadir}/java/libcephfs-test.jar \
"

RDEPENDS:${PN}-test = " \
    ${PN}-common \
    curl \
    jq \
    socat \
    xmlstarlet \
"

# =============================================================================
# libcephfs2: Ceph distributed file system client library
# =============================================================================
FILES:libcephfs2 = " \
    ${libdir}/libcephfs.so.2* \
"

# =============================================================================
# libcephfs-dev: Ceph distributed file system client library (development)
# =============================================================================
FILES:libcephfs-dev = " \
    ${includedir}/cephfs/ceph_ll_client.h \
    ${includedir}/cephfs/libcephfs.h \
    ${includedir}/cephfs/metrics/Types.h \
    ${includedir}/cephfs/types.h \
    ${libdir}/libcephfs.so \
"

RDEPENDS:libcephfs-dev = "libcephfs2"

# =============================================================================
# libcephfs-jni: Java Native Interface library for CephFS Java bindings
# =============================================================================
FILES:libcephfs-jni = " \
    ${libdir}/jni/libcephfs_jni.so* \
"

RDEPENDS:libcephfs-jni = "libcephfs2"

# =============================================================================
# libcephfs-java: Java library for the Ceph File System
# =============================================================================
FILES:libcephfs-java = " \
    ${datadir}/java/libcephfs.jar \
"

RDEPENDS:libcephfs-java = "libcephfs-jni"

# =============================================================================
# librados2: RADOS distributed object store client library
# =============================================================================
FILES:librados2 = " \
    ${libdir}/ceph/libceph-common.so* \
    ${libdir}/librados.so.2* \
"

# =============================================================================
# librados-dev: RADOS distributed object store client library (development)
# =============================================================================
FILES:librados-dev = " \
    ${bindir}/librados-config \
    ${includedir}/rados/librados.h \
    ${includedir}/rados/rados_types.h \
    ${libdir}/librados.so \
"

RDEPENDS:librados-dev = "librados2"

# =============================================================================
# libradospp-dev: RADOS distributed object store C++ library (development)
# =============================================================================
FILES:libradospp-dev = " \
    ${includedir}/rados/buffer.h \
    ${includedir}/rados/buffer_fwd.h \
    ${includedir}/rados/crc32c.h \
    ${includedir}/rados/inline_memory.h \
    ${includedir}/rados/librados.hpp \
    ${includedir}/rados/librados_fwd.hpp \
    ${includedir}/rados/page.h \
    ${includedir}/rados/rados_types.hpp \
"

RDEPENDS:libradospp-dev = "librados-dev"

# =============================================================================
# libradosstriper1: RADOS striping interface
# =============================================================================
FILES:libradosstriper1 = " \
    ${libdir}/libradosstriper.so.1* \
"

RDEPENDS:libradosstriper1 = "librados2"

# =============================================================================
# libradosstriper-dev: RADOS striping interface (development)
# =============================================================================
FILES:libradosstriper-dev = " \
    ${includedir}/radosstriper/libradosstriper.h \
    ${includedir}/radosstriper/libradosstriper.hpp \
    ${libdir}/libradosstriper.so \
"

RDEPENDS:libradosstriper-dev = "libradosstriper1"

# =============================================================================
# librbd1: RADOS block device client library
# =============================================================================
FILES:librbd1 = " \
    ${libdir}/librbd.so.1* \
    ${libdir}/ceph/librbd/libceph_librbd_parent_cache.so.* \
"

RDEPENDS:librbd1 = "librados2"

# =============================================================================
# librbd-dev: RADOS block device client library (development)
# =============================================================================
FILES:librbd-dev = " \
    ${includedir}/rbd/features.h \
    ${includedir}/rbd/librbd.h \
    ${includedir}/rbd/librbd.hpp \
    ${libdir}/librbd.so \
    ${libdir}/ceph/librbd/libceph_librbd_parent_cache.so \
"

RDEPENDS:librbd-dev = "librbd1"

# =============================================================================
# librgw2: RADOS Gateway client library
# =============================================================================
FILES:librgw2 = " \
    ${libdir}/librgw.so.2* \
"

RDEPENDS:librgw2 = "librados2"

# =============================================================================
# librgw-dev: RADOS Gateway client library (development)
# =============================================================================
FILES:librgw-dev = " \
    ${includedir}/rados/librgw.h \
    ${includedir}/rados/rgw_file.h \
    ${libdir}/librgw.so \
"

RDEPENDS:librgw-dev = "librgw2"

# =============================================================================
# libsqlite3-mod-ceph: SQLite3 VFS for Ceph
# =============================================================================
FILES:libsqlite3-mod-ceph = " \
    ${libdir}/libcephsqlite.so \
"

# =============================================================================
# libsqlite3-mod-ceph-dev: SQLite3 VFS for Ceph (development)
# =============================================================================
FILES:libsqlite3-mod-ceph-dev = " \
    ${includedir}/libcephsqlite.h \
"

RDEPENDS:libsqlite3-mod-ceph-dev = "libsqlite3-mod-ceph libsqlite3-dev"

# =============================================================================
# rados-objclass-dev: RADOS object class development kit
# =============================================================================
FILES:rados-objclass-dev = " \
    ${includedir}/rados/objclass.h \
"

RDEPENDS:rados-objclass-dev = "librados-dev"

# =============================================================================
# python3-ceph-argparse: Python 3 utility libraries for Ceph CLI
# =============================================================================
FILES:python3-ceph-argparse = " \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_argparse.py* \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_daemon.py* \
    ${PYTHON_SITEPACKAGES_DIR}/__pycache__/ceph_argparse.*.pyc \
    ${PYTHON_SITEPACKAGES_DIR}/__pycache__/ceph_daemon.*.pyc \
"

RDEPENDS:python3-ceph-argparse = "python3-core"

# =============================================================================
# python3-ceph-common: Python 3 utility libraries for Ceph
# =============================================================================
FILES:python3-ceph-common = " \
    ${PYTHON_SITEPACKAGES_DIR}/ceph \
    ${PYTHON_SITEPACKAGES_DIR}/ceph-*.egg-info \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_node_proxy \
    ${PYTHON_SITEPACKAGES_DIR}/ceph_node_proxy-*.egg-info \
"

RDEPENDS:python3-ceph-common = "python3-core"

# =============================================================================
# python3-cephfs: Python 3 libraries for the Ceph libcephfs library
# =============================================================================
FILES:python3-cephfs = " \
    ${PYTHON_SITEPACKAGES_DIR}/cephfs-*.egg-info \
    ${PYTHON_SITEPACKAGES_DIR}/cephfs.cpython*.so \
"

RDEPENDS:python3-cephfs = " \
    libcephfs2 \
    python3-ceph-argparse \
    python3-rados \
"

# =============================================================================
# python3-rados: Python 3 libraries for the Ceph librados library
# =============================================================================
FILES:python3-rados = " \
    ${PYTHON_SITEPACKAGES_DIR}/rados-*.egg-info \
    ${PYTHON_SITEPACKAGES_DIR}/rados.cpython*.so \
"

RDEPENDS:python3-rados = "librados2"

# =============================================================================
# python3-rbd: Python 3 libraries for the Ceph librbd library
# =============================================================================
FILES:python3-rbd = " \
    ${PYTHON_SITEPACKAGES_DIR}/rbd-*.egg-info \
    ${PYTHON_SITEPACKAGES_DIR}/rbd.cpython*.so \
"

RDEPENDS:python3-rbd = "librbd1"

# =============================================================================
# python3-rgw: Python 3 libraries for the Ceph librgw library
# =============================================================================
FILES:python3-rgw = " \
    ${PYTHON_SITEPACKAGES_DIR}/rgw-*.egg-info \
    ${PYTHON_SITEPACKAGES_DIR}/rgw.cpython*.so \
"

RDEPENDS:python3-rgw = " \
    librgw2 \
    python3-rados \
"

# =============================================================================
# python3-ceph: Meta-package for all Python 3.x modules for the Ceph libraries
# =============================================================================
ALLOW_EMPTY:python3-${PN} = "1"
FILES:python3-${PN} = ""

RDEPENDS:python3-${PN} = " \
    python3-cephfs \
    python3-rados \
    python3-rbd \
    python3-rgw \
"

# =============================================================================
# ceph-dev: Ceph development files (catch-all for remaining -dev files)
# =============================================================================
FILES:${PN}-dev = " \
    ${includedir} \
    ${libdir}/lib*.so \
    ${libdir}/cmake \
    ${libdir}/pkgconfig \
"

# =============================================================================
# ceph-staticdev: Ceph static libraries
# =============================================================================
FILES:${PN}-staticdev = " \
    ${libdir}/lib*.a \
"

# =============================================================================
# ceph-doc: Ceph documentation
# =============================================================================
FILES:${PN}-doc = " \
    ${datadir}/doc/ceph \
    ${mandir} \
"

# =============================================================================
# INSANE_SKIP settings for known issues
# =============================================================================
# The erasure-code and rados-classes plugins have unusual SONAME patterns
INSANE_SKIP:${PN}-base += "dev-so"
INSANE_SKIP:${PN}-common += "dev-so"

# =============================================================================
# INSANE_SKIP for Python bindings (Cython embeds build paths)
# =============================================================================
# FIXME remove when Cython build path embedding is fixed
INSANE_SKIP:python3-rados += "buildpaths"
INSANE_SKIP:python3-rbd += "buildpaths"
INSANE_SKIP:python3-cephfs += "buildpaths"
INSANE_SKIP:python3-rgw += "buildpaths"

# Skip ldconfig for plugin directories
SKIP_LDCONFIG = "1"

# =============================================================================
# Alternative names/provides for compatibility
# =============================================================================
RPROVIDES:${PN}-cephadm = "cephadm"
RPROVIDES:${PN}-common = "ceph-client"

SYSTEMD_PACKAGES = "${PN}-common ${PN}-base ${PN}-mon ${PN}-osd ${PN}-mds ${PN}-mgr \
                    ${PN}-immutable-object-cache ${PN}-volume \
                    cephfs-mirror radosgw rbd-mirror"

SYSTEMD_SERVICE:${PN}-common = "ceph.target rbdmap.service"
SYSTEMD_SERVICE:${PN}-base = "ceph-crash.service"
SYSTEMD_SERVICE:${PN}-mon = "ceph-mon.target ceph-mon@.service"
SYSTEMD_SERVICE:${PN}-osd = "ceph-osd.target ceph-osd@.service"
SYSTEMD_SERVICE:${PN}-mds = "ceph-mds.target ceph-mds@.service"
SYSTEMD_SERVICE:${PN}-mgr = "ceph-mgr.target ceph-mgr@.service"
SYSTEMD_SERVICE:${PN}-immutable-object-cache = "ceph-immutable-object-cache.target ceph-immutable-object-cache@.service"
SYSTEMD_SERVICE:${PN}-volume = "ceph-volume@.service"
SYSTEMD_SERVICE:${PN}-exporter = "ceph-exporter.service"
SYSTEMD_SERVICE:cephfs-mirror = "cephfs-mirror.target cephfs-mirror@.service"
SYSTEMD_SERVICE:radosgw = "ceph-radosgw.target ceph-radosgw@.service"
SYSTEMD_SERVICE:rbd-mirror = "ceph-rbd-mirror.target ceph-rbd-mirror@.service"

SYSTEMD_AUTO_ENABLE = "disable"
