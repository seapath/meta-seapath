# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Common functions and variables that can be used for
# QA checks
#

verify_secureboot_signature() {
    if [ "${UEFI_SB}" != "1" ]; then
        return 0
    fi

    for efifile in $(find ${IMAGE_ROOTFS}/boot/EFI/BOOT -type f -iname "*.efi"); do
        filename=$(basename ${efifile})
        # LockDown.efi is special : it is supposed to be called to populate
        # SecureBoot variables so it cannot be signed.
        # Hence if detected, skip that binary.
        if [ "${filename}" = "LockDown.efi" ]; then
            continue
        fi
        # Binaries must be signed using the DB key.
        if ! sbverify "${efifile}" --cert ${UEFI_SB_KEYS_DIR}/DB.crt; then
            bbwarn "${filename} is not correctly signed for Secureboot"
            return 1
        fi
    done
}

check_grub_configuration(){
    [ ! -f "$1" ] && return 254

    if is_bios_image; then
        bbwarn "QA check skipped: BIOS image detected"
        return 0
    fi

    local _grub_passwd="$(grep "grub.pbkdf2" "$1")"
    local _passwd_alg="$(echo "${_grub_passwd}" | cut -d. -f3)"
    local _passwd_iterations="$(echo "${_grub_passwd}" | cut -d. -f4)"
    local _passwd_enc="$(echo "${_grub_passwd}" | cut -d. -f5)"
    local _passwd_salt="$(echo "${_grub_passwd}" | cut -d. -f6)"

    [ -z "${_grub_passwd}" ] && {
            bberror "Cannot find GRUB password definition in $1"
            return 1
    }
    [ "${_passwd_alg}" = "sha512" ] || {
            bberror "Chosen algorithm is invalid. Expected 'sha512', got ${_passwd_alg}"
            return 2
    }
    [ "${_passwd_iterations}" = "65536" ] || {
            bberror "Chosen number of iterations is invalid. Expected '65536', got ${_passwd_iterations}"
            return 3
    }
    [ ${#_passwd_enc} -eq 512 ] || {
            bberror "Encrypted password length is invalid. Expected '512', got ${#_passwd_enc}"
            return 4
    }
    [ ${#_passwd_salt} -eq 128 ] || {
            bberror "Salt length is invalid. Expected '128', got ${#_passwd_salt}"
            return 5
    }
}

is_bios_image() {
    if [ "${WKS_FILE}" = "mkbiosdisk.wks.in" ]; then
        return 0
    fi

    return 1
}
