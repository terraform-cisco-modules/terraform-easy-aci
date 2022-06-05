/*_____________________________________________________________________________________________________________________

Leaf Interfaces — Access Policy Group — Variables
_______________________________________________________________________________________________________________________
*/
variable "leaf_interfaces_policy_groups_access" {
  default = {
    "default" = {
      annotation                       = ""
      attachable_entity_profile        = "**REQUIRED**"
      cdp_interface_policy             = ""
      copp_interface_policy            = ""
      data_plane_policing_egress       = ""
      data_plane_policing_ingress      = ""
      description                      = ""
      dot1x_port_authentication_policy = ""
      dwdm_policy                      = ""
      fibre_channel_interface_policy   = ""
      global_alias                     = ""
      l2_interface_policy              = ""
      link_flap_policy                 = ""
      link_level_flow_control_policy   = ""
      link_level_policy                = ""
      lldp_interface_policy            = ""
      macsec_policy                    = ""
      mcp_interface_policy             = ""
      monitoring_policy                = ""
      netflow_monitor_policies         = []
      poe_interface_policy             = ""
      port_security_policy             = ""
      priority_flow_control_policy     = ""
      slow_drain_policy                = ""
      span_destination_groups          = []
      span_source_groups               = []
      spanning_tree_interface_policy   = ""
      storm_control_policy             = ""
      synce_interface_policy           = ""
    }
  }
  description = <<-EOT
    Key — Name of the Leaf Interface - Access Policy Group.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * attachable_entity_profile: (required) — The Name of the Global Attachable Entity Profile.
    * cdp_interface_policy: (optional) — The Name of the CDP Interface Policy.
    * copp_interface_policy: (optional) — The Name of the CoPP Interafce Policy.
    * data_plane_policing_egress: (optional) — The Name of the Egress Data Plane Policing Policy.
    * data_plane_policing_ingress: (optional) — The Name of the Ingress Data Plane Policing Policy.
    * description: (optional) — escription to add to the Object.  The description can be up to 128 characters.
    * dot1x_port_authentication_policy: (optional) — The Name of the 802.1X Port Authentication Policy.
    * dwdm_policy: (optional) — The Name of the DWDM Interface Policy.
    * fibre_channel_interface_policy: (optional) — The Name of the 802.1X Port Authentication Policy.
    * global_alias: (optional) — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
    * l2_interface_policy: (optional) — The Name of the Layer2 Interface Policy.
    * link_flap_policy: (optional) — The Name of the Link Flap Policy.
    * link_level_flow_control_policy: (optional) — The Name of the Link Level Flow Control Policy.
    * link_level_policy: (optional) — The Name of the Link Level Policy.
    * lldp_interface_policy: (optional) — The Name of the LLDP Interface Policy.
    * macsec_policy: (optional) — The Name of the MACSec Policy.
    * mcp_interface_policy: (optional) — The Name of the MCP Interface Policy.
    * monitoring_policy: (optional) — The Name of the Monitoring Policy.
    * netflow_monitor_policies: (optional) — Map of Objects to assign Netflow Monitor Policies to the Policy Group.
      - ip_filter_type — IP Filter Type.  Options are:
        * ce
        * ipv4
        * ipv6
      - netflow_monitor_policy — The Name of the Netflow Monitor Policy.
    * poe_interface_policy: (optional) — The Name of the PoE Interface Policy.
    * port_security_policy: (optional) — The Name of the Port Security Policy.
    * priority_flow_control_policy: (optional) — The Name of the Priority Flow Control Policy.
    * slow_drain_policy: (optional) — The Name of the Slow Drain Policy.
    * span_destination_groups: (optional) — The Name of the Span Destination Group.
    * span_source_groups: (optional) — The Name of the Span Source Groups.
    * spanning_tree_interface_policy: (optional) — The Name of the Spanning Tree Interface Policy.
    * storm_control_policy: (optional) — The Name of the Storm Control Policy.
    * synce_interface_policy: (optional) — The Name of the SyncE Interface Policy.
  EOT
  type = map(object(
    {
      annotation                       = optional(string)
      attachable_entity_profile        = string
      cdp_interface_policy             = optional(string)
      copp_interface_policy            = optional(string)
      data_plane_policing_egress       = optional(string)
      data_plane_policing_ingress      = optional(string)
      description                      = optional(string)
      dot1x_port_authentication_policy = optional(string)
      dwdm_policy                      = optional(string)
      fibre_channel_interface_policy   = optional(string)
      global_alias                     = optional(string)
      l2_interface_policy              = optional(string)
      link_flap_policy                 = optional(string)
      link_level_flow_control_policy   = optional(string)
      link_level_policy                = optional(string)
      lldp_interface_policy            = optional(string)
      macsec_policy                    = optional(string)
      mcp_interface_policy             = optional(string)
      monitoring_policy                = optional(string)
      netflow_monitor_policies = optional(list(object(
        {
          ip_filter_type         = optional(string)
          netflow_monitor_policy = string
        }

      )))
      port_security_policy           = optional(string)
      poe_interface_policy           = optional(string)
      priority_flow_control_policy   = optional(string)
      slow_drain_policy              = optional(string)
      span_destination_groups        = optional(list(string))
      span_source_groups             = optional(list(string))
      spanning_tree_interface_policy = optional(string)
      storm_control_policy           = optional(string)
      synce_interface_policy         = optional(string)
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/accportgrp-{name}"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {name}

_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_access_port_policy_group" "leaf_interfaces_policy_groups_access" {
  depends_on = [
    aci_attachable_access_entity_profile.global_attachable_access_entity_profiles,
    aci_cdp_interface_policy.policies_cdp_interface,
    aci_interface_fc_policy.policies_fibre_channel_interface,
    aci_l2_interface_policy.policies_l2_interface,
    aci_fabric_if_pol.policies_link_level,
    aci_lldp_interface_policy.policies_lldp_interface,
    aci_miscabling_protocol_interface_policy.policies_mcp_interface,
    aci_port_security_policy.policies_port_security,
    aci_spanning_tree_interface_policy.policies_spanning_tree_interface
  ]
  for_each    = local.leaf_interfaces_policy_groups_access
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  relation_infra_rs_copp_if_pol = length(compact([each.value.copp_interface_policy])
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: dwdmIfPol
  relation_infra_rs_dwdm_if_pol = length(compact([each.value.dwdm_policy])
  ) > 0 ? "uni/infra/dwdmifpol-${each.value.dwdm_policy}" : ""
  # class: fcIfPol
  relation_infra_rs_fc_if_pol = length(compact([each.value.fibre_channel_interface_policy])
  ) > 0 ? "uni/infra/fcIfPol-${each.value.fibre_channel_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: l2IfPol
  relation_infra_rs_l2_if_pol = length(compact([each.value.l2_interface_policy])
  ) > 0 ? "uni/infra/l2IfP-${each.value.l2_interface_policy}" : ""
  # class: l2PortAuthPol
  relation_infra_rs_l2_port_auth_pol = length(compact([each.value.dot1x_port_authentication_policy])
  ) > 0 ? "uni/infra/portauthpol-${each.value.dot1x_port_authentication_policy}" : ""
  # class: l2PortSecurityPol
  relation_infra_rs_l2_port_security_pol = length(compact([each.value.port_security_policy])
  ) > 0 ? "uni/infra/portsecurityP-${each.value.port_security_policy}" : ""
  # class: lldpIfPol
  relation_infra_rs_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  # class: macsecIfPol
  relation_infra_rs_macsec_if_pol = length(compact([each.value.macsec_policy])
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
  # class: mcpIfPol
  relation_infra_rs_mcp_if_pol = length(compact([each.value.mcp_interface_policy])
  ) > 0 ? "uni/infra/mcpIfP-${each.value.mcp_interface_policy}" : ""
  # class: monFabricPol
  relation_infra_rs_mon_if_infra_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  # class: netflowMonitorPol
  dynamic "relation_infra_rs_netflow_monitor_pol" {
    for_each = each.value.netflow_monitor_policies
    content {
      flt_type  = relation_infra_rs_netflow_monitor_pol.value.ip_filter_type
      target_dn = "uni/infra/monitorpol-${relation_infra_rs_netflow_monitor_pol.value.netflow_monitor_policy}"
    }
  }
  # class: poeIfPol
  relation_infra_rs_poe_if_pol = length(compact([each.value.poe_interface_policy])
  ) > 0 ? "uni/infra/poeIfP-${each.value.poe_interface_policy}" : ""
  # class: qosDppPol
  relation_infra_rs_qos_egress_dpp_if_pol = length(compact([each.value.data_plane_policing_egress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_egress}" : ""
  # class: qosDppPol
  relation_infra_rs_qos_ingress_dpp_if_pol = length(compact([each.value.data_plane_policing_ingress])
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_ingress}" : ""
  # class: qosPfcIfPol
  relation_infra_rs_qos_pfc_if_pol = length(compact([each.value.priority_flow_control_policy])
  ) > 0 ? "uni/infra/pfc-${each.value.priority_flow_control_policy}" : ""
  # class: qosSdIfPol
  relation_infra_rs_qos_sd_if_pol = length(compact([each.value.slow_drain_policy])
  ) > 0 ? "uni/infra/qossdpol-${each.value.slow_drain_policy}" : ""
  # class: spanVDestGrp
  relation_infra_rs_span_v_dest_grp = length(compact(each.value.span_destination_groups)
  ) > 0 ? [for s in each.value.span_source_groups : "uni/infra/vdestgrp-${s}"] : []
  # class: spanVSrcGrp
  relation_infra_rs_span_v_src_grp = length(compact(each.value.span_source_groups)
  ) > 0 ? [for s in each.value.span_source_groups : "uni/infra/vsrcgrp-${s}"] : []
  # class: stormctrlIfPol
  relation_infra_rs_stormctrl_if_pol = length(compact([each.value.storm_control_policy])
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  relation_infra_rs_stp_if_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/ifPol-${each.value.spanning_tree_interface_policy}" : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/funcprof/accportgrp-{name}/alias"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "leaf_interfaces_policy_groups_access_global_alias" {
  depends_on = [
    aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access,
  ]
  for_each   = local.leaf_interfaces_policy_groups_access_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/infra/funcprof/accportgrp-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
