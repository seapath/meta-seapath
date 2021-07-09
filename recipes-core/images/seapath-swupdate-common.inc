# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit deploy
inherit boot-partition

IMAGE_INSTALL_append = " \
    swupdate             \
    dosfstools           \
    localedef            \
    glibc-utils          \
    system-config-efi    \
"

IMAGE_FSTYPES += "tar.xz"
SYSTEMD_DEFAULT_TARGET="boot-complete.target"
