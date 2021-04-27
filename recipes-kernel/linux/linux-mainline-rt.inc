# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0"

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

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

KBRANCH ?= "v4.19.188-rt77"
KCONFIG_MODE="--alldefconfig"
KMACHINE ?= "${MACHINE}"

# Required to add firmwares built-in
DEPENDS += " linux-firmware "
inherit kernel
inherit kernel-yocto
inherit security/deploy-kernelconfig

