# Copyright (C) 2021, RTE (http://www.rte-france.com)
# Copyright (C) 2023-2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

#
# Configuration used by users.bbclass
#

USERS_LIST ?= "admin emergadmin ansible"
USERS_LIST[doc] = "List of users to be added"
USERS_LIST_DISABLEMAXDAYS ?= "admin ansible"
USERS_LIST_DISABLEMAXDAYS[doc] = "List of added users without maximum number of days for the password validity. Users that aren't in USERS_LIST are ignored."
USERS_LIST_EXPIRED ?= "emergadmin"
USERS_LIST_EXPIRED[doc] = "List of users with expiration password set. This will enforce a password change at first login."
USERS_LIST_SUDOERS ?= "admin emergadmin ansible"
USERS_LIST_SUDOERS[doc] = "List of users that will have a 'user' sudoers entry created with ALL permissions"
USERS_LIST_NOPASSWD ?= "admin ansible"
USERS_LIST_NOPASSWD[doc] = "List of users that do not require authentication for sudo (adding NOPASSWD)"
USERS_LIST_EXEC ?= "admin ansible emergadmin"
USERS_LIST_EXEC[doc] = "List of users that require EXEC tag in sudoers configuration"

USERS_LIST_REMOVED ?= "mail"
USERS_LIST_REMOVED[doc] = "List of users to remove"
USERS_LIST_LOCKED ?= "daemon \
 sync \
 ${@bb.utils.contains('DISTRO_FEATURES', 'virtualization', "qemu", '', d)} \
 systemd-timesync \
 systemd-resolve \
 systemd-network \
 sshd \
 messagebus \
 ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', "hacluster", '', d)} \
 nobody \
 snmp \
"
USERS_LIST_LOCKED[doc] = "List of users to lock"

# Configure users with the ansible key enabled
USERS_SSH_ANSIBLE = "admin ansible"

# Disable polyinstantiated directories for ansible users
SEAPATH_PAM_NAMESPACES_EXCLUDE_USERS = "ansible ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', "cephadm", '', d)}"

# Additionnal group definition
GROUPS_LIST ?= "privileged operator maint-n1 maint-n3 admincluster adminsys"
GROUPS_LIST[doc] = "List of groups to be added"
GROUPS_LIST_SUDOERS ?= ""
GROUPS_LIST_SUDOERS[doc] = "List of groups that will have a 'group' sudoers entry created with ALL permissions"
GROUPS_LIST_NOPASSWD ?= ""
GROUPS_LIST_NOPASSWD[doc] = "List of groups that do not require authentication for sudo (adding NOPASSWD)"
GROUPS_LIST_EXEC ?= ""
GROUPS_LIST_EXEC[doc] = "List of groups that require EXEC tag in sudoers configuration"
SUDO_GROUP_OWNER ?= "privileged"
SUDO_GROUP_OWNER[doc] = "Group owner of sudo binary"

# Groups set for users
# USER_GROUP_LIST[myuser] = "mygroup1 mygroup2"

# Permissions policies to enforce
GROUP_POLICIES_SUDO ?= "operator maint-n1 maint-n3 admincluster adminsys"

# List of users that is allowed to run rootless containers
USER_CONTAINER_LIST ?= "admin ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-clustering', "containerized-ceph", '', d)}"
