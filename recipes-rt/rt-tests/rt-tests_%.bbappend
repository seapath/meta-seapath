# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

python () {
    if d.getVar('SEAPATH_CYCLICTEST_TP') == 'true':
        d.appendVar("SRC_URI", " file://0001-cyclictest-add-lttng-tracepoint-for-latency-spikes.patch")
        d.appendVar("DEPENDS", " lttng-ust")
}
