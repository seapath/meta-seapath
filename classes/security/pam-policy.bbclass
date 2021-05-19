# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Setup and install hardened PAM policy
#

install_pam_policy(){
    if ${@bb.utils.contains('DISTRO_FEATURES', 'pam', 'true', 'false', d)}; then
        rm --one-file-system -f ${IMAGE_ROOTFS}/etc/pam.d/*
        for policyfile in ${SEC_ARTIFACTS_DIR}/pam/*; do
            install -D -m 0644 ${policyfile} ${IMAGE_ROOTFS}/etc/pam.d/$(basename ${policyfile})
        done
    fi
}

python() {
    if bb.data.inherits_class('image', d):
        if bb.utils.contains('DISTRO_FEATURES', 'pam', True, False, d):
            d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "install_pam_policy;")
}
