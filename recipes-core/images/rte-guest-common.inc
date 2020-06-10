DESCRIPTION = "A common base for guest image"

LICENSE = "CLOSED"
require rte-common.inc

IMAGE_INSTALL_append = " \
   pacemaker-remote \
"
IMAGE_FSTYPES = "wic.qcow2"
WKS_FILE = "mkefidisk-guest.wks.in"
