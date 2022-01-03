# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath"
require seapath-common.inc
require seapath-host-common-ha.inc
require seapath-host-common-virtu.inc

inherit security/qa-host-images

# Hypervisor and cluster tests
IMAGE_INSTALL_append = " \
    cukinia-tests-cluster \
    cukinia-tests-hypervisor \
    syslog-ng-client \
    system-config-host \
    system-config-security \
    system-upgrade \
    net-snmp-server \
    net-snmp-client \
    msmtp \
    mailx \
"

# Host images are compatible with votp only
# GRUB static configuration for host machines
# depends on votp
COMPATIBLE_MACHINE = "votp"
