# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_install:append () {
   install -p ${S}/phc_ctl  ${D}${bindir}
}
