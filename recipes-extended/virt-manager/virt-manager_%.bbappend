# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

PACKAGECONFIG = ""

RDEPENDS:${PN}:remove = " \
  gdk-pixbuf \
  gtk+3 \
  hicolor-icon-theme \
"
RDEPENDS:${PN}-install = "${PN}"
