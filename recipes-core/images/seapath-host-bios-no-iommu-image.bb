# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A production image for Seapath with bios support and IOMMU disable"
require seapath-host-common.inc
WKS_FILE = "mkbiosdisk_no_iommu.wks.in"
