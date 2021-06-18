# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Setup ansible SSH authorized_keys file for any user allowed
# to execute ansible tasks.
#

AUTHORIZED_KEYS_DIR := "${THISDIR}/ansible"
USERS_SSH_ANSIBLE ?= ""
USERS_SSH_ANSIBLE[doc] = "List of the users allowed to connect through SSH using Ansible keys"

do_add_ansible_ssh_key() {
    export PSEUDO="${FAKEROOTENV} ${STAGING_DIR_NATIVE}${bindir}/pseudo"
    for user in ${USERS_SSH_ANSIBLE}; do
        if ! grep -q "$user" ${IMAGE_ROOTFS}/${sysconfdir}/passwd; then
            bbwarn "User $user does not exist in destination image. Skipped"
            continue
        fi
        install -d 0755 ${IMAGE_ROOTFS}/${sysconfdir}/ssh/$user
        install -m 0600 ${AUTHORIZED_KEYS_DIR}/ansible-authorized_keys \
                        ${IMAGE_ROOTFS}/${sysconfdir}/ssh/$user/authorized_keys

        eval flock -x ${IMAGE_ROOTFS}/${sysconfdir} -c \"$PSEUDO chown -R $user:$user ${IMAGE_ROOTFS}/etc/ssh/$user \"
        sed -i "s#AuthorizedKeysFile.*#AuthorizedKeysFile	/etc/ssh/%u/authorized_keys#" \
                        ${IMAGE_ROOTFS}/${sysconfdir}/ssh/sshd_config
        sed -i "s#AuthorizedKeysFile.*#AuthorizedKeysFile	/etc/ssh/%u/authorized_keys#" \
                        ${IMAGE_ROOTFS}/${sysconfdir}/ssh/sshd_config_readonly
    done
    sed -i "s/^UsePAM*/#UsePAM/g" \
        ${IMAGE_ROOTFS}/${sysconfdir}/ssh/sshd_config_readonly
}

python() {
    have_ssh = bb.utils.contains('IMAGE_FEATURES', 'ssh-server-openssh', True, False, d)
    using_ansible_key = bb.utils.contains('DISTRO_FEATURES', 'ansible', True, False, d)

    if have_ssh and using_ansible_key:
        key = os.path.join(d.getVar('AUTHORIZED_KEYS_DIR'), 'ansible-authorized_keys')
        if os.path.islink(key) and not os.path.isfile(key):
            error_msg = "Can't find a valid ssh public key."
            error_msg += " Please consult README to find instructions "
            error_msg += '"on how to setup the build environment.".'
            bb.error(error_msg)

        d.appendVar('ROOTFS_POSTPROCESS_COMMAND', 'do_add_ansible_ssh_key;')
}
