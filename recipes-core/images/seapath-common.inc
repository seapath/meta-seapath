# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A common base for Seapath images"
LICENSE = "Apache-2.0"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL:append = " \
    cukinia-tests \
    cukinia-tests-common \
    ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','cukinia-tests-common-security','',d)} \
    linuxptp \
    system-config-common \
"
# Add kernel-modules
IMAGE_INSTALL:append = " \
    kernel-modules \
"

# Ansible required modules
IMAGE_INSTALL:append = " \
    python3-json \
    python3-modules \
"

IMAGE_INSTALL:append = " less"

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL:append = " openssh-sftp-server"

IMAGE_INSTALL:append = " syslog-ng"

# AMD micro-codes
IMAGE_INSTALL:append = " amd-ucode"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

IMAGE_FSTYPES = "wic.gz wic.bmap"
WKS_FILE = "mkefidisk.wks.in"
# Do not update fstab file when using wic images
WIC_CREATE_EXTRA_ARGS += "--no-fstab-update"
EXTRA_IMAGE_FEATURES = ""

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'security/users', '', d)}
inherit ansible-ssh

require ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','','recipes-core/images/seapath-common-no-security.inc',d)}

DEPENDS += "kconfig-hardened-check-native"
