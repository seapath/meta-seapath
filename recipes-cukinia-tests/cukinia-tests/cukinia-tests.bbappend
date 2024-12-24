# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

do_install:append:seapath-standalone-containers-host () {

    # Remove hypervisor tests not applicable to the standalone-containers-host image
    rm -f ${D}${sysconfdir}/cukinia/hypervisor_tests.d/libvirt.conf
    rm -f ${D}${sysconfdir}/cukinia/hypervisor_tests.d/virtualization.conf
    rm -f ${D}${sysconfdir}/cukinia/hypervisor_security_tests.d/libvirt.conf
}

do_install:append:seapath-hypervisor-aaeon () {

    # Remove hypervisor tests not applicable to the hypervisor-aaeon machine configuration
    rm -f ${D}${sysconfdir}/cukinia/common_tests.d/preempt-rt.conf
    rm -f ${D}${sysconfdir}/cukinia/hypervisor_tests.d/iommu.conf
}
