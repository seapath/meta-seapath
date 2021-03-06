# Copyright (C) 2020, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

# Monitoring tools
IMAGE_INSTALL += "htop"

# Network tools
IMAGE_INSTALL += "tcpdump"

# System tools
IMAGE_FEATURES += "allow-empty-password debug-tweaks empty-root-password \
                   post-install-logging"
