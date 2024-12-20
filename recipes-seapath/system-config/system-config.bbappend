# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

# TODO: Move this bbappend to the meta-seapath-aaeon
# TODO: Remove this file when the RT kernel is enabled

SYSTEMD_SERVICE:${PN}-host:remove:seapath-hypervisor-aaeon = "rt-runtime-share.service"
