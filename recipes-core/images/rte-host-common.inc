DESCRIPTION = "A production image for rte"
require rte-common.inc

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_INSTALL_append = " pacemaker cluster-glue crmsh"
