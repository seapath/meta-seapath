FILESEXTRAPATHS_prepend :="${THISDIR}/files:"

inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"

SRC_URI_append = " file://metricbeat.service"
SRC_URI_append = " file://system.yml"
SYSTEMD_SERVICE_${PN} = "metricbeat.service"
FILES_${PN} += "${systemd_system_unitdir}/metricbeat.service"

do_install_append() {
  install -d ${D}${sysconfdir}/${GO_PACKAGE}/modules.d
  install -m 0644 ${WORKDIR}/system.yml ${D}${sysconfdir}/${GO_PACKAGE}/modules.d/system.yml
  install -d ${D}${systemd_system_unitdir}
  install -m 0644 ${WORKDIR}/metricbeat.service ${D}${systemd_system_unitdir}
}
