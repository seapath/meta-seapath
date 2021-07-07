# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=git;name=machine;tag=v4.19.188-rt77;nobranch=1; \
        file://defconfig \
"

SRC_URI_append_votp-nuc = " \
        file://intel-nuc.cfg \
"

SRC_URI_append_votp-no-iommu = " \
        file://no-iommu.cfg \
"

LINUX_VERSION ?= "4.19.188"
LINUX_VERSION_EXTENSION_append = "-mainline-rt"

S = "${WORKDIR}/git"
PV = "${LINUX_VERSION}+git${SRCPV}"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(votp|votp-nuc|votp-no-iommu)"
