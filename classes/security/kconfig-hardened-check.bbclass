# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# Perform kernel configuration audit using "kconfig-hardened-check" tool.
#
# This class offers a wrapping interface over the tool's options and handles
# the execution of the script for generating a report stored in the specified
# directory.
#

KCONFIG_HARDENED_CHECK_MODE[only-pass] = "show_ok"
KCONFIG_HARDENED_CHECK_MODE[only-fail] = "show_fail"
KCONFIG_HARDENED_CHECK_MODE[raw] = "json"
KCONFIG_HARDENED_CHECK_MODE[all] = "verbose"

KCONFIG_HARDENED_CHECK_MODE ?= "only-fail"
KCONFIG_HARDENED_CHECK_MODE[doc] = \
    "Select output format for the kernel configuration hardening report"

KCONFIG_HARDENED_CHECK_SUPPORTED_ARCHS = "x86_64 i586 arm aarch64"
KCONFIG_HARDENED_CHECK_REPORT_DIR ?= "${DEPLOY_DIR_IMAGE}"

do_kconfig_hardened_check[depends] = " \
    kconfig-hardened-check-native:do_populate_sysroot \
    virtual/kernel:do_deploy \
    virtual/kernel:do_populate_sysroot \
"

exec_kconfig_hardened_check() {
    local kernel_config="${DEPLOY_DIR_IMAGE}/config_kernel"

    if [ ! -f "${kernel_config}" ]; then
        bbwarn "Kernel configuration not found in '${kernel_config}'! Unable to analyze it"
        return
    fi

    mkdir -p "${KCONFIG_HARDENED_CHECK_REPORT_DIR}"

    kconfig-hardened-check    \
        -m "${SELECTED_MODE}" \
        -c "${kernel_config}" > "${KCONFIG_HARDENED_CHECK_REPORT_DIR}/kernel-hardened-config.report"
}

python do_kconfig_hardened_check() {
    supported_modes = d.getVarFlags("KCONFIG_HARDENED_CHECK_MODE")
    selected_mode = d.getVar("KCONFIG_HARDENED_CHECK_MODE")

    if selected_mode in supported_modes:
        d.setVar("SELECTED_MODE", d.getVarFlag("KCONFIG_HARDENED_CHECK_MODE", selected_mode))
        bb.build.exec_func('exec_kconfig_hardened_check', d)
    else:
        bb.warn("The mode selected is not supported : '%s' not in '%s'" \
                % (selected_mode, supported_modes.keys()))
}

python() {
    if bb.data.inherits_class('kernel-yocto', d):
        if bb.utils.contains("KCONFIG_HARDENED_CHECK_SUPPORTED_ARCHS", \
                              d.getVar("TUNE_ARCH"), True, False, d):
            bb.build.addtask("do_kconfig_hardened_check", "do_build", "do_compile", d)
        else:
            bb.warn("Unsupported architecture for kernel configuration \
                     hardening check : %s" % d.getVar("TUNE_ARCH"))
}

IMAGE_POSTPROCESS_COMMAND += "do_kconfig_hardened_check ;"
