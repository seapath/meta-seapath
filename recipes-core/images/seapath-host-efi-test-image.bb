# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A test image for Seapath"
require seapath-test-common.inc
require seapath-efi-common.inc
require seapath-swupdate-common.inc

# Signed update packages are verified against the trust anchors installed here.
IMAGE_INSTALL:append = " swupdate-trust"
