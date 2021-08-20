# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

import re
import subprocess
import logging

PCI_ADDRESS_MATCHER = re.compile(
    r"^((0{1,4}:)?(?P<part1>[0-9a-f]{1,2}):(?P<part2>[0-9a-f]{1,2})."
    r"(?P<part3>[0-9a-f]))$"
)

IPv4_ADDRESS_MATCHER = re.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")

MAC_ADDRESS_MATCHER = re.compile(r"^([0-9a-f][0-9a-f]:){5}([0-9a-f][0-9a-f])$")

dry_run = False


def run_command(*cmd_args, **kargs):
    """
    Shell runner helper
    Work as subproccess.run except check is set to true by default and
    stdout is not printed unless the logging level is DEBUG
    """
    logging.debug("Run command: " + " ".join(map(str, cmd_args)))
    if not dry_run:
        if "check" not in kargs:
            kargs["check"] = True
            if (
                logging.getLogger().getEffectiveLevel() != logging.DEBUG
                and "stdout" not in kargs
                and (
                    "capture_output" not in kargs
                    or not kargs["capture_output"]
                )
            ):
                kargs["stdout"] = subprocess.DEVNULL
            return subprocess.run(cmd_args, **kargs)
