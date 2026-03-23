# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

FILESEXTRAPATHS:prepend := "${THISDIR}/cephadm:"
CEPHADM_PACKAGE ?= "${PN}"

SRC_URI += "file://cephadm-sudoers"

# Add a sudo dependency to be able to add cephadm user to sudo group
DEPENDS:append = " sudo"

inherit useradd security/users

USERADD_PACKAGES += "${CEPHADM_PACKAGE}"
USERADD_PARAM:${CEPHADM_PACKAGE} = "\
    --system \
    --create-home \
    --home-dir ${localstatedir}/lib/cephadm \
    --shell /bin/bash \
    --user-group \
    --groups ${SUDO_GROUP_OWNER} \
    -c 'cephadm user' cephadm ; \
    --system \
    --no-create-home \
    --home-dir ${localstatedir}/lib/containerized-ceph \
    --shell /bin/bash \
    --user-group \
    -c 'ceph container user' containerized-ceph"

do_install:append () {
    install -m 0750 -d ${D}${sysconfdir}/sudoers.d
    install -m 0440 ${UNPACKDIR}/cephadm-sudoers ${D}${sysconfdir}/sudoers.d/cephadm
}

RDEPENDS:${CEPHADM_PACKAGE} = " \
    lvm2 \
    python3-core \
    sudo \
"

RRECOMMENDS:${CEPHADM_PACKAGE} = " \
    podman \
"
