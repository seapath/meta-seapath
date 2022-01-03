# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend :="${THISDIR}/files:"
SRC_URI_append = " \
    file://0001-networkd-wait-online-add-any-option.patch \
    file://basic.conf \
    file://boot-complete.target \
    file://resolved.conf \
    file://journald.conf \
    file://systemd-networkd-wait-online.service \
"
PACKAGECONFIG_append = " seccomp"
do_install_append () {
    install -m 0644 ${WORKDIR}/basic.conf ${D}/usr/lib/sysusers.d/
    # Remove audio group references
    sed '/- audio -/d' -i ${D}/usr/lib/tmpfiles.d/static-nodes-permissions.conf
    # Remove missing group in udev rules
    for group in dialout kmem render audio lp cdrom tape ; do
        sed "/GROUP=\"${group}\"/d" -i \
            ${D}/${rootlibexecdir}/udev/rules.d/50-udev-default.rules
    done
    # Change boot-complete.target to be run after multi-user.target
    install -m 644 ${WORKDIR}/boot-complete.target \
        ${D}/${systemd_unitdir}/system/boot-complete.target
    install -m 0644 ${WORKDIR}/journald.conf \
        ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/resolved.conf \
        ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/systemd-networkd-wait-online.service ${D}${sysconfdir}/systemd/system/
}
