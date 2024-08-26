# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
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
    net-snmp-configuration-cluster \
    pacemaker \
    resource-agents \
    corosync-qdevice \
"

# Install ipmitool for fencing
IMAGE_INSTALL:append = " ipmitool"
