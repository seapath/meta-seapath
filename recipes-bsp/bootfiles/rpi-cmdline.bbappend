# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

# Mount rootfs on mmcblk0p2
CMDLINE_ROOTFS = "root=/dev/mmcblk0p2 ${CMDLINE_ROOT_FSTYPE} rootwait ${APPEND}"
