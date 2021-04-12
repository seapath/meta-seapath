# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A test image for Seapath guest"
require seapath-guest-efi-image.bb

# Tests
IMAGE_INSTALL += "test-sync-storage"

# RT Tests
IMAGE_INSTALL += "cukinia-tests-realtime"
