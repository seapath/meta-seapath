# Copyright (C) 2024-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

MACHINEOVERRIDES =. "seapath:seapath-hypervisor-aaeon:"

require conf/machine/include/seapath-hypervisor-common.inc

PREFERRED_PROVIDER_virtual/bootloader:imx-nxp-bsp = "u-boot-imx"
PREFERRED_PROVIDER_virtual/kernel:imx-nxp-bsp = "linux-imx"

# Use the meta-imx dpdk recipe
REQUIRED_VERSION_dpdk:seapath-hypervisor-aaeon = "21.11"

# Kernel parameters
APPEND += " \
    ro \
"
