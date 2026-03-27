LICENSE = "LGPL-2.1-only & BSD-3-Clause"
LIC_FILES_CHKSUM = "file://COPYING.LIB;md5=13491c437f1f737d366322a97a7a1d96 \
                    file://examples/LICENSE-FOR-EXAMPLES;md5=642aab861aee55b1f009e35b7350534f \
                    file://golang/LICENSE;md5=4fbd65380cdd255951079008b364516c \
                    file://golang/examples/LICENSE-FOR-EXAMPLES;md5=1900b31814765d8ee1675b497a26c082 \
                    file://ocaml/examples/LICENSE-FOR-EXAMPLES;md5=dc19736c102bee1ab5e1dd39d7c83e27 \
                    file://python/examples/LICENSE-FOR-EXAMPLES;md5=499975ab3b1d53690119a63fac7c7489 \
                    file://sh/examples/LICENSE-FOR-EXAMPLES;md5=e39512c19f865cc78b367f7d688cae90"

SRC_URI = " \
    https://download.libguestfs.org/${BPN}/${LIBNBD_MAJOR_VERSION}-stable/${BPN}-${PV}.tar.gz \
    file://0001-nbddiscard.in-do-not-use-fixed-Python-path.patch \
"
SRC_URI[sha256sum] = "4039cafb89c26f2c3f28fc16af7344d0cdd08845a27ce8c5c10efb2ca66bdfd2"

LIBNBD_MAJOR_VERSION = "1.24"
PV = "1.24.2"

DEPENDS = "gnutls glib-2.0 libxml2 fuse3 bash-completion"

inherit python3native perlnative pkgconfig autotools

EXTRA_OEMAKE += "VERSION_SCRIPT='-Wl,--version-script=${S}/lib/libnbd.syms' PYTHON_INSTALLDIR='${PYTHON_SITEPACKAGES_DIR}'"

FILES:${PN} += "\
    ${datadir}/bash-completion/* \
    ${PYTHON_SITEPACKAGES_DIR}/* \
"
