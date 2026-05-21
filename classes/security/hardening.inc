# Copyright (C) 2022, RTE (http://www.rte-france.com)
# Copyright (C) 2025 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# Entrypoint class that assists in enabling security-oriented features
# for overall system hardening, cybersecurity audits and/or regulation
# compliance purposes.
#
#

BB_NO_NETWORK ??= "0"

require hardening-handler.inc
require hardening-config.inc

# Community / 3rd-party classes to be included

include conf/distro/include/cve-extra-exclusions.inc
inherit image-buildinfo

inherit create-spdx

# We want the CVE statuses in the SPDX3 file:
SPDX_INCLUDE_VEX = "all"

SPDX_PRETTY = "1"
SPDX_INCLUDE_SOURCES = "0"
SPDX_ARCHIVE_SOURCES = "0"
SPDX_ARCHIVE_PACKAGED = "0"

# The following is required so kernel CVEs are filtered based on the files that
# have actually been compiled.
SPDX_INCLUDE_COMPILED_SOURCES:pn-linux-mainline-rt = "1"

# Hardening framework classes
inherit security/kconfig-hardened-check
inherit security/manifests-archiver
inherit security/pam-policy
inherit security/rootfs-tweaks

# Yocto security options for compilation and linking
inherit security/check-hardened-compilation
