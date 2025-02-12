# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath System configuration cluster"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"
RDEPENDS:${PN} = "libvirt pacemaker"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "\
    --system \
    -b /var/lib \
    -m \
    -p '*' \
    -G haclient,libvirt \
    livemigration \
"
USERADD_DEPENDS = "libvirt pacemaker"

ALLOW_EMPTY:${PN} = '1'

inherit allarch useradd
