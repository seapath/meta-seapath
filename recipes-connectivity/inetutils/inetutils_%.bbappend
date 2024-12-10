FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:seapath = " file://0001-ping-remove-root-suid-sgid.patch"
