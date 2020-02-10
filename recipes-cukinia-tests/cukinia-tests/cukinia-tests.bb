SUMMARY = "cukinia-tests"
DESCRIPTION = "Cukinia test files"
HOMEPAGE = "https://github.com/savoirfairelinux/cukinia"
LICENSE = "CLOSED"
SRC_URI = "\
    file://cukinia.conf \
    file://tests.d/00-cukinia-installation.conf \
"
RDEPENDS_${PN} += "cukinia"
RDEPENDS_${PN} += "bash"
do_install () {
    install -m 0755 -d ${D}${sysconfdir}/cukinia/
    install -m 0755 -d ${D}${sysconfdir}/cukinia/tests.d/
    install -m 0644 ${WORKDIR}/cukinia.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/tests.d/00-cukinia-installation.conf ${D}${sysconfdir}/cukinia/tests.d
}
