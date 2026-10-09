# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

# Shared CMS signing configuration for production-capable SWUpdate images.
#
# The signer certificate and key sign sw-description at build time, while the
# extra certificates carry the intermediate CA inside the CMS structure so the
# target can rebuild the chain up to a trust anchor. SWUPDATE_KEYS_DIR is
# defined in conf/layer.conf; every path below can be overridden through the
# SEAPATH_SWUPDATE_* variables exported from seapath.conf.
#
# See keys/README.adoc for the key layout and
# scripts/generate-swupdate-keys.sh for a throwaway test PKI.

SWUPDATE_SIGNING = "CMS"
SWUPDATE_CMS_MD = "sha256"
SWUPDATE_CMS_CERT ?= "${@d.getVar('SEAPATH_SWUPDATE_CMS_CERT') or '${SWUPDATE_KEYS_DIR}/signer.crt'}"
SWUPDATE_CMS_KEY ?= "${@d.getVar('SEAPATH_SWUPDATE_CMS_KEY') or '${SWUPDATE_KEYS_DIR}/signer.key'}"
SWUPDATE_CMS_EXTRA_CERTS ?= "${@d.getVar('SEAPATH_SWUPDATE_CMS_EXTRA_CERTS') or '${SWUPDATE_KEYS_DIR}/ca/intermediate-ca.crt'}"
