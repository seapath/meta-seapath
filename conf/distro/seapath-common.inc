# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Distro based on poky
require conf/distro/poky.conf

# Maintainer email
MAINTAINER = "support@savoirfairelinux.com"

# Use systemd as default
DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"

# Use sysvinit for rescue system
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"

# No need for x11 and wayland
DISTRO_FEATURES_remove = " x11"
DISTRO_FEATURES_remove = " wayland"

# Remove unneeded distribution features
DISTRO_FEATURES_remove = " 3g alsa bluetooth nfc nfs opengl pcmcia vulkan wifi zeroconf"
DISTRO_FEATURES_BACKFILL_CONSIDERED += "pulseaudio gobject-introspection-data"

# Active buildhistory
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"

# Use virtualization features
DISTRO_FEATURES_append = " virtualization"
DISTRO_FEATURES_append = " kvm"

# Enable dpdk for openvswitch
PACKAGECONFIG_append_pn-openvswitch = " dpdk"
COMPATIBLE_MACHINE_pn-dpdk = "(votp)"
PREFERRED_VERSION_openvswitch = "2.15%"
PREFERRED_VERSION_dpdk = "20.11.%"

# Disable and blacklist busybox
PREFERRED_PROVIDER_virtual/base-utils = "packagegroup-core-base-utils"
VIRTUAL-RUNTIME_base-utils = "packagegroup-core-base-utils"
VIRTUAL-RUNTIME_base-utils-hwclock = "util-linux-hwclock"
VIRTUAL-RUNTIME_base-utils-syslog = ""
VIRTUAL-RUNTIME_vim = "vim-tiny"
VIRTUAL-RUNTIME_syslog = ""
VIRTUAL-RUNTIME_login_manager = "shadow-base"
PNBLACKLIST[busybox] = "Don't build this"

# Disable and blacklist cups
PACKAGECONFIG_remove_pn-samba = "cups"
PNBLACKLIST[cups] = "Don't build this"

# Disable snapper module to remove unneeded dependency on dbus
SAMBA4_MODULES_append_pn-samba = ",!vfs-snapper"

# Blacklist dtc
PNBLACKLIST[dtc] = "Don't build this"

# Configure QEMU to:
#     * disable audio support
#     * only support x86 targets
QEMU_TARGETS_pn-qemu = "i386 x86_64"
PACKAGECONFIG_remove_pn-qemu = "fdt"
EXTRA_OECONF_append_pn-qemu = " --audio-drv-list=''"

# Enable ptest
DISTRO_FEATURES_append = " ptest"

# Enable pam
DISTRO_FEATURES_append = " pam"

# Enable seccomp for conmon (needed to upgrade podman)
DISTRO_FEATURES_append = " seccomp"

# Enable security hardening
DISTRO_FEATURES_append = " seapath-security"

# Enable Ansible SSH key copy
DISTRO_FEATURES_append = " ansible"

# Enable readonly
DISTRO_FEATURES_append = " seapath-readonly"
DISTRO_FEATURES_append = " seapath-overlay"

# Enable clustering
DISTRO_FEATURES_append = " seapath-clustering"

# Set persistent /var/log
VOLATILE_LOG_DIR = "no"

#Inherit all bbclass that will check DISTRO_FEATURES
INHERIT += "security/hardening"
INHERIT += "security/readonly"
INHERIT += "overlay"

PREFERRED_VERSION_libvirt = "6.3.0"
PREFERRED_VERSION_conmon = "2.0.30%"
