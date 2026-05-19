# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

include cve-exclusion-6.12.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-mainline-rt_6.12:"

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_MAJOR_VERSION = "6.12"
LINUX_REVISION_VERSION = "89"
LINUX_VERSION = "${LINUX_MAJOR_VERSION}.${LINUX_REVISION_VERSION}"
RT_REVISION = "rt18"
KBRANCH = "v${LINUX_MAJOR_VERSION}-rt"
LINUX_FULL_VERSION = "${LINUX_VERSION}-${RT_REVISION}"
KTAG = "v${LINUX_FULL_VERSION}"
PV = "${LINUX_FULL_VERSION}+git${SRCPV}"

SRCREV = "fa86ec894b58dec08703af4a28eb27ccb5d4ecfb"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=https;name=machine;branch=${KBRANCH} \
        file://defconfig \
        file://megaraid.cfg \
        file://gcc-plugin.cfg \
        file://gcc-plugin_6.cfg \
        file://sched.cfg \
        file://usb-acm.cfg \
        file://vsockets.cfg \
        file://rt.cfg \
        file://podman.cfg \
        file://x86-64-hardening.cfg \
        file://generic-hardened.cfg \
        file://low-latency-passthrough.cfg \
"

SRC_URI:append:seapath-installer = " file://exfat.cfg"

# Uncomment this line to enable debug traces in Kernel and tracing tools
# support (like LTTng or perf).
#SRC_URI:append = " file://traces.cfg"
