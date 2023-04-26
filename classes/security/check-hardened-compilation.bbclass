# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# QA check to list packages which are not compiled with
# hardened compilation and linking options.
#

DEPENDS:append:class-target = " binutils-native"

SECCOMPILE_MANIFEST = "${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}_disabled_opts.csv"
SECCOMPILE_MANIFEST_TMP = "${TMPDIR}/disabled_compile_opts"
RUNTIME_DIR = "${PKGDATA_DIR}/runtime"
HIDE_WARNING ?= "y"

# Logging function
seccompile_log_and_record_failure() {
    [ "${HIDE_WARNING}" = "y" ] || {
        bbwarn "$1"
    }
    echo "$2;$3;$4;$5" >> ${SECCOMPILE_MANIFEST_TMP}
}

# Check if executable is PIE
seccompile_check_PIE() {
    local _binary_name="$(basename $1)"
    local _binary_extension="$(echo "${_binary_name}" | cut -d'.' -f2)"

    if [ "${_binary_extension}" = "ko" ]
    then
        return 0
    fi

    if [ "${_binary_name}" = "python.o" ]
    then
        return 0
    fi

    if  readelf -l "$1" | grep -q DYN && readelf -l "$1" | grep -q PHDR
    then
        local _virt_addr="$(readelf -l "$1" | grep PHDR | awk '{print $3}')"
        local _phys_addr="$(readelf -l "$1" | grep PHDR | awk '{print $4}')"
        if [ "${_virt_addr}" != "${_phys_addr}" ]
        then
            return 1
        fi
    fi
    return 0
}

# Check that stack is not executable
seccompile_check_execstack() {
    if readelf -l "$1" | grep -q -A1 GNU_STACK | grep -q RWE
    then
        return 1
    else
        return 0
    fi
}

# Check if stackprotector is enabled
seccompile_check_stackprotector() {
    readelf -s "$1" | grep -q __stack_chk_fail
}

# Check if sources are fortified
seccompile_check_fortify() {
    # 1. Check that binary is linked against libc AND
    # 2. Check that binary contains memcpy/strcpy/printf... functions
    # 3. Check that binary also contains fortified version of functions
    #    if some functions can be fortified
    if readelf --dynamic "$1" | grep -q libc; then
        if  readelf -s "$1" | grep -q -E "f?gets" ||
            readelf -s "$1" | grep -q -E "v?sn?printf" ||
            readelf -s "$1" | grep -q -E "st[rp]n?c(py|at)" ||
            readelf -s "$1" | grep -q -E "memp?(cpy|move|set)"
        then
            if  readelf -s "$1" | grep -q -E "gets_chk" ||
                readelf -s "$1" | grep -q -E "printf_chk" ||
                readelf -s "$1" | grep -q -E "st[rp]n?c(py|at)_chk" ||
                readelf -s "$1" | grep -q -E "memp?(cpy|move|set)_chk"
            then
                return 0
            else
                return 1
            fi
        fi
    fi
    return 0
}

# Check that relocation table is read-only
seccompile_check_relro() {
    readelf -l "$1" | grep -q GNU_RELRO
}

# Check that binding is done immediately
seccompile_check_bindnow() {
    readelf -d "$1" | grep -q BIND_NOW
}

do_check_compile_options() {
    :
}

do_check_compile_options:class-target() {
    echo "Package name, Package version, binary, missing option" > "${SECCOMPILE_MANIFEST_TMP}"

    bbplain "Starting binary compile and linking options analysis..."
    local _binary_list="$(find ${IMAGE_ROOTFS} -exec file {} \; | grep ELF | cut -d':' -f1)"

    for binary in ${_binary_list}; do
        local _binary_name="$(basename ${binary})"
        local _binary_path="${binary#"${IMAGE_ROOTFS}"}"
        local _pkgdata="$(grep -rn ${RUNTIME_DIR} -e "FILES_INFO:.*${_binary_path}" | cut -d':' -f1 | head -n1)"
        local _package_name="$(grep PN ${_pkgdata} | cut -d' ' -f2)"
        local _package_version="$(grep PV ${_pkgdata} | cut -d' ' -f2)"

        # Check if executable is PIE
        seccompile_check_PIE "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} compiled without -fPIE." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "-fPIE"

        # Check if stackprotector is enabled
        seccompile_check_stackprotector "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} compiled without -fstack-protector-strong." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "-fstack-protector-strong"

        # Check if sources are fortified
        seccompile_check_fortify "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} compiled without -D_FORTIFY_SOURCE=2." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "-D_FORTIFY_SOURCE=2"

        # Check that stack is not executable
        seccompile_check_execstack "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} linked without --no-execstack." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "--no-execstack"

        # Check that relocation table is read-only
        seccompile_check_relro "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} linked without -z,relro." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "-z,relro"

        # Check that binding is done immediately
        seccompile_check_bindnow "${binary}" ||
        seccompile_log_and_record_failure \
            "${_binary_name} linked without -z,now." \
            "${_package_name}" "${_package_version}" "${_binary_name}" "-z,now"
    done

    mv "${SECCOMPILE_MANIFEST_TMP}" "${SECCOMPILE_MANIFEST}"
    bbplain "Compile and linking options analysis done."
}

ROOTFS_POSTPROCESS_COMMAND += "do_check_compile_options; "
