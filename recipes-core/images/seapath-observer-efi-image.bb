# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "An observer image for Seapath cluster"
require seapath-common.inc
require seapath-efi-common.inc
require seapath-host-common-ha.inc
require seapath-observer-common.inc
require seapath-swupdate-common.inc

IMAGE_INSTALL:append = " syslog-ng-server"
