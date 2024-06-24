# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A test image for seapath host and guest"
require seapath-guest-host-bios-image.bb

# Tests
IMAGE_INSTALL += "test-sync-storage"

# KVM unit tests
IMAGE_INSTALL += "kvm-unit-tests"

# Add ptests
EXTRA_IMAGE_FEATURES += "ptest-pkgs"
IMAGE_INSTALL += "ptest-runner"

# Add extra space for testing
# Add 2.35 GB. It's a compromise to have enough disk space to work without having an image too big.
IMAGE_ROOTFS_EXTRA_SPACE = "2465792"
