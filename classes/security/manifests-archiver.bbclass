# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Archive manifest files that contain information related to
# and/or important with respect to cybersecurity.
#
# As they are files to archive from this class point of view, those
# manifests can be generated by any function, class or script called
# during the build process.
#
# A list of variables can be defined/overriden using the MANIFESTS_LIST.
#
# Each variable added must expand as an absolute path to a regular file.
#

MANIFESTS_ARCHIVER_DIR ?= "${SEC_ROOTDIR}/manifests"
MANIFESTS_ARCHIVER_DIR[doc] = "Directory where manifests will be stored"

MANIFESTS_LIST ?= "IMAGE_MANIFEST CVE_CHECK_MANIFEST"
MANIFESTS_LIST[doc] = "List of manifests to be included. Those should be paths to existing files"

MANIFESTS_IMAGE_BASEDIR = "${MANIFESTS_ARCHIVER_DIR}/${DATETIME}"
MANIFESTS_IMAGE_DIR = "${MANIFESTS_IMAGE_BASEDIR}/${DISTRO}/${MACHINE_ARCH}/${IMAGE_BASENAME}"

MANIFESTS_ARCHIVER_ARCHIVE_PATH = "${SEC_ROOTDIR}/hardening_images-manifests.tar.gz"

def create_archive_from_path(srcpath, archivepath, d):
    """
    Create a tarball file from 'srcpath' and store the
    resulting archive into 'archivepath'.

    Resulting archive is overwritten after each call.
    """

    import os
    import tarfile

    # Delete any existing archive
    if os.path.isfile(archivepath):
        os.remove(archivepath)

    with tarfile.open(archivepath, "w:gz") as tar:
        for file in os.scandir(srcpath):
            tar.add(file.path, arcname=file.name)

def copy_manifests_in_list_to_dir(manifestlist, destdir, d):
    """
    Copy each file in 'manifestlist' to 'destdir'.

    Each element in 'manifestlist' must be a Yocto variable
    that expands as an absolute path to a file.

    'manifestlist' can't be empty.
    """
    if not manifestlist:
        bb.fatal("MANIFESTS_LIST must not be set empty")

    for var in manifestlist:
        manifestfile = d.getVar(var)

        try:
            if not os.path.isfile(manifestfile):
                bb.fatal("'%s' file is missing or not a regular file" % manifestfile)
        except TypeError as e:
            bb.fatal("Invalid content for variable %s.\nEnsure that MANIFESTS_LIST contains only variable names not paths and that those variables are valid" % var)

        manifestname = os.path.basename(manifestfile)

        # Manifest is copied so an history can be built. It is not guaranteed that
        # the deploy directory will be kept sane or left untouched after two
        # consequent builds.
        bb.utils.copyfile(manifestfile, os.path.join(destdir, manifestname))

python run_manifests_archiver() {
    archivepath = os.path.join(d.getVar("MANIFESTS_ARCHIVER_DIR"), d.getVar("MANIFESTS_ARCHIVER_ARCHIVE_PATH"))
    create_archive_from_path(d.getVar("MANIFESTS_IMAGE_BASEDIR"), archivepath, d)
}

python do_prepare_image_manifests() {
    imagedir = d.getVar("MANIFESTS_IMAGE_DIR")

    bb.utils.mkdirhier(imagedir)

    manifestlist = d.getVar("MANIFESTS_LIST").split()
    copy_manifests_in_list_to_dir(manifestlist, imagedir, d)
}

# NOTE: "secdoc-compliance" will serve later as an introspection flag
# to generate coverage documentation
do_manifests_archiver[secdoc-compliance] = "ANSSI-NT28/R1"
do_manifests_archiver[doc] = "Archives all the manifests generated when producing an image for cybersecurity purposes"

# Exclude this function from the variable dependency computation as it
# relies on DATETIME
IMAGE_POSTPROCESS_COMMAND += "do_prepare_image_manifests;"
IMAGE_POSTPROCESS_COMMAND[vardepvalueexclude] .= "| do_prepare_image_manifests ;"
IMAGE_POSTPROCESS_COMMAND[vardepsexclude] += "do_prepare_image_manifests"

addhandler run_manifests_archiver
run_manifests_archiver[eventmask] = "bb.event.BuildCompleted"
