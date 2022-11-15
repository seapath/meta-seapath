# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

inherit deploy
inherit boot-partition

IMAGE_INSTALL_remove = "grub"
IMAGE_INSTALL_append = " \
    grub-efi             \
    efitools             \
    efibootmgr           \
    cukinia-tests-efi    \
"
