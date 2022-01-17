# Copyright (C) 2022, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Handle rootfs overlay in a data partition
#

require ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-overlay', 'overlay.inc', '', d)}
