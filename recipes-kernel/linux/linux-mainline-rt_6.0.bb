# Copyright (C) 2023 Savoir-faire Linux, Inc
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_VERSION = "6.0.5"
RT_REVISION = "rt14"
PV = "${LINUX_VERSION}-${RT_REVISION}"
KBRANCH = "v${PV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git;protocol=git;name=machine;tag=${KBRANCH};nobranch=1; \
        file://defconfig \
        file://megaraid.cfg \
"

SRC_URI_append_votp-no-iommu = " \
        file://no-iommu.cfg \
"

# Uncomment this line to unaible debug traces in Kernel and tracing tools
# support (like LTTng or perf).
#SRC_URI_append = " file://traces.cfg"


