# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/.:"
DESCRIPTION = "A Python3 module to apply an OVS configuration from a JSON file"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
RDEPENDS_${PN} = "python3 openvswitch"
SRC_URI = "file://src/"
S = "${WORKDIR}/src"
inherit setuptools3
