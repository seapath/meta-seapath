# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

REQUIRED_HEARTBEAT_SCRIPTS = "VirtualDomain"

do_install_append() {
    # Remove tools and libraries used for NFS filesystem manipulations
    #
    # Note: resource-agents detects if "svclib_nfslock" is installed
    # and adapts its behavior if not detected (see ip.sh script)
    rm ${D}${libdir}/ocf/resource.d/heartbeat/nfsserver
    rm ${D}${libdir}/ocf/resource.d/heartbeat/exportfs
    rm ${D}${libdir}/ocf/lib/heartbeat/nfsserver-redhat.sh
    rm ${D}${libdir}/ocf/resource.d/heartbeat/nfsnotify
    rm ${D}${datadir}/cluster/netfs.sh
    rm ${D}${datadir}/cluster/nfsclient.sh
    rm ${D}${datadir}/cluster/nfsserver.sh
    rm ${D}${datadir}/cluster/nfsexport.sh
    rm ${D}${datadir}/cluster/svclib_nfslock

    # Remove support for GFS (unused)
    rm ${D}${datadir}/cluster/clusterfs.sh

    # Remove OCFT (unused test framework)
    rm -r ${D}${datadir}/resource-agents/ocft
    rm ${D}${sbindir}/ocft

    # Remove LVM2 scripts and libraries (unused)
    rm ${D}${libdir}/ocf/resource.d/heartbeat/clvm
    rm ${D}${libdir}/ocf/resource.d/heartbeat/lvmlockd
    rm ${D}${libdir}/ocf/resource.d/heartbeat/LVM
    rm ${D}${libdir}/ocf/resource.d/heartbeat/LVM-activate
    rm ${D}${libdir}/ocf/lib/heartbeat/lvm-*.sh
    rm ${D}${datadir}/cluster/lvm.metadata
    rm ${D}${datadir}/cluster/lvm*.sh

    # Remove unused heartbeat modules not declared in REQUIRED_HEARTBEAT_SCRIPTS
    for i in $(find ${D}${libdir}/ocf/resource.d/heartbeat/* -type f); do
        scriptname="$(basename ${i})"
        if echo "${REQUIRED_HEARTBEAT_SCRIPTS}" | grep -q "${scriptname}" ; then
            continue
        fi
        rm "${i}"
    done
}

RDEPENDS_${PN}_remove = "lvm2 nfs-utils"
