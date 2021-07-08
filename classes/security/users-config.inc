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
USERS_LIST_LOCKED ?= "daemon sync qemu systemd-bus-proxy systemd-timesync \
    systemd-resolve systemd-network ceph sshd coroqnetd messagebus hacluster nobody"
USERS_LIST_LOCKED[doc] = "List of users to lock"

# Configure users with the ansible key enabled
USERS_SSH_ANSIBLE = "admin root"

# Additionnal group definition
GROUPS_LIST ?= "privileged"
GROUPS_LIST[doc] = "List of groups to be added"
GROUPS_LIST_SUDOERS ?= "privileged"
GROUPS_LIST_SUDOERS[doc] = "List of groups sudoers"
GROUPS_LIST_NOPASSWD ?= "privileged"
GROUPS_LIST_NOPASSWD[doc] = "List of users that do not require authentication for sudo"
GROUPS_LIST_EXEC ?= "privileged"
GROUPS_LIST_EXEC[doc] = "List of users that require EXEC tag in sudoers configuration"
SUDO_GROUP_OWNER ?= "privileged"
SUDO_GROUP_OWNER[doc] = "Group owner of sudo binary"

# Groups set for users
USER_GROUP_LIST[admin] = "admin privileged"
