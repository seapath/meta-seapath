# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "Pre-provisioned container images for SEAPATH (Ceph + Registry)"
DESCRIPTION = "Bundles quay.io/ceph/ceph:v20.2.0 and docker.io/library/registry:2 \
for offline use by the cephadm_install Ansible role"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit container-bundle systemd

CONTAINER_BUNDLES = "\
    quay.io/ceph/ceph:v20.2.0 \
    docker.io/library/registry:2 \
"

CONTAINER_DIGESTS[quay.io_ceph_ceph_v20.2.0] = "sha256:1228c3d05e45fbc068a8c33614e4409b6dac688bcc77369b06009b5830fa8d86"
CONTAINER_DIGESTS[docker.io_library_registry_2] = "sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373"

# Re-enable do_unpack (disabled by container-bundle.bbclass) so that
# SRC_URI files (service script, systemd unit) are unpacked.
# Setting [noexec] to anything other than "1" is treated as truthy
# in current BitBake; we must delete the flag in anonymous python instead.
# Re-enable do_unpack and fix S/B to use UNPACKDIR (Scarthgap requirement)
python __anonymous() {
    d.delVarFlag('do_unpack', 'noexec')
}

# Override S/B from container-bundle.bbclass: Scarthgap requires UNPACKDIR
S = "${UNPACKDIR}/sources"
B = "${UNPACKDIR}/build"

CONTAINER_BUNDLE_RUNTIME = "podman"

SRC_URI:append = " \
    file://seapath-load-images.sh \
    file://seapath-load-images.service \
"

RDEPENDS:${PN} = "skopeo"

do_install:append() {
    install -d ${D}${sbindir}
    install -m 0755 ${UNPACKDIR}/seapath-load-images.sh ${D}${sbindir}/seapath-load-images.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${UNPACKDIR}/seapath-load-images.service ${D}${systemd_system_unitdir}/seapath-load-images.service

    # Override refs file with full registry-qualified image names.
    # container-bundle.bbclass strips the registry (quay.io, docker.io)
    # from image references, which causes podman to resolve them to
    # docker.io/library by default.
    cat > ${D}${datadir}/container-bundles/podman/${PN}.refs << EOF
ceph_v20.2.0:quay.io/ceph/ceph:v20.2.0
registry_2:docker.io/library/registry:2
EOF
}

SYSTEMD_SERVICE:${PN} = "seapath-load-images.service"

# Extend FILES to include our service script and systemd unit.
# container-bundle.bbclass sets FILES:${PN} = "${datadir}/container-bundles"
FILES:${PN}:append = " ${sbindir}/seapath-load-images.sh"
