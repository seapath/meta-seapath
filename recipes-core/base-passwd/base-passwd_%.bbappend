FILESEXTRAPATHS:prepend:seapath-sec := "${THISDIR}/${PN}:"
SRC_URI:prepend:seapath-sec = " \
    file://passwd.master \
    file://group.master \
"

do_configure:prepend:seapath-sec () {
    cp -v ${WORKDIR}/passwd.master ${S}/
    cp -v ${WORKDIR}/group.master ${S}/
}
