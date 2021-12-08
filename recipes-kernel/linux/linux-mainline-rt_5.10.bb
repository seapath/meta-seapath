# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require linux-mainline-rt.inc

PACKAGE_ARCH = "${MACHINE_ARCH}"
LINUX_VERSION = "5.10.83"
KBRANCH = "v${LINUX_VERSION}-rt58"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git;protocol=git;name=machine;tag=${KBRANCH};nobranch=1; \
        file://defconfig \
"

LINUX_VERSION_EXTENSION_append = "-mainline-rt"

S = "${WORKDIR}/git"
PV = "${LINUX_VERSION}+git${SRCPV}"

EXTRA_OEMAKE = " HOSTCC="${BUILD_CC} ${BUILD_CFLAGS} ${BUILD_LDFLAGS}" HOSTCPP="${BUILD_CPP}""

COMPATIBLE_MACHINE = "(votp|votp-nuc|votp-no-iommu)"
