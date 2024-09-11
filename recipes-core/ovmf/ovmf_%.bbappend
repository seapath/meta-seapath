# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

do_install:append () {
    if [ -f "${D}/efi/boot/bootx64.efi" ]; then
        mv "${D}/efi/boot/bootx64.efi" "${D}/efi/boot/shellx64.efi"
    fi
}

do_deploy:class-target:append () {
    if [ "${TARGET_ARCH}" = "x86_64" ]; then
        cp  "${D}/efi/boot/shellx64.efi" "${DEPLOYDIR}/shellx64.efi"
    fi
}
