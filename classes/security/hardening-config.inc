# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# Configuration for classes, modules and variables used in
# the hardening environment.
#

BB_NO_NETWORK ??= "0"

SECCOMPILE_MANIFEST ??= ""
BUILDINFO_FILE ?= "${IMAGE_ROOTFS}${IMAGE_BUILDINFO_FILE}"
IMAGE_BUILDINFO_VARS := "DISTRO DISTRO_VERSION IMAGE_NAME"
KERNELCONFIG_FILE ?= "${DEPLOY_DIR_IMAGE}/config_kernel"
KCONFIGHARDENED_FILE = "${DEPLOY_DIR_IMAGE}/kernel-hardened-config.report"

MANIFESTS_LIST ?= "IMAGE_MANIFEST ${@'CVE_CHECK_MANIFEST' if not bb.utils.to_boolean(BB_NO_NETWORK) else ''} BUILDINFO_FILE KERNELCONFIG_FILE KCONFIGHARDENED_FILE SECCOMPILE_MANIFEST"

# Enable PIE for glibc
GLIBCPIE="--enable-static-pie"
