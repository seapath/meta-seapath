# Copyright (C) 2020, RTE (http://www.rte-france.com)
# Copyright (C) 2026 Savoir-faire Linux, Inc.
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECONF:append:class-target = "${@bb.utils.contains('DISTRO_FEATURES','seapath-clustering', " --enable-rbd", "",d)}"
DEPENDS:append:class-target = "${@bb.utils.contains('DISTRO_FEATURES','seapath-clustering'," ceph", "",d)}"

PACKAGECONFIG:append = " libusb pixman spice vhost virtfs vnc-jpeg gnutls"
