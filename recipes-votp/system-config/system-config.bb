DESCRIPTION = "Votp System configuration"
LICENSE = "CLOSED"

SRCREV = "${AUTOREV}"

SRC_URI = " \
    file://votp-loadkeys.service \
"

do_install () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/votp-loadkeys.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = " \
    votp-loadkeys.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd
