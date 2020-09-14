SYSTEMD_AUTO_ENABLE = "disable"

do_install_append() {
    rm "${D}${systemd_unitdir}/system/sysinit.target.wants/proc-fs-nfsd.mount"
}
