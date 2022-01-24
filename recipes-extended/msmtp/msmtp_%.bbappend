# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit useradd

USERADD_PACKAGES = "${PN}"
GROUPADD_PACKAGES = "${PN}"
GROUPADD_PARAM_${PN} = "-g 2000 msmtp"

do_install:append() {
  install -d ${D}${sysconfdir}/tmpfiles.d
  echo "d /var/log/msmtp 0770 hacluster msmtp -" > ${D}${sysconfdir}/tmpfiles.d/msmtp.conf
}
