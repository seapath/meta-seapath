SUMMARY = "AMD processors micro-code files"
HOMEPAGE = "https://www.kernel.org/"
DESCRIPTION = "AMD processors micro-code take from linux-firmware"
SECTION = "kernel"

LICENSE = 'Firmware-amd-ucode'


SRC_URI = " \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amd-ucode/microcode_amd.bin?h=${PV};name=microcode_amd.bin;downloadfilename=microcode_amd.bin \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amd-ucode/microcode_amd_fam15h.bin?h=${PV};name=microcode_amd_fam15h.bin;downloadfilename=microcode_amd_fam15h.bin \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amd-ucode/microcode_amd_fam16h.bin?h=${PV};name=microcode_amd_fam16h.bin;downloadfilename=microcode_amd_fam16h.bin \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amd-ucode/microcode_amd_fam17h.bin?h=${PV};name=microcode_amd_fam17h.bin;downloadfilename=microcode_amd_fam17h.bin \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amd-ucode/microcode_amd_fam19h.bin?h=${PV};name=microcode_amd_fam19h.bin;downloadfilename=microcode_amd_fam19h.bin \
    https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENSE.amd-ucode?h=${PV};name=LICENSE.amd-ucode;downloadfilename=LICENSE.amd-ucode \
"

SRC_URI[microcode_amd.bin.sha256sum] = '8a9d9e8b788e31e61cddc03cb1eeab5db99e0f667128943ff0780e6437d2e43e'
SRC_URI[microcode_amd_fam15h.bin.sha256sum] = '9d4a668410e72a4bdb86dc23e4261eca04daa83456ada02504115223f356981a'
SRC_URI[microcode_amd_fam16h.bin.sha256sum] = 'e02ad653b39c975d6c52674b50f23727bb6706bab7b4e5b391a4ce229e7ff121'
SRC_URI[microcode_amd_fam17h.bin.sha256sum] = '01dd65f59293442c3fc01f8c19f81f84adcfbff2a005bc06dd0cee6742391372'
SRC_URI[microcode_amd_fam19h.bin.sha256sum] = '73d7e1d6913667cc368ad2b329d472fcafaa334c0f91e45d41966004696e5e6d'
SRC_URI[LICENSE.amd-ucode.sha256sum] = 'e258da1b1d48096c73bc64d8ebc7a30926cf7fab33108d41c5d8ca5ccba8b7bc'

LIC_FILES_CHKSUM = "file://LICENSE.amd-ucode;md5=3c5399dc9148d7f0e1f41e34b69cf14f"
NO_GENERIC_LICENSE[Firmware-amd-ucode] = "LICENSE.amd-ucode"
PE = "1"

S = "${WORKDIR}/"

inherit allarch
CLEANBROKEN = "1"

do_install() {
        install -d -m 755 "${D}/${nonarch_base_libdir}/firmware"
        install -m 644 "${S}/microcode_amd.bin" "${D}/${nonarch_base_libdir}/firmware/"
        for number in 15 16 17 19 ; do
            install -m 644 "${S}/microcode_amd_fam${number}h.bin" "${D}/${nonarch_base_libdir}/firmware/"
        done
}


FILES_${PN} = "${nonarch_base_libdir}/firmware/*"

