FILESEXTRAPATHS:prepend:seapath-sec := "${THISDIR}/${PN}:"
SRC_URI:prepend:seapath-sec = " \
    file://passwd.master \
    file://group.master \
"

do_configure:prepend:seapath-sec () {
    cp -v ${UNPACKDIR}/passwd.master ${S}/
    cp -v ${UNPACKDIR}/group.master ${S}/
}
