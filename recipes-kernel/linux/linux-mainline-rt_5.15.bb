# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_VERSION = "5.15.10"
RT_REVISION = "rt24"
PV = "${LINUX_VERSION}-${RT_REVISION}"
KBRANCH = "v${PV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=git;name=machine;tag=${KBRANCH};nobranch=1; \
        file://defconfig \
"

SRC_URI_append_votp-no-iommu = " \
        file://no-iommu.cfg \
"

LINUX_VERSION_EXTENSION_append = "-mainline-rt"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(votp|votp-no-iommu)"
