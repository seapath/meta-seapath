# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2024-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

require seapath-host-common.inc

IMAGE_INSTALL:append = " \
    ethtool \
    rt-tests \
"

IMAGE_INSTALL:append = " \
    system-config-test \
"
