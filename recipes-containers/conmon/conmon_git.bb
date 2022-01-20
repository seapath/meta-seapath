SUMMARY = "An OCI container runtime monitor"
SECTION = "console/utils"
HOMEPAGE = "https://github.com/containers/conmon"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=61af0b6932ea7b12fb9142721043bc77"

inherit features_check
REQUIRED_DISTRO_FEATURES ?= "seccomp"

DEPENDS = "glib-2.0 go-md2man-native libseccomp"

SRCREV = "e67bb4d9bb74424569b3b38943d13fe9e5dfcb20"
SRC_URI = "\
    git://github.com/containers/conmon.git;branch=main;protocol=https \
"

PV = "2.0.30+git${SRCPV}"

S = "${WORKDIR}/git"

inherit pkgconfig

EXTRA_OEMAKE = "PREFIX=${prefix} BINDIR=${bindir} LIBEXECDIR=${libexecdir}"

PACKAGECONFIG ??= "${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"
PACKAGECONFIG[systemd] = ",,systemd"

do_install() {
    oe_runmake 'DESTDIR=${D}' install
}



