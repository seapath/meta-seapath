# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

MACHINEOVERRIDES =. "seapath:"

require conf/machine/intel-corei7-64.conf
PREFERRED_PROVIDER_virtual/kernel = "linux-mainline-rt"
PREFERRED_VERSION_linux-mainline-rt ?= "6.1.%"
IMAGE_FSTYPES = "wic"
SERIAL_CONSOLES = "115200;ttyS0"
EFI_PROVIDER = "grub-efi"

# Kernel parameters
APPEND += " \
    systemd.unified_cgroup_hierarchy=0 \
    audit=0 \
    slab_nomerge \
    slub_debug=ZF \
    rootfstype=ext4 \
"
