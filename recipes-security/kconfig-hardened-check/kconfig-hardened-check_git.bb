# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Kernel configuration hardening check tool"
DESCRIPTION = "Audit the kernel configuration and check against hardening recommandations made by several actors of the Linux security community"

LICENSE = "GPL-3.0-or-later"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d32239bcb673463ab874e80d47fae504"

SRC_URI = "git://github.com/a13xp0p0v/${BPN};protocol=https;branch=master"

SRC_URI[md5sum] = "283a53ac7fa1c9096521a58161f77019"
SRC_URI[sha256sum] = "ffea105f7532fe03ae48f4d0b8c9c0a74f1279a924111214c43f96e1200823ba"

# v0.6.17.1
SRCREV = "afc376f2a935994793343cfeb05953583cc30191"


BBCLASSEXTEND = "native"

RDEPENDS:${PN} += "python3"

inherit python3native python_setuptools_build_meta
