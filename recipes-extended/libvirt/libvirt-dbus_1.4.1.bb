# SPDX-License-Identifier: Apache-2.0
# Import from meta-virtualization 415cc454d08c0151e51bb987233c30052bb663a4

SUMMARY = "dBus wrapper for libvirt"
DESCRIPTION = "libvirt-dbus wraps libvirt API to provide a high-level object-oriented API better suited for dbus-based applications."
AUTHOR = "Lars Karlitski <lars@karlitski.net> Pavel Hrdina <phrdina@redhat.com> Katerina Koukiou <kkoukiou@redhat.com>"
HOMEPAGE = "https://www.libvirt.org/dbus.html"
BUGTRACKER = "https://gitlab.com/libvirt/libvirt-dbus/-/issues"
SECTION = "libs"
LICENSE = "LGPL-2.1-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=4fbd65380cdd255951079008b364516c"
CVE_PRODUCT = "libvirt-dbus"

DEPENDS += "glib-2.0 libvirt libvirt-glib python3-docutils-native"

SRC_URI = "git://gitlab.com/libvirt/libvirt-dbus.git;nobranch=1;protocol=https"

SRCREV = "0c355bb8921d7cbccf93f41a8615fcd973e64f70"
S = "${WORKDIR}/git"

inherit meson pkgconfig

FILES:${PN} += "\
    ${datadir}/dbus-1/* \
    ${datadir}/polkit-1/* \
"
