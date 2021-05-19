# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Test distributed files storage"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit pkgconfig cmake systemd
DEPENDS = "glib-2.0"
RDEPENDS_${PN} += "bash netcat-openbsd"

PR = "r0"
S = "${WORKDIR}/"

SRC_URI = "file://CMakeLists.txt;md5=a832ee3d5087929bd31746f7ff06dcad \
           file://test_sync_storage_result.c;md5=04731f6b41f6215b5287f86e6840335c \
           file://test_sync_storage_write.c;md5=4e8af9b2de1c0edeba6f6d90e76da21a \
           file://votp-test-sync.conf;md5=f0a78adc8916f8a18aeb46b71ba58bee \
           file://votp-test-sync.service;md5=33e2c62eac1f435e6bf34d0eaa12d3a2 \
           file://launch_votp_test.sh;md5=4623d2582fc4d15efa8d207c4cdf540e \
"

do_install_append() {
    install -d ${D}${sysconfdir}/sysconfig/
    install -m 6444 ${S}/votp-test-sync.conf ${D}${sysconfdir}/sysconfig

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${S}/votp-test-sync.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} += " \
    ${sysconfdir}/sysconfig/votp-test-sync.conf \
    ${systemd_unitdir}/system/votp-test-sync.service \
"

SYSTEMD_SERVICE_${PN} = "votp-test-sync.service"

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
