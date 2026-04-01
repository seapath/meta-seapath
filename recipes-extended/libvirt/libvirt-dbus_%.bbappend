# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

EXTRA_OEMESON:append = " -Dsystem_user=root -Dunix_socket_group=qemu"

CFLAGS:append = " -Wno-error=inline"
