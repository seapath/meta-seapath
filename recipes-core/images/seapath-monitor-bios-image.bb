# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A monitor image for Seapath cluster"
require seapath-common.inc
require seapath-host-common-ha.inc
require seapath-monitor-common.inc

WKS_FILE = "mkbiosdisk.wks.in"

IMAGE_INSTALL:append = " syslog-ng-server"
