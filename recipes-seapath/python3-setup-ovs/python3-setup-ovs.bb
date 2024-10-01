# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to apply an OVS configuration from a JSON file"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/seapath/python3-setup-ovs.git;protocol=https;branch=main"
SRCREV = "9a4462360e070b80142c7def1f0906a64cc56931"
S = "${WORKDIR}/git"

RDEPENDS:${PN} = "python3 openvswitch python3-pyyaml"

inherit setuptools3
