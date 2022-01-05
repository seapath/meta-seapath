# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

EXTRA_OECONF_append_class-target = "${@bb.utils.contains('DISTRO_FEATURES','seapath-clustering', " --enable-rbd", "",d)}"
DEPENDS_append_class-target = "${@bb.utils.contains('DISTRO_FEATURES','seapath-clustering'," ceph", "",d)}"
