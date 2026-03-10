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

# In Scarthgap, create-spdx implcitely inherits create-spdx-2.2. In order not
# to be confused once we upgrade to the next Yocto version, we explicitely ask
# for the 2.2 class.
inherit create-spdx-2.2
# Even though we don't use cve-check, we want the annotations generated with
# the CVE_STATUS variables to be exported, thus we use the vex class.
# This will no longer be needed with SPDX3 in the future Yocto version.
inherit vex

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
