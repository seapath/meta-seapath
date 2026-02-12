FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://tmpfile-lvm2.conf"

do_install:append() {
    # Install lvm2 tmpfile.d required by cephadm
    install -d ${D}${libdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/tmpfile-lvm2.conf ${D}${libdir}/tmpfiles.d/lvm2.conf
}

FILES:${PN} += "${libdir}/tmpfiles.d/lvm2.conf"
