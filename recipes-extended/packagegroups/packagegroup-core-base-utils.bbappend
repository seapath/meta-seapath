# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

RDEPENDS:${PN}:remove = " \
    bind-utils            \
    cpio                  \
    diffutils             \
    dhcpcd                \
    ed                    \
    inetutils             \
    inetutils-telnet      \
    inetutils-telnetd     \
    inetutils-tftp        \
    inetutils-traceroute  \
    parted                \
    patch                 \
    time                  \
"

# CAUTION: a CVE has been ignored for inetutils-telnetd
# in the inetutils_%.bbappend file.
