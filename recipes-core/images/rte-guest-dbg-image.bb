DESCRIPTION = "A debug guest image for rte"
require rte-guest-common.inc
require rte-dbg-common.inc

# Tests
IMAGE_INSTALL += "test-sync-storage"
