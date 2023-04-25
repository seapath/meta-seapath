# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "Seapath images flash script"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN} = "bash"

SRC_URI = " \
    file://flash.sh \
    file://profile \
"

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/flash.sh ${D}/${bindir}/flash
    install -d -m 0700 ${D}/${ROOT_HOME}
    install -m 0644 ${WORKDIR}/profile ${D}/${ROOT_HOME}/.profile

}

FILES:${PN} = "${bindir}/flash"
FILES:${PN} += "${ROOT_HOME}/.profile"
