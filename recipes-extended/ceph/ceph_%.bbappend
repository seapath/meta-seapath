# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECMAKE_append = " -DENABLE_GIT_VERSION=OFF"

def limit_parallel(limit):
   import multiprocessing
   nproc = min(multiprocessing.cpu_count(), int(limit))
   return "-j{}".format(nproc)

PARALLEL_MAKE = "${@limit_parallel(8)}"

# For the POC remove ceph user depencie in systemd service.
# In production use an specfic user in recommanded.
do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        sed s'/ --setuser ceph --setgroup ceph//' -i \
            ${D}${systemd_unitdir}/system/*.service
    fi
}
