# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Active Directory enrollment"
DESCRIPTION = "A helper library and tools for Active Directory client operations."

HOMEPAGE = "http://cgit.freedesktop.org/realmd/adcli"
SECTION = "net"

SRC_URI = "https://gitlab.freedesktop.org/realmd/adcli/-/archive/${PV}/${PN}-${PV}.tar.gz;name=libtar"
SRC_URI[libtar.md5sum] = "5f543b231169768b543a170ff2282435"

LICENSE = "LGPL-2.0+"
LIC_FILES_CHKSUM = "file://COPYING;md5=23c2a5e0106b99d75238986559bb5fc6"

inherit autotools xmlcatalog

DEPENDS += "virtual/crypt krb5 openldap gettext libxslt xmlto libxml2-native \
            cyrus-sasl libxslt-native xmlto-native coreutils-native\
           "

EXTRA_OECONF += "--disable-static \
                 --disable-silent-rules \
                 --disable-doc \
                "
