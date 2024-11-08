# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require seapath-host-common.inc

# Cockpit web GUI
IMAGE_INSTALL:append = " \
    cockpit \
    cockpit-bridge \
    cockpit-cluster-dashboard \
    cockpit-cluster-vm-management \
    cockpit-dashboard \
    cockpit-machines \
    cockpit-shell \
    cockpit-systemd \
    cockpit-update \
    cockpit-users \
    cockpit-ws \
    ethtool \
    rt-tests \
"

IMAGE_INSTALL:append = " \
    system-config-test \
"
