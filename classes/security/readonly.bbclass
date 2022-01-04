# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

#
# Handle rootfs readonly creation
# Must be inherit in a Yocto distro
#

require ${@bb.utils.contains('DISTRO_FEATURES', 'seapath-readonly', 'readonly.inc', '', d)}
