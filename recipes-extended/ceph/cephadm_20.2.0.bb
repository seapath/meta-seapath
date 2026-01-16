# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Ceph cluster management tool"
DESCRIPTION = "cephadm is a utility to bootstrap and manage Ceph clusters using containers"
HOMEPAGE = "https://ceph.io/"
LICENSE = "LGPL-2.1-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.1-or-later;md5=2a4f4fd2128ea2f65047ee63fbca9f68"

SRC_URI = "https://download.ceph.com/rpm-${PV}/el9/noarch/cephadm;downloadfilename=cephadm-${PV}"
SRC_URI[sha256sum] = "ed5a13ad26f7f55dd30e9b63855e4e581fd86973bec1d21a12ed0bb26af19c8b"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/cephadm-${PV} ${D}${sbindir}/cephadm
}

RDEPENDS:${PN} = "python3-core lvm2"

RRECOMMENDS:${PN} = " \
    podman \
"

COMPATIBLE_HOST = "(x86_64).*"
