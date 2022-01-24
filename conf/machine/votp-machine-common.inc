# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#@TYPE: Machine
#@NAME:
#@SOC:
#@DESCRIPTION: Machine configuration based on x86-64 processor

require conf/machine/intel-corei7-64.conf
PREFERRED_PROVIDER_virtual/kernel = "linux-mainline-rt"
PREFERRED_VERSION_linux-mainline-rt ?= "5.15.%"
IMAGE_FSTYPES = "wic"
SERIAL_CONSOLES = "115200;ttyS0"
EFI_PROVIDER = "grub-efi"

# Kernel parameters
APPEND += " \
    systemd.unified_cgroup_hierarchy=0 \
    audit=0 \
    slab_nomerge \
    pti=on \
    slub_debug=ZF \
    rootwait \
    rootfstype=ext4 \
"
