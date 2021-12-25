# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A debug image for Seapath with bios support"
require seapath-host-common.inc
require seapath-dbg-common.inc

IMAGE_INSTALL += "docker-ce"
IMAGE_INSTALL += "python3-docker-compose"

WKS_FILE = "mkbiosdisk.wks.in"
