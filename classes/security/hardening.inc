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

inherit ${@'cve-check' if not bb.utils.to_boolean(BB_NO_NETWORK) else ''}
include ${@'conf/distro/include/cve-extra-exclusions.inc' if not bb.utils.to_boolean(BB_NO_NETWORK) else ''}
inherit image-buildinfo
inherit create-spdx

SPDX_PRETTY = "1"
SPDX_INCLUDE_SOURCES = "1"
SPDX_ARCHIVE_SOURCES = "1"
SPDX_ARCHIVE_PACKAGED = "1"

# Hardening framework classes
inherit security/kconfig-hardened-check
inherit security/manifests-archiver
inherit security/pam-policy
inherit security/rootfs-tweaks

# Yocto security options for compilation and linking
inherit security/check-hardened-compilation
