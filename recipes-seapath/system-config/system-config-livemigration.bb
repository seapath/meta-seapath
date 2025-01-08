# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Seapath livemigration System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit useradd

RDEPENDS:${PN} = "libvirt pacemaker"

# Add DEPENDS required for create the livemigration user
DEPENDS += "libvirt pacemaker"

USERADD_PACKAGES = "${PN}"
USERADD_PARAM:${PN} = "\
    --system \
    -b /var/lib \
    -m \
    -p '*' \
    -G haclient,libvirt \
    livemigration \
"
