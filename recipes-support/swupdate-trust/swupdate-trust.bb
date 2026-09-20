# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

SUMMARY = "SWUpdate CMS trust configuration"
DESCRIPTION = "\
    Install the SWUpdate trust-anchor bundle and the runtime configuration \
    that enforces CMS signature verification and refuses downgrades. The \
    trust anchors are read from the build key store at build time."
SECTION = "base"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://swupdate.cfg.in"

S = "${UNPACKDIR}"

inherit allarch

RDEPENDS:${PN} = "swupdate"

# The trust anchors are read from SWUPDATE_CA_CERTS_DIR, outside the recipe
# workdir. Hash their contents so a changed or rotated key store invalidates
# the task signature instead of being hidden by the sstate cache.
python __anonymous() {
    import glob
    import hashlib
    import os

    h = hashlib.sha256()
    pattern = os.path.join(d.getVar('SWUPDATE_CA_CERTS_DIR') or "", "*.crt")
    for crt in sorted(glob.glob(pattern)):
        with open(crt, "rb") as f:
            h.update(f.read())
    d.setVar('SWUPDATE_CA_CERTS_HASH', h.hexdigest())
}

do_install[vardeps] += "SWUPDATE_CA_CERTS_HASH"

python do_validate_version() {
    import re

    version = d.getVar('DISTRO_VERSION') or ""
    semver = re.compile(r'^[0-9]+\.[0-9]+\.[0-9]+(?:[-+][0-9A-Za-z.-]+)?$')
    numeric = re.compile(r'^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

    if not (semver.match(version) or numeric.match(version)):
        bb.fatal("DISTRO_VERSION '%s' is not a valid semver or 4-field numeric "
                 "version; it cannot be used as a no-downgrading floor." % version)
}
addtask do_validate_version before do_install after do_configure

do_install() {
    install -d -m 0700 ${D}${sysconfdir}/swupdate

    # Assemble every trusted CA certificate into a single PEM bundle.
    bundle="${D}${sysconfdir}/swupdate/ca-chain.pem"
    : > "$bundle"
    for crt in ${SWUPDATE_CA_CERTS_DIR}/*.crt; do
        [ -e "$crt" ] || continue
        cat "$crt" >> "$bundle"
    done
    if [ ! -s "$bundle" ]; then
        bbfatal "No CA certificate found in ${SWUPDATE_CA_CERTS_DIR}; cannot install the SWUpdate trust store"
    fi
    chmod 0600 "$bundle"

    # Render the runtime configuration from the build's DISTRO_VERSION.
    sed -e 's|@@DISTRO_VERSION@@|${DISTRO_VERSION}|g' \
        ${S}/swupdate.cfg.in > ${D}${sysconfdir}/swupdate.cfg
    chmod 0600 ${D}${sysconfdir}/swupdate.cfg
}

FILES:${PN} = "\
    ${sysconfdir}/swupdate.cfg \
    ${sysconfdir}/swupdate/ca-chain.pem \
"
