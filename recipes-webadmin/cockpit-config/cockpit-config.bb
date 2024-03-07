DESCRIPTION = "Cockpit configuration for Seapath"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} = "cockpit"

SRC_URI = " \
    file://cockpit \
"

inherit allarch

do_install(){
    install -d -m 0750 ${D}/${sysconfdir}/sudoers.d
    install -m 0440 ${WORKDIR}/cockpit ${D}/${sysconfdir}/sudoers.d/cockpit
}
