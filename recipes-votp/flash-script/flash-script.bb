# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "Seapath images flash script"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS_${PN} = "bash"

SRC_URI = " \
    file://flash.sh \
"

do_install () {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/flash.sh ${D}/${bindir}/flash

}

FILES_${PN} = "${bindir}/flash"
