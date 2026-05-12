# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "\
  file://0001-wic-support-multiple-bootimg-efi-sources.patch \
  file://0002-wic-plugins-source-bootimg-efi-search-image-file-in-.patch \
"

