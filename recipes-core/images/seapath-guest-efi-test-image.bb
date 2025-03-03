# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "A test image for Seapath guest"
require seapath-guest-efi-image.bb
require seapath-guest-test-common.inc

# seapath-benchmark packages
IMAGE_INSTALL += " \
    fio \
    gnuplot \
    patch \
    phoronix-test-suite \
    rsvg \
    sysbench \
    vnstat \
"
