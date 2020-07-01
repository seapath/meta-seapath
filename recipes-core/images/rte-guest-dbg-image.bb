DESCRIPTION = "A debug guest image for rte"
require rte-guest-common.inc

# Monitoring tools
IMAGE_INSTALL += "htop"

# Network tools
IMAGE_INSTALL += "tcpdump"
IMAGE_FEATURES += "ssh-server-dropbear"

# System tools
IMAGE_FEATURES += "allow-empty-password debug-tweaks empty-root-password \
                   post-install-logging"

# Tests
IMAGE_INSTALL += "test-sync-storage"
