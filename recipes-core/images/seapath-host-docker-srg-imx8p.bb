# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

LICENSE = "Apache-2.0"

DESCRIPTION = "A production image for host with docker installed compatible with AAEON srg-imx8p machine"

require recipes-core/images/seapath-host-common.inc
require recipes-core/images/seapath-swupdate-common.inc

WKS_FILE="sdimage-aaeon.wks.in"

# Add AAEON recommended software
IMAGE_INSTALL += " \
    aaeon-tools \
    libgpiod \
    libgpiod-dev \
    libgpiod-tools \
    service-tools \
"

IMAGE_INSTALL += " \
    net-snmp-configuration \
"

# Add test tools
# multiprocessing module needs to be installed manually as it is not part of
# python3-core in this version of yocto.
IMAGE_INSTALL += " \
    linuxptp \
    python3-core \
    python3-multiprocessing \
"

IMAGE_QA_COMMANDS:remove = " \
    grub_file_is_setup_properly \
    verify_secureboot_signature \
    "

IMAGE_FEATURES += "ssh-server-openssh"

COMPATIBLE_MACHINE = "seapath-hypervisor-aaeon"

IMAGE_ROOTFS_EXTRA_SPACE += " + 8000000"
