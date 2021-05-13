# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# This class implements functions to harden the rootfs after its generation.
#

python() {
    if not bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', True, False, d):
        d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "set_random_root_passwd;")
    d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "install_pam_policy;")
}

install_pam_policy(){
    if ${@bb.utils.contains('DISTRO_FEATURES', 'pam', 'true', 'false', d)}; then
        rm --one-file-system -f ${IMAGE_ROOTFS}/etc/pam.d/*
        for policyfile in ${SEC_ARTIFACTS_DIR}/pam/*; do
            install -D -m 0644 ${policyfile} ${IMAGE_ROOTFS}/etc/pam.d/$(basename ${policyfile})
        done
    fi
}

set_random_root_passwd(){
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -D -m 0644 ${SEC_ARTIFACTS_DIR}/random-root-passwd.service \
            ${IMAGE_ROOTFS}/lib/systemd/system
        ln -sf /lib/systemd/system/random-root-passwd.service \
            ${IMAGE_ROOTFS}/etc/systemd/system/sysinit.target.wants/random-root-passwd.service
    fi
}
