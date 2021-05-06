# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Entrypoint class that assists in enabling security-oriented features
# for overall system hardening, cybersecurity audits and/or regulation
# compliance purposes.
#

require hardening-handler.inc
require hardening-config.inc

# Community / 3rd-party classes to be included
inherit cve-check
inherit image-buildinfo

# Hardening framework classes
inherit security/kconfig-hardened-check
inherit security/manifests-archiver
inherit security/rootfs-tweaks
