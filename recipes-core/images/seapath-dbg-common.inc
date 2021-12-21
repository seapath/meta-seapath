# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Monitoring tools
IMAGE_INSTALL += "htop"
IMAGE_INSTALL += "console-vm-script curl screen stress-ng rsync sysstat"

# Network tools
IMAGE_INSTALL += "tcpdump inetutils-ping inetutils-ping6"

# System tools
IMAGE_FEATURES += "allow-empty-password debug-tweaks empty-root-password \
                   post-install-logging"

# Debug images are not compatible with SEAPATH PAM policy
IMAGE_FEATURES += "unsafe-pam-policy"

IMAGE_FSTYPES += "wic.qcow2"
