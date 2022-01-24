# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#to add hacluster to the msmtp group, so that it can write to msmtp log file
RDEPENDS_${PN} += "msmtp"
DEPENDS += "msmtp"
USERADD_PARAM_${PN}:prepend = " -G msmtp "

do_install_append() {
    for file in $(find ${D}${libdir}/stonith/plugins/external -type f); do
        sed -i "s%${HOSTTOOLS_DIR}/%%g" "${file}"
    done
}
