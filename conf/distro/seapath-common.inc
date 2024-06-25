# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DISTROOVERRIDES =. "seapath:"

# Distro based on poky
require conf/distro/poky.conf

# Maintainer email
MAINTAINER = "support@savoirfairelinux.com"

# Use systemd as default
DISTRO_FEATURES:append = " systemd usrmerge"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"

# Use sysvinit for rescue system
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"

# No need for x11 and wayland
DISTRO_FEATURES:remove = " x11"
DISTRO_FEATURES:remove = " wayland"

# Remove unneeded distribution features
DISTRO_FEATURES:remove = " 3g alsa bluetooth nfc nfs opengl pcmcia vulkan wifi zeroconf"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "pulseaudio"

# Active buildhistory
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"

# Use virtualization features
DISTRO_FEATURES:append = " virtualization"
DISTRO_FEATURES:append = " kvm"

# Disable and blacklist busybox
PREFERRED_PROVIDER_virtual/base-utils = "packagegroup-core-base-utils"
VIRTUAL-RUNTIME_base-utils = "packagegroup-core-base-utils"
VIRTUAL-RUNTIME_base-utils-hwclock = "util-linux-hwclock"
VIRTUAL-RUNTIME_base-utils-syslog = ""
VIRTUAL-RUNTIME_vim = "vim-tiny"
VIRTUAL-RUNTIME_syslog = ""
VIRTUAL-RUNTIME_login_manager = "shadow-base"
SKIP_RECIPE[busybox] = "Don't build this"

# Disable and blacklist cups
PACKAGECONFIG:remove:pn-samba = "cups"
SKIP_RECIPE[cups] = "Don't build this"

# Disable GUI on virt-manager
PACKAGECONFIG:remove:pn-virt-manager = "gui"

# Disable snapper module to remove unneeded dependency on dbus
SAMBA4_MODULES:append:pn-samba = ",!vfs-snapper"

# Configure QEMU to:
#     * disable audio support
#     * only support x86 targets
QEMU_TARGETS:pn-qemu = "i386 x86_64"
EXTRA_OECONF:append:pn-qemu = " --audio-drv-list=''"

# Enable ptest
DISTRO_FEATURES:append = " ptest"

# Enable pam
DISTRO_FEATURES:append = " pam"

# Enable security hardening
DISTRO_FEATURES:append = " seapath-security"

# Enable Ansible SSH key copy
DISTRO_FEATURES:append = " ansible"

# Enable readonly
DISTRO_FEATURES:append = " seapath-readonly"
DISTRO_FEATURES:append = " seapath-overlay"

# Enable clustering
DISTRO_FEATURES:append = " seapath-clustering"

# Set persistent /var/log
VOLATILE_LOG_DIR = "no"

#Inherit all bbclass that will check DISTRO_FEATURES
INHERIT += "security/hardening"
INHERIT += "security/readonly"
INHERIT += "overlay"

IMAGE_FEATURES[validitems] += "unsafe-pam-policy"

# Create /etc/build
INHERIT += "image-buildinfo"

# Set the root home directory
# By default, it is set to /home/root, but it is not well supported by systemd
ROOT_HOME = "/root"

# Enable UID and GID static allocation
USERADD_UID_TABLES = "conf/distro/include/passwd.uid"
GROUPADD_GID_TABLES = "conf/distro/include/group.gid"

# Ceph do not support the rocksdb version 9 provide by meta-oe
# So we need to use a earlier version
REQUIERED_VERSION_rocksdb = "7.%"
