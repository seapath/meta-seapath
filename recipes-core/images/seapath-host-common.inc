# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath"
require seapath-common.inc
require ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'seapath-host-common-ha.inc', '', d)}
require seapath-host-common-virtu.inc

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'security/qa-host-images', '', d)}

# Hypervisor and cluster tests
IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cukinia-tests-cluster', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', \
            bb.utils.contains('DISTRO_FEATURES', 'seapath-security', \
                    'cukinia-tests-cluster-security', '', d), '', d)} \
    cukinia-tests-hypervisor \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'cukinia-tests-hypervisor-security', '', d)} \
    syslog-ng-client \
    system-config-host \
    system-config-cluster \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'system-config-security', '', d)} \
    system-upgrade \
    net-snmp-server \
    net-snmp-client \
    net-snmp-dev \
    python3-vm-manager \
    tuna \
    irqbalance \
    chrony \
    chronyc \
"

# Host images are compatible with seapath-hypervisor only
# GRUB static configuration for host machines
# depends on seapath-hypervisor
COMPATIBLE_MACHINE = "seapath-hypervisor"

def get_seapath_kernel_parameters(d):
    kernel_parameters = ""
    rt_cores = d.getVar("SEAPATH_RT_CORES", "")
    disable_ipv6 = d.getVar("SEAPATH_DISABLE_IPV6", "")
    if rt_cores:
        kernel_parameters +="isolcpus={} nohz_full={} rcu_nocbs={}".format(
            rt_cores,
            rt_cores,
            rt_cores)
    if disable_ipv6 == "true":
        kernel_parameters += " ipv6.disable=1"
    return kernel_parameters


APPEND += "${@get_seapath_kernel_parameters(d)}"
