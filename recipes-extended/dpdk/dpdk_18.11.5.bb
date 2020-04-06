include dpdk.inc

CONFIG_NAME = "common_linuxapp"
TEST_DIR = "test"

STABLE = "-stable"
BRANCH = "18.11"
SRCREV = "7df88d5d7e913146dadccf1645d558ffc0146825"

LICENSE = "BSD-3-Clause & LGPLv2.1 & GPLv2"
LIC_FILES_CHKSUM = "file://license/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
                    file://license/lgpl-2.1.txt;md5=4b54a1fd55a448865a0b32d41598759d \
                    file://license/bsd-3-clause.txt;md5=0f00d99239d922ffd13cabef83b33444"

do_install_append () {
    # Remove the unneeded dir
    rm -rf ${D}/${INSTALL_PATH}/${RTE_TARGET}/app
}
