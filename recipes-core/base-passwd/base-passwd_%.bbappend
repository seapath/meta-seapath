FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:prepend = " \
    file://passwd.master \
    file://group.master \
"

do_configure:prepend () {
    if ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false',d)}; then
        cp -v ${WORKDIR}/passwd.master ${S}/
        cp -v ${WORKDIR}/group.master ${S}/
    fi
}
