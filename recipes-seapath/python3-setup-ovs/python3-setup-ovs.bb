# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024, Savoir-faire Linux, Inc
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to apply an OVS configuration from a JSON file"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/seapath/python3-setup-ovs.git;protocol=https;branch=main"
SRCREV = "9a4462360e070b80142c7def1f0906a64cc56931"
S = "${WORKDIR}/git"

RDEPENDS:${PN} = "python3 openvswitch python3-pyyaml"

inherit setuptools3
