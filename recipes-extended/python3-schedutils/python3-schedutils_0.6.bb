# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Python interface for the Linux scheduler functions etc."
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=8ca43cbc842c2336e835926c2166c28b"

SRCREV="07657b88d8745e0e349ac272c1f1f2f0a18064d3"
S="${WORKDIR}/git"

SRC_URI = " \
  git://git.kernel.org/pub/scm/libs/python/python-schedutils/python-schedutils.git;branch=main;protocol=https \
  file://0001-setup.py-use-setuptools-instead-of-distutils.patch \
"

inherit setuptools3
