# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath"
require seapath-common.inc
require ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'seapath-host-common-ha.inc', '', d)}
require seapath-host-common-virtu.inc

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'security/qa-host-images', '', d)}

# Hypervisor and cluster tests
IMAGE_INSTALL_append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cukinia-tests-cluster', '', d)} \
    cukinia-tests-hypervisor \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-readonly', 'cukinia-tests-hypervisor-readonly', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'cukinia-tests-hypervisor-security', '', d)} \
    syslog-ng-client \
    system-config-host \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'system-config-security', '', d)} \
    system-upgrade \
    net-snmp-server \
"

# Host images are compatible with votp only
# GRUB static configuration for host machines
# depends on votp
COMPATIBLE_MACHINE = "votp"
