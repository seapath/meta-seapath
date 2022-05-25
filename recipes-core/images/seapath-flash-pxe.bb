# Copyright (C) 2021, RTE (http://www.rte-france.com)

DESCRIPTION = "An PXE image used to flash other Seapath images"
require recipes-core/images/seapath-flash-common.inc

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
PACKAGE_INSTALL = "${IMAGE_INSTALL}"
INITRAMFS_IMAGE = "image-initramfs"
INITRAMFS_IMAGE_BUNDLE = "1"

# Set initramfs max size ot 256 MB
INITRAMFS_MAXSIZE = "262144"


# Install EFI tools
IMAGE_INSTALL_append = " \
    efitools             \
    efibootmgr           \
"
