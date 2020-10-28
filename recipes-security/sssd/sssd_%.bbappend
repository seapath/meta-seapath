# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
PACKAGECONFIG_append = " \
    curl \
    samba \
    systemd \
"
DEPENDS_append = " \
    cifs-utils \
    jansson \
"

EXTRA_OECONF = " \
    --with-smb-idmap-interface-version=5 \
    --without-nfsv4-idmapd-plugin \
    --with-ldb-lib-dir=${libdir}/ldb/modules/ldb \
"

SRC_URI += "file://sssd.service"

FILES_${PN}_append = "${systemd_unitdir}/system/sssd.service"
do_install_append() {
       install -d ${D}/${systemd_unitdir}/system
       install -m 644 ${WORKDIR}/sssd.service ${D}/${systemd_unitdir}/system/sssd.service
}
