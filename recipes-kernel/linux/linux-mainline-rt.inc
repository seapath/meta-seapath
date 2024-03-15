# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

require ${@bb.utils.contains('DISTRO_FEATURES', 'efi-secure-boot', 'linux-yocto-efi-secure-boot.inc', '', d)}

# EFI configured through defconfig rather than config fragments
KERNEL_FEATURES:remove = "${efi_secure_boot_sccs}"

# Set firmware path in kernel configuration
do_firmware_path () {
    # Will be used only if CONFIG_EXTRA_FIRMWARE="xxx"
    sed \
        "s@^CONFIG_EXTRA_FIRMWARE_DIR.*@CONFIG_EXTRA_FIRMWARE_DIR=\"${STAGING_DIR_TARGET}/${base_libdir}/firmware/\"@g" \
        -i ${B}/.config
}
addtask firmware_path before do_build after do_configure

# Kernel build process dependencies
DEPENDS += "bc-native bison-native openssl-native util-linux-native xz-native rsync-native elfutils-native"

KCONFIG_MODE="--alldefconfig"
KMACHINE ?= "${MACHINE}"

# Required to add firmwares built-in
DEPENDS += " linux-firmware "
inherit kernel
inherit kernel-yocto

LINUX_VERSION_EXTENSION:append = "-mainline-rt"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(seapath|seapath-no-iommu)"

do_deploy:append() {
   install -m 0644 .config $deployDir/config_kernel
}
