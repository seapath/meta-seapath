# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

from setuptools import setup

setup(
    name="setup_ovs",
    version="1.0",
    packages=["setup_open_vswitch"],
    author="RTE",
    license="Apache License 2.0",
    author_email="mathieu.dupre@savoirfairelinux.com",
    description="Apply an OVS configuration from a JSON file",
    scripts=[
        "setup_ovs.py",
    ],
)
