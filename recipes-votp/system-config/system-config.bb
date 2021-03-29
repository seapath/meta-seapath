# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"


do_fetch[nostamp] = "1"

# Check the ssh public key is present
do_fetch_prepend () {
    for directoy in d.getVar('FILESPATH').split(':'):
        key = os.path.join(directoy, 'authorized_keys')
        if os.path.islink(key) and not os.path.isfile(key):
            error_msg = "Can't find ssh public key. "
            error_msg += "Put your ssh public key in "
            error_msg += '"keys/ansible_public_ssh_key.pub".'
            bb.fatal(error_msg)
}

SRC_URI = " \
    file://common/90-sysctl-hardening.conf \
    file://common/authorized_keys \
    file://common/votp-loadkeys.service \
    file://host/votp-config_ovs.service \
"

do_install () {
    install -d ${D}${systemd_unitdir}/system

# Common
    install -m 0644 ${WORKDIR}/common/votp-loadkeys.service \
        ${D}${systemd_unitdir}/system
    install -d -m 0700 ${D}/${ROOT_HOME}/.ssh
    install -m 0600 ${WORKDIR}/common/authorized_keys \
        ${D}/${ROOT_HOME}/.ssh/authorized_keys
    install -d ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/common/90-sysctl-hardening.conf \
        ${D}${sysconfdir}/sysctl.d

# Host
    install -m 0644 ${WORKDIR}/host/votp-config_ovs.service \
        ${D}${systemd_unitdir}/system
}

PACKAGES =+ " \
    ${PN}-common \
    ${PN}-host \
"

SYSTEMD_PACKAGES += " \
    ${PN}-common \
    ${PN}-host \
"

SYSTEMD_SERVICE_${PN}-common = " \
    votp-loadkeys.service \
"

SYSTEMD_SERVICE_${PN}-host = " \
    votp-config_ovs.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd distro_features_check

FILES_${PN}-common = " \
    ${ROOT_HOME}/.ssh/authorized_keys \
    ${sysconfdir}/sysctl.d/90-sysctl-hardening.conf \
    ${systemd_unitdir}/system/votp-loadkeys.service \
"

FILES_${PN}-host = " \
    ${systemd_unitdir}/system/votp-config_ovs.service \
"
