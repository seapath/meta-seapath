# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024-2026, Savoir-faire Linux, Inc
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to apply an OVS configuration from a JSON file"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/seapath/python3-setup-ovs.git;protocol=https;branch=main"
SRCREV = "9420aa925310ecbb4b67ec4f91610127bd217f14"

RDEPENDS:${PN} = "python3 openvswitch python3-pyyaml"

inherit python_setuptools_build_meta
