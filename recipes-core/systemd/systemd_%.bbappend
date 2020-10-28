# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend :="${THISDIR}/files:"
SRC_URI_append = " \
    file://0001-networkd-wait-online-add-any-option.patch \
"
