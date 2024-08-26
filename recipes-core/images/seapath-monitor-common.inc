# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

USERS_LIST_LOCKED:remove = "qemu"

IMAGE_INSTALL:append = " \
    cukinia-tests-monitor \
    system-upgrade \
    system-config-cluster \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'system-config-security', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-readonly', 'system-config-ro', '', d)} \
    chrony \
    chronyc \
    corosync-qnetd \
"

COMPATIBLE_MACHINE = "seapath-monitor"

def get_seapath_kernel_parameters(d):
    disable_ipv6 = d.getVar("SEAPATH_DISABLE_IPV6", "")
    if disable_ipv6 == "true":
        return "ipv6.disable=1"
    return ""

APPEND += "${@get_seapath_kernel_parameters(d)}"
