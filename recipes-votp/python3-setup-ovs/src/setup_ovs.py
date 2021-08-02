#!/usr/bin/env python3
# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

import argparse
import logging
import json
import os
import re
import subprocess


class SetupOVSException(Exception):
    """
    Base class for exception in setup_ovs module
    """


class SetupOVSConfigException(SetupOVSException):
    """
    JSON configuration exception class
    """


class SetupOVS:
    """
    SetupOVS is a class to create Open vSwitch bridges and configure its
    ports based on configuration formatted as a JSON file.
    It supports DPDK and automatically bind network interface in DPDK
    """

    PCI_ADDRESS_MATCHER = re.compile(
        r"^((0{1,4}:)?(?P<part1>[0-9a-f]{1,2}):(?P<part2>[0-9a-f]{1,2})."
        r"(?P<part3>[0-9a-f]))$"
    )

    IPv4_ADDRESS_MATCHER = re.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")

    def __init__(
        self,
        config="/etc/ovs_configuration.json",
        check_only=False,
        dry_run=False,
    ):
        """
        SetupOVS Constructor
        :param config: The JSON configuration file which describes the OVS
        setup
        :param check_only: if set to true, does not apply the configuration
        and only check the JSON configuration file.
        """
        self.check_only = check_only
        self.dry_run = dry_run
        self.dpdk_interfaces = []
        self.dpdk_bridges = []
        logging.debug("Configuration file: " + config)
        if self.check_only:
            logging.debug("Check configuration file only")
        if self.dry_run:
            logging.debug("Dry-run enable")
        if os.path.isfile(config):
            with open(config, "r") as fd:
                file_content = fd.read()
                logging.debug("Configuration:\n" + file_content)
                self.json_config = json.loads(file_content)
        else:
            self.json_config = []
            logging.warning(f"Configuration file {config} not found ")

    def _run_command(self, *cmd_args, **kargs):
        """
        Shell runner helper
        Work as subproccess.run except check is set to true by default and
        stdout is not printed unless the logging level is DEBUG
        """
        logging.debug("Run command: " + " ".join(map(str, cmd_args)))
        if not self.dry_run:
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

    def check(self):
        """
        Check if the system is ready to apply an OVS configuration and also
        check the JSON configuration file.
        """
        self._configuration_check()
        if not self.check_only:
            self._system_check()

    def _system_check(self):
        """
        Check if the system is ready to apply an OVS configuration
        Raise an exception if the check failed
        """
        logging.info("Check OVS is up")
        try:
            self._run_command(
                "/usr/bin/ovs-vsctl", "show", capture_output=True
            )
        except subprocess.CalledProcessError as e:
            logging.error("OVS is not running or unavailable")
            raise e

    def _configuration_check(self):
        """
        Check the JSON configuration file and extract the DPDK interfaces from
        it. Raise an exception if the check failed
        """
        logging.info("Checking configuration")
        if type(self.json_config) != list:
            raise SetupOVSConfigException(
                "The configuration should be a bridge list"
            )
        for bridge in self.json_config:
            if type(bridge) != dict:
                raise SetupOVSConfigException("A bridge must be a dictionary")
            if "name" not in bridge:
                raise SetupOVSConfigException("Bridge without name attribute")
            logging.debug("Checking: " + bridge["name"])
            if "ports" in bridge:
                if type(bridge["ports"]) != list:
                    raise SetupOVSConfigException("ports must be a list")
                for port in bridge["ports"]:
                    if type(port) != dict:
                        raise SetupOVSConfigException(
                            "A bridge must be a dictionary"
                        )
                    self._check_port_configuration(bridge["name"], port)
            if "other_config" in bridge:
                attribute_value = (
                    [bridge["other_config"]]
                    if type(bridge["other_config"]) == str
                    else bridge["other_config"]
                )
                if type(attribute_value) != list:
                    raise SetupOVSConfigException(
                        "Bridge {}: other_config must be an string or a "
                        "strings list".format(bridge["name"])
                    )
                for element in attribute_value:
                    if type(element) != str:
                        raise SetupOVSConfigException(
                            "Bridge {}: other_config must be an string or a "
                            "strings list".format(bridge["name"])
                        )
            if "rstp_enable" in bridge and type(bridge["rstp_enable"] != bool):
                raise SetupOVSConfigException(
                    "Bridge {}: rstp_enable must be a boolean".format(
                        bridge["name"]
                    )
                )
        logging.info("Configuration check: OK")

    @staticmethod
    def _attribute_is_a_port(
        attribute_name, attribute_value, bridge_name, port_name
    ):
        if type(attribute_value) != int:
            raise SetupOVSConfigException(
                "Bridge {} Port {}: attribute {} must be an "
                "integer".format(bridge_name, port_name, attribute_name)
            )
        if attribute_value < 0 or attribute_value > 4095:
            raise SetupOVSConfigException(
                "Bridge {} Port {}: attribute {} must be in range 0 to "
                "4,095".format(bridge_name, port_name, attribute_name)
            )

    def _check_port_configuration(self, bridge_name, port):
        """
        Helper method for _configuration_check which checks the port
        configuration
        :param bridge_name: the bridge name in which the port take from
        :param port: the port configuration
        """
        self.dpdk_interfaces.clear()
        system_interfaces = []
        if "name" not in port:
            raise SetupOVSConfigException(
                "Bridge {}: Port without name attribute".format(bridge_name)
            )
        port_name = port["name"]
        logging.debug("Checking Port: " + port_name)
        if "type" not in port:
            raise SetupOVSConfigException(
                "Bridge {}: Port without type attribute".format(bridge_name)
            )
        port_type = port["type"]
        if port_type not in (
            "internal",
            "tap",
            "system",
            "dpdk",
            "dpdkvhostuserclient",
            "vxlan",
        ):
            raise SetupOVSConfigException(
                "Bridge {} Port {}: Bad type value: {}".format(
                    bridge_name, port_name, port_type
                )
            )
        if port_type in ("dpdk", "system"):
            if "interface" not in port:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: attribute interface is required with "
                    "type {}}".format(bridge_name, port_name, port_type)
                )
            interface = port["interface"]
            if port_type == "dpdk":
                # Check interface is a PCI address
                match = self.PCI_ADDRESS_MATCHER.match(interface)
                if not match:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: NIC {} is not a PCI address. Invalid "
                        "format".format(bridge_name, port_name, interface)
                    )

                # Convert the NIC PCI address in the lspci format
                match_group = match.groupdict()
                lspci_nic_address_part1 = int(match_group["part1"], 16)
                lspci_nic_address_part2 = int(match_group["part2"], 16)
                lspci_nic_address_part3 = int(match_group["part3"], 16)
                lspci_nic_address = (
                    f"{lspci_nic_address_part1:02x}:"
                    f"{lspci_nic_address_part2:02x}.{lspci_nic_address_part3:01x}"
                )
                if not self.dry_run:
                    try:
                        self._run_command(
                            "/usr/bin/lspci -mm | /bin/grep -q "
                            + lspci_nic_address,
                            shell=True,
                        )
                    except subprocess.CalledProcessError:
                        raise SetupOVSConfigException(
                            "Bridge {} Port {}: Can't found the NIC {}".format(
                                bridge_name, port_name, interface
                            )
                        )

                if interface in self.dpdk_interfaces:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: NIC {} already use in another "
                        "port".format(bridge_name, port_name, interface)
                    )
                self.dpdk_interfaces.append(interface)
                if bridge_name not in self.dpdk_bridges:
                    self.dpdk_bridges.append(bridge_name)
            else:
                if not os.path.isdir(
                    os.path.join("/proc/sys/net/ipv4/conf/", interface)
                ):
                    if self.dry_run:
                        logging.error(
                            "Bridge {} Port {}: could not found the network "
                            "interface {}".format(
                                bridge_name, port_name, interface
                            )
                        )
                    else:
                        raise SetupOVSConfigException(
                            "Bridge {} Port {}: could not found the network "
                            "interface {}".format(
                                bridge_name, port_name, interface
                            )
                        )
                if interface in system_interfaces:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: {} already use in another port".format(
                            bridge_name, port_name, interface
                        )
                    )
                system_interfaces.append(interface)
        else:
            if "interface" in port:
                logging.warning(
                    "Bridge {} Port {}: attribute interface is ignored when "
                    "type is not system nor dpdk".format(
                        bridge_name, port_name
                    )
                )
        for attribute in ("key", "remote_ip", "remote_port"):
            if port["type"] == "vxlan":
                if attribute != "remote_port" and attribute not in port:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: {} must be set if type is "
                        "vxlan".format(bridge_name, port_name, attribute)
                    )
            else:
                logging.warning(
                    "Bridge {} Port {}: attribute {} is ignored"
                    "when type is not vxlan".format(
                        bridge_name, port_name, attribute
                    )
                )
        if "vlan" in port:
            self._attribute_is_a_port(
                "tag", port["tag"], bridge_name, port_name
            )
        if "trunks" in port:
            trunks = (
                [port["trunks"]]
                if type(port["trunks"]) == int
                else port["trunks"]
            )
            if type(trunks) != list:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: attribute trunks must be an integer or"
                    " an integer list".format(bridge_name, port_name)
                )
            for trunk in trunks:
                self._attribute_is_a_port(
                    "trunks", trunk, bridge_name, port_name
                )
        if "vlan_mode" in port and port["vlan_mode"] not in (
            "access",
            "native-tagged",
            "native-untagged",
            "trunk",
        ):
            raise SetupOVSConfigException(
                "Bridge {} Port {}: Bad vlan_mode value: {}".format(
                    bridge_name, port_name, port["vlan_mode"]
                )
            )
        for attribute in (
            "ingress_policing_rate",
            "ingress_policing_burst",
        ):
            if attribute in port:
                if type(port[attribute] != int):
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: attribute {} must be an "
                        "integer".format(bridge_name, port_name, attribute)
                    )
        if "remote_port" in port:
            self._attribute_is_a_port(
                "remote_port", port["remote_port"], bridge_name, port_name
            )
        for attribute in ("key", "remote_ip", "hook_file"):
            if attribute in port:
                if type(port[attribute] != str):
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: attribute {} must be a "
                        "string".format(bridge_name, port_name, attribute)
                    )
                if (
                    attribute == "remote_ip"
                    and not self.IPv4_ADDRESS_MATCHER.match(port[attribute])
                ):
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: attribute {} must be an"
                        "IPv4".format(bridge_name, port_name, attribute)
                    )
                if attribute == "hook_file" and not os.path.isfile(
                    port["hook_file"]
                ):
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: cannot find {}".format(
                            bridge_name, port_name, attribute
                        )
                    )
        for attribute in ("other_config", "external-ids"):
            if attribute in port:
                attribute_value = (
                    [port[attribute]]
                    if type(port[attribute]) == str
                    else port[attribute]
                )
                if type(attribute_value) != list:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: attribute {} must be an string or "
                        "a string list".format(
                            bridge_name, port_name, attribute
                        )
                    )
                for element in attribute_value:
                    if type(element) != str:
                        raise SetupOVSConfigException(
                            "Bridge {} Port {}: attribute {} must be an string or "
                            "a string list".format(
                                bridge_name, port_name, attribute
                            )
                        )

    def apply(self):
        """
        Check and apply the OVS configuration
        """
        self.check()
        if not self.check_only:
            if self.dpdk_interfaces:
                logging.info("Enable IOMMU vhost")
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "set",
                    "Open_vSwitch",
                    ".",
                    "other_config:vhost-iommu-support=true",
                )
                logging.info("Enable DPDK support")
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "set",
                    "Open_vSwitch",
                    ".",
                    "other_config:dpdk-init=true",
                )
            else:
                logging.info("Disable IOMMU vhost")
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "set",
                    "Open_vSwitch",
                    ".",
                    "other_config:vhost-iommu-support=false",
                )
                logging.info("Disable DPDK support")
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "set",
                    "Open_vSwitch",
                    ".",
                    "other_config:dpdk-init=false",
                )
            logging.info("Applying configuration...")
            self._clear_ovs()
            self._bind_dpdk_interfaces()
            self._create_bridges()
            logging.info("Applying configuration: done")

    def _clear_ovs(self):
        """
        Remove all OVS bridges
        """
        list_br = []
        if not self.dry_run:
            raw_list_br = self._run_command(
                "/usr/bin/ovs-vsctl", "list-br", capture_output=True
            )
            list_br = (
                raw_list_br.stdout.decode("UTF-8").split("\n")
                if raw_list_br.stdout
                else []
            )
        for bridge in list_br:
            if bridge:
                self._run_command("/usr/bin/ovs-vsctl", "del-br", bridge)

    def _bind_dpdk_interfaces(self):
        """
        Bind NIC in DPDK
        """
        for nic in self.dpdk_interfaces:
            logging.info("Attach {} to DPDK".format(nic))
            self._run_command(
                "/usr/sbin/dpdk-devbind", "--force", "--bind=vfio-pci", nic
            )

    def _create_bridges(self):
        """
        Create bridges with their ports
        """
        for bridge in self.json_config:
            bridge_name = bridge["name"]
            logging.info("Create the DPDK bridge: " + bridge_name)
            if bridge_name in self.dpdk_bridges:
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "--",
                    "--if-exists",
                    "del-br",
                    bridge_name,
                    "--",
                    "add-br",
                    bridge_name,
                    "--",
                    "set",
                    "bridge",
                    bridge_name,
                    "datapath_type=netdev",
                )
            else:
                logging.info("Create the bridge: " + bridge_name)
                self._run_command("/usr/bin/ovs-vsctl", "add-br", bridge_name)
            if "rstp_enable" in bridge and bridge["rstp_enable"]:
                logging.info("Enabling rstp_enable on bridge: " + bridge_name)
                self._run_command(
                    "/usr/bin/ovs-vsctl",
                    "set",
                    "Bridge",
                    bridge_name,
                    "rstp_enable=true",
                )
            if "other_config" in bridge:
                logging.info("Applying other_config on bridge: " + bridge_name)
                other_configs = (
                    [bridge["other_config"]]
                    if type(bridge["other_config"]) == str
                    else bridge["other_config"]
                )
                for other_config in other_configs:
                    self._run_command(
                        "/usr/bin/ovs-vsctl",
                        "set",
                        "Bridge",
                        bridge_name,
                        "other_config=" + other_config,
                    )

            if "ports" in bridge:
                for port in bridge["ports"]:
                    port_type = port["type"]
                    port_name = (
                        port["interface"]
                        if port_type == "system"
                        else port["name"]
                    )
                    if port_type == "tap" and not os.path.isdir(
                        os.path.join("/sys/class/net/", port_name)
                    ):
                        logging.info("Create tun interface " + port_name)
                        self._run_command(
                            "/sbin/ip",
                            "tuntap",
                            "add",
                            "mode",
                            "tap",
                            "name",
                            port_name,
                        )
                    elif port_type == "system" or port_type == "dpdk":
                        logging.info(
                            "Create port: "
                            + port["name"]
                            + " on "
                            + bridge_name
                            + " and attach "
                            + port["interface"]
                            + " on it"
                        )
                    else:
                        logging.info(
                            "Create port: " + port_name + " on " + bridge_name
                        )
                    cmd_args = [
                        "/usr/bin/ovs-vsctl",
                        "--",
                        "--if-exists",
                        "del-port",
                        port_name,
                        "--",
                        "add-port",
                        bridge_name,
                        port_name,
                    ]
                    if "vlan_mode" in port:
                        cmd_args.append("vlan_mode=" + port["vlan_mode"])
                    if "tag" in port:
                        cmd_args.append("tag={}".format(port["tag"]))
                    if "trunks" in port:
                        cmd_args.append(
                            "trunks="
                            + ",".join([str(tag) for tag in port["trunks"]])
                        )
                    if port_type not in ("tap", "system"):
                        cmd_args += [
                            "--",
                            "set",
                            "Interface",
                            port_name,
                            "type=" + port_type,
                        ]
                    if port_type == "dpdk":
                        cmd_args.append(
                            "options:dpdk-devargs=" + port["interface"]
                        )
                    elif port_type == "dpdkvhostuserclient":
                        cmd_args += [
                            "--",
                            "set",
                            "Interface",
                            port_name,
                            "options:vhost-server-path=/var/run/openvswitch/"
                            "vm-sockets/dpdkvhostuser_" + port_name,
                        ]
                    elif port_type == "vxlan":
                        cmd_args += [
                            "options:remote_ip=" + port["remote_ip"],
                            "options:key=" + port["key"],
                        ]
                        if "remote_port" in port:
                            cmd_args.append(
                                "options:remote_port=" + port["remote_port"]
                            )

                    if "external-ids" in port:
                        external_ids = (
                            [port["external-ids"]]
                            if type(port["external-ids"]) == str
                            else port["external-ids"]
                        )
                        for external_id in external_ids:
                            cmd_args += [
                                "--",
                                "set",
                                "Interface",
                                port_name,
                                "external-ids:" + external_id,
                            ]
                    self._run_command(*cmd_args)
                    if "other_config" in port:
                        logging.info(
                            "Applying other_config on port {} in bridge: {}".format(
                                port_name, bridge_name
                            )
                        )
                        other_configs = (
                            [port["other_config"]]
                            if type(port["other_config"]) == str
                            else port["other_config"]
                        )
                        for other_config in other_configs:
                            self._run_command(
                                "/usr/bin/ovs-vsctl",
                                "set",
                                "Port",
                                port_name,
                                "other_config=" + other_config,
                            )
                    if "ingress_policing_rate" in port:
                        logging.info(
                            "Applying ingress policing rate on port {} in "
                            "bridge {}".format(port_name, bridge_name)
                        )
                        self._run_command(
                            "/usr/bin/ovs-vsctl",
                            "set",
                            "interface",
                            port_name,
                            "ingress_policing_rate="
                            + str(port["ingress_policing_rate"]),
                        )
                    if "ingress_policing_burst" in port:
                        logging.info(
                            "Applying ingress policing burst on port {} in "
                            "bridge {}".format(port_name, bridge_name)
                        )
                        self._run_command(
                            "/usr/bin/ovs-vsctl",
                            "set",
                            "interface",
                            port_name,
                            "ingress_policing_burst="
                            + str(port["ingress_policing_burst"]),
                        )
                    if "hook_file" in port:
                        logging.info(
                            "Call external hook "
                            + port["hook_file"]
                            + " for port "
                            + port_name
                            + " in bridge "
                            + bridge_name
                        )
                        self._run_command(
                            port["hook_file"], bridge_name, port_name
                        )
                    if port_type in ("tap", "vxlan"):
                        self._run_command(
                            "/sbin/ip", "link", "set", port_name, "up"
                        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Setup OVS bridges and ports")
    parser.add_argument(
        "-v",
        "--verbose",
        help="increase output verbosity",
        action="store_true",
        required=False,
    )
    parser.add_argument(
        "-f",
        "--file",
        help="Path to the OVS configuration JSON file",
        type=str,
        default="/etc/ovs_configuration.json",
    )
    parser.add_argument(
        "-c",
        "--check",
        help="Check only the configuration file. Do not apply the "
        "configuration",
        action="store_true",
        required=False,
    )
    parser.add_argument(
        "-d",
        "--dry-run",
        help="Do not run any command.",
        action="store_true",
        required=False,
    )
    args = parser.parse_args()
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
        logging.debug("Enable debug traces")
    else:
        logging.basicConfig(level=logging.WARNING)
    configurator = SetupOVS(
        config=args.file, check_only=args.check, dry_run=args.dry_run
    )
    configurator.apply()
