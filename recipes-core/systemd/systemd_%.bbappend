# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend :="${THISDIR}/files:"
SRC_URI_append = " \
    file://0001-networkd-wait-online-add-any-option.patch \
    file://basic.conf \
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
}
