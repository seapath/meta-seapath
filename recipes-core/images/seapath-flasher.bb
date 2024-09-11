# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "An image to flash other SEAPATH images"
LICENSE = "Apache-2.0"

inherit image

IMAGE_FSTYPES = "wic.gz wic.bmap"

# Note that this recipe does not install any package. It uses the Kernel and the
# initramfs created in the seapath-flasher-cpio recipe.
do_image_wic[depends] += "seapath-flasher-cpio:do_image_complete"
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot
do_package[noexec] = "1"
deltask do_package_qa
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"
EXCLUDE_FROM_WORLD = "1"

EXTRA_IMAGE_FEATURES = ""

COMPATIBLE_MACHINE = "seapath-installer"

PACKAGE_INSTALL += "ovmf-shell-efi"
IMAGE_EFI_BOOT_FILES = "${KERNEL_IMAGETYPE} microcode.cpio shellx64.efi;efi/boot/shellx64.efi"

WKS_FILE = "flasher.wks.in"
