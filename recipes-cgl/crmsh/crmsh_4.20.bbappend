# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

RDEPENDS_${PN}_remove = "python-lxml"
RDEPENDS_${PN}_append = " python3-lxml \
                        python3-parallax \
                        python3-pyyaml"
