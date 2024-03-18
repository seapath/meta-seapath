#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Check the system health

set -e
/lib/systemd/systemd-boot-check-no-failures
