# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#

IMAGE_FEATURES += "read-only-rootfs"
ROOTFS_RO_UNNEEDED ?= "update-rc.d ${VIRTUAL-RUNTIME_update-alternatives} ${ROOTFS_BOOTSTRAP_INSTALL}"
APPEND += "init=/sbin/init.sh"
