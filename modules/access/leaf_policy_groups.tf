/*_____________________________________________________________________________________________________________________

Leaf Policy Group Variables
_______________________________________________________________________________________________________________________
*/
variable "leaf_policy_groups" {
  default = {
    "default" = {
      alias                          = ""
      bfd_ipv4_policy                = "default"
      bfd_ipv6_policy                = "default"
      bfd_multihop_ipv4_policy       = "default"
      bfd_multihop_ipv6_policy       = "default"
      cdp_policy                     = "default"
      copp_leaf_policy               = "default"
      copp_pre_filter                = "default"
      description                    = ""
      dot1x_authentication_policy    = "default"
      equipment_flash_config         = "default"
      fast_link_failover_policy      = "default"
      fibre_channel_node_policy      = "default"
      fibre_channel_san_policy       = "default"
      forward_scale_profile_policy   = "default"
      lldp_policy                    = "default"
      monitoring_policy              = "default"
      netflow_node_policy            = "default"
      ptp_node_policy                = "default"
      poe_node_policy                = "default"
      spanning_tree_interface_policy = "default"
      synce_node_policy              = "default"
      tags                           = ""
      usb_configuration_policy       = "default"
    }
  }
  description = <<-EOT
  key - Name of the Leaf Policy Group.
    * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    * bfd_ipv4_policy: The BFD IPv4 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
    * bfd_ipv6_policy: The BFD IPv6 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
    * bfd_multihop_ipv4_policy: The BFD multihop IPv4 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv4 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
    * bfd_multihop_ipv6_policy: The BFD multihop IPv6 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv6 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
    * cdp_policy: The CDP policy name.  CDP is used to obtain protocol addresses of neighboring devices and discover those devices. CDP is also be used to display information about the interfaces connecting to the neighboring devices. CDP is media- and protocol-independent, and runs on all Cisco-manufactured equipments including routers, bridges, access servers, and switches.
    * copp_leaf_policy: The leaf CoPP policy name.  Control Plane Policing (CoPP) protects the control plane, which ensures network stability, reachability, and packet delivery.
    * copp_pre_filter: The CoPP Pre-Filter name.  A CoPP prefilter profile is used on spine and leaf switches to filter access to authentication services based on specified sources and TCP ports to protect against DDoS attacks. When deployed on a switch, control plane traffic is denied by default. Only the traffic specified in the CoPP prefilter profile is permitted.
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    * dot1x_authentication_policy: The 802.1x node authentication policy name.  An 802.1x node authorization policy is a client and server-based access control and authentication protocol that restricts unauthorized clients from connecting to a LAN through publicly accessible ports.
    * equipment_flash_config: Flash Configuration Policy.
    * fast_link_failover_policy: The fast link failover policy name.  A fast link failover policy provides better convergence of the network.  Fast link failover policies are not supported on the same port as port profiles or remote leaf switch connections.
    * fibre_channel_node_policy: The default Fibre Channel node policy name.  Fibre channel node policies specify FCoE-related settings, such as the load balance options and FIP keep alive intervals. 
    * fibre_channel_san_policy: The Fibre Channel SAN policy name.  Fibre Channel SAN policies specify FCoE-related settings: Error detect timeout values (EDTOV), resource allocation timeout values (RATOV), and the MAC address prefix (also called FC map) used by the leaf switch. Typically the default value 0E:FC:00 is used. 
    * forward_scale_profile_policy: The forwarding scale profile policy name.  The forwarding scale profile policy provides different scalability options. The scaling types are:
      - Dual Stack: Provides scalability of up to 12,000 endpoints for IPv6 configurations and up to 24,000 endpoints for IPv4 configurations.
      - High LPM: Provides scalability similar to the dual-stack policy, except that the longest prefix match (LPM) scale is 128,000 and the policy scale is 8,000.
      - IPv4 Scale: Enables systems with no IPv6 configurations to increase scalability to 48,000 IPv4 endpoints.
      - High Dual Stack: Provides scalability of up to 64,000 MAC endpoints, 64,000 IPv4 endpoints, and 24,000 IPv6 endpoints.
      For more information about this feature, see the Cisco APIC Forwarding Scale Profiles document.
    * lldp_policy: The LLDP policy name.  LLDP uses the logical link control (LLC) services to transmit and receive information to and from other LLDP agents.
    * monitoring_policy: The monitoring policy name.  Monitoring policies can include policies such as event/fault severity or the fault lifecycle. 
    * netflow_node_policy: The NetFlow node policy name.  The node-level policy deploys two different NetFlow timers that specify the rate at which flow records are sent to the external collector.
    * ptp_node_policy: The PTP node policy name.  The Precision Time Protocol (PTP) synchronizes distributed clocks in a system using Ethernet networks.
    * poe_node_policy: The PoE node policy name.  PoE node policies control the overall power setting for the switch.
    * spanning_tree_interface_policy: The spanning tree policy name.  A spanning tree protocol (STP) policy prevents loops caused by redundant paths in your network.
    * synce_node_policy: The SyncE Node policy name.  Synchronous Ethernet (SyncE) provides high-quality clock synchronization over Ethernet ports by using known common precision frequency references.
    * tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
    * usb_configuration_policy: The USB configuration policy name.  The USB configuration policy can disable the USB port on a Cisco ACI-mode switch to prevent someone booting the switch from a USB image that contains malicious code.
  EOT
  type = map(object(
    {
      alias                          = optional(string)
      bfd_ipv4_policy                = optional(string)
      bfd_ipv6_policy                = optional(string)
      bfd_multihop_ipv4_policy       = optional(string)
      bfd_multihop_ipv6_policy       = optional(string)
      cdp_policy                     = optional(string)
      copp_leaf_policy               = optional(string)
      copp_pre_filter                = optional(string)
      description                    = optional(string)
      dot1x_authentication_policy    = optional(string)
      equipment_flash_config         = optional(string)
      fast_link_failover_policy      = optional(string)
      fibre_channel_node_policy      = optional(string)
      fibre_channel_san_policy       = optional(string)
      forward_scale_profile_policy   = optional(string)
      lldp_policy                    = optional(string)
      monitoring_policy              = optional(string)
      netflow_node_policy            = optional(string)
      ptp_node_policy                = optional(string)
      poe_node_policy                = optional(string)
      spanning_tree_interface_policy = optional(string)
      synce_node_policy              = optional(string)
      tags                           = optional(string)
      usb_configuration_policy       = optional(string)
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
 - Distinguished Name: "uni/infra/cdpIfP-{cdp_policy}"
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
 - Distinguished Name: "uni/infra/lldpIfP-{lldp_policy}"
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
resource "aci_access_switch_policy_group" "leaf_policy_groups" {
  depends_on = [
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_lldp_interface_policy.lldp_interface_policies,
  ]
  for_each                                               = local.leaf_policy_groups
  annotation                                             = each.value.tags
  description                                            = each.value.description
  name                                                   = each.key
  name_alias                                             = each.value.alias
  relation_infra_rs_bfd_ipv4_inst_pol                    = "uni/infra/bfdIpv4Inst-${each.value.bfd_ipv4_policy}"
  relation_infra_rs_bfd_ipv6_inst_pol                    = "uni/infra/bfdIpv6Inst-${each.value.bfd_ipv6_policy}"
  relation_infra_rs_bfd_mh_ipv4_inst_pol                 = var.apic_version > 4 ? "uni/infra/bfdMhIpv4Inst-${each.value.bfd_multihop_ipv4_policy}" : ""
  relation_infra_rs_bfd_mh_ipv6_inst_pol                 = var.apic_version > 4 ? "uni/infra/bfdMhIpv6Inst-${each.value.bfd_multihop_ipv6_policy}" : ""
  relation_infra_rs_equipment_flash_config_pol           = "uni/infra/flashconfigpol-${each.value.equipment_flash_config}"
  relation_infra_rs_fc_fabric_pol                        = "uni/infra/fcfabricpol-${each.value.fibre_channel_san_policy}"
  relation_infra_rs_fc_inst_pol                          = "uni/infra/fcinstpol-${each.value.fibre_channel_node_policy}"
  relation_infra_rs_iacl_leaf_profile                    = "uni/infra/iaclleafp-${each.value.copp_pre_filter}"
  relation_infra_rs_l2_node_auth_pol                     = "uni/infra/nodeauthpol-${each.value.dot1x_authentication_policy}"
  relation_infra_rs_leaf_copp_profile                    = "uni/infra/coppleafp-${each.value.copp_leaf_policy}"
  relation_infra_rs_leaf_p_grp_to_cdp_if_pol             = aci_cdp_interface_policy.cdp_interface_policies[each.value.cdp_policy].id
  relation_infra_rs_leaf_p_grp_to_lldp_if_pol            = aci_lldp_interface_policy.lldp_interface_policies[each.value.lldp_policy].id
  relation_infra_rs_mon_node_infra_pol                   = "uni/infra/moninfra-${each.value.monitoring_policy}"
  relation_infra_rs_mst_inst_pol                         = "uni/infra/mstpInstPol-${each.value.spanning_tree_interface_policy}"
  relation_infra_rs_netflow_node_pol                     = "uni/infra/nodepol-${each.value.netflow_node_policy}"
  relation_infra_rs_poe_inst_pol                         = "uni/infra/poeInstP-${each.value.poe_node_policy}"
  relation_infra_rs_topoctrl_fast_link_failover_inst_pol = "uni/infra/fastlinkfailoverinstpol-${each.value.fast_link_failover_policy}"
  relation_infra_rs_topoctrl_fwd_scale_prof_pol          = "uni/infra/fwdscalepol-${each.value.forward_scale_profile_policy}"
}
