# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "A test image for Seapath guest"
require seapath-guest-image.bb

# Tests
IMAGE_INSTALL += "test-sync-storage"
