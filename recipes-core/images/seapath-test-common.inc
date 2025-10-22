# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require seapath-host-common.inc

# Cockpit web GUI
IMAGE_INSTALL:append = " \
    cockpit \
    cockpit-bridge \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cockpit-cluster-dashboard', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', 'cockpit-cluster-vm-management', '', d)} \
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
