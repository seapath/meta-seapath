#!/bin/sh
# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

set -e

for user in $@; do
    userUID=$(id -u ${user})
    userGID=$(id -g ${user})
    mkdir -p /mnt/persistent/users/${userUID}
    chown ${userUID}:${userGID} /mnt/persistent/users/${userUID}
    chmod 700 /mnt/persistent/users/${userUID}
done

chmod 755 /mnt/persistent/users
