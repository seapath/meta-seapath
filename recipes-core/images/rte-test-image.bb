DESCRIPTION = "A test image for rte"
require rte-image.bb

# Real time Tools
IMAGE_INSTALL += "rt-tests"

# Dropbear (A lightweight SSH and SCP implementation)
IMAGE_INSTALL += "dropbear"

# KVM unit tests
IMAGE_INSTALL += "kvm-unit-tests"
