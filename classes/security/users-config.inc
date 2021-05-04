# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Configuration used by users.bbclass
#

USERS_LIST ?= "admin"
USERS_LIST[doc] = "List of users to be added"
USERS_LIST_EXPIRED ?= "admin"
USERS_LIST_EXPIRED[doc] = "List of users with expiration password set"
USERS_LIST_SUDOERS ?= "admin"
USERS_LIST_SUDOERS[doc] = "List of users sudoers"
USERS_LIST_REMOVED ?= "mail"
USERS_LIST_REMOVED[doc] = "List of users to remove"
