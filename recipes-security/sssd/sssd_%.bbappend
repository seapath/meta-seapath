FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
PACKAGECONFIG_append = " curl systemd"
DEPENDS_append = " jansson"

SRC_URI += "file://sssd.service"

FILES_${PN}_append = "${systemd_unitdir}/system/sssd.service"
do_install_append() {
       install -d ${D}/${systemd_unitdir}/system
       install -m 644 ${WORKDIR}/sssd.service ${D}/${systemd_unitdir}/system/sssd.service
}
