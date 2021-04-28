# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to manage VMs in a SEAPATH cluster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"
RDEPENDS_${PN} = "python3 ceph pacemaker"
SRC_URI = "file://src/"
S = "${WORKDIR}/src"
FILESEXTRAPATHS_prepend := "${THISDIR}/.:"
inherit setuptools3
