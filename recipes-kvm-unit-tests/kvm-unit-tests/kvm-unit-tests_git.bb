# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

LICENSE = "GPL-2.0 & LGPL-2.0+"
LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=8a44f57fb36dd391ae65e11a6d370615"
HOMEPAGE = "https://www.linux-kvm.org/page/KVM-unit-tests"
RDEPENDS:${PN} += "bash coreutils glibc-utils python3"
DEPENDS += "coreutils-native"

SRC_URI = "git://gitlab.com/kvm-unit-tests/kvm-unit-tests.git;branch=master;protocol=https"

PV = "1.0+git${SRCPV}"
# v2023-01-05
SRCREV = "e11a0e2f881d7bc038f44d8d4f99b2d55a01bc4e"

S = "${WORKDIR}/git"

do_configure () {
	./configure --arch=${TARGET_ARCH} --prefix=${D}${prefix}
}

do_compile () {
	oe_runmake standalone
}

do_install () {
	oe_runmake install
}


FILES:${PN} += "${datadir}/kvm-unit-tests/*"
