# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/ceph-18:"

SRC_URI:append = " \
    file://0001-systemd-ceph-volume-do-not-block-indefinitely-on-cep.patch \
    file://0021-remove-usage-of-distutils.patch \
    file://py313-compat/0001-mgr-stop-using-deprecated-API-to-initialize-Python.patch \
    file://py313-compat/0002-mgr-set-argv-for-python-in-PyModuleRegistry.patch \
    file://py313-compat/0003-mgr-add-site-package-paths-in-PyModuleRegistry.patch \
    file://py313-compat/0004-Revert-Merge-pull-request-55436-from-tchaikov-mgr-py.patch \
    file://py313-compat/0005-mgr-do-not-require-NOTIFY_TYPES-in-python-modules.patch \
    file://py313-compat/0007-mgr-stop-using-deprecated-API-to-initialize-Python.patch \
    file://py313-compat/0008-mgr-set-argv-for-python-in-PyModuleRegistry.patch \
    file://py313-compat/0009-mgr-add-site-package-paths-in-PyModuleRegistry.patch \
    file://py313-compat/0010-ceph-volume-fix-importlib.metadata-compat.patch \
    file://0001-fix-cross-compilation-with-python-cython-modules-18.patch \
"

include ceph.inc

# ceph-volume requires python3-packaging
RDEPENDS:${PN} += "python3-packaging"

PACKAGE_BEFORE_PN:append = " ${PN}-cephadm"

do_install:append() {
    # Fix python3 shebangs in ceph-node-proxy
    sed -i '1 s|^#!.*|#!/usr/bin/env python3|' ${D}${sbindir}/ceph-node-proxy
}

FILES:${PN} += " ${systemd_unitdir}/system/ceph-exporter.service"
FILES:${PN}-cephadm += " ${sbindir}/cephadm "
SYSTEMD_SERVICE:${PN} += "ceph-exporter.service"
