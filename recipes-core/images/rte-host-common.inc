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
# HA
IMAGE_INSTALL_append = " pacemaker cluster-glue crmsh drbd-utils ocfs2-tools \
ceph resource-agents dlm xfsprogs "
