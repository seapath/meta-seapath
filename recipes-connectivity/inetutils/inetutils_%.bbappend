FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:seapath = " file://0001-ping-remove-root-suid-sgid.patch"

CVE_STATUS[CVE-2026-32746] = "not-applicable-config: telnetd not included in SEAPATH"
