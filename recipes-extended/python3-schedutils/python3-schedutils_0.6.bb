# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Python interface for the Linux scheduler functions etc."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

SRCREV="v${PV}"
S="${WORKDIR}/git"

SRC_URI = "git://git.kernel.org/pub/scm/libs/python/python-schedutils/python-schedutils.git;branch=main"

inherit distutils3
