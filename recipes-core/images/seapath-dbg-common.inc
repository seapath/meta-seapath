# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Monitoring tools
IMAGE_INSTALL += "htop"
IMAGE_INSTALL += "console-vm-script curl screen stress-ng rsync sysstat"
IMAGE_INSTALL += "strace dnf gdb pigz lsof git iperf3"

# Network tools
IMAGE_INSTALL += "tcpdump inetutils-ping inetutils-ping6"

# Trace tools
# Uncomment this line to install LTTng.
# LTTng require the kernel fragment trace.cfg
# See recipes-kernel/linux/linux-mainline-rt_5.15.bb
#IMAGE_INSTALL += " lttng-tools lttng-modules"

# System tools
IMAGE_FEATURES += "allow-empty-password debug-tweaks empty-root-password \
                   post-install-logging"

# Debug images are not compatible with SEAPATH PAM policy
IMAGE_FEATURES += "unsafe-pam-policy"

IMAGE_FSTYPES += "wic.qcow2"
