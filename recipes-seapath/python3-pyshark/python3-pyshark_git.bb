LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=0b2555c8f5ba5a6aa4636b49c1d4b754"

SRC_URI = "git://github.com/KimiNewt/pyshark;protocol=https;branch=master"

PV = "1.0+git${SRCPV}"
SRCREV = "c89fc6e67e8ae67bcfabadef906b977c911636dc"

S = "${WORKDIR}/git"

inherit setuptools3_legacy
SETUPTOOLS_SETUP_PATH = "${S}/src"
RDEPENDS:${PN} += " \
    python3-appdirs \
    python3-lxml \
    python3-packaging \
    python3-termcolor \
    tshark"
