# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# Setup and install hardened PAM policy
#

install_pam_policy() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'pam', 'true', 'false', d)}; then
        rm --one-file-system -f ${IMAGE_ROOTFS}/etc/pam.d/*
        for policyfile in $(find ${SEC_ARTIFACTS_DIR}/pam -maxdepth 1 -type f); do
            install -D -m 0644 ${policyfile} ${IMAGE_ROOTFS}/etc/pam.d/$(basename ${policyfile})
        done
    fi
}

clear_securetty() {
    rm -f ${IMAGE_ROOTFS}/etc/securetty
    touch ${IMAGE_ROOTFS}/etc/securetty
}

install_pam_environment() {
    install -D -m 0640 ${SEC_ARTIFACTS_DIR}/pam/config/etc/environment ${IMAGE_ROOTFS}/etc/environment
}

install_pam_access() {
    install -D -m 0640 ${SEC_ARTIFACTS_DIR}/pam/config/etc/access.conf ${IMAGE_ROOTFS}/etc/security/access.conf
}

python() {
    if bb.data.inherits_class('image', d):
        if bb.utils.contains('DISTRO_FEATURES', 'pam', True, False, d):
            has_unsafe_policy = bb.utils.contains('IMAGE_FEATURES', 'unsafe-pam-policy', True, False, d)
            has_debug_tweaks = bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', True, False, d)
            has_unsafe_features = bb.utils.contains('IMAGE_FEATURES', 'allow-empty-password', True, False, d) or \
                                  bb.utils.contains('IMAGE_FEATURES', 'empty-root-password', True, False, d)

            if has_unsafe_policy:
                if not has_unsafe_features and not has_debug_tweaks:
                    bb.warn("Image uses an unsafe PAM policy. DO NOT use in production.")
                return

            if has_unsafe_features or has_debug_tweaks:
                if not has_unsafe_policy:
                    raise bb.parse.SkipRecipe("Image uses features incompatible with SEAPATH PAM policy.\n" + \
                                              "Consider adding 'unsafe-pam-policy' to IMAGE_FEATURES " + \
                                              "or remove 'debug-tweaks / allow-empty-password / empty-root-password'")

            d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "install_pam_policy; clear_securetty; install_pam_environment; install_pam_access;")
            d.appendVar("IMAGE_INSTALL", " pam-plugin-access")
}
