SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPLv2"

require recipes-kernel/linux/linux.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

# Set firmware path in kernel configuration
do_firmware_path () {
    # Will be used only if CONFIG_EXTRA_FIRMWARE="xxx"
    sed "s@^CONFIG_EXTRA_FIRMWARE_DIR.*@CONFIG_EXTRA_FIRMWARE_DIR=\"${STAGING_DIR_TARGET}/${base_libdir}/firmware/\"@g" -i ${WORKDIR}/defconfig
}
addtask firmware_path before do_configure after do_patch

# Kernel build process dependencies
DEPENDS += "bc-native bison-native openssl-native util-linux-native xz-native rsync-native"

# Required to add firmwares built-in
DEPENDS += " linux-firmware "
inherit kernel
