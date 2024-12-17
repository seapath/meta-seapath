FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx_5.15:"

SRC_URI += "file://defconfig"

KBUILD_DEFCONFIG:mx8-nxp-bsp = "defconfig"

do_copy_defconfig() {
  install -d ${B}
  cp ${WORKDIR}/defconfig ${B}/.config
}

do_kernel_metadata:prepend() {
  cp ${WORKDIR}/defconfig ${S}/arch/arm64/configs/defconfig
}

do_deploy:append() {
   install -m 0644 .config $deployDir/config_kernel
}
