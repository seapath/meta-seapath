# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-probe-Support-probing-for-partition-UUID-with-part-u.patch \
"

GRUB_BUILDIN += " password_pbkdf2 probe regexp"
