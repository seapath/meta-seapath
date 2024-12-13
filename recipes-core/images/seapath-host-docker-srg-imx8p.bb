# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

LICENSE = "Apache-2.0"

DESCRIPTION = "A production image for host with docker installed compatible with AAEON srg-imx8p machine"

require recipes-core/images/core-image-minimal.bb

# Add docker
IMAGE_INSTALL += " \
    docker-ce \
    docker-ce-contrib \
    python3-docker-compose \
"

# Add AAEON recommended software
IMAGE_INSTALL += " \
    aaeon-tools \
    libgpiod \
    libgpiod-dev \
    libgpiod-tools \
    service-tools \
"

# Add test tools
# multiprocessing module needs to be installed manually as it is not part of
# python3-core in this version of yocto.
IMAGE_INSTALL += " \
    linuxptp \
    python3-core \
    python3-multiprocessing \
"

IMAGE_FEATURES += "ssh-server-openssh"

COMPATIBLE_MACHINE = "(srg-imx8p-2g|srg-imx8p-4g)"

IMAGE_ROOTFS_EXTRA_SPACE += " + 8000000"
