# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

include cve-exclusion-6.12.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-mainline-rt_6.12:"

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_MAJOR_VERSION = "6.12"
LINUX_REVISION_VERSION = "95"
LINUX_VERSION = "${LINUX_MAJOR_VERSION}.${LINUX_REVISION_VERSION}"
KBRANCH = "linux-${LINUX_MAJOR_VERSION}.y"
LINUX_FULL_VERSION = "${LINUX_VERSION}"
KTAG = "v${LINUX_FULL_VERSION}"
PV = "${LINUX_FULL_VERSION}+git${SRCPV}"

SRCREV = "296aabce459470a4c1b68ffd0c0c0920e563aaad"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git;protocol=https;name=machine;branch=${KBRANCH} \
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
        file://fq_codel.cfg \
"

SRC_URI:append:seapath-installer = " file://exfat.cfg"

# Enable debug traces in Kernel and tracing tools support (like LTTng or perf).
SRC_URI:append:seapath-lttng = " file://traces.cfg"
