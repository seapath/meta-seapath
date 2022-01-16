# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#to add hacluster to the msmtp group, so that it can write to msmtp log file
RDEPENDS_${PN} += "msmtp"
DEPENDS += "msmtp"
USERADD_PARAM_${PN} = "--home-dir=${localstatedir}/lib/heartbeat/cores/${HA_USER} \
                       -g ${HA_GROUP} -G msmtp -r -s ${sbindir}/nologin -c 'cluster user' ${HA_USER} \
                      "

