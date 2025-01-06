#!/bin/bash

# Copyright (C) 2024 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Script that switches between "SEAPATH slot 0" and "SEAPATH slot 1"

set -e

partitionset_active=$(fw_printenv partitionset_active | cut -d'=' -f2)

if [ "$partitionset_active" = "A" ]; then
    fw_setenv partitionset_active "B"
else
    fw_setenv partitionset_active "A"
fi
