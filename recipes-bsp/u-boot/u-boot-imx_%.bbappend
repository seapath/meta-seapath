

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"

SRC_URI += " \
    file://bootcount.cfg \
    file://0001-imx8mp_evk.h-add-support-for-A-B-layout-in-uboot-env.patch \
"
