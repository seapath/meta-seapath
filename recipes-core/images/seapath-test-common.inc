# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

require seapath-host-common.inc

# Real time Tools
IMAGE_INSTALL += "cukinia-tests-realtime"

# KVM unit tests
IMAGE_INSTALL += "kvm-unit-tests"

# Add ptests
EXTRA_IMAGE_FEATURES += "ptest-pkgs"
IMAGE_INSTALL += "ptest-runner"

# Active Directory tools
IMAGE_INSTALL += " \
    podman \
    criu \
    slirp4netns \
"

# Add extra space for testing
IMAGE_ROOTFS_EXTRA_SPACE = "2465792"
