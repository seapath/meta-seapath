# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

LICENSE = "GPL-2.0 & LGPL-2.0+"
LIC_FILES_CHKSUM = "file://COPYRIGHT;md5=8a44f57fb36dd391ae65e11a6d370615"
HOMEPAGE = "https://www.linux-kvm.org/page/KVM-unit-tests"
RDEPENDS:${PN} += "bash coreutils glibc-utils python3"

SRC_URI = " \
	git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git;branch=master;protocol=https \
	file://0001-run_tests.sh-make-it-called-from-any-directory.patch \
	"

PV = "1.0+git${SRCPV}"
SRCREV = "ef5d77a0a9eba7f71d061d8ae41242b5451b4897"

S = "${WORKDIR}/git"

do_configure () {
	./configure --arch=${TARGET_ARCH} --prefix=${D}${sbindir}/kvm-unit-tests
}

do_compile () {
	oe_runmake
}

do_install () {
	install -d ${D}${sbindir}
	install -d ${D}${sbindir}/kvm-unit-tests
	install -d ${D}${sbindir}/scripts
	install -d ${D}${sbindir}/x86

	oe_runmake install
	install -m 0644 ${S}/build-head ${D}${sbindir}
	install -m 0755 ${S}/run_tests.sh ${D}${sbindir}
	install -m 0755 ${S}/config.mak ${D}${sbindir}
	install -m 0644 ${S}/scripts/* ${D}${sbindir}/scripts/
	install -m 0755 ${S}/scripts/pretty_print_stacks.py ${D}${sbindir}/scripts/
	install -m 0644 ${S}/x86/* ${D}${sbindir}/x86/
	install -m 0755 ${S}/x86/run ${D}${sbindir}/x86/
}


INSANE_SKIP:${PN} = "arch textrel"
FILES:${PN} += "${sbindir}/kvm-unit-tests/*"
FILES:${PN} += "${sbindir}/run_tests.sh"
FILES:${PN} += "${sbindir}/config.mak"
FILES:${PN} += "${sbindir}/scripts"
FILES:${PN} += "${sbindir}/x86"
