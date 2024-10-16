# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024, Savoir-faire Linux, Inc
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A Python3 module to manage VMs in a SEAPATH cluster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = " \
    git://github.com/seapath/vm_manager.git;protocol=https;branch=main \
    file://0001-vm-manager-fix-RADOS-permission-denied-issue.patch \
"

SRCREV = "d26cc7f3b4710a476519b27c48b9055fc72870b5"
S = "${WORKDIR}/git"

RDEPENDS:${PN} = "python3 libvirt"
RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', "pacemaker ceph", '', d)}"

inherit setuptools3

do_install:append() {
    # Create testdata directory
    install -d ${D}/${datadir}/testdata

    # Move python test scripts in testdata
    mv ${D}/${bindir}/* ${D}/${datadir}/testdata/
    rm -rf ${D}/${bindir}

    # testdata files
    install -m 644 ${S}/vm_manager/testdata/* ${D}/${datadir}/testdata/

    # Install CLI tool as "vm-mgr"
    install -D -m 750 ${S}/vm_manager_cmd.py ${D}/${sbindir}/vm-mgr
}

FILES:${PN} += "${datadir}/testdata/*"
