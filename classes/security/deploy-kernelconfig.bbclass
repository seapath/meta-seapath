# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# class that deploy Kernel .config into ${DEPLOY_DIR_IMAGE}/config_kernel
#

do_deploy_config () {
    cp ${B}/.config ${DEPLOY_DIR_IMAGE}/config_kernel
}
addtask deploy_config before do_build after do_configure
