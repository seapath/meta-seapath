# Copyright (C) 2020, RTE (http://www.rte-france.com)

DESCRIPTION = "A debug guest image for Seapath"
require seapath-guest-common.inc
require seapath-dbg-common.inc

# Tests
IMAGE_INSTALL += "test-sync-storage"
