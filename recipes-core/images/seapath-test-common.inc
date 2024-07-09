# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require seapath-host-common.inc

# Cockpit web GUI
IMAGE_INSTALL:append = " \
    cockpit-dashboard \
    cockpit-ws \
    cockpit-bridge \
    cockpit-shell \
    cockpit-users \
    cockpit-systemd \
    cockpit-machines \
    cockpit-cluster-dashboard \
    cockpit-cluster-vm-management \
    cockpit-update \
    cockpit \
"
