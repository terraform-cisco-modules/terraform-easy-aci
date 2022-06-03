/*_____________________________________________________________________________________________________________________

Leaf Policy Group Variables
_______________________________________________________________________________________________________________________
*/
variable "switches_leaf_policy_groups" {
  default = {
    "default" = {
      annotation                       = ""
      bfd_ipv4_policy                  = "default"
      bfd_ipv6_policy                  = "default"
      bfd_multihop_ipv4_policy         = "default"
      bfd_multihop_ipv6_policy         = "default"
      cdp_interface_policy             = "default"
      copp_leaf_policy                 = "default"
      copp_pre_filter                  = "default"
      description                      = ""
      dot1x_node_authentication_policy = "default"
      equipment_flash_config           = "default"
      fast_link_failover_policy        = "default"
      fibre_channel_node_policy        = "default"
      fibre_channel_san_policy         = "default"
      forward_scale_profile_policy     = "default"
      lldp_interface_policy            = "default"
      monitoring_policy                = "default"
      netflow_node_policy              = "default"
      poe_node_policy                  = "default"
      ptp_node_policy                  = "default"
      spanning_tree_interface_policy   = "default"
      synce_node_policy                = "default"
      usb_configuration_policy         = "default"
    }
  }
  description = <<-EOT
    key - Name of the Leaf Policy Group.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * bfd_ipv4_policy: (default: default) — The BFD IPv4 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
    * bfd_ipv6_policy: (default: default) — The BFD IPv6 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
    * bfd_multihop_ipv4_policy: (default: default) — The BFD multihop IPv4 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv4 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
    * bfd_multihop_ipv6_policy: (default: default) — The BFD multihop IPv6 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv6 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
    * cdp_interface_policy: (default: default) — The CDP policy name.  CDP is used to obtain protocol addresses of neighboring devices and discover those devices. CDP is also be used to display information about the interfaces connecting to the neighboring devices. CDP is media- and protocol-independent, and runs on all Cisco-manufactured equipments including routers, bridges, access servers, and switches.
    * copp_leaf_policy: (default: default) — The leaf CoPP policy name.  Control Plane Policing (CoPP) protects the control plane, which ensures network stability, reachability, and packet delivery.
    * copp_pre_filter: (default: default) — The CoPP Pre-Filter name.  A CoPP prefilter profile is used on spine and leaf switches to filter access to authentication services based on specified sources and TCP ports to protect against DDoS attacks. When deployed on a switch, control plane traffic is denied by default. Only the traffic specified in the CoPP prefilter profile is permitted.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * dot1x_node_authentication_policy: (default: default) — The 802.1x node authentication policy name.  An 802.1x node authorization policy is a client and server-based access control and authentication protocol that restricts unauthorized clients from connecting to a LAN through publicly accessible ports.
    * equipment_flash_config: (default: default) — Flash Configuration Policy.
    * fast_link_failover_policy: (default: default) — The fast link failover policy name.  A fast link failover policy provides better convergence of the network.  Fast link failover policies are not supported on the same port as port profiles or remote leaf switch connections.
    * fibre_channel_node_policy: (default: default) — The default Fibre Channel node policy name.  Fibre channel node policies specify FCoE-related settings, such as the load balance options and FIP keep alive intervals. 
    * fibre_channel_san_policy: (default: default) — The Fibre Channel SAN policy name.  Fibre Channel SAN policies specify FCoE-related settings: Error detect timeout values (EDTOV), resource allocation timeout values (RATOV), and the MAC address prefix (also called FC map) used by the leaf switch. Typically the default value 0E:FC:00 is used. 
    * forward_scale_profile_policy: (default: default) — The forwarding scale profile policy name.  The forwarding scale profile policy provides different scalability options. The scaling types are:
      - Dual Stack — Provides scalability of up to 12,000 endpoints for IPv6 configurations and up to 24,000 endpoints for IPv4 configurations.
      - High LPM — Provides scalability similar to the dual-stack policy, except that the longest prefix match (LPM) scale is 128,000 and the policy scale is 8,000.
      - IPv4 Scale — Enables systems with no IPv6 configurations to increase scalability to 48,000 IPv4 endpoints.
      - High Dual Stack — Provides scalability of up to 64,000 MAC endpoints, 64,000 IPv4 endpoints, and 24,000 IPv6 endpoints.
      For more information about this feature, see the Cisco APIC Forwarding Scale Profiles document.
    * lldp_interface_policy: (default: default) — The LLDP policy name.  LLDP uses the logical link control (LLC) services to transmit and receive information to and from other LLDP agents.
    * monitoring_policy: (default: default) — The monitoring policy name.  Monitoring policies can include policies such as event/fault severity or the fault lifecycle. 
    * netflow_node_policy: (default: default) — The NetFlow node policy name.  The node-level policy deploys two different NetFlow timers that specify the rate at which flow records are sent to the external collector.
    * poe_node_policy: (default: default) — The PoE node policy name.  PoE node policies control the overall power setting for the switch.
    * ptp_node_policy: (default: default) — The PTP node policy name.  The Precision Time Protocol (PTP) synchronizes distributed clocks in a system using Ethernet networks.
    * spanning_tree_interface_policy: (default: default) — The spanning tree policy name.  A spanning tree protocol (STP) policy prevents loops caused by redundant paths in your network.
    * synce_node_policy: (default: default) — The SyncE Node policy name.  Synchronous Ethernet (SyncE) provides high-quality clock synchronization over Ethernet ports by using known common precision frequency references.
    * usb_configuration_policy: (default: default) — The USB configuration policy name.  The USB configuration policy can disable the USB port on a Cisco ACI-mode switch to prevent someone booting the switch from a USB image that contains malicious code.
  EOT
  type = map(object(
    {
      annotation                       = optional(string)
      bfd_ipv4_policy                  = optional(string)
      bfd_ipv6_policy                  = optional(string)
      bfd_multihop_ipv4_policy         = optional(string)
      bfd_multihop_ipv6_policy         = optional(string)
      cdp_interface_policy             = optional(string)
      copp_leaf_policy                 = optional(string)
      copp_pre_filter                  = optional(string)
      description                      = optional(string)
      dot1x_node_authentication_policy = optional(string)
      equipment_flash_config           = optional(string)
      fast_link_failover_policy        = optional(string)
      fibre_channel_node_policy        = optional(string)
      fibre_channel_san_policy         = optional(string)
      forward_scale_profile_policy     = optional(string)
      lldp_interface_policy            = optional(string)
      monitoring_policy                = optional(string)
      netflow_node_policy              = optional(string)
      poe_node_policy                  = optional(string)
      ptp_node_policy                  = optional(string)
      spanning_tree_interface_policy   = optional(string)
      synce_node_policy                = optional(string)
      usb_configuration_policy         = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccNodePGrp"
 - Distinguished Name: "uni/infra/funcprof/accnodepgrp-{name}"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Policy Groups: {name}

802.1x Node Authentication Policy
 - Class: "l2NodeAuthPol"
 - Distinguished Name: "uni/infra/nodeauthpol-{dot1x_authentication_policy}"
BFD IPv4 Policy
 - Class: "bfdIpv4InstPol"
 - Distinguished Name: "uni/infra/bfdIpv4Inst-{bfd_ipv4_policy}"
BFD IPv6 Policy
 - Class: "bfdIpv6InstPol"
 - Distinguished Name: "uni/infra/bfdIpv6Inst-{bfd_ipv6_policy}"
BFD Multihop IPv4 Policy
 - Class: "bfdMhIpv4InstPol"
 - Distinguished Name: "uni/infra/bfdMhIpv4Inst-{bfd_multihop_ipv4_policy}"
BFD Multihop IPv6 Policy
 - Class: "bfdMhIpv6InstPol"
 - Distinguished Name: "uni/infra/bfdMhIpv6Inst-{bfd_multihop_ipv6_policy}"
CDP Policy
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{cdp_interface_policy}"
CoPP Leaf Policy
 - Class: "coppLeafProfile"
 - Distinguished Name: "uni/infra/coppleafp-{copp_leaf_policy}"
CoPP Pre-Filter
 - Class: "iaclLeafProfile"
 - Distinguished Name: "uni/infra/iaclleafp-{copp_pre_filter}"
Equipment Flash Config
 - Class: "equipmentFlashConfigPol"
 - Distinguished Name: "uni/infra/flashconfigpol-{equipment_flash_config}"
Fast Link Failover Policy
 - Class: "topoctrlFastLinkFailoverInstPol"
 - Distinguished Name: "uni/infra/fastlinkfailoverinstpol-{fast_link_failover_policy}"
Fibre Channel SAN Policy
 - Class: "fcFabricPol"
 - Distinguished Name: "uni/infra/fcfabricpol-{fibre_channel_san_policy}"
Fibre Channel Node Policy
 - Class: "fcInstPol"
 - Distinguished Name: "uni/infra/fcinstpol-{fibre_channel_node_policy}"
Forward Scale Profile Policy
 - Class: "topoctrlFwdScaleProfilePol"
 - Distinguished Name: "uni/infra/fwdscalepol-{forward_scale_profile_policy}"
LLDP Policy
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{lldp_interface_policy}"
Monitoring Policy
 - Class: "monInfraPol"
 - Distinguished Name: "uni/infra/moninfra-{monitoring_policy}"
Netflow Node Policy
 - Class: "netflowNodePol"
 - Distinguished Name: "uni/infra/nodepol-{netflow_node_policy}"
PoE Node Policy
 - Class: "poeInstPol"
 - Distinguished Name: "uni/infra/poeInstP-{poe_node_policy}"
Spanning Tree Policy (MSTP)
 - Class: "stpInstPol"
 - Distinguished Name: "uni/infra/mstpInstPol-{spanning_tree_policy}"
_______________________________________________________________________________________________________________________
*/
resource "aci_access_switch_policy_group" "switches_leaf_policy_groups" {
  for_each    = local.switches_leaf_policy_groups
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  # class: bfdIpv4InstPol
  relation_infra_rs_bfd_ipv4_inst_pol = length(compact([each.value.bfd_ipv4_policy])
  ) > 0 ? "uni/infra/bfdIpv4Inst-${each.value.bfd_ipv4_policy}" : ""
  # class: bfdIpv6InstPol
  relation_infra_rs_bfd_ipv6_inst_pol = length(compact([each.value.bfd_ipv6_policy])
  ) > 0 ? "uni/infra/bfdIpv6Inst-${each.value.bfd_ipv6_policy}" : ""
  # class: bfdMhIpv4InstPol
  relation_infra_rs_bfd_mh_ipv4_inst_pol = length(regexall(
    "^5", var.apic_version)) > 0 && length(compact([each.value.bfd_multihop_ipv4_policy])
  ) > 0 ? "uni/infra/bfdMhIpv4Inst-${each.value.bfd_multihop_ipv4_policy}" : ""
  # class: bfdMhIpv6InstPol
  relation_infra_rs_bfd_mh_ipv6_inst_pol = length(regexall(
    "^5", var.apic_version)) > 0 && length(compact([each.value.bfd_multihop_ipv6_policy])
  ) > 0 ? "uni/infra/bfdMhIpv6Inst-${each.value.bfd_multihop_ipv6_policy}" : ""
  # class: equipmentFlashConfigPol
  relation_infra_rs_equipment_flash_config_pol = length(compact([each.value.equipment_flash_config])
  ) > 0 ? "uni/infra/flashconfigpol-${each.value.equipment_flash_config}" : ""
  # class: fcFabricPol
  relation_infra_rs_fc_fabric_pol = length(compact([each.value.fibre_channel_san_policy])
  ) > 0 ? "uni/infra/fcfabricpol-${each.value.fibre_channel_san_policy}" : ""
  # class: fcInstPol
  relation_infra_rs_fc_inst_pol = length(compact([each.value.fibre_channel_node_policy])
  ) > 0 ? "uni/infra/fcinstpol-${each.value.fibre_channel_node_policy}" : ""
  # class: iaclLeafProfile
  relation_infra_rs_iacl_leaf_profile = length(compact([each.value.copp_pre_filter])
  ) > 0 ? "uni/infra/iaclleafp-${each.value.copp_pre_filter}" : ""
  # class: l2NodeAuthPol
  relation_infra_rs_l2_node_auth_pol = length(compact([each.value.dot1x_node_authentication_policy])
  ) > 0 ? "uni/infra/nodeauthpol-${each.value.dot1x_node_authentication_policy}" : ""
  # class: coppLeafProfile
  relation_infra_rs_leaf_copp_profile = length(compact([each.value.copp_leaf_policy])
  ) > 0 ? "uni/infra/coppleafp-${each.value.copp_leaf_policy}" : ""
  # class: cdpIfPol
  relation_infra_rs_leaf_p_grp_to_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: lldpIfPol
  relation_infra_rs_leaf_p_grp_to_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  # class: monInfraPol
  relation_infra_rs_mon_node_infra_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # class: stpInstPol
  relation_infra_rs_mst_inst_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/mstpInstPol-${each.value.spanning_tree_interface_policy}" : ""
  # class: netflowNodePol
  relation_infra_rs_netflow_node_pol = length(compact([each.value.netflow_node_policy])
  ) > 0 ? "uni/infra/nodepol-${each.value.netflow_node_policy}" : ""
  # class: poeInstPol
  relation_infra_rs_poe_inst_pol = length(compact([each.value.poe_node_policy])
  ) > 0 ? "uni/infra/poeInstP-${each.value.poe_node_policy}" : ""
  # class: topoctrlFastLinkFailoverInstPol
  relation_infra_rs_topoctrl_fast_link_failover_inst_pol = length(compact([each.value.fast_link_failover_policy])
  ) > 0 ? "uni/infra/fastlinkfailoverinstpol-${each.value.fast_link_failover_policy}" : ""
  # class: topoctrlFwdScaleProfilePol
  relation_infra_rs_topoctrl_fwd_scale_prof_pol = length(compact([each.value.forward_scale_profile_policy])
  ) > 0 ? "uni/infra/fwdscalepol-${each.value.forward_scale_profile_policy}" : ""
}
