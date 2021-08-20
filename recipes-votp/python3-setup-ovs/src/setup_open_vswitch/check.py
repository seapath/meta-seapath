# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

import logging
import subprocess
import os
from . import helpers
from .setup_ovs_exception import SetupOVSConfigException


def system_check():
    """
    Check if the system is ready to apply an OVS configuration
    Raise an exception if the check failed
    """
    logging.info("Check OVS is up")
    try:
        helpers.run_command("/usr/bin/ovs-vsctl", "show", capture_output=True)
    except subprocess.CalledProcessError as e:
        logging.error("OVS is not running or unavailable")
        raise e


def configuration_check(config):
    """
    Check the JSON configuration file and extract the DPDK interfaces from
    it. Raise an exception if the check failed
    :param config: The configuration which describes the OVS setup
    """
    logging.info("Checking configuration")
    if type(config) != list:
        raise SetupOVSConfigException(
            "The configuration should be a bridge list"
        )
    for bridge in config:
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
                        "A port must be a dictionary"
                    )
                _check_port_configuration(bridge["name"], port)
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
        for attribute in ("rstp_enable", "enable_ipv6"):
            if attribute in bridge and type(bridge[attribute]) != bool:
                raise SetupOVSConfigException(
                    "Bridge {}: {} must be a boolean".format(
                        bridge["name"], attribute
                    )
                )
    logging.info("Configuration check: OK")


def _attribute_is_a_port(
    attribute_name, attribute_value, bridge_name, port_name
):
    """
    Check if an attribute is a TCP or UDP port
    :param attribute_name: The attribute name
    :param attribute_value: The attribute value
    :param bridge_name: The attribute bridge name
    :param port_name: The attribute port name
    """
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


def _attribute_is_an_ipv4(
    attribute_name, attribute_value, bridge_name, port_name
):
    """
    Check if an attribute is an IPv4 address
    :param attribute_name: The attribute name
    :param attribute_value: The attribute value
    :param bridge_name: The attribute bridge name
    :param port_name: The attribute port name
    """
    if type(attribute_value) != str or not helpers.IPv4_ADDRESS_MATCHER.match(
        attribute_value
    ):
        raise SetupOVSConfigException(
            "Bridge {} Port {}: attribute {} must be an"
            " IPv4 address".format(bridge_name, port_name, attribute_name)
        )


def _attribute_is_a_mac(
    attribute_name, attribute_value, bridge_name, port_name
):
    """
    Check if an attribute is a MAC address
    :param attribute_name: The attribute name
    :param attribute_value: The attribute value
    :param bridge_name: The attribute bridge name
    :param port_name: The attribute port name
    """
    if type(attribute_value) != str or not helpers.MAC_ADDRESS_MATCHER.match(
        attribute_value
    ):
        raise SetupOVSConfigException(
            "Bridge {} Port {}: attribute {} must be an"
            ' MAC address, in lower case with ":" as separator'.format(
                bridge_name, port_name, attribute_name
            )
        )


def _check_port_configuration(bridge_name, port):
    """
    Helper method for _configuration_check which checks the port
    configuration
    :param bridge_name: the bridge name in which the port take from
    :param port: the port configuration
    """
    dpdk_interfaces = []
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
            match = helpers.PCI_ADDRESS_MATCHER.match(interface)
            if not match:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: NIC {} is not a PCI address."
                    " Invalid format".format(bridge_name, port_name, interface)
                )

            # Convert the NIC PCI address in the lspci format
            match_group = match.groupdict()
            lspci_nic_address_part1 = int(match_group["part1"], 16)
            lspci_nic_address_part2 = int(match_group["part2"], 16)
            lspci_nic_address_part3 = int(match_group["part3"], 16)
            lspci_nic_address = (
                f"{lspci_nic_address_part1:02x}:"
                f"{lspci_nic_address_part2:02x}."
                f"{lspci_nic_address_part3:01x}"
            )
            if not helpers.dry_run:
                try:
                    helpers.run_command(
                        "/usr/bin/lspci -mm | /bin/grep -q "
                        + lspci_nic_address,
                        shell=True,
                    )
                except subprocess.CalledProcessError:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: Can't find the NIC {}".format(
                            bridge_name, port_name, interface
                        )
                    )

            if interface in dpdk_interfaces:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: NIC {} already used in another "
                    "port".format(bridge_name, port_name, interface)
                )
            dpdk_interfaces.append(interface)
        else:
            if not os.path.isdir(
                os.path.join("/proc/sys/net/ipv4/conf/", interface)
            ):
                if helpers.dry_run:
                    logging.error(
                        "Bridge {} Port {}: could not find the network "
                        "interface {}".format(
                            bridge_name, port_name, interface
                        )
                    )
                else:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: could not find the network "
                        "interface {}".format(
                            bridge_name, port_name, interface
                        )
                    )
            if interface in system_interfaces:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: {} already used in another"
                    " port".format(bridge_name, port_name, interface)
                )
            system_interfaces.append(interface)
    else:
        if "interface" in port:
            logging.warning(
                "Bridge {} Port {}: attribute interface is ignored when "
                " type is not system nor dpdk".format(bridge_name, port_name)
            )
    for attribute in ("key", "remote_ip", "remote_port"):
        if attribute in port:
            if port["type"] == "vxlan":
                if attribute != "remote_port" and attribute not in port:
                    raise SetupOVSConfigException(
                        "Bridge {} Port {}: {} must be set if type is "
                        "vxlan".format(bridge_name, port_name, attribute)
                    )
            else:
                logging.warning(
                    "Bridge {} Port {}: attribute {} is ignored"
                    " when type is not vxlan".format(
                        bridge_name, port_name, attribute
                    )
                )
    if "vlan" in port:
        _attribute_is_a_port("tag", port["tag"], bridge_name, port_name)
    if "trunks" in port:
        trunks = (
            [port["trunks"]] if type(port["trunks"]) == int else port["trunks"]
        )
        if type(trunks) != list:
            raise SetupOVSConfigException(
                "Bridge {} Port {}: attribute trunks must be an integer or"
                " an integer list".format(bridge_name, port_name)
            )
        for trunk in trunks:
            _attribute_is_a_port("trunks", trunk, bridge_name, port_name)
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
        _attribute_is_a_port(
            "remote_port", port["remote_port"], bridge_name, port_name
        )
    for attribute in ("key", "remote_ip", "hook_file"):
        if attribute in port:
            if type(port[attribute]) != str:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: attribute {} must be a "
                    "string".format(bridge_name, port_name, attribute)
                )
            if attribute == "remote_ip":
                _attribute_is_an_ipv4(
                    attribute, port[attribute], bridge_name, port_name
                )
    for attribute in ("other_config", "ip"):
        if attribute in port:
            attribute_value = (
                [port[attribute]]
                if type(port[attribute]) == str
                else port[attribute]
            )
            if type(attribute_value) != list:
                raise SetupOVSConfigException(
                    "Bridge {} Port {}: attribute {} must be a string or "
                    "a string list".format(bridge_name, port_name, attribute)
                )
            for element in attribute_value:
                if attribute == "other_config":
                    if type(element) != str:
                        raise SetupOVSConfigException(
                            "Bridge {} Port {}: attribute {} must be a string"
                            " or a string list".format(
                                bridge_name, port_name, attribute
                            )
                        )
                else:
                    _attribute_is_an_ipv4(
                        attribute, element, bridge_name, port_name
                    )
                    if port["type"] not in ("tap", "dpdkvhostuserclient"):
                        raise SetupOVSConfigException(
                            "Bridge {} Port {}: attribute {} only works if"
                            " interface is tap or"
                            " dpdkvhostuserclient".format(
                                bridge_name, port_name, attribute
                            )
                        )
    if "mac" in port:
        _attribute_is_a_mac("mac", port["mac"], bridge_name, port_name)
        if port["type"] not in ("tap", "dpdkvhostuserclient"):
            raise SetupOVSConfigException(
                "Bridge {} Port {}: attribute mac only works if"
                " interface is tap or"
                " dpdkvhostuserclient".format(
                    bridge_name, port_name, attribute
                )
            )
