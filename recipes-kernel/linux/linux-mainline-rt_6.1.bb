# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_MAJOR_VERSION = "6.1"
LINUX_REVISION_VERSION = "112"
LINUX_VERSION = "${LINUX_MAJOR_VERSION}.${LINUX_REVISION_VERSION}"
RT_REVISION = "rt43"
KBRANCH = "v${LINUX_MAJOR_VERSION}-rt"
LINUX_FULL_VERSION = "${LINUX_VERSION}-${RT_REVISION}"
KTAG = "v${LINUX_FULL_VERSION}"
PV = "${LINUX_FULL_VERSION}+git${SRCPV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=https;name=machine;tag=${KTAG};branch=${KBRANCH} \
        file://defconfig \
        file://megaraid.cfg \
        file://gcc-plugin.cfg \
        file://gcc-plugin_6.cfg \
        file://sched.cfg \
        file://drm.cfg \
        file://usb-acm.cfg \
"

SRC_URI:append:seapath-installer = " file://exfat.cfg"

# Uncomment this line to unaible debug traces in Kernel and tracing tools
# support (like LTTng or perf).
#SRC_URI:append = " file://traces.cfg"
