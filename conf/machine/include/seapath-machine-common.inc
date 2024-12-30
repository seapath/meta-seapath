# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

MACHINEOVERRIDES =. "seapath:"

IMAGE_FSTYPES = "wic"
SERIAL_CONSOLES = "115200;ttyS0"

# Kernel parameters
APPEND += " \
    systemd.unified_cgroup_hierarchy=0 \
    audit=0 \
    slab_nomerge \
    slub_debug=ZF \
    rootfstype=ext4 \
"
