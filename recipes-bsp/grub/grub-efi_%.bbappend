# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:class-target = " \
    file://grub-efi.cfg.in   \
"

do_compile:append:class-target() {
    grub_timeout=0
    grub_password='grub.pbkdf2.sha512.65536.93A962261977428CADFAF1C7EAD6339B40F422991C7F86FECC8E44411686C9E36FE7B5E7352DE3F2E29042CD7A95FDFFF9998C6A6EF80F98F05C763D754AFF2F6B9A321C8FB452F93DE72457B8E89C0DD46ACDE0C7598DD67E9D730931624CD29F972EE568248DC4734A42E127316CAB87C2EC05C538BFC65B7BF6A3581582BEFD596551B383567BE95DF1B498F93867FF074E4FBF09C5BCA266E484EC22A0BD6AD2EA9E1D8DAF67FDCCEEFA4614A65BC8EB857903A012DA4FFBC0161E8F775FF173031913437567AC42E7C015A851DABD0BAF2ECBF01F3A4C38F024A74ABC3E07ABD697E5AB63EFCC0C7A91725FBB86D71A1CBE84893A876B8BD225F928581F.4E8A15EEAFD2AEFC1338A1F31B26D1B7C2ABA9C5FCE0858A05C8456D24EF994974883825900241959B8B35B73AC913437FC24AF80B6DBFF1FBD32770CF118DDD'
    if [ -n "${SEAPATH_GRUB_TIMEOUT}" ] ; then
        grub_timeout="${SEAPATH_GRUB_TIMEOUT}"
    fi
    if [ -n "${SEAPATH_GRUB_PASSWORD}" ] ; then
        grub_password="${SEAPATH_GRUB_PASSWORD}"
    fi
    echo "serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1" \ 
        > "${B}/grub-efi.cfg"
    if ${@bb.utils.contains('DISTRO_FEATURES','seapath-security','true','false',d)}; then
        echo 'set superusers="root"' >> "${B}/grub-efi.cfg"
        echo "password_pbkdf2 root ${grub_password}" >> "${B}/grub-efi.cfg"
    fi
    echo "timeout=$grub_timeout" >> "${B}/grub-efi.cfg"
    extra_append=""
    if ${@bb.utils.contains('MACHINE_FEATURES', 'seapath-guest', 'true', 'false', d)} ; then
        if [ "${SEAPATH_GUEST_DISABLE_IPV6}" = "true" ] ; then
            extra_append=" ipv6.disable=1"
        fi
    else
        if [ "${SEAPATH_DISABLE_IPV6}" = "true" ] ; then
            extra_append=" ipv6.disable=1"
        fi
    fi
    echo "set kernel_parameters='${APPEND}${extra_append}'" >> "${B}/grub-efi.cfg"
    cat "${WORKDIR}/grub-efi.cfg.in" >> "${B}/grub-efi.cfg"
}

do_install:prepend:class-target:votp-host() {
    extra_append=""
    if [ -n "${SEAPATH_RT_CORES}" ] ; then
        extra_append="isolcpus=${SEAPATH_RT_CORES} nohz_full=${SEAPATH_RT_CORES} rcu_nocbs=${SEAPATH_RT_CORES}"
    fi
    sed "s/\(set kernel_parameters='.*\)'/\1 $extra_append'/" \
        -i "${B}/grub-efi.cfg"

}

do_install:append:class-target() {
    if [ "${UEFI_SB}" != "1" ]; then
        install -D -m 0600 "${B}/grub-efi.cfg" "${D}${EFI_FILES_PATH}/grub.cfg"
    fi
    rm -rf ${D}/${EFI_BOOT_PATH}/${GRUB_TARGET}-efi
    rm -rf ${D}/usr
}

# Ensure that SELoader is installed when enabled while Secureboot is
# also enabled.
# "grub-efi" actually depends on MOK2Verify protocol being installed by
# SELoader before its execution.
RDEPENDS:${PN}:class-target:append = "${@' seloader' if (d.getVar('UEFI_SELOADER') == '1' and d.getVar('UEFI_SB') == '1') else ''}"

# Remove dependency to grub-bootconf as the configuration is installed
# in grub-efi
RDEPENDS:${PN}:class-target:remove = "virtual/grub-bootconf"

FILES:${PN}:remove = "${libdir}/grub"

FILES:${PN}:append = " ${EFI_FILES_PATH}"

GRUB_BUILDIN += " password_pbkdf2 probe regexp chain"

COMPATIBLE_MACHINE_${PN}= "votp"
