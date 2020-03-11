DESCRIPTION = "A common base for rte product"
LICENSE = "CLOSED"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL_append = " \
    cukinia-tests \
    system-config \
"

# Virtualization
IMAGE_INSTALL_append = " \
    qemu \
"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

WKS_FILE = "mkefidisk.wks.in"
