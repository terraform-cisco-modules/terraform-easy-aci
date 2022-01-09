/*_____________________________________________________________________________________________________________________

Leaf Profile Variables
_______________________________________________________________________________________________________________________
*/
variable "leaf_profiles" {
  default = {
    "default" = {
      alias            = ""
      description      = ""
      external_pool_id = "0"
      interfaces = {
        "default" = {
          interface_description  = ""
          interface_policy_group = ""
          port_type              = "access"
          selector_description   = ""
          sub_port               = false
        }
      }
      leaf_policy_group = "**REQUIRED**"
      monitoring_policy = "default"
      name              = "**REQUIRED**"
      node_type         = "unspecified"
      pod_id            = "1"
      role              = "leaf"
      serial            = "**REQUIRED**"
      tags              = ""
      two_slot_leaf     = false
    }
  }
  description = <<-EOT
  key - Node ID of the Leaf
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * external_pool_id:
  * interfaces:
    - Key: The Name of the Interface Selector.  This Must be in the format of X/X for a regular leaf port or X/X/X for a breakout sub port.
      * interface_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
      * interface_policy_group: Name of the Interface Policy Group
      * port_type: The type of Policy to Apply to the Port.
        - access: Access Port Policy Group
        - breakout: Breakout Port Policy Group
        - port-channel: Port-Channel Port Policy Group
        - vpc: Virtual Port-Channel Port Policy Group
      * selector_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
      * sub_port: Flag to tell the Script to create a Sub-Port Block or regular Port Block
  * monitoring_policy: Name of the Monitoring Policy to assign to the Fabric Node Member.
  * name: Hostname of the Leaf plus Name of the Leaf Profile, Leaf Interface Profile, and Leaf Profile Selector.
  * node_type:
    - leaf
    - remote-leaf-wan
    - spine
    - tier-2-leaf
    - virtual-leaf
  * pod_id: Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.
  * serial: Manufacturing Serial Number of the Switch.
  * tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * two_slot_leaf: Flag to Tell the Script this is a Leaf with more than 99 ports.  It will Name Leaf Selectors as Eth1-001 instead of Eth1-01.
  EOT
  type = map(object(
    {
      alias            = optional(string)
      description      = optional(string)
      external_pool_id = optional(string)
      interfaces = map(object(
        {
          interface_description  = optional(string)
          interface_policy_group = optional(string)
          port_type              = optional(string)
          selector_description   = optional(string)
          sub_port               = optional(bool)
        }
      ))
      leaf_policy_group = string
      monitoring_policy = optional(string)
      name              = string
      node_type         = optional(string)
      pod_id            = optional(string)
      role              = optional(string)
      serial            = string
      tags              = optional(string)
      two_slot_leaf     = optional(bool)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccPortP"
 - Distinguished Name: "uni/infra/accportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_interface_profile" "leaf_interface_profiles" {
  for_each    = local.leaf_profiles
  annotation  = each.value.tags
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_port_selector" "leaf_interface_selectors" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_leaf_access_port_policy_group.policy_groups,
    aci_leaf_breakout_port_group.policy_groups,
    aci_leaf_access_bundle_policy_group.policy_groups
  ]
  for_each                  = local.leaf_interface_selectors
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_interface_profiles[each.value.key1].id
  description               = each.value.selector_description
  name                      = each.value.interface_name
  access_port_selector_type = "range"
  relation_infra_rs_acc_base_grp = length(
    regexall("access", each.value.port_type)
    ) > 0 && each.value.interface_policy_group != "" ? aci_leaf_access_port_policy_group.policy_groups[
    each.value.interface_policy_group].id : length(regexall("breakout", each.value.port_type)
    ) > 0 && each.value.interface_policy_group != "" ? aci_leaf_breakout_port_group.policy_groups[
    each.value.interface_policy_group].id : length(regexall("(port-channel|vpc)", each.value.port_type)
    ) > 0 && each.value.interface_policy_group != "" ? aci_leaf_access_bundle_policy_group.policy_groups[
    each.value.interface_policy_group
  ].id : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortBlk"
 - Distinguished Name: " uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range/portblk-{interface_selector}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_port_block" "leaf_port_blocks" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_access_port_selector.leaf_interface_selectors
  ]
  for_each                = { for k, v in local.leaf_interface_selectors : k => v if v.sub_port == "" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  description             = each.value.interface_description
  from_card               = each.value.module
  from_port               = each.value.port
  name                    = each.value.interface_name
  to_card                 = each.value.module
  to_port                 = each.value.port
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortBlk"
 - Distinguished Name: " uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-{selector_type}/portblk-{interface_selector}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_sub_port_block" "leaf_port_subblocks" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_access_port_selector.leaf_interface_selectors
  ]
  for_each                = { for k, v in local.leaf_interface_selectors : k => v if v.sub_port != "" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  description             = each.value.interface_description
  from_card               = each.value.module
  from_port               = each.value.port
  from_sub_port           = each.value.sub_port
  name                    = each.value.interface_name
  to_card                 = each.value.module
  to_port                 = each.value.port
  to_sub_port             = each.value.sub_port
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraLeafS"
 - Distinguished Name: "uni/infra/nprof-{Name}"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Profiles > {Name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_profile" "leaf_profiles" {
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles
  ]
  for_each    = local.leaf_profiles
  annotation  = each.value.tags
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
  # relation_infra_rs_acc_port_p = [
  #   aci_leaf_interface_profile.leaf_interface_profiles[each.key].id
  # ]
}

resource "aci_rest" "leaf_profile_to_leaf_interface_profile" {
  provider = netascode
  depends_on = [
    aci_leaf_interface_profile.leaf_interface_profiles,
    aci_leaf_profile.leaf_profiles
  ]
  for_each   = local.leaf_profiles
  dn         = "${aci_leaf_profile.leaf_profiles[each.key].id}/rsaccPortP-[${aci_leaf_interface_profile.leaf_interface_profiles[each.key].id}]"
  class_name = "infraRsAccPortP"
  content = {
    tDn = aci_leaf_interface_profile.leaf_interface_profiles[each.key].id
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraLeafS"
 - Class: "infraRsAccNodePGrp"
 - Distinguished Name: "uni/infra/nprof-{name}/leaves-{selector_name}-typ-range"
GUI Location:
 - Fabric > Access Policies > Switches > Leaf Switches > Profiles > {name}: Leaf Selectors Policy Group: {selector_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "leaf_selectors" {
  provider = netascode
  depends_on = [
    aci_leaf_profile.leaf_profiles,
    aci_access_switch_policy_group.leaf_policy_groups
  ]
  for_each   = local.leaf_profiles
  dn         = "${aci_leaf_profile.leaf_profiles[each.key].id}/leaves-${each.value.name}-typ-range"
  class_name = "infraLeafS"
  content = {
    # annotation = each.value.tags
    descr     = each.value.description
    name      = each.value.name
    nameAlias = each.value.alias
  }
}

resource "aci_rest" "leaf_profile_policy_group" {
  provider   = netascode
  for_each   = local.leaf_profiles
  dn         = "${aci_rest.leaf_selectors[each.key].dn}/rsaccNodePGrp"
  class_name = "infraRsAccNodePGrp"
  content = {
    tDn = aci_access_switch_policy_group.leaf_policy_groups[each.value.leaf_policy_group].id
  }
}

resource "aci_rest" "leaf_profile_blocks" {
  provider   = netascode
  for_each   = local.leaf_profiles
  dn         = "${aci_rest.leaf_selectors[each.key].dn}/nodeblk-blk${each.key}-${each.key}"
  class_name = "infraNodeBlk"
  content = {
    name  = "blk${each.key}-${each.key}"
    from_ = each.key
    to_   = each.key
  }
}

# resource "aci_leaf_selector" "leaf_selectors" {
#   depends_on = [
#     aci_leaf_profile.leaf_profiles,
#     aci_access_switch_policy_group.leaf_policy_groups
#   ]
#   for_each                         = local.leaf_profiles
#   leaf_profile_dn                  = aci_leaf_profile.leaf_profiles[each.key].id
#   name                             = each.value.name
#   switch_association_type          = "range"
#   annotation                       = each.value.tags
#   description                      = each.value.description
#   name_alias                       = each.value.alias
#   relation_infra_rs_acc_node_p_grp = aci_access_switch_policy_group.leaf_policy_groups[each.value.leaf_policy_group].id
# }
