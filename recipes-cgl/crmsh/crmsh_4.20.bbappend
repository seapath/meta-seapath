# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

DEPENDS:remove = "python-setuptools-native"
DEPENDS:append = " python3-setuptools-native"

RDEPENDS:${PN}:append = " python3-pyyaml"
