FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

SRC_URI_append = " \
    file://busybox_lspci.cfg \
    file://busybox_less.cfg \
"
