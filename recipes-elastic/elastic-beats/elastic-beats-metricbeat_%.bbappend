FILESEXTRAPATHS:prepend :="${THISDIR}/files:"

inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"

SRCREV = "1d9cced55410003f5d0b4594ff5471d15a4e2900"

SRC_URI = " \
        git://${GO_IMPORT}.git;protocol=https;branch=7.11 \
        "

SRC_URI:append = " file://metricbeat.service"
SRC_URI:append = " file://system.yml"
SRC_URI:append = " file://metricbeat.yml"
SYSTEMD_SERVICE:${PN} = "metricbeat.service"
FILES:${PN} += "${systemd_system_unitdir}/metricbeat.service"

do_install:append() {
  install -d ${D}${sysconfdir}/${GO_PACKAGE}/modules.d
  install -m 0644 ${WORKDIR}/system.yml ${D}${sysconfdir}/${GO_PACKAGE}/modules.d/system.yml
  install -d ${D}${systemd_system_unitdir}
  install -m 0644 ${WORKDIR}/metricbeat.service ${D}${systemd_system_unitdir}
}
