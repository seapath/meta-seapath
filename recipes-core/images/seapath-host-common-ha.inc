# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# HA
IMAGE_INSTALL_append = " \
    pacemaker \
    cluster-glue \
    cluster-glue-plugin-stonith2 \
    cluster-glue-plugin-stonith2-ribcl \
    cluster-glue-plugin-stonith-external \
    cluster-glue-plugin-interfacemgr \
    cluster-glue-plugin-test \
    cluster-glue-plugin-raexec \
    crmsh \
    ceph \
    resource-agents \
"
