# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Configuration for classes, modules and variables used in
# the hardening environment.
#

BUILDINFO_FILE ?= "${IMAGE_ROOTFS}${IMAGE_BUILDINFO_FILE}"
IMAGE_BUILDINFO_VARS := "DISTRO DISTRO_VERSION IMAGE_NAME"
KERNELCONFIG_FILE ?= "${DEPLOY_DIR_IMAGE}/config_kernel"
KCONFIGHARDENED_FILE = "${DEPLOY_DIR_IMAGE}/kernel-hardened-config.report"
MANIFESTS_LIST ?= "IMAGE_MANIFEST CVE_CHECK_MANIFEST BUILDINFO_FILE KERNELCONFIG_FILE KCONFIGHARDENED_FILE"

# Enable PIE for glibc
GLIBCPIE="--enable-static-pie"

# List supported documents for traceability
TRACEABILITY_DOCUMENTS += "ANSSINT28"
