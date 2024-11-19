# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DISTROOVERRIDES =. "seapath-host:"

require conf/distro/seapath-common.inc

# Enable dpdk for openvswitch
PACKAGECONFIG:append:pn-openvswitch = " dpdk"
COMPATIBLE_MACHINE:pn-dpdk = "(seapath)"
REQUIRED_VERSION_dpdk = "23.11.%"
