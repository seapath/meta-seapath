# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

SYSTEMD_AUTO_ENABLE = "disable"

do_install_append() {
    rm "${D}${systemd_unitdir}/system/sysinit.target.wants/proc-fs-nfsd.mount"
}
