# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

DISTROOVERRIDES =. "seapath:"

DISTROOVERRIDES =. "${@ 'seapath-lttng:' if (d.getVar('SEAPATH_USE_LTTNG') == 'true') else ''}"

# Distro based on poky
require conf/distro/poky.conf

# Maintainer email
MAINTAINER = "support@savoirfairelinux.com"

# Use systemd as default
DISTRO_FEATURES:append = " systemd usrmerge"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"

# Use sysvinit for rescue system
DISTRO_FEATURES:remove = "sysvinit"

# No need for x11 and wayland
DISTRO_FEATURES:remove = " x11"
DISTRO_FEATURES:remove = " wayland"

# Remove unneeded distribution features
DISTRO_FEATURES:remove = " 3g alsa bluetooth nfc nfs opengl pcmcia vulkan wifi zeroconf"
DISTRO_FEATURES_OPTED_OUT += "pulseaudio"

# Use virtualization features
DISTRO_FEATURES:append = " virtualization"
DISTRO_FEATURES:append = " kvm"

# Enable predictable network interface names
DISTRO_FEATURES:append = " pni-names"

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

# Pre-provisioned container images (ceph, registry) for offline Ansible deployment
DISTRO_FEATURES:append = " seapath-preprovisioned-containers"

# Enable Cockpit Web UI if defined in seapath.conf
DISTRO_FEATURES:append = " ${@bb.utils.contains('SEAPATH_COCKPIT', 'true', ' seapath-cockpit', '', d)}"


#Inherit all bbclass that will check DISTRO_FEATURES
INHERIT += "security/hardening"
INHERIT += "security/readonly"
INHERIT += "overlay"

# Remove recipe work directories after build to save disk space.
# Set SEAPATH_RM_WORK to true in seapath.conf to enable.
INHERIT += "${@'rm_work' if (d.getVar('SEAPATH_RM_WORK') or 'false') == 'true' else ''}"

IMAGE_FEATURES[validitems] += "unsafe-pam-policy"

# Set version of ceph to 16.x.y
REQUIRED_VERSION_ceph = "20.2.1"
REQUIRED_VERSION_boost = "1.89.0"
REQUIRED_VERSION_grub = "2.12"
# Create /etc/build
INHERIT += "image-buildinfo"

# Set the root home directory
# By default, it is set to /home/root, but it is not well supported by systemd
ROOT_HOME = "/root"

FILESYSTEM_PERMS_TABLES:remove = "files/fs-perms-volatile-log.txt"

# Enable UID and GID static allocation
USERADDEXTENSION = "useradd-staticids"
USERADD_ERROR_DYNAMIC = "error"

USERADD_UID_TABLES = "conf/distro/include/passwd.uid"
USERADD_GID_TABLES = "conf/distro/include/group.gid"



# Use the cephadm recipe as cephadm provider to have the latest version
PREFERRED_RPROVIDER_cephadm = "cephadm"
