# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2024 Savoir-faire Linux, Inc

SUMMARY = "Cockpit UI for virtual machines"
DESCRIPTION = "Cockpit-machines provides a user interface to manage virtual machines"

LICENSE = "LGPL-2.1-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4fbd65380cdd255951079008b364516c"

DEPENDS += "cockpit"

SRC_URI = "https://github.com/cockpit-project/cockpit-machines/releases/download/${PV}/cockpit-machines-${PV}.tar.xz"
SRC_URI[sha256sum] = "b9b41d728d68ae9d21c229765e00793ad018231903c84ed653c21d25444714e3"

S = "${WORKDIR}/${PN}"

inherit autotools-brokensep features_check gettext

COMPATIBLE_HOST:libc-musl = "null"

RDEPENDS:${PN} += "cockpit libvirt-dbus pciutils virt-manager-install"

REQUIRED_DISTRO_FEATURES = "systemd pam"

# Default installation path of cockpit-machines is /usr/local/
FILES:${PN} = "\
    ${prefix}/local/ \
    ${datadir}/metainfo/org.cockpit-project.cockpit-machines.metainfo.xml \
"

BUGTRACKER = "github.com/cockpit-project/cockpit-machines/issues"
