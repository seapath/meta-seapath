# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Hardening framework environment setup and event handler.
#
# Prepare, verify environment and declare variables
# required and used by classes dealing with Hardening
# framework functions and artifacts.
#
# Serves as the entrypoint for event handling in the
# framework
#

SEC_ROOTDIR ?= "${TOPDIR}/security"
SEC_ROOTDIR[doc] = "Main directory where all security related artifacts, document, logs will be copied"

SEC_ROOTDIR_CLEAN_ON_BUILD ?= "0"
SEC_ROOTDIR_CLEAN_ON_BUILD[doc] = "If not 0, the SEC_ROOTDIR directory will be cleaned at each build"

def create_hardening_env_directory(d):
    secrootdir = d.getVar("SEC_ROOTDIR")
    if not secrootdir:
        bb.fatal("SEC_ROOTDIR variable is not defined")

    # Clean directory if requested
    clean = bb.utils.to_boolean(d.getVar("SEC_ROOTDIR_CLEAN_ON_BUILD"))
    if clean:
        import shutil
        if os.path.isdir(secrootdir):
            shutil.rmtree(secrootdir)
        else:
            os.remove(secrootdir)

    bb.utils.mkdirhier(secrootdir)

python hardening_eventhandler() {
    if bb.event.getName(e) == "BuildStarted":
        bb.note("[Hardening]: started")
        create_hardening_env_directory(d)
    elif bb.event.getName(e) == "BuildCompleted":
        bb.note("[Hardening]: done")
}

addhandler hardening_eventhandler
hardening_eventhandler[eventmask] = "bb.event.BuildStarted bb.event.BuildCompleted"
