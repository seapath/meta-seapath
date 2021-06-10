# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# QA checks to be performed on host images prior building
# the image.
# Those checks shall return 0 on success and >0 on failure.
#
# Any check failure will stop the build.
#

require qa-common.inc

grub_file_is_setup_properly() {
    check_grub_configuration "${IMAGE_ROOTFS}/boot/EFI/BOOT/grub.cfg"
}

IMAGE_QA_COMMANDS += "          \
    grub_file_is_setup_properly \
    verify_secureboot_signature \
"
