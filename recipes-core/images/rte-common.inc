DESCRIPTION = "A common base for rte product"
LICENSE = "CLOSED"
require recipes-core/images/core-image-minimal.bb
IMAGE_INSTALL_append = " \
    cukinia-tests \
    system-config \
"

# Virtualization
IMAGE_INSTALL_append = " \
    libvirt \
    libvirt-libvirtd \
    libvirt-virsh \
    openvswitch \
    qemu \
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

GLIBC_GENERATE_LOCALES = "en_US.UTF-8 fr_FR.UTF-8"
IMAGE_LINGUAS ?= "en_US fr_FR"

IMAGE_FSTYPES = "wic.gz"
WKS_FILE = "mkefidisk.wks.in"
