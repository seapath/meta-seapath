DESCRIPTION = "A production image for rte"
require rte-common.inc

# Virtualization
IMAGE_INSTALL_append = " \
    libvirt \
    libvirt-libvirtd \
    libvirt-virsh \
    openvswitch \
    qemu \
"
IMAGE_FEATURES += "ssh-server-openssh"

# HA
IMAGE_INSTALL_append = " pacemaker cluster-glue crmsh"
