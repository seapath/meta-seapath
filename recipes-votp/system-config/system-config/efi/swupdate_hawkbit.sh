#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

die() {
    local msg=${*}
    echo "Fatal: ${msg}"
    exit 1
}

# TODO: For the moment the mechanism to store EFI variables is not
# ready, so its value is set by hand (should use EFI vars instead)
system_updated="1"

# TODO: Determine which tests should be passed. Check if passing all the
# tests can give problems. Remove the "set -e"?
cukinia "/etc/cukinia/common_tests.d/cukinia-installation.conf"
if [ $? == "1" ] ; then
    update_failed="1"
else
    update_failed="0"
fi

# Suricatta extra arguments are used to send target status
if [ "$system_updated" == "0" ]; then
    suricatta_extra_args=""
elif [ "$system_updated" == "1" ] && [ "$update_failed" == "1" ]; then
    suricatta_extra_args="-c 3"
elif [ "$system_updated" == "1" ] && [ "$update_failed" == "0" ]; then
    suricatta_extra_args="-c 2"
else
    die "incorrect value of system_updated"
fi

HAWKBIT_DEVICE_ID="${HOSTNAME}"

[ -z "$HAWKBIT_DEVICE_ID" ] && die "please set hawkBit device id"
[ -z "$HAWKBIT_SERVER_URL" ] && die "please set hawkBbit server url"
[ -z "$HAWKBIT_SERVER_PORT" ] && die "please set hawkBit server port"

# TODO: reset EFI variables

swupdate -u "-u http://$HAWKBIT_SERVER_URL:$HAWKBIT_SERVER_PORT \
    -i $HAWKBIT_DEVICE_ID -t default $suricatta_extra_args" || exit 1
