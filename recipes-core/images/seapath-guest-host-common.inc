# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A common base for host and guest image"

require seapath-host-common.inc

IMAGE_INSTALL:append = " \
   pacemaker-remote \
"
IMAGE_FSTYPES = "wic.qcow2 wic.vmdk"
WKS_FILE = "mkbiosdisk.wks.in"

COMPATIBLE_MACHINE = "votp-host"
