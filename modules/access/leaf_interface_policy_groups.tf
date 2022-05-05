#------------------------------------------
# Create Access Port Policy Groups
#------------------------------------------

variable "leaf_port_group_access" {
  default = {
    "default" = {
      aaep_policy                        = ""
      annotation                         = ""
      cdp_interface_policy               = ""
      copp_interface_policy              = ""
      data_plane_policing_policy         = ""
      data_plane_policing_policy_egress  = ""
      data_plane_policing_policy_ingress = ""
      description                        = ""
      dot1x_port_policy                  = ""
      dwdm_policy                        = ""
      fc_interface_policy                = ""
      group_alias                        = ""
      l2_interface_policy                = ""
      link_level_policy                  = ""
      lldp_interface_policy              = ""
      macsec_policy                      = ""
      mcp_interface_policy               = ""
      monitoring_policy                  = ""
      netflow_policy                     = []
      port_security_policy               = ""
      priority_flow_control_policy       = ""
      slow_drain_policy                  = ""
      span_destination_groups            = ""
      span_source_groups                 = ""
      spanning_tree_interface_policy     = ""
      storm_control_policy               = ""
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  EOT
  type = map(object(
    {
      aaep_policy                        = optional(string)
      annotation                         = optional(string)
      cdp_interface_policy               = optional(string)
      copp_interface_policy              = optional(string)
      data_plane_policing_policy         = optional(string)
      data_plane_policing_policy_egress  = optional(string)
      data_plane_policing_policy_ingress = optional(string)
      description                        = optional(string)
      dot1x_port_policy                  = optional(string)
      dwdm_policy                        = optional(string)
      fc_interface_policy                = optional(string)
      global_alias                       = optional(string)
      l2_interface_policy                = optional(string)
      link_level_policy                  = optional(string)
      lldp_interface_policy              = optional(string)
      macsec_policy                      = optional(string)
      mcp_interface_policy               = optional(string)
      monitoring_policy                  = optional(string)
      netflow_policy                     = optional(list(string))
      port_security_policy               = optional(string)
      priority_flow_control_policy       = optional(string)
      slow_drain_policy                  = optional(string)
      span_destination_groups            = optional(string)
      span_source_groups                 = optional(string)
      spanning_tree_interface_policy     = optional(string)
      storm_control_policy               = optional(string)
    }
  ))
}
/*
API Information:
 - Class: "infraAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/accportgrp-{{Name}}"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > Leaf Access Port > {{Name}}
*/
resource "aci_leaf_access_port_policy_group" "policy_groups" {
  depends_on = [
    aci_attachable_access_entity_profile.aaep_policies,
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_interface_fc_policy.fc_interface_policies,
    aci_l2_interface_policy.l2_interface_policies,
    aci_fabric_if_pol.link_level_policies,
    aci_lldp_interface_policy.lldp_interface_policies,
    aci_miscabling_protocol_interface_policy.mcp_interface_policies,
    aci_port_security_policy.port_security_policies,
    aci_spanning_tree_interface_policy.spanning_tree_interface_policies
  ]
  for_each    = local.leaf_port_group_access
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
  # class: infraAttEntityP
  # DN: "uni/infra/attentp-{aaep_policy}"
  relation_infra_rs_att_ent_p = length(
    regexall("^[[:alnum:]]", coalesce(each.value.aaep_policy, "_EMPTY"))
  ) > 0 ? aci_attachable_access_entity_profile.aaep_policies[each.value.aaep_policy].id : ""
  # class: cdpIfPol
  # DN: "uni/infra/cdpIfP-{cdp_interface_policy}"
  relation_infra_rs_cdp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.cdp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_cdp_interface_policy.cdp_interface_policies[each.value.cdp_interface_policy].id : ""
  # class: coppIfPol
  # DN: "uni/infra/coppifpol-{copp_interface_policy}"
  relation_infra_rs_copp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.copp_interface_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: dwdmIfPol
  # DN: "uni/infra/dwdmifpol-{dwdm_policy}"
  relation_infra_rs_dwdm_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.dwdm_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/dwdmifpol-${each.value.dwdm_policy}" : ""
  # class: fcIfPol
  # DN: "uni/infra/fcIfPol-{fc_interface_policy}"
  relation_infra_rs_fc_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.fc_interface_policy, "_EMPTY"))
  ) > 0 ? aci_interface_fc_policy.fc_interface_policies[each.value.fc_interface_policy].id : ""
  # class: fabricHIfPol
  # DN: "uni/infra/hintfpol-{link_level_policy}"
  relation_infra_rs_h_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.link_level_policy, "_EMPTY"))
  ) > 0 ? aci_fabric_if_pol.link_level_policies[each.value.link_level_policy].id : ""
  # class: l2IfPol
  # DN: "uni/infra/l2IfP-{l2_interface_policy}"
  relation_infra_rs_l2_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.l2_interface_policy, "_EMPTY"))
  ) > 0 ? aci_l2_interface_policy.l2_interface_policies[each.value.l2_interface_policy].id : ""
  # class: l2PortAuthPol
  # DN: "uni/infra/portauthpol-{dot1x_port_policy}"
  relation_infra_rs_l2_port_auth_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.dot1x_port_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/portauthpol-${each.value.dot1x_port_policy}" : ""
  # class: l2PortSecurityPol
  # DN: "uni/infra/portsecurityP-{port_security_policy}"
  relation_infra_rs_l2_port_security_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.port_security_policy, "_EMPTY"))
  ) > 0 ? aci_port_security_policy.port_security_policies[each.value.port_security_policy].id : ""
  # class: lldpIfPol
  # DN: "uni/infra/lldpIfP-{lldp_interface_policy}"
  relation_infra_rs_lldp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.lldp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_lldp_interface_policy.lldp_interface_policies[each.value.lldp_interface_policy].id : ""
  # class: macsecIfPol
  # DN: "uni/infra/macsecifp-{macsec_policy}"
  relation_infra_rs_macsec_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.macsec_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
  # class: mcpIfPol
  # DN: "uni/infra/mcpIfP-{mcp_interface_policy}"
  relation_infra_rs_mcp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.mcp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_miscabling_protocol_interface_policy.mcp_interface_policies[each.value.mcp_interface_policy].id : ""
  # class: monFabricPol
  # DN: "uni/fabric/monfab-{monitoring_policy}"
  relation_infra_rs_mon_if_infra_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.monitoring_policy, "_EMPTY"))
  ) > 0 ? "uni/fabric/monfab-${each.value.monitoring_policy}" : ""
  # class: netflowMonitorPol
  # DN: "uni/infra/monitorpol-{netflow_policy}"
  # relation_infra_rs_netflow_monitor_pol = length(
  #   each.value.netflow_policy
  # ) > 0 ? [for s in each.value.netflow_policy : "uni/infra/monitorpol-${s}"] : []
  # **There is no default Policy**
  # class: poeIfPol
  # DN: "uni/infra/poeIfP-{poe_policy}"
  relation_infra_rs_poe_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.poe_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/poeIfP-${each.value.poe_policy}" : ""
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{{qosDppPol}}"
  relation_infra_rs_qos_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy}" : ""
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{data_plane_policing_policy_egress}"
  relation_infra_rs_qos_egress_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy_egress, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy_egress}" : ""
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{data_plane_policing_policy_ingress}"
  relation_infra_rs_qos_ingress_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy_ingress, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy_ingress}" : ""
  # class: qosPfcIfPol
  # DN: "uni/infra/pfc-{priority_flow_control_policy}"
  relation_infra_rs_qos_pfc_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.priority_flow_control_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/pfc-${each.value.priority_flow_control_policy}" : ""
  # class: qosSdIfPol
  # DN: "uni/infra/qossdpol-{slow_drain_policy}"
  relation_infra_rs_qos_sd_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.slow_drain_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/qossdpol-${each.value.slow_drain_policy}" : ""
  # class: spanVDestGrp
  # DN: "uni/infra/vdestgrp-{span_destination_groups}"
  relation_infra_rs_span_v_dest_grp = length(
    regexall("^[[:alnum:]]", coalesce(each.value.span_destination_groups, "_EMPTY"))
  ) > 0 ? ["uni/infra/vdestgrp-${each.value.span_destination_groups}"] : []
  # class: spanVSrcGrp
  # DN: "uni/infra/vsrcgrp-{span_source_groups}"
  relation_infra_rs_span_v_src_grp = length(
    regexall("^[[:alnum:]]", coalesce(each.value.span_source_groups, "_EMPTY"))
  ) > 0 ? ["uni/infra/vsrcgrp-${each.value.span_source_groups}"] : []
  # class: stormctrlIfPol
  # DN: "uni/infra/stormctrlifp-{storm_control_policy}"
  relation_infra_rs_stormctrl_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.storm_control_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  # DN: "uni/infra/ifPol-{spanning_tree_interface_policy}"
  relation_infra_rs_stp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.spanning_tree_interface_policy, "_EMPTY"))
  ) > 0 ? aci_spanning_tree_interface_policy.spanning_tree_interface_policies[each.value.spanning_tree_interface_policy].id : ""
}

variable "leaf_port_group_breakout" {
  default = {
    "default" = {
      annotation   = ""
      breakout_map = "10g-4x"
      description  = ""
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      annotation   = optional(string)
      breakout_map = optional(string)
      description  = optional(string)
    }
  ))
}

#------------------------------------------
# Create Breakout Port Policy Groups
#------------------------------------------

/*
API Information:
 - Class: "infraBrkoutPortGrp"
 - Distinguished Name: "uni/infra/funcprof/brkoutportgrp-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Interface > Leaf Interfaces > Policy Groups > Leaf Breakout Port Group:{{Name}}
*/
resource "aci_leaf_breakout_port_group" "policy_groups" {
  for_each    = local.leaf_port_group_breakout
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  brkout_map  = each.value.breakout_map
  description = each.value.description
  name        = each.key
}


variable "leaf_port_group_bundle" {
  default = {
    "default" = {
      aaep_policy                        = ""
      annotation                         = ""
      cdp_interface_policy               = ""
      copp_interface_policy              = ""
      data_plane_policing_policy         = ""
      data_plane_policing_policy_egress  = ""
      data_plane_policing_policy_ingress = ""
      description                        = ""
      fc_interface_policy                = ""
      lacp_interface_policy              = ""
      link_aggregation_type              = ""
      l2_interface_policy                = ""
      lldp_interface_policy              = ""
      macsec_policy                      = ""
      mcp_interface_policy               = ""
      monitoring_policy                  = ""
      port_security_policy               = ""
      priority_flow_control_policy       = ""
      slow_drain_policy                  = ""
      span_destination_groups            = ""
      span_source_groups                 = ""
      storm_control_policy               = ""
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      aaep_policy                        = optional(string)
      annotation                         = optional(string)
      cdp_interface_policy               = optional(string)
      copp_interface_policy              = optional(string)
      data_plane_policing_policy         = optional(string)
      data_plane_policing_policy_egress  = optional(string)
      data_plane_policing_policy_ingress = optional(string)
      description                        = optional(string)
      fc_interface_policy                = optional(string)
      l2_interface_policy                = optional(string)
      lacp_interface_policy              = optional(string)
      link_aggregation_type              = optional(string)
      lldp_interface_policy              = optional(string)
      macsec_policy                      = optional(string)
      mcp_interface_policy               = optional(string)
      monitoring_policy                  = optional(string)
      port_security_policy               = optional(string)
      priority_flow_control_policy       = optional(string)
      slow_drain_policy                  = optional(string)
      span_destination_groups            = optional(string)
      span_source_groups                 = optional(string)
      spanning_tree_interface_policy     = optional(string)
      storm_control_policy               = optional(string)
    }
  ))
}
#------------------------------------------------
# Create Bundle (port-channel|vpc) Policy Groups
#------------------------------------------------

/*
API Information:
 - Class: "infraAccBndlGrp"
 - Distinguished Name: "uni/infra/funcprof/accbundle-{{Name}}"
GUI Location:
 - Fabric > Interfaces > Leaf Interfaces > Policy Groups > [PC or VPC] Interface > {{Name}}
*/
resource "aci_leaf_access_bundle_policy_group" "policy_groups" {
  depends_on = [
    aci_attachable_access_entity_profile.aaep_policies,
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_interface_fc_policy.fc_interface_policies,
    aci_l2_interface_policy.l2_interface_policies,
    aci_lacp_policy.lacp_interface_policies,
    aci_fabric_if_pol.link_level_policies,
    aci_lldp_interface_policy.lldp_interface_policies,
    aci_miscabling_protocol_interface_policy.mcp_interface_policies,
    aci_port_security_policy.port_security_policies,
    aci_spanning_tree_interface_policy.spanning_tree_interface_policies
  ]
  for_each    = local.leaf_port_group_bundle
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  lag_t       = each.value.link_aggregation_type
  name        = each.key
  # class: infraAttEntityP
  # DN: "uni/infra/attentp-{aaep_policy}"
  relation_infra_rs_att_ent_p = length(
    regexall("^[[:alnum:]]", coalesce(each.value.aaep_policy, "_EMPTY"))
  ) > 0 ? aci_attachable_access_entity_profile.aaep_policies[each.value.aaep_policy].id : ""
  # class: cdpIfPol
  # DN: "uni/infra/cdpIfP-{cdp_interface_policy}"
  relation_infra_rs_cdp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.cdp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_cdp_interface_policy.cdp_interface_policies[each.value.cdp_interface_policy].id : ""
  # class: coppIfPol
  # DN: "uni/infra/coppifpol-{copp_interface_policy}"
  relation_infra_rs_copp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.copp_interface_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: fcIfPol
  # DN: "uni/infra/fcIfPol-{fc_interface_policy}"
  relation_infra_rs_fc_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.fc_interface_policy, "_EMPTY"))
  ) > 0 ? aci_interface_fc_policy.fc_interface_policies[each.value.fc_interface_policy].id : ""
  # class: l2IfPol
  # DN: "uni/infra/l2IfP-{l2_interface_policy}"
  relation_infra_rs_l2_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.l2_interface_policy, "_EMPTY"))
  ) > 0 ? aci_l2_interface_policy.l2_interface_policies[each.value.l2_interface_policy].id : ""
  # class: l2PortSecurityPol
  # DN: "uni/infra/portsecurityP-{port_security_policy}"
  relation_infra_rs_l2_port_security_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.port_security_policy, "_EMPTY"))
  ) > 0 ? aci_port_security_policy.port_security_policies[each.value.port_security_policy].id : ""
  # class: lacpLagPol
  # DN: "uni/infra/lacplagp-{lacp_interface_policy}"
  relation_infra_rs_lacp_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.lacp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_lacp_policy.lacp_interface_policies[each.value.lacp_interface_policy].id : ""
  # class: lldpIfPol
  # DN: "uni/infra/lldpIfP-{lldp_interface_policy}"
  relation_infra_rs_lldp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.lldp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_lldp_interface_policy.lldp_interface_policies[each.value.lldp_interface_policy].id : ""
  # class: macsecIfPol
  # DN: "uni/infra/macsecifp-{macsec_policy}"
  relation_infra_rs_macsec_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.macsec_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
  # class: mcpIfPol
  # DN: "uni/infra/mcpIfP-{mcp_interface_policy}"
  relation_infra_rs_mcp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.mcp_interface_policy, "_EMPTY"))
  ) > 0 ? aci_miscabling_protocol_interface_policy.mcp_interface_policies[each.value.mcp_interface_policy].id : ""
  # class: monFabricPol
  # DN: "uni/fabric/monfab-{monitoring_policy}"
  relation_infra_rs_mon_if_infra_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.monitoring_policy, "_EMPTY"))
  ) > 0 ? "uni/fabric/monfab-${each.value.monitoring_policy}" : ""
  # **There is no default Policy**
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{{qosDppPol}}"
  relation_infra_rs_qos_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy}" : ""
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{data_plane_policing_policy_egress}"
  relation_infra_rs_qos_egress_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy_egress, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy_egress}" : ""
  # class: qosDppPol
  # DN: "uni/infra/qosdpppol-{data_plane_policing_policy_ingress}"
  relation_infra_rs_qos_ingress_dpp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.data_plane_policing_policy_ingress, "_EMPTY"))
  ) > 0 ? "uni/infra/qosdpppol-${each.value.data_plane_policing_policy_ingress}" : ""
  # class: qosPfcIfPol
  # DN: "uni/infra/pfc-{priority_flow_control_policy}"
  relation_infra_rs_qos_pfc_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.priority_flow_control_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/pfc-${each.value.priority_flow_control_policy}" : ""
  # class: qosSdIfPol
  # DN: "uni/infra/qossdpol-{slow_drain_policy}"
  relation_infra_rs_qos_sd_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.slow_drain_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/qossdpol-${each.value.slow_drain_policy}" : ""
  # class: spanVDestGrp
  # DN: "uni/infra/vdestgrp-{span_destination_groups}"
  relation_infra_rs_span_v_dest_grp = length(
    regexall("^[[:alnum:]]", coalesce(each.value.span_destination_groups, "_EMPTY"))
  ) > 0 ? ["uni/infra/vdestgrp-${each.value.span_destination_groups}"] : []
  # class: spanVSrcGrp
  # DN: "uni/infra/vsrcgrp-{span_source_groups}"
  relation_infra_rs_span_v_src_grp = length(
    regexall("^[[:alnum:]]", coalesce(each.value.span_source_groups, "_EMPTY"))
  ) > 0 ? ["uni/infra/vsrcgrp-${each.value.span_source_groups}"] : []
  # class: stormctrlIfPol
  # DN: "uni/infra/stormctrlifp-{storm_control_policy}"
  relation_infra_rs_stormctrl_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.storm_control_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  # DN: "uni/infra/ifPol-{spanning_tree_interface_policy}"
  relation_infra_rs_stp_if_pol = length(
    regexall("^[[:alnum:]]", coalesce(each.value.spanning_tree_interface_policy, "_EMPTY"))
  ) > 0 ? aci_spanning_tree_interface_policy.spanning_tree_interface_policies[each.value.spanning_tree_interface_policy].id : ""
}
