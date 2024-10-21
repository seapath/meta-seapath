FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx_5.15:"

SRC_URI += "file://docker_defconfig"

KBUILD_DEFCONFIG:mx8-nxp-bsp = "docker_defconfig"

do_copy_defconfig() {
  install -d ${B}
  cp ${WORKDIR}/docker_defconfig ${B}/.config
}

do_kernel_metadata:prepend() {
  cp ${WORKDIR}/docker_defconfig ${S}/arch/arm64/configs/docker_defconfig
}

do_deploy:append() {
   install -m 0644 .config $deployDir/config_kernel
}
