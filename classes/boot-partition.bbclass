# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_tar_image_boot_directory() {
    if [ "${TARGET_ARCH}" = "aarch64" ]; then
        tar -cJhf ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-boot.tar.xz \
            -C ${DEPLOY_DIR_IMAGE} \
            tee.bin \
            ${KERNEL_DEVICETREE_BASENAME}.dtb \
            Image
    else
        tar -cJhf ${IMGDEPLOYDIR}/${IMAGE_BASENAME}-boot.tar.xz -C ${IMAGE_ROOTFS}/boot ./EFI ./bzImage
    fi
}

addtask tar_image_boot_directory before do_image after do_rootfs
