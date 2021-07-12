#!/bin/bash
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

LOGIN_FILE="/etc/pam.d/login"

# Before first match of "^auth.*", insert "auth requisite pam_deny.so"
sed -i '0,/^auth.*/s//auth\trequisite\tpam_deny.so\n&/' ${LOGIN_FILE} && \
    chattr +i ${LOGIN_FILE}
