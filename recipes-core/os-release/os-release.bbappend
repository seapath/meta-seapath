# SPDX-License-Identifier: MIT
# Original commit from poky: https://git.yoctoproject.org/poky/commit/?id=d674b5fe133ad83ea476eb9a2258683813e1be0f

OS_RELEASE_FIELDS += "CPE_NAME"

# The vendor field is hardcoded to "openembedded" deliberately. We'd
# advise developers leave it as this value to clearly identify the
# underlying build environment from which the OS was constructed. We
# understand people will want to identify themselves as the people who
# built the image, we'd suggest using the DISTRO element to do this, so
# that is customisable.
# This end result combines to mean systems can be traced back to both who
# built them and which system was used, which is ultimately the goal of
# the CPE.

CPE_DISTRO ??= "${DISTRO}"
CPE_NAME="cpe:/o:openembedded:${CPE_DISTRO}:${VERSION_ID}"
