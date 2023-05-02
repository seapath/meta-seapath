# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_VERSION = "5.15.92"
RT_REVISION = "rt57"
PV = "${LINUX_VERSION}-${RT_REVISION}"
KBRANCH = "v${PV}"


SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=https;name=machine;tag=${KBRANCH};nobranch=1; \
        file://defconfig \
        file://megaraid.cfg \
"

SRC_URI:append_votp-no-iommu = " \
        file://no-iommu.cfg \
"

# Uncomment this line to unaible debug traces in Kernel and tracing tools
# support (like LTTng or perf).
#SRC_URI:append = " file://traces.cfg"

