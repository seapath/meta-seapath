# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_install_append() {
    for file in $(find ${D}${libdir}/stonith/plugins/external -type f); do
        sed -i "s%${HOSTTOOLS_DIR}/%%g" "${file}"
    done
}
