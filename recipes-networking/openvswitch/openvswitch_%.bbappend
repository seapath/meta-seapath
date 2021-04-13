# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_compile[depends] += "make-mod-scripts:do_configure"

SYSTEMD_AUTO_ENABLE_${PN}-switch = "disable"
