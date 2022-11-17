# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Tuna"
HOMEPAGE = "https://rt.wiki.kernel.org/index.php/Tuna"
DESCRIPTION = "cui/gui tool for tuning of running processes"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRCREV="0681906e75e1c8166126bbfc2f3055e7507bfcb5"
S="${WORKDIR}/git"

RDEPENDS_${PN} += " \
    python3-linux-procfs \
    python3-schedutils \
    python3-inet-diag \
    "

do_install_append() {
    install -m 0755 -d ${D}/${bindir}
    install -m 0755 ${S}/tuna-cmd.py ${D}/${bindir}/tuna
}

SRC_URI = "git://git.kernel.org/pub/scm/utils/tuna/tuna.git;branch=main"

inherit distutils3
