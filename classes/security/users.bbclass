# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Handle users creation
#
require users-config.inc
inherit extrausers

SUDOERS_DIR ?="${IMAGE_ROOTFS}/etc/sudoers.d"
USERS_LIST ?= ""
USERS_LIST_EXPIRED ?= ""
USERS_LIST_REMOVED ?= ""
USERS_LIST_SUDOERS ?= ""

IMAGE_INSTALL_append = " sudo"

python do_add_users() {
    userslist = d.getVar("USERS_LIST").split()
    userslistexpired = d.getVar("USERS_LIST_EXPIRED").split()
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

    if extrausersparams:
        d.setVar("EXTRA_USERS_PARAMS", extrausersparams)
}

# do_add_users must be called very early following rootfs generation
# so that extrausers.bbclass can use EXTRA_USERS_PARAMS variable
python prepend_to_rootfs_postprocess () {
    e.data.prependVar('ROOTFS_POSTPROCESS_COMMAND', ' do_add_users;')
}
addhandler prepend_to_rootfs_postprocess
prepend_to_rootfs_postprocess[eventmask] = "bb.event.RecipePreFinalise"
