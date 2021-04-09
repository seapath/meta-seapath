# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath"
require seapath-common.inc
require seapath-host-common-ha.inc
require seapath-host-common-virtu.inc

# Hypervisor and cluster tests
IMAGE_INSTALL_append = " \
    cukinia-tests-cluster \
    cukinia-tests-hypervisor \
    system-config-host \
"
