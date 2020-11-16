# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECMAKE_append = " -DENABLE_GIT_VERSION=OFF"

def limit_parallel(limit):
   import multiprocessing
   nproc = min(multiprocessing.cpu_count(), int(limit))
   return "-j{}".format(nproc)

PARALLEL_MAKE = "${@limit_parallel(8)}"

inherit useradd

USERADD_PACKAGES= "${PN}"
USERADD_PARAM_${PN} = "--system --no-create-home --home-dir /var/lib/ceph \
    --shell /bin/nologin --user-group -c 'Ceph daemons' ceph"
