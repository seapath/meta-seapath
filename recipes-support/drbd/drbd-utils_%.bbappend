# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECONF = " \
                --with-initdir=/etc/init.d    \
                --with-pacemaker           \
                --without-rgmanager           \
                --without-bashcompletion      \
                --with-distro debian          \
                --with-initscripttype=both    \
                --with-systemdunitdir=${systemd_unitdir}/system \
                --without-manual \
               "

RDEPENDS_${PN}_append = " pacemaker"
FILES_${PN}_append = "\
    ${libdir_native}/ocf/resource.d/linbit \
    ${libdir_native}/ocf/resource.d/linbit/drbd \
    ${libdir_native}/ocf/resource.d/linbit/drbd.shellfuncs.sh"

