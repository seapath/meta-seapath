# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

PACKAGECONFIG = ""

RDEPENDS:${PN}:append = " \
  libvirt-glib \
  libxml2-python \
  python3-pygobject \
  python3-requests \
"
RDEPENDS:${PN}-install = "${PN}"
