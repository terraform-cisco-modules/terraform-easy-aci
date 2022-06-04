/*_____________________________________________________________________________________________________________________

Domain Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "domains_layer3" {
  value = local.domains_layer3 != {} ? { for v in sort(
    keys(aci_l3_domain_profile.domains_layer3)
  ) : v => aci_l3_domain_profile.domains_layer3[v].id } : {}
}

output "domains_physical" {
  value = local.domains_physical != {} ? { for v in sort(
    keys(aci_physical_domain.domains_physical)
  ) : v => aci_physical_domain.domains_physical[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Global Policies/Profiles — Outputs
_______________________________________________________________________________________________________________________
*/
output "global_attachable_access_entity_profiles" {
  value = local.global_attachable_access_entity_profiles != {} ? { for v in sort(
    keys(aci_attachable_access_entity_profile.global_attachable_access_entity_profiles)
  ) : v => aci_attachable_access_entity_profile.global_attachable_access_entity_profiles[v].id } : {}
}

output "global_error_disabled_recovery_policy" {
  value = local.global_error_disabled_recovery_policy != {} ? { for v in sort(
    keys(aci_attachable_access_entity_profile.global_error_disabled_recovery_policy)
  ) : v => aci_attachable_access_entity_profile.global_error_disabled_recovery_policy[v].id } : {}
}

output "global_mcp_instance_policy" {
  value = local.global_mcp_instance_policy != {} ? { for v in sort(
    keys(aci_mcp_instance_policy.global_mcp_instance_policy)
  ) : v => aci_mcp_instance_policy.global_mcp_instance_policy[v].id } : {}
}

output "global_qos_class" {
  value = local.global_qos_class != {} ? { for v in sort(
    keys(aci_qos_instance_policy.global_qos_class)
  ) : v => aci_qos_instance_policy.global_qos_class[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Leaf Interface Policy Group — Outputs (Access/Breakout/Bundle)
_______________________________________________________________________________________________________________________
*/
output "leaf_interfaces_policy_groups_access" {
  value = local.leaf_interfaces_policy_groups_access != {} ? { for v in sort(
    keys(aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access)
  ) : v => aci_leaf_access_port_policy_group.leaf_interfaces_policy_groups_access[v].id } : {}
}

output "leaf_interfaces_policy_groups_breakout" {
  value = local.leaf_interfaces_policy_groups_breakout != {} ? { for v in sort(
    keys(aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout)
  ) : v => aci_leaf_breakout_port_group.leaf_interfaces_policy_groups_breakout[v].id } : {}
}

output "leaf_interfaces_policy_groups_bundle" {
  value = local.leaf_interfaces_policy_groups_bundle != {} ? { for v in sort(
    keys(aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle)
  ) : v => aci_leaf_access_bundle_policy_group.leaf_interfaces_policy_groups_bundle[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Interface Policies — Outputs
_______________________________________________________________________________________________________________________
*/
output "policies_cdp_interface" {
  value = local.policies_cdp_interface != {} ? { for v in sort(
    keys(aci_cdp_interface_policy.policies_cdp_interface)
  ) : v => aci_cdp_interface_policy.policies_cdp_interface[v].id } : {}
}

output "policies_fibre_channel_interface" {
  value = local.policies_fibre_channel_interface != {} ? { for v in sort(
    keys(aci_interface_fc_policy.policies_fibre_channel_interface)
  ) : v => aci_interface_fc_policy.policies_fibre_channel_interface[v].id } : {}
}

output "policies_l2_interface" {
  value = local.policies_l2_interface != {} ? { for v in sort(
    keys(aci_l2_interface_policy.policies_l2_interface)
  ) : v => aci_l2_interface_policy.policies_l2_interface[v].id } : {}
}

output "policies_link_level" {
  value = local.policies_link_level != {} ? { for v in sort(
    keys(aci_fabric_if_pol.policies_link_level)
  ) : v => aci_fabric_if_pol.policies_link_level[v].id } : {}
}

output "policies_lldp_interface" {
  value = local.policies_lldp_interface != {} ? { for v in sort(
    keys(aci_lldp_interface_policy.policies_lldp_interface)
  ) : v => aci_lldp_interface_policy.policies_lldp_interface[v].id } : {}
}

output "policies_mcp_interface" {
  value = local.policies_mcp_interface != {} ? { for v in sort(
    keys(aci_miscabling_protocol_interface_policy.policies_mcp_interface)
  ) : v => aci_miscabling_protocol_interface_policy.policies_mcp_interface[v].id } : {}
}

output "policies_port_channel" {
  value = local.policies_port_channel != {} ? { for v in sort(
    keys(aci_lacp_policy.policies_port_channel)
  ) : v => aci_lacp_policy.policies_port_channel[v].id } : {}
}

output "policies_port_security" {
  value = local.policies_port_security != {} ? { for v in sort(
    keys(aci_port_security_policy.policies_port_security)
  ) : v => aci_port_security_policy.policies_port_security[v].id } : {}
}

output "policies_spanning_tree_interface" {
  value = local.policies_spanning_tree_interface != {} ? { for v in sort(
    keys(aci_spanning_tree_interface_policy.policies_spanning_tree_interface)
  ) : v => aci_spanning_tree_interface_policy.policies_spanning_tree_interface[v].id } : {}
}


/*_____________________________________________________________________________________________________________________

Pools — VLAN Outputs
_______________________________________________________________________________________________________________________
*/
output "pools_vlan" {
  value = local.pools_vlan != {} ? { for v in sort(
    keys(aci_vlan_pool.pools_vlan)
  ) : v => aci_vlan_pool.pools_vlan[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Spine — Interface Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "spine_interface_policy_groups" {
  value = local.spine_interface_policy_groups != {} ? { for v in sort(
    keys(aci_spine_port_policy_group.spine_interface_policy_groups)
  ) : v => aci_spine_port_policy_group.spine_interface_policy_groups[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Switches — Policy Groups — Outputs
_______________________________________________________________________________________________________________________
*/
output "switches_leaf_policy_groups" {
  value = local.switches_leaf_policy_groups != {} ? { for v in sort(
    keys(aci_access_switch_policy_group.switches_leaf_policy_groups)
  ) : v => aci_access_switch_policy_group.switches_leaf_policy_groups[v].id } : {}
}

output "switches_spine_policy_groups" {
  value = local.switches_spine_policy_groups != {} ? { for v in sort(
    keys(aci_spine_switch_policy_group.switches_spine_policy_groups)
  ) : v => aci_spine_switch_policy_group.switches_spine_policy_groups[v].id } : {}
}

/*_____________________________________________________________________________________________________________________

Virtual Networking — VMM Domain — Outputs
_______________________________________________________________________________________________________________________
*/
output "vmm_domains" {
  value = local.domains_vmm != {} ? { for v in sort(
    keys(aci_vmm_domain.domains_vmm)
  ) : v => aci_vmm_domain.domains_vmm[v].id } : {}
}
