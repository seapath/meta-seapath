# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DESCRIPTION = "Votp SSH configuration"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

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
    file://authorized_keys \
"

do_install () {
    install -d -m 0700 ${D}/${ROOT_HOME}/.ssh
    install -m 0600 ${WORKDIR}/authorized_keys \
        ${D}/${ROOT_HOME}/.ssh/authorized_keys
}

FILES_${PN} = " \
    ${ROOT_HOME}/.ssh/authorized_keys \
"
