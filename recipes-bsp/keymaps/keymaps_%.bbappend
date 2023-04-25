# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

do_configure:prepend () {
    if [ -z "${SEAPATH_KEYMAP}" ] ; then
         SEAPATH_KEYMAP=us
    fi
    cat << EOF > ${S}/keymap.sh
#!/bin/sh
#
# load keymap, if existing
loadkeys ${SEAPATH_KEYMAP}
EOF
}
