# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp System configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRCREV = "${AUTOREV}"

# Check the ssh public key is present
do_fetch_prepend () {
    for directoy in d.getVar('FILESPATH').split(':'):
        key = os.path.join(directoy, 'authorized_keys')
        if os.path.islink(key) and not os.path.isfile(key):
            error_msg = "Can't find ssh public key. "
            error_msg += "Put your ssh public key in "
            error_msg += '"yocto-bsp/keys/ansible_public_ssh_key.pub".'
            bb.fatal(error_msg)
}

SRC_URI = " \
    file://votp-config_ovs.service \
    file://votp-loadkeys.service \
    file://authorized_keys \
"

do_install () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/votp-config_ovs.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/votp-loadkeys.service ${D}${systemd_unitdir}/system
    install -d -m 0700 ${D}/${ROOT_HOME}/.ssh
    install -m 0600 ${WORKDIR}/authorized_keys ${D}/${ROOT_HOME}/.ssh/authorized_keys

}

SYSTEMD_SERVICE_${PN} = " \
    votp-config_ovs.service \
    votp-loadkeys.service \
"

REQUIRED_DISTRO_FEATURES = "systemd"

inherit allarch systemd

FILES_${PN} = "${ROOT_HOME}/.ssh/authorized_keys"
