/*_____________________________________________________________________________________________________________________

Layer 3 Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "layer3_domains" {
  default = {
    "default" = {
      annotation = ""
      name_alias = ""
      vlan_pool  = ""
    }
  }
  description = <<-EOT
  Key: Name of the Layer 3 Domain.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  * vlan_pool: Name of the VLAN Pool to Associate to the Domain.
  EOT
  type = map(object(
    {
      name_alias = optional(string)
      annotation = optional(string)
      vlan_pool  = string
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extDomP"
 - Distinguished Name: "uni/l3dom-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > L3 Domains: {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_domain_profile" "layer3_domains" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each                  = local.layer3_domains
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  name_alias                = each.value.name_alias
  relation_infra_rs_vlan_ns = aci_vlan_pool.vlan_pools[each.value.vlan_pool].id
}


/*_____________________________________________________________________________________________________________________

Physical Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "physical_domains" {
  default = {
    "default" = {
      annotation = ""
      name_alias = ""
      vlan_pool  = ""
    }
  }
  description = <<-EOT
  Key: Name of the Physical Domain.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * vlan_pool: Name of the VLAN Pool to Associate to the Domain.
  EOT
  type = map(object(
    {
      name_alias = optional(string)
      annotation = optional(string)
      vlan_pool  = string
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "physDomP"
 - Distinguished Name: "uni/infra/phys-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > Physical Domains: {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_physical_domain" "physical_domains" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each                  = local.physical_domains
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  name_alias                = each.value.name_alias
  relation_infra_rs_vlan_ns = aci_vlan_pool.vlan_pools[each.value.vlan_pool].id
}


/*_____________________________________________________________________________________________________________________

Virtual Machine Managed Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "vmm_domains" {
  default = {
    "default" = {
      access_mode                    = "read-write"
      annotation                     = ""
      arp_learning                   = "disabled"
      cdp_interface_policy           = ""
      configure_infra_port_groups    = ""
      control                        = "epDpVerify"
      delimiter                      = ""
      enable_tag_collection          = false
      encapsulation                  = "vlan"
      endpoint_inventory_type        = "on-link"
      endpoint_retention_time        = 0
      enforcement                    = "hw"
      enhanced_lag_policy            = ""
      firewall_policy                = ""
      host_availability_monitor      = false
      lacp_interface_policy          = ""
      lldp_interface_policy          = ""
      multicast_address              = ""
      multicast_pool                 = ""
      mtu_policy                     = "default"
      name_alias                     = ""
      preferred_encapsulation        = "unspecified"
      provider_type                  = "VMware"
      spanning_tree_interface_policy = ""
      virtual_switch_type            = "default"
      vlan_pool                      = ""
    }
  }
  description = <<-EOT
  Key: Name of the Virtual Machine Managed (VMM) Domain.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * vlan_pool: Name of the VLAN Pool to Associate to the Domain.
  EOT
  type = map(object(
    {
      access_mode                    = optional(string)
      annotation                     = optional(string)
      arp_learning                   = optional(string)
      cdp_interface_policy           = optional(string)
      configure_infra_port_groups    = optional(string)
      control                        = optional(string)
      delimiter                      = optional(string)
      enable_tag_collection          = optional(bool)
      encapsulation                  = optional(string)
      endpoint_inventory_type        = optional(string)
      endpoint_retention_time        = optional(number)
      enforcement                    = optional(string)
      enhanced_lag_policy            = optional(string)
      firewall_policy                = optional(string)
      host_availability_monitor      = optional(bool)
      lacp_interface_policy          = optional(string)
      lldp_interface_policy          = optional(string)
      multicast_address              = optional(string)
      multicast_pool                 = optional(string)
      mtu_policy                     = optional(string)
      name_alias                     = optional(string)
      preferred_encapsulation        = optional(string)
      provider_type                  = optional(string)
      spanning_tree_interface_policy = optional(string)
      virtual_switch_type            = optional(string)
      vlan_pool                      = optional(string)
      vxlan_pool                     = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "physDomP"
 - Distinguished Name: "uni/infra/phys-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > Physical Domains: {{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_domain" "vmm_domains" {
  depends_on = [
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_lacp_policy.lacp_interface_policies,
    aci_lldp_interface_policy.lldp_interface_policies,
    aci_spanning_tree_interface_policy.spanning_tree_interface_policies,
    aci_vlan_pool.vlan_pools
  ]
  for_each                              = local.vmm_domains
  access_mode                           = each.value.access_mode
  annotation                            = each.value.annotation != "" ? each.value.annotation : var.annotation
  arp_learning                          = each.value.arp_learning
  config_infra_pg                       = each.value.configure_infra_port_groups
  ctrl_knob                             = each.value.control
  delimiter                             = each.value.delimiter
  enable_tag                            = each.value.enable_tag_collection
  encap_mode                            = each.value.encapsulation
  enf_pref                              = each.value.enforcement
  ep_inventory_type                     = each.value.endpoint_inventory_type
  ep_ret_time                           = each.value.endpoint_retention_time
  hv_avail_monitor                      = each.value.host_availability_monitor
  mcast_addr                            = each.value.multicast_address
  mode                                  = each.value.virtual_switch_type
  name                                  = each.key
  name_alias                            = each.value.name_alias
  pref_encap_mode                       = each.value.preferred_encapsulation
  provider_profile_dn                   = each.value.provider_type
  relation_vmm_rs_pref_enhanced_lag_pol = each.value.enhanced_lag_policy
  relation_infra_rs_vlan_ns = length(
    regexall("_EMPTY", each.value.vlan_pool)
  ) > 0 ? aci_vlan_pool.vlan_pools[each.value.vlan_pool].id : ""
  relation_vmm_rs_dom_mcast_addr_ns = each.value.multicast_pool
  relation_vmm_rs_default_cdp_if_pol = length(
    regexall("_EMPTY", each.value.cdp_interface_policy)
  ) != 1 ? aci_cdp_interface_policy.cdp_interface_policies[each.value.cdp_interface_policy].id : ""
  relation_vmm_rs_default_lacp_lag_pol = length(
    regexall("_EMPTY", each.value.lacp_interface_policy)
  ) > 0 ? aci_lacp_policy.lacp_interface_policies[each.value.lacp_interface_policy].id : ""
  relation_vmm_rs_default_lldp_if_pol = length(
    regexall("_EMPTY", each.value.lldp_interface_policy)
  ) > 0 ? aci_lldp_interface_policy.lldp_interface_policies[each.value.lldp_interface_policy].id : ""
  relation_vmm_rs_default_stp_if_pol = length(
    regexall("_EMPTY", each.value.spanning_tree_interface_policy)
  ) > 0 ? aci_spanning_tree_interface_policy.spanning_tree_interface_policies[each.value.spanning_tree_interface_policy].id : ""
  relation_vmm_rs_default_fw_pol      = each.value.firewall_policy
  relation_vmm_rs_default_l2_inst_pol = each.value.mtu_policy # AKA L2 Policy
}