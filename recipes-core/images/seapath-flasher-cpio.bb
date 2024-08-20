# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Initramfs image, which can be used by seapath-flasher."
LICENSE = "Apache-2.0"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL:append = " \
    bmaptool \
    e2fsprogs-mke2fs \
    flash-script \
    flash-script-auto \
    python3-json \
    python3-modules \
    os-release \
    kbd-keymaps \
    efitools \
    efibootmgr \
    linux-firmware-amdgpu \
    system-config-keymap \
"
# Add kernel-modules
IMAGE_INSTALL:append = " \
    kernel-modules \
"

IMAGE_INSTALL:append = " openssh-sshd openssh-sftp-server"

IMAGE_INSTALL:append = " less"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

PACKAGE_INSTALL = "${IMAGE_INSTALL}"
INITRAMFS_FSTYPES = "cpio.gz"
INITRAMFS_IMAGE_BUNDLE = "0"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

IMAGE_FEATURES += "ssh-server-openssh allow-empty-password empty-root-password"
EXTRA_IMAGE_FEATURES = ""

USERS_SSH_ANSIBLE = "root"

inherit ansible-ssh
COMPATIBLE_MACHINE = "seapath-installer"

# 256MB
INITRAMFS_MAXSIZE = "400000"
