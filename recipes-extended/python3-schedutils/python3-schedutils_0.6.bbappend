# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-setup.py-use-setuptools-instead-of-distutils.patch"
