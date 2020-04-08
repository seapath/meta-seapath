DESCRIPTION = "A test image for rte"
require rte-image.bb

# Real time Tools
IMAGE_INSTALL += "rt-tests"

# Dropbear (A lightweight SSH and SCP implementation)
IMAGE_INSTALL += "dropbear"

# KVM unit tests
IMAGE_INSTALL += "kvm-unit-tests"

# Add ptests
EXTRA_IMAGE_FEATURES += "ptest-pkgs"
IMAGE_INSTALL += "ptest-runner"

# Add extra space for testing
IMAGE_ROOTFS_EXTRA_SPACE = "2465792"
