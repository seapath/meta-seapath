# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# QA check to list packages which are not compiled with
# hardened compilation and linking options.
#

DEPENDS:append:class-target = " checksec-native"

SECCOMPILE_MANIFEST = "${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}_compiled_opts.csv"
SECCOMPILE_MANIFEST_TMP = "${TMPDIR}/compiled_opts.csv"
RUNTIME_DIR = "${PKGDATA_DIR}/runtime"
HIDE_WARNING ?= "y"
SEAPATH_SECCOMPILE_MANIFEST_SKIP ?= "0"

# Logging function
seccompile_record() {
    echo -n "$2,$3,$4," >> ${SECCOMPILE_MANIFEST_TMP}
    checksec --file="${1}" --format=csv | cut -d ',' -f "-8" >> ${SECCOMPILE_MANIFEST_TMP}
}

do_check_compile_options() {
    :
}

do_check_compile_options:class-target() {
    if [ "${SEAPATH_SECCOMPILE_MANIFEST_SKIP}" = "1" ] ; then
        bbnote "SEAPATH_SECCOMPILE_MANIFEST_SKIP=1: skip compilation options report"
        echo "Manifest not generated. Set SEAPATH_SECCOMPILE_MANIFEST_SKIP to 0 to generate it" > "${SECCOMPILE_MANIFEST}"
        return 0
    fi
    echo "Package name, Package version, Binary, RELRO, Stack canary, NX, PIE, RPATH, RUNPATH, Debug Symbols, Fortify source" > "${SECCOMPILE_MANIFEST_TMP}"

    bbplain "Starting binary compile and linking options analysis..."
    local _binary_list="$(find ${IMAGE_ROOTFS} -exec file {} \; | grep ELF | cut -d':' -f1)"

    for binary in ${_binary_list}; do
        local _binary_name="$(basename ${binary})"
        local _binary_path="${binary#"${IMAGE_ROOTFS}"}"
        local _pkgdata="$(grep -rn ${RUNTIME_DIR} -e "FILES_INFO:.*${_binary_path}" | cut -d':' -f1 | head -n1)"
        local _package_name="$(grep PN ${_pkgdata} | cut -d' ' -f2)"
        local _package_version="$(grep PV ${_pkgdata} | cut -d' ' -f2)"

        seccompile_record "${binary}" "${_package_name}" "${_package_version}" "${_binary_name}" 
    done

    mv "${SECCOMPILE_MANIFEST_TMP}" "${SECCOMPILE_MANIFEST}"
    bbplain "Compile and linking options analysis done."
}

ROOTFS_POSTPROCESS_COMMAND += "do_check_compile_options; "
