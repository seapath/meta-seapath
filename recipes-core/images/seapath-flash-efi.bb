# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "An image working on EFI machine used to flash other Seapath images"
require recipes-core/images/seapath-flash-common.inc
require recipes-core/images/seapath-efi-common.inc

WKS_FILE = "mkefidisk-flasher.wks.in"
