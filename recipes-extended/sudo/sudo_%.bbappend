# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://sudoers\
"

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 0440 ${UNPACKDIR}/sudoers \
       ${D}${sysconfdir}/sudoers
}

inherit useradd security/users


USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "${SUDO_GROUP_OWNER}"
