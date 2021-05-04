FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_prepend = " \
    file://passwd.master \
    file://group.master \
"

do_configure_prepend () {
    cp -v ${WORKDIR}/passwd.master ${S}/
    cp -v ${WORKDIR}/group.master ${S}/
}
