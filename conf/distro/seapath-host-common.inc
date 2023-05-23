# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require conf/distro/seapath-common.inc

# Enable dpdk for openvswitch
PACKAGECONFIG:append:pn-openvswitch = " dpdk"
COMPATIBLE_MACHINE:pn-dpdk = "(votp)"
REQUIERED_VERSION_dpdk = "21.11.%"

DISTROOVERRIDES =. "seapath-host:"
