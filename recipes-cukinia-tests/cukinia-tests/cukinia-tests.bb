SUMMARY = "cukinia-tests"
DESCRIPTION = "Cukinia test files"
HOMEPAGE = "https://github.com/savoirfairelinux/cukinia"
LICENSE = "CLOSED"
SRC_URI = "\
    file://cukinia.conf \
    file://tests.d/00-cukinia-installation.conf \
    file://tests.d/01-sw-versions.conf \
    file://tests.d/02-preempt-rt.conf \
    file://tests.d/03-no-kernel-errors.conf \
    file://tests.d/04-virtualization.conf \
"
RDEPENDS_${PN} += "cukinia"
RDEPENDS_${PN} += "bash"
do_install () {
    install -m 0755 -d ${D}${sysconfdir}/cukinia/
    install -m 0755 -d ${D}${sysconfdir}/cukinia/tests.d/
    install -m 0644 ${WORKDIR}/cukinia.conf ${D}${sysconfdir}/cukinia
    install -m 0644 ${WORKDIR}/tests.d/00-cukinia-installation.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/01-sw-versions.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/02-preempt-rt.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/03-no-kernel-errors.conf ${D}${sysconfdir}/cukinia/tests.d
    install -m 0644 ${WORKDIR}/tests.d/04-virtualization.conf ${D}${sysconfdir}/cukinia/tests.d
}
