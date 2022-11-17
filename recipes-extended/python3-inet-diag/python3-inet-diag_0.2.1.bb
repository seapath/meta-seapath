# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Python bindings for the inet_diag kernel interface"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

SRCREV="v${PV}"
S="${WORKDIR}/git"

SRC_URI = "git://git.kernel.org/pub/scm/libs/python/python-inet_diag/python-inet_diag.git;branch=master;protocol=https"

inherit distutils3
