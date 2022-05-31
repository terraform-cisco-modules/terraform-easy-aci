variable "leaf_interfaces_policy_groups_bundle" {
  default = {
    "default" = {
      attachable_entity_profile      = ""
      annotation                     = ""
      cdp_interface_policy           = ""
      copp_interface_policy          = ""
      data_plane_policing_egress     = ""
      data_plane_policing_ingress    = ""
      description                    = ""
      fibre_channel_interface_policy = ""
      link_aggregation_policy        = ""
      link_aggregation_type          = ""
      link_flap_policy               = ""
      link_level_flow_control_policy = ""
      link_level_policy              = ""
      l2_interface_policy            = ""
      lldp_interface_policy          = ""
      macsec_policy                  = ""
      mcp_interface_policy           = ""
      monitoring_policy              = ""
      netflow_monitor_policies       = []
      port_security_policy           = ""
      priority_flow_control_policy   = ""
      slow_drain_policy              = ""
      span_destination_groups        = ""
      span_source_groups             = ""
      storm_control_policy           = ""
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      attachable_entity_profile      = optional(string)
      annotation                     = optional(string)
      cdp_interface_policy           = optional(string)
      copp_interface_policy          = optional(string)
      data_plane_policing_egress     = optional(string)
      data_plane_policing_ingress    = optional(string)
      description                    = optional(string)
      fibre_channel_interface_policy = optional(string)
      l2_interface_policy            = optional(string)
      link_aggregation_policy        = optional(string)
      link_aggregation_type          = optional(string)
      link_flap_policy               = optional(string)
      link_level_flow_control_policy = optional(string)
      link_level_policy              = optional(string)
      lldp_interface_policy          = optional(string)
      macsec_policy                  = optional(string)
      mcp_interface_policy           = optional(string)
      monitoring_policy              = optional(string)
      netflow_monitor_policies       = optional(list(string))
      port_security_policy           = optional(string)
      priority_flow_control_policy   = optional(string)
      slow_drain_policy              = optional(string)
      span_destination_groups        = optional(string)
      span_source_groups             = optional(string)
      spanning_tree_interface_policy = optional(string)
      storm_control_policy           = optional(string)
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
resource "aci_leaf_access_bundle_policy_group" "leaf_interfaces_policy_groups_bundle" {
  depends_on = [
    aci_attachable_access_entity_profile.global_attachable_access_entity_profiles,
    aci_cdp_interface_policy.policies_cdp_interface,
    aci_interface_fc_policy.policies_fibre_channel_interface,
    aci_l2_interface_policy.policies_l2_interface,
    aci_lacp_policy.policies_port_channel,
    aci_fabric_if_pol.policies_link_level,
    aci_lldp_interface_policy.policies_lldp_interface,
    aci_miscabling_protocol_interface_policy.policies_mcp_interface,
    aci_port_security_policy.policies_port_security,
    aci_spanning_tree_interface_policy.policies_spanning_tree_interface
  ]
  for_each    = local.leaf_interfaces_policy_groups_bundle
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  lag_t       = each.value.link_aggregation_type == "pc" ? "node" : "link"
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: coppIfPol
  relation_infra_rs_copp_if_pol = length(compact([each.value.copp_interface_policy])
  ) > 0 ? "uni/infra/coppifpol-${each.value.copp_interface_policy}" : ""
  # class: fcIfPol
  relation_infra_rs_fc_if_pol = length(compact([each.value.fibre_channel_interface_policy])
  ) > 0 ? "uni/infra/fcIfPol-${each.value.fibre_channel_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: l2IfPol
  relation_infra_rs_l2_if_pol = length(compact([each.value.l2_interface_policy])
  ) > 0 ? "uni/infra/l2IfP-${each.value.l2_interface_policy}" : ""
  # class: l2PortSecurityPol
  relation_infra_rs_l2_port_security_pol = length(compact([each.value.port_security_policy])
  ) > 0 ? "uni/infra/portsecurityP-${each.value.port_security_policy}" : ""
  # class: lacpLagPol
  relation_infra_rs_lacp_pol = length(compact([each.value.link_aggregation_policy])
  ) > 0 ? "uni/infra/lacplagp-${each.value.link_aggregation_policy}" : ""
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
  ) > 0 ? "uni/fabric/monfab-${each.value.monitoring_policy}" : ""
  # class: netflowMonitorPol
  dynamic "relation_infra_rs_netflow_monitor_pol" {
    for_each = toset(each.value.netflow_monitor_policies)
    content {
      flt_type  = element(split(":", relation_infra_rs_netflow_monitor_pol.value), 1)
      target_dn = "uni/infra/monitorpol-${element(split(":", relation_infra_rs_netflow_monitor_pol.value), 0)}"
    }
  }
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
  relation_infra_rs_span_v_dest_grp = length(compact([each.value.span_destination_groups])
  ) > 0 ? ["uni/infra/vdestgrp-${each.value.span_destination_groups}"] : []
  # class: spanVSrcGrp
  relation_infra_rs_span_v_src_grp = length(compact([each.value.span_source_groups])
  ) > 0 ? ["uni/infra/vsrcgrp-${each.value.span_source_groups}"] : []
  # class: stormctrlIfPol
  relation_infra_rs_stormctrl_if_pol = length(compact([each.value.storm_control_policy])
  ) > 0 ? "uni/infra/stormctrlifp-${each.value.storm_control_policy}" : ""
  # class: stpIfPol
  relation_infra_rs_stp_if_pol = length(compact([each.value.spanning_tree_interface_policy])
  ) > 0 ? "uni/infra/ifPol-${each.value.spanning_tree_interface_policy}" : ""
}
