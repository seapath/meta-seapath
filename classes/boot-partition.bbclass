# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_tar_image_boot_directory() {
    tar -czhf ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-boot.tar.gz -C ${IMAGE_ROOTFS}/boot ./EFI ./bzImage
}

addtask tar_image_boot_directory before do_image after do_rootfs
