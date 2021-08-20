# Copyright (C) 2021, RTE (http://www.rte-france.com)
# SPDX-License-Identifier: Apache-2.0


import logging
import os

from . import helpers


def setup_ovs(config):
    """
    Apply the OVS configuration
    """
    dpdk_interfaces = []
    dpdk_bridges = []
    logging.info("Applying configuration...")
    for bridge in config:
        if "ports" in bridge:
            for port in bridge["ports"]:
                if port["type"] == "dpdk":
                    dpdk_interfaces.append(port["interface"])
                    if bridge["name"] not in dpdk_bridges:
                        dpdk_bridges.append(bridge["name"])
    if dpdk_interfaces:
        logging.info("Enable IOMMU vhost")
        helpers.run_command(
            "/usr/bin/ovs-vsctl",
            "set",
            "Open_vSwitch",
            ".",
            "other_config:vhost-iommu-support=true",
        )
        logging.info("Enable DPDK support")
        helpers.run_command(
            "/usr/bin/ovs-vsctl",
            "set",
            "Open_vSwitch",
            ".",
            "other_config:dpdk-init=true",
        )
    else:
        logging.info("Disable IOMMU vhost")
        helpers.run_command(
            "/usr/bin/ovs-vsctl",
            "set",
            "Open_vSwitch",
            ".",
            "other_config:vhost-iommu-support=false",
        )
        logging.info("Disable DPDK support")
        helpers.run_command(
            "/usr/bin/ovs-vsctl",
            "set",
            "Open_vSwitch",
            ".",
            "other_config:dpdk-init=false",
        )
    _bind_dpdk_interfaces(dpdk_interfaces)
    _create_bridges(config, dpdk_bridges)

    logging.info("Applying configuration: done")


def clear_ovs():
    """
    Remove all OVS bridges
    """
    list_br = []
    if not helpers.dry_run:
        raw_list_br = helpers.run_command(
            "/usr/bin/ovs-vsctl", "list-br", capture_output=True
        )
        list_br = (
            raw_list_br.stdout.decode("UTF-8").split("\n")
            if raw_list_br.stdout
            else []
        )
    for bridge in list_br:
        if bridge:
            helpers.run_command("/usr/bin/ovs-vsctl", "del-br", bridge)


def clear_tap():
    """
    Remove all tap interfaces.
    Warnings:
      - clear_tap will fail if tap interfaces are used.
        To avoid errors stop all the VMs and call clear_ovs() before.
    """

    for interface in os.listdir("/sys/class/net"):
        if os.path.isfile(
            os.path.join("/sys/class/net", interface, "tun_flags")
        ):
            helpers.run_command(
                "/sbin/ip",
                "tuntap",
                "del",
                "mode",
                "tap",
                "name",
                interface,
            )


def _bind_dpdk_interfaces(dpdk_interfaces):
    """
    Bind NIC in DPDK
    """
    for nic in dpdk_interfaces:
        logging.info("Attach {} to DPDK".format(nic))
        helpers.run_command(
            "/usr/sbin/dpdk-devbind", "--force", "--bind=vfio-pci", nic
        )


def _create_bridges(config, dpdk_bridges):
    """
    Create bridges with their ports
    """
    for bridge in config:
        bridge_name = bridge["name"]
        logging.info("Create the DPDK bridge: " + bridge_name)
        if bridge_name in dpdk_bridges:
            helpers.run_command(
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
            helpers.run_command("/usr/bin/ovs-vsctl", "add-br", bridge_name)
        if "rstp_enable" in bridge and bridge["rstp_enable"]:
            logging.info("Enabling rstp_enable on bridge: " + bridge_name)
            helpers.run_command(
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
                helpers.run_command(
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
                    helpers.run_command(
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
                helpers.run_command(*cmd_args)
                if "other_config" in port:
                    logging.info(
                        "Applying other_config on port {} in bridge:"
                        " {}".format(port_name, bridge_name)
                    )
                    other_configs = (
                        [port["other_config"]]
                        if type(port["other_config"]) == str
                        else port["other_config"]
                    )
                    for other_config in other_configs:
                        helpers.run_command(
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
                    helpers.run_command(
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
                    helpers.run_command(
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
                    helpers.run_command(
                        port["hook_file"], bridge_name, port_name
                    )
                if port_type == "tap":
                    helpers.run_command(
                        "/sbin/ip", "link", "set", port_name, "up"
                    )
