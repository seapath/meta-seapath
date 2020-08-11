# Copyright (C) 2020, RTE (http://www.rte-france.com)

FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

SRC_URI_append = " \
    file://busybox_lspci.cfg \
    file://busybox_less.cfg \
"
