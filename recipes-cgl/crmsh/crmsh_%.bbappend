# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

do_install:append() {
    install -d ${D}${sysconfdir}/tmpfiles.d
    echo "f /var/log/crmsh/crmsh.log 0664 hacluster haclient -" > ${D}${sysconfdir}/tmpfiles.d/crmsh-log.conf
}

FILES:${PN} += "${sysconfdir}/tmpfiles.d/crmsh-log.conf"
