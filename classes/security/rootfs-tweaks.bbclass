# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# This class implements functions to harden the rootfs after its generation.
#

python() {
    if not bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', True, False, d):
        d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "set_random_root_passwd;")
    d.appendVar("ROOTFS_POSTPROCESS_COMMAND", "set_bash_profile;")
}

set_bash_profile() {
    install -D -m 0644 ${SEC_ARTIFACTS_DIR}/profile ${IMAGE_ROOTFS}/etc/profile
}

set_random_root_passwd(){
    if ${@bb.utils.contains('VIRTUAL-RUNTIME_init_manager', 'systemd', 'true', 'false', d)}; then
        install -D -m 0644 ${SEC_ARTIFACTS_DIR}/random-root-passwd.service \
            ${IMAGE_ROOTFS}/lib/systemd/system
        install -d -m 0755 ${IMAGE_ROOTFS}/etc/systemd/system/sysinit.target.wants
        ln -sf /lib/systemd/system/random-root-passwd.service \
            ${IMAGE_ROOTFS}/etc/systemd/system/sysinit.target.wants/random-root-passwd.service
    fi
}
