DESCRIPTION = "A debug image for rte"
require rte-common.inc

# Monitoring tools
IMAGE_INSTALL += "htop"

# Network tools
IMAGE_INSTALL += "tcpdump ssh-server-dropbear"

# useful tools
IMAGE_INSTALL += "allow-empty-password debug-tweaks empty-root-password post-install-logging"
