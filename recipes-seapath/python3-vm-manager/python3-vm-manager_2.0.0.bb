# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2025-2026, Savoir-faire Linux, Inc
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to manage VMs in a SEAPATH cluster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = " \
    git://github.com/seapath/vm_manager.git;protocol=https;branch=main \
"

SRCREV = "16bf3bc5d6f9bb0b8edba624535ffa64065db3df"

RDEPENDS:${PN} = "python3 libvirt jq"
RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', "pacemaker ceph", '', d)}"

inherit python_setuptools_build_meta

do_install:append() {
    ln -s ${bindir}/vm_manager_cmd ${D}/${bindir}/vm-mgr
}

FILES:${PN} += "${datadir}/testdata/*"
