DESCRIPTION = "A production image for rte"
require rte-common.inc

IMAGE_INSTALL_append = " pacemaker"
