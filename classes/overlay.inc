# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0
#

PYTHON_BASEVERSION = "3.12"
PYTHON_DIR = "python${PYTHON_BASEVERSION}"
PYTHON_SITEPACKAGES_DIR = "${libdir}/${PYTHON_DIR}/site-packages"


VOLATILE_BINDS:pn-volatile-binds ?= "\
    /mnt/persistent/home /home\n\
    /var/volatile/pycache ${PYTHON_SITEPACKAGES_DIR}/__pycache__\n\
    /mnt/persistent/var/lib /var/lib\n\
    /var/volatile/cache /var/cache\n\
    /var/volatile/spool /var/spool\n\
    /var/volatile/srv /srv\n\
    /mnt/persistent/root /root\n\
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
/bin/mkdir -p /mnt/persistent/var
/bin/mount -t overlay overlay -o lowerdir=/etc,upperdir=/mnt/persistent/etc,workdir=/mnt/persistent/.etc-work /etc
exec /sbin/init \$@

EOF

    chmod 755 ${IMAGE_ROOTFS}/sbin/init.sh
}

IMAGE_PREPROCESS_COMMAND += "change_init;"
IMAGE_PREPROCESS_COMMAND += "create_persistent_dir;"
