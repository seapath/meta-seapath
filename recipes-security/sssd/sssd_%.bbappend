FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
PACKAGECONFIG_append = " curl systemd"
DEPENDS_append = " jansson"
