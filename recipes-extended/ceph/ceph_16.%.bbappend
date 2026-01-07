# Copyright (C) 2022-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SRC_URI:append = " \
    file://0001-fix-cross-compilation-with-python-cython-modules.patch \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
"
include ceph.inc
