# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_VERSION = "5.15.14"
RT_REVISION = "rt27"
PV = "${LINUX_VERSION}-${RT_REVISION}"
KBRANCH = "v${PV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=git;name=machine;tag=${KBRANCH};nobranch=1; \
        file://defconfig \
        file://megaraid.cfg \
"

SRC_URI_append_votp-guest = " \
        file://ptp_kvm.cfg \
"
SRC_URI_append_votp-no-iommu = " \
        file://no-iommu.cfg \
"

# Uncomment this line to unaible debug traces in Kernel and tracing tools
# support (like LTTng or perf).
#SRC_URI_append = " file://traces.cfg"

LINUX_VERSION_EXTENSION_append = "-mainline-rt"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(votp|votp-no-iommu)"
