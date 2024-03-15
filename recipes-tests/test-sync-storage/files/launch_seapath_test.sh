#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

set -e
PERIOD="${PERIOD:-500}"
FILE_PATH="${FILE_PATH:-/test_sync_file}"
SEND_PERIODICALLY="${SEND_PERIODICALLY:no}"

if [ -f "${FILE_PATH}" ] ; then
    result=$(test_sync_storage_result "${FILE_PATH}")
    current_timestamp=$(date +%s)
    current_time="Current time: $(date --iso-8601=seconds) timestamp: ${current_timestamp}"
    last_timestamp=$(echo "${result}" |grep -Eo "timestamp [0-9]+" | \
        cut -d ' ' -f 2)
    diff=$(( current_timestamp - last_timestamp ))
    message="$(hostname);diff: ${diff};${current_time};${result}"
    if [ -n "${SERVER_IP}" ] ; then
        echo "${message}" | nc -w 1 "${SERVER_IP}" 5555
    fi
    echo "${message}"
fi
if [ "${SEND_PERIODICALLY}" = yes ] ; then
    test_sync_storage_write -p "${PERIOD}" "${FILE_PATH}" \
        | nc  "${SERVER_IP}" 5555
else
    test_sync_storage_write -p "${PERIOD}" "${FILE_PATH}"
fi
