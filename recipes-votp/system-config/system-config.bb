DESCRIPTION = "Votp System configuration"
LICENSE = "CLOSED"

SRCREV = "${AUTOREV}"

SRC_URI = " \
    file://votp-config_ovs.service \
    file://votp-loadkeys.service \
"

do_install () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/votp-config_ovs.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/votp-loadkeys.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = " \
    votp-config_ovs.service \
    votp-loadkeys.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd
