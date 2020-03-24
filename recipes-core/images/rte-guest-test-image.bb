DESCRIPTION = "A guest test image for rte"
require rte-image.bb

# Real time Tools
IMAGE_INSTALL += "rt-tests"

# Dropbear (A lightweight SSH and SCP implementation)
IMAGE_INSTALL += "dropbear"
