# Copyright (C) 2020, RTE (http://www.rte-france.com)

EXTRA_OECONF_append_class-target = " --enable-rbd"
DEPENDS_append_class-target = " ceph spice"
PACKAGECONFIG_append = " spice"
