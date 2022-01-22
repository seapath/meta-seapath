# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A common base for guest image"

require seapath-common.inc

inherit ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-security', 'security/qa-guest-images', '', d)}

IMAGE_INSTALL_append = " \
    cukinia-tests-vm \
    pacemaker-remote \
    syslog-ng-client \
    system-config-security \
"
#add docker
IMAGE_INSTALL += " docker-ce docker-ce-contrib python3-docker-compose"

IMAGE_FSTYPES = "wic.qcow2 wic.vmdk"
WKS_FILE = "mkefidisk-guest.wks.in"

# Guest images are compatible with votp-vm only
# GRUB static configuration for guest machines
# depends on votp-vm
COMPATIBLE_MACHINE = "votp-vm"

# Remove users that do not exist in
# guest images
USERS_LIST_LOCKED_remove = "qemu ceph"
