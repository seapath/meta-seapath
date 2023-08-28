# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require conf/machine/intel-corei7-64.conf
PREFERRED_PROVIDER_virtual/kernel = "linux-mainline-rt"
PREFERRED_VERSION_linux-mainline-rt ?= "5.15.%"
IMAGE_FSTYPES = "wic"
SERIAL_CONSOLES = "115200;ttyS0"
EFI_PROVIDER = "grub-efi"

MACHINEOVERRIDES =. "votp:"
# Kernel parameters
APPEND += " \
    systemd.unified_cgroup_hierarchy=0 \
    audit=0 \
    slab_nomerge \
    slub_debug=ZF \
    rootwait \
    rootfstype=ext4 \
"
