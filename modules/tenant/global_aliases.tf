# I will have to think how I want to accomplish this.
# resource "aci_rest_managed" "global_aliases" {
#   depends_on = [
#     aci_maintenance_policy.maintenance_group_policy,
#     aci_pod_maintenance_group.maintenance_groups,
#     aci_maintenance_group_node.maintenance_group_nodes,
#     aci_attachable_access_entity_profile.aaep_policies,
#     aci_access_generic.access_generic,
#     aci_error_disable_recovery.error_disabled_recovery_policy,
#     aci_mcp_instance_policy.mcp_instance_policy,
#     aci_qos_instance_policy.global_qos_class,
#     aci_cdp_interface_policy.cdp_interface_policies,
#     aci_interface_fc_policy.fc_interface_policies,
#     aci_l2_interface_policy.l2_interface_policies,
#     aci_lacp_policy.lacp_interface_policies,
#     aci_fabric_if_pol.link_level_policies,
#     aci_lldp_interface_policy.lldp_interface_policies,
#     aci_miscabling_protocol_interface_policy.mcp_interface_policies,
#     aci_port_security_policy.port_security_policies,
#     aci_spanning_tree_interface_policy.spanning_tree_interface_policies,
#     aci_rest_managed.fabric_membership,
#     aci_leaf_access_port_policy_group.policy_groups,
#     aci_leaf_breakout_port_group.policy_groups,
#     aci_leaf_access_bundle_policy_group.policy_groups,
#     aci_access_switch_policy_group.leaf_policy_groups,
#     aci_leaf_interface_profile.leaf_interface_profiles,
#     aci_access_port_selector.leaf_interface_selectors,
#     aci_access_port_block.leaf_port_blocks,
#     aci_access_sub_port_block.leaf_port_subblocks,
#     aci_leaf_profile.leaf_profiles,
#     aci_leaf_selector.leaf_selectors,
#     aci_node_block.leaf_profile_blocks,
#     aci_vlan_pool.vlan_pools,
#     aci_ranges.vlans,
#     aci_spine_port_policy_group.spine_interface_policy_groups,
#     aci_spine_switch_policy_group.spine_policy_groups,
#     aci_spine_interface_profile.spine_interface_profiles,
#     aci_rest_managed.spine_interface_selectors,
#     aci_spine_profile.spine_profiles,
#     aci_spine_switch_association.spine_profiles,
#     aci_rest_managed.spine_profile_node_blocks,
#     aci_vmm_domain.domains,
#     aci_rest_managed.vmm_domains_uplinks,
#     aci_rest_managed.vmm_uplink_names,
#     aci_vmm_credential.credentials,
#     aci_vmm_controller.controllers,
#     aci_vswitch_policy.vswitch_policies,
#     aci_vpc_domain_policy.vpc_domain_policies,
#     aci_vpc_explicit_protection_group.vpc_domains
#   ]
#   for_each   = local.global_aliases
#   dn         = each.value.distinguished_name
#   class_name = "tagAliasInst"
#   content = {
#     name = each.value.global_alias
#   }
# }

