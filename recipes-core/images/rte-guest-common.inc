# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "A common base for guest image"

require rte-common.inc

IMAGE_INSTALL_append = " \
   pacemaker-remote \
"
IMAGE_FSTYPES = "wic.qcow2 wic.vmdk"
WKS_FILE = "mkefidisk-guest.wks.in"
