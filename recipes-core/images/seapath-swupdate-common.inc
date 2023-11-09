# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

inherit deploy
inherit boot-partition

IMAGE_INSTALL:append = " \
    swupdate             \
    dosfstools           \
    localedef            \
    glibc-utils          \
    system-config-efi    \
    grub-efi-editenv     \
"

IMAGE_FSTYPES += "tar.xz"
SYSTEMD_DEFAULT_TARGET="boot-complete.target"
