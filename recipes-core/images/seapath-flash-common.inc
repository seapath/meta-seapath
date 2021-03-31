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
    system-config \
"
# Add kernel-modules
IMAGE_INSTALL_append = " \
    kernel-modules \
"

IMAGE_INSTALL_append = " openssh-sshd openssh-sftp-server"

IMAGE_INSTALL_append = " less"

IMAGE_FEATURES += "debug-tweaks"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

IMAGE_FSTYPES = "wic.gz"
EXTRA_IMAGE_FEATURES = ""
