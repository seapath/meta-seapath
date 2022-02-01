# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "A common base for image used to flash Seapath images"
LICENSE = "Apache-2.0"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL_append = " \
    bmap-tools \
    flash-script \
    python3-json \
    python3-modules \
    os-release \
    kbd-keymaps \
"
# Add kernel-modules
IMAGE_INSTALL_append = " \
    kernel-modules \
"

IMAGE_INSTALL_append = " openssh-sshd openssh-sftp-server"

IMAGE_INSTALL_append = " less"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

IMAGE_FSTYPES = "wic.gz wic.bmap"
IMAGE_FEATURES += "ssh-server-openssh allow-empty-password empty-root-password"
EXTRA_IMAGE_FEATURES = ""

USERS_SSH_ANSIBLE = "root"

inherit ansible-ssh
COMPATIBLE_MACHINE = "votp-flash"
