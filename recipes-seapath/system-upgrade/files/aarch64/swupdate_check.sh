#!/bin/bash
# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

if [ -f /var/log/update_marker ] ; then
    if ! /usr/share/update/check-health.sh ; then
        echo "Update test on systemd services has failed" 1>&2
        echo "Rebooting to the last working state..."
        fw_setenv bootcount "4"
        fw_setenv upgrade_available "1"
        reboot
        exit 1
    else
        rm -f /var/log/update_marker
    fi
fi
