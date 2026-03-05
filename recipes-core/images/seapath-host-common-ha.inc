# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

# HA
IMAGE_INSTALL:append = " \
    cluster-glue \
    cluster-glue-plugin-stonith2 \
    cluster-glue-plugin-stonith2-ribcl \
    cluster-glue-plugin-stonith-external \
    cluster-glue-plugin-interfacemgr \
    cluster-glue-plugin-test \
    cluster-glue-plugin-raexec \
    crmsh \
    ceph \
    cephadm \
    ceph-volume \
    net-snmp-configuration-cluster \
    pacemaker \
    resource-agents \
    corosync-qdevice \
"

# Remove corosync-qdevice in the toolchain to avoid a bash conflict
TOOLCHAIN_HOST_TASK:remove:append = " corosync-qdevice"

# Install ipmitool for fencing
IMAGE_INSTALL:append = " ipmitool"
