# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "SWUpdate upgrade image for SEAPATH arm"
LICENSE = "Apache-2.0"
FILESEXTRAPATHS:prepend := "${THISDIR}/files/hosts:"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit swupdate

SRC_URI = "\
    file://sw-description \
    file://swupdate_install.sh \
"

# Images to build before building SWUpdate image
IMAGE_DEPENDS = "seapath-host-docker-srg-imx8p"

# Images and files that will be included in the .swu image
SWUPDATE_IMAGES = "seapath-host-docker-srg-imx8p seapath-host-docker-srg-imx8p-boot"

SWUPDATE_IMAGES_FSTYPES[seapath-host-docker-srg-imx8p] = ".tar.xz"
SWUPDATE_IMAGES_FSTYPES[seapath-host-docker-srg-imx8p-boot] = ".tar.xz"
