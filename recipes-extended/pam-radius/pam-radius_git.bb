# Copyright (C) 2020, RTE (http://www.rte-france.com)

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=cbbd794e2a0a289b9dfcc9f513d1996e"

SRC_URI = " \
    git://github.com/FreeRADIUS/pam_radius.git;protocol=https \
    file://0001-Use-standard-libtool-build-system.patch \
"

PV = "1.5+git${SRCPV}"
SRCREV = "ffcaf3a4462639f12b860377671836c28e124dfd"
DEPENDS = "libpam"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF = "--libdir=/lib"
REQUIRED_DISTRO_FEATURES = "pam"
FILES_${PN} = "${base_libdir}/security/pam_radius_auth.so"
