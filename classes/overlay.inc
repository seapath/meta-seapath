# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#

VOLATILE_BINDS:pn-volatile-binds ?= "\
    /mnt/persistent/home /home\n\
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

change_init () {
    cat <<EOF>${IMAGE_ROOTFS}/sbin/init.sh
#!/bin/bash
/bin/mount -t proc proc /proc
/bin/mount -t sysfs sysfs /sys
/bin/mount -t ext4 \$(blkid -L persistent) /mnt/persistent
/bin/mkdir -p /mnt/persistent/etc
/bin/mkdir -p /mnt/persistent/.etc-work
/bin/mount -t overlay overlay -o lowerdir=/etc,upperdir=/mnt/persistent/etc,workdir=/mnt/persistent/.etc-work /etc
exec /sbin/init \$@

EOF

    chmod 755 ${IMAGE_ROOTFS}/sbin/init.sh
}

IMAGE_PREPROCESS_COMMAND += "change_init;"
IMAGE_PREPROCESS_COMMAND += "create_persistent_dir;"
