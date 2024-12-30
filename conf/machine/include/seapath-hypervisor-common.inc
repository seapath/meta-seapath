# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require conf/machine/include/seapath-machine-common.inc

APPEND += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-overlay', 'init=/sbin/init.sh', '', d)} \
    default_hugepagesz=1G \
    hugepagesz=1G \
    skew_tick=1 \
    rcutree.kthread_prio=10 \
    ${@bb.utils.contains("DISTRO_FEATURES", "kvm", "kvm.halt_poll_ns=0", "", d)
    "
