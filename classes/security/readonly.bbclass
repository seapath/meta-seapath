# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Handle rootfs readonly creation
# Must be inherit in a Yocto distro
#

IMAGE_FEATURES += "read-only-rootfs"
ROOTFS_RO_UNNEEDED ?= "update-rc.d ${VIRTUAL-RUNTIME_update-alternatives} ${ROOTFS_BOOTSTRAP_INSTALL}"

VOLATILE_BINDS_pn-volatile-binds ?= "\
    /mnt/persistent/home /home\n\
    /mnt/persistent/opt/setup /opt/setup\n\
    /var/volatile/usr/lib/python3.8/site-packages/__pycache__ /usr/lib/python3.8/site-packages/__pycache__\n\
    /mnt/persistent/var/lib /var/lib\n\
    /var/volatile/cache /var/cache\n\
    /var/volatile/spool /var/spool\n\
    /var/volatile/srv /srv\n\
"

# Create empty /mnt/persistent directory
create_persistent_dir () {
    install -d ${IMAGE_ROOTFS}/mnt/persistent
    install -d ${IMAGE_ROOTFS}/opt/setup
}

IMAGE_PREPROCESS_COMMAND += "create_persistent_dir;"
