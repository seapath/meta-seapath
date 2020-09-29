# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "A common base for rte product"
LICENSE = "Apache-2.0"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL_append = " \
    cukinia-tests \
    system-config \
"
# Add kernel-modules
IMAGE_INSTALL_append = " \
    kernel-modules \
"

# Container
IMAGE_INSTALL_append = " \
    docker-ce \
    docker-ce-contrib \
    kubernetes \
"

IMAGE_INSTALL_append = " less"

IMAGE_INSTALL_append = " pam-radius"

IMAGE_INSTALL_append = " sssd adcli krb5-user"
IMAGE_FEATURES += "ssh-server-openssh"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

IMAGE_FSTYPES = "wic.gz"
WKS_FILE = "mkefidisk.wks.in"
