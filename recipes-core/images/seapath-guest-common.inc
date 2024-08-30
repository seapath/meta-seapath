# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A common base for guest image"

require seapath-common.inc

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'security/qa-guest-images', '', d)}

IMAGE_INSTALL:append = " \
    cukinia-tests-vm \
    syslog-ng-client \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'system-config-security', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-readonly', 'system-config-ro', '', d)} \
    net-snmp-server \
    net-snmp-client \
    net-snmp-dev \
    net-snmp-configuration \
"
#add docker
IMAGE_INSTALL += " \
    docker-moby \
    docker-moby-contrib \
    docker-compose \
"

IMAGE_FSTYPES = "wic.qcow2 wic.vmdk"
WKS_FILE = "mkefidisk-guest.wks.in"

# Guest images are compatible with seapath-vm only
# GRUB static configuration for guest machines
# depends on seapath-vm
COMPATIBLE_MACHINE = "seapath-vm"

# Remove users that do not exist in
# guest images
USERS_LIST_LOCKED:remove = "qemu ceph"

def get_seapath_kernel_parameters(d):
    disable_ipv6 = d.getVar("SEAPATH_GUEST_DISABLE_IPV6", "")
    if disable_ipv6 == "true":
        return "ipv6.disable=1"
    return ""

APPEND += "${@get_seapath_kernel_parameters(d)}"
