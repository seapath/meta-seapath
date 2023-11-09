#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

die() {
    local msg=${*}
    echo "Fatal: ${msg}" 1>&2
    exit 1
}

HAWKBIT_DEVICE_ID="${HOSTNAME}"

[ -z "$HAWKBIT_DEVICE_ID" ] && die "please set hawkBit device id"
[ -z "$HAWKBIT_SERVER_URL" ] && die "please set hawkBbit server url"
suricatta_extra_args=""

if [ -f /var/log/update_success ] ; then
    suricatta_extra_args="-c 2"
    rm -f /var/log/update_success
elif [ -f /var/log/update_fail ] ; then
    suricatta_extra_args="-c 3"
    rm -f /var/log/update_fail
fi

swupdate -u "-u $HAWKBIT_SERVER_URL \
    -i $HAWKBIT_DEVICE_ID \
    -t default \
    $suricatta_extra_args"
