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

    # The ceph-ansible 16 search ceph scripts inside /usr/libexec/ceph directory
    # only on Yocto. Moving the scripts to /usr/libexec/ceph directory result to
    # other issues. So, we create a symlink to the scripts here because we do
    # not have a way to patch ceph-ansible on SEAPATH.
    for ceph_script in ceph-osd-prestart.sh ceph_common.sh ; do
        ln -sf /usr/lib/ceph/${ceph_script} ${D}/${libexecdir}/${ceph_script}
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

RDEPENDS:${PN} += "\
    lvm2 \
    python3-dateutil \
    python3-requests \
"

REQUIRED_DISTRO_FEATURES:append = "systemd"
