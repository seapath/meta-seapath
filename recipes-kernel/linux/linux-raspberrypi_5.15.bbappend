# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

do_deploy:append() {
    install -m 0644 .config $deployDir/config_kernel
}
