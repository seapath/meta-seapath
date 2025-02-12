# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "svtrace is a tool used to monitor IEC61850 SV network performance on a machine."
HOMEPAGE = "https://github.com/seapath/svtrace"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/seapath/svtrace;protocol=https;branch=main"

PV = "0.1+git${SRCPV}"
SRCREV = "0ae04c6a34cc1a6a3beaa1d60e6cf34d0cd10ec5"

S = "${WORKDIR}/git"

inherit setuptools3_legacy

RDEPENDS:${PN} += "bpftrace python3-core python3-pyshark"
