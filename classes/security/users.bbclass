# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Handle users creation
#
require users-config.inc
inherit extrausers

SUDO_BIN ?="${IMAGE_ROOTFS}/usr/bin/sudo"
SUDOERS_DIR ?="${IMAGE_ROOTFS}/etc/sudoers.d"
USERS_LIST ?= ""
USERS_LIST_EXPIRED ?= ""
USERS_LIST_REMOVED ?= ""
USERS_LIST_SUDOERS ?= ""
USER_GROUP_LIST ?= ""
GROUPS_LIST ?= ""
GROUPS_LIST_SUDOERS ?= ""
SUDO_GROUP_OWNER ?= ""

IMAGE_INSTALL_append = " sudo"

python do_configure_users() {
    userslist = d.getVar("USERS_LIST").split()
    userslistexpired = d.getVar("USERS_LIST_EXPIRED").split()
    userslistlocked = d.getVar("USERS_LIST_LOCKED").split()
    userslistremoved = d.getVar("USERS_LIST_REMOVED").split()
    userslistsudoers = d.getVar("USERS_LIST_SUDOERS").split()

    sudoersdir = d.getVar("SUDOERS_DIR")

    extrausersparams = ""
    if not userslist:
        bb.warn("USERS_LIST empty, not creating any users")
        return

    # add users defined in USERS_LIST
    for user in userslist:
        extrausersparams += " useradd "+user+";"
        extrausersparams += " usermod -P '"+user+"' "+user+";"

    # set expiration for users in USERS_LIST_EXPIRED
    for user in userslistexpired:
        if user not in userslist:
            bb.warn("Can not set expiration for user %s (not in USERS_LIST)"
                %(user))
            continue

        extrausersparams += " passwd-expire "+user+";"

    # add in sudoers for users in USERS_LIST_SUDOERS
    for user in userslistsudoers:
        if user not in userslist:
            bb.warn("Can not add sudoers for user %s (not in USERS_LIST)"
                %(user))
            continue

        with open(os.path.join(sudoersdir, user), "w") as f:
            f.write(user+"  ALL=(ALL) NOPASSWD:ALL")

    # remove users from USERS_LIST_REMOVED
    for user in userslistremoved:
        extrausersparams += " userdel "+user+";"

    # lock users from USERS_LIST_LOCKED
    for user in userslistlocked:
        extrausersparams += " usermod -L "+user+";"

    ret = configure_groups(d, userslist, extrausersparams)
    if ret:
        extrausersparams += ret

    if extrausersparams:
        d.setVar("EXTRA_USERS_PARAMS", extrausersparams)
}

def configure_groups(d, userslist, extrausersparams):
    groupslist = d.getVar("GROUPS_LIST").split()
    groupslistsudoers = d.getVar("GROUPS_LIST_SUDOERS").split()
    sudoersdir = d.getVar("SUDOERS_DIR")
    usergrouplist = d.getVarFlags("USER_GROUP_LIST")
    ret = ""

    for g in groupslist:
        bb.note("adding group %s" %(g))
        ret += " groupadd "+g+";"

    # add in sudoers for groups in GROUP_LIST_SUDOERS
    for group in groupslistsudoers:
        if group not in groupslist:
            bb.warn("Can not add sudoers for group %s (not in GROUP_LIST)"
                %(group))
            continue

        with open(os.path.join(sudoersdir, group), "w") as f:
            f.write("%"+group+"  ALL=(ALL) NOPASSWD:ALL")

    for g in usergrouplist:
        bb.note("adding group for %s" %(g))
        if g not in userslist:
            bb.fatal("%s is not defined in USERS_LIST" %(g))

        for group in usergrouplist[g].split():
            ret += " usermod -a -G "+group+" "+g+";"
            bb.note("adding group %s for %s" %(group, g))
    return ret

do_configure_sudo() {
    $PSEUDO chown "root:${SUDO_GROUP_OWNER}" ${SUDO_BIN}
    $PSEUDO chmod 4750 ${SUDO_BIN}
}

# do_add_users must be called very early following rootfs generation
# so that extrausers.bbclass can use EXTRA_USERS_PARAMS variable
python modify_rootfs_postprocess () {
    e.data.prependVar('ROOTFS_POSTPROCESS_COMMAND', ' do_configure_users;')
    e.data.appendVar('ROOTFS_POSTPROCESS_COMMAND', ' do_configure_sudo;')
}
addhandler modify_rootfs_postprocess
modify_rootfs_postprocess[eventmask] = "bb.event.RecipePreFinalise"
