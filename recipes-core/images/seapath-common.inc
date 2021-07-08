# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A common base for Seapath images"
LICENSE = "Apache-2.0"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL_append = " \
    cukinia-tests \
    cukinia-tests-common \
    system-config-common \
"
# Add kernel-modules
IMAGE_INSTALL_append = " \
    kernel-modules \
"

# Ansible required modules
IMAGE_INSTALL_append = " \
    python3-json \
    python3-modules \
"

IMAGE_INSTALL_append = " less"

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL_append = " openssh-sftp-server"

IMAGE_INSTALL_append = " syslog-ng"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

IMAGE_FSTYPES = "wic.gz wic.bmap"
WKS_FILE = "mkefidisk.wks.in"
# Do not update fstab file when using wic images
WIC_CREATE_EXTRA_ARGS += "--no-fstab-update"
EXTRA_IMAGE_FEATURES = ""

inherit security/users
inherit ansible-ssh
