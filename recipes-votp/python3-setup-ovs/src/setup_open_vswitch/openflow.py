# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0

import logging
from . import helpers


class SetupOpenFlow:
    """
    Apply OpenFlow rules to harden the open vSwich configuration
    """

    def __init__(self, config):
        """
        SetupOpenFlow constructor
        :param config: the configuration which describes the OVS setup
        """
        for bridge in config:
            self.configure_bridge_flow(bridge)

    @classmethod
    def configure_bridge_flow(cls, bridge):
        """
        Apply the OpenFlow rules to a bridge
        :param bridge: the bridge in which the openflow rules will be added
        """
        bridge_name = bridge["name"]
        logging.info(f"Apply openFlow filters for bridge: {bridge_name}")
        if "ports" in bridge:
            # Clear default filters
            helpers.run_command("ovs-ofctl", "del-flows", bridge_name)
            for port in bridge["ports"]:
                if (
                    port["type"] in ("tap", "dpdkvhostuserclient")
                    and "mac" in port
                    and port["mac"]
                    and "ip" in port
                    and port["ip"]
                ):
                    cls.configure_port_flow(bridge_name, port)
            if "enable_ipv6" in bridge and bridge["enable_ipv6"]:
                logging.warning(
                    "Force enabling IPv6."
                    "Warning: there is no rules to secure IPv6"
                )
                ipv6_action = "normal"
            else:
                ipv6_action = "drop"
            cls.add_flow(bridge_name, 0, 1, ipv6_action, "ipv6")
            cls.add_flow(bridge_name, 1, 1, ipv6_action, "ipv6")
            # Default rules we allow everything
            cls.add_flow(bridge_name, 0, 0, "normal", "")

    @classmethod
    def configure_port_flow(cls, bridge_name, port):
        """
        Apply the OpenFlow rules to a bridge port
        :param bridge_name: the port bridge name
        :param port: the bridge port in which the openflow rules will be added
        """

        # Table 0
        port_name = port["name"]
        mac = port["mac"]
        ips = port["ip"] if type(port["ip"]) == list else [port["ip"]]
        # Protect against Mac spoofing
        # Only allow packets with the port mac address
        cls.add_flow(
            bridge_name,
            0,
            40,
            "goto_table:1",
            f"dl_src={mac}",
            port=port_name,
        )
        # Drop other packets
        cls.add_flow(bridge_name, 0, 39, "drop", "", port=port_name)

        # Table 1
        # By default drop all ingress packets
        cls.add_flow(
            bridge_name,
            1,
            0,
            "drop",
            "",
            port=port_name,
        )
        # Allow only IP packets with correct source IPs to ingress
        priority = 20
        for ip in ips:
            cls.add_flow(
                bridge_name,
                1,
                priority,
                "normal",
                f"ip nw_src={ip}",
                port=port_name,
            )
            priority += 1

        # Respond to ARP request only with correct IPs
        cls.add_flow(
            bridge_name,
            1,
            priority,
            "drop",
            f"arp arp_sha={mac}",
            port=port_name,
        )
        priority += 1
        for ip in ips:
            cls.add_flow(
                bridge_name,
                1,
                priority,
                "normal",
                f"arp arp_sha={mac} arp_spa={ip}",
                port=port_name,
            )
            priority += 1

        # Drop DHCP packets
        cls.add_flow(
            bridge_name,
            1,
            priority,
            "drop",
            "udp udp_src=67",
            port=port_name,
        )
        priority += 1

    @staticmethod
    def add_flow(bridge_name, table, priority, action, rule, port=None):
        """
        Add an openFlow rule to a bridge
        :param bridge_name: The bridge where the rule will be applied
        :param table: the table where the rule will be inserted
        :param priority: the rule priority
        :param action: the action to performed if the rule matches
        :param rule: the rule
        :param port: option input port
        """
        in_port = f"in_port={port} " if port else ""
        helpers.run_command(
            "ovs-ofctl",
            "add-flow",
            bridge_name,
            f"table={table} {in_port} {rule} "
            f"priority={priority} action={action}",
        )
