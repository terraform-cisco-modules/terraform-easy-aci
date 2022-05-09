/*_____________________________________________________________________________________________________________________

Switch Profile Variables
_______________________________________________________________________________________________________________________
*/
variable "switch_profiles" {
  default = {
    "default" = {
      annotation        = ""
      description       = ""
      external_pool_id  = 0
      inband_addressing = []
      /* Example
      inband_addressing = [
        {
          ipv4_address   = ""
          ipv4_gateway   = ""
          ipv6_address   = ""
          ipv6_gateway   = ""
          management_epg = "default"
        }
      ] */
      interfaces = [
        {
          description           = ""
          interface_description = ""
          name                  = "1/1"
          policy_group          = ""
          port_type             = "access"
          sub_port              = false
        }
      ]
      monitoring_policy = "default"
      name              = "**REQUIRED**"
      node_type         = "leaf"
      ooband_addressing = []
      /* Exmaple
      ooband_addressing = [
        {
          ipv4_address   = "198.18.2.101/24"
          ipv4_gateway   = "198.18.2.1"
          ipv6_address   = "2001::2:101/64"
          ipv6_gateway   = "2001::1"
          management_epg = "default"
        }
      ] */
      policy_group  = "**REQUIRED**"
      pod_id        = 1
      serial        = "**REQUIRED**"
      two_slot_leaf = false
    }
  }
  description = <<-EOT
  key - Node ID of the Leaf or Spine
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
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
  * pod_id: Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.
  * serial: Manufacturing Serial Number of the Switch.
  * two_slot_leaf: Flag to Tell the Script this is a Leaf with more than 99 ports.  It will Name Leaf Selectors as Eth1-001 instead of Eth1-01.
  EOT
  type = map(object(
    {
      annotation       = optional(string)
      description      = optional(string)
      external_pool_id = optional(number)
      inband_addressing = optional(list(object(
        {
          ipv4_address   = optional(string)
          ipv4_gateway   = optional(string)
          ipv6_address   = optional(string)
          ipv6_gateway   = optional(string)
          management_epg = optional(string)
        }
      )))
      interfaces = list(object(
        {
          interface_description = optional(string)
          name                  = string
          policy_group          = optional(string)
          port_type             = optional(string)
          selector_description  = optional(string)
          sub_port              = optional(bool)
        }
      ))
      monitoring_policy = optional(string)
      name              = string
      node_type         = optional(string)
      ooband_addressing = optional(list(object(
        {
          ipv4_address   = optional(string)
          ipv4_gateway   = optional(string)
          ipv6_address   = optional(string)
          ipv6_gateway   = optional(string)
          management_epg = optional(string)
        }
      )))
      policy_group  = string
      pod_id        = optional(number)
      serial        = string
      two_slot_leaf = optional(bool)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNode"
 - Distinguished Name: "topology/pod-{pod_id}/node-{node_id}"
GUI Location:
 - Fabric > Access Policies > Inventory > Fabric Membership:[Registered Nodes or Nodes Pending Registration]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "fabric_membership" {
  for_each   = local.switch_profiles
  dn         = "uni/controller/nodeidentpol/nodep-${each.value.serial}"
  class_name = "fabricNodeIdentP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    extPoolId = each.value.node_type == "remote-leaf" ? each.value.external_pool_id : 0
    name      = each.value.name
    nodeId    = each.key
    nodeType = length(regexall(
      "remote-leaf", each.value.node_type)) > 0 ? "remote-leaf-wan" : length(regexall(
    "tier-2-leaf", each.value.node_type)) > 0 ? each.value.node_type : "unspecified"
    podId  = each.value.pod_id
    role   = each.value.node_type == "spine" ? "spine" : "leaf"
    serial = each.value.serial
  }
}

# resource "aci_fabric_node_member" "fabric_node_members" {
#   for_each    = local.fabric_node_members
#   ext_pool_id = each.value.external_pool_id
#   fabric_id   = 1
#   name        = each.value.name
#   node_id     = each.key
#   node_type   = each.value.node_type
#   pod_id      = each.value.pod_id
#   role        = each.value.role
#   serial      = each.value.serial
# }


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAccPortP"
 - Distinguished Name: "uni/infra/accportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Leaf Interfaces > Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_interface_profile" "leaf_interface_profiles" {
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
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
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  relation_infra_rs_acc_port_p = [
    aci_leaf_interface_profile.leaf_interface_profiles[each.key].id
  ]
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
resource "aci_leaf_selector" "leaf_selectors" {
  depends_on = [
    aci_leaf_profile.leaf_profiles,
    aci_access_switch_policy_group.leaf_policy_groups
  ]
  for_each                         = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation                       = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                      = each.value.description
  leaf_profile_dn                  = aci_leaf_profile.leaf_profiles[each.key].id
  name                             = each.value.name
  relation_infra_rs_acc_node_p_grp = aci_access_switch_policy_group.leaf_policy_groups[each.value.policy_group].id
  switch_association_type          = "range"
}

resource "aci_node_block" "leaf_profile_blocks" {
  depends_on = [
    aci_leaf_selector.leaf_selectors
  ]
  for_each              = { for k, v in local.switch_profiles : k => v if v.node_type != "spine" }
  annotation            = each.value.annotation != "" ? each.value.annotation : var.annotation
  description           = each.value.description
  from_                 = each.key
  name                  = "blk${each.key}-${each.key}"
  switch_association_dn = aci_leaf_selector.leaf_selectors[each.key].id
  to_                   = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpAccPortP"
 - Distinguished Name: "uni/infra/spaccportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_interface_profile" "spine_interface_profiles" {
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/nprof-{Name}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {Name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_profile" "spine_profiles" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each    = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  relation_infra_rs_sp_acc_port_p = [
    aci_spine_interface_profile.spine_interface_profiles[each.key].id
  ]
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/spprof-{name}/spines-{name}-typ-range"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {name}: Spine Selectors [{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_switch_association" "spine_profiles" {
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_policy_group.spine_policy_groups
  ]
  for_each                               = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  annotation                             = each.value.annotation != "" ? each.value.annotation : var.annotation
  spine_profile_dn                       = aci_spine_profile.spine_profiles[each.key].id
  description                            = each.value.description
  name                                   = each.value.name
  relation_infra_rs_spine_acc_node_p_grp = aci_spine_switch_policy_group.spine_policy_groups[each.value.policy_group].id
  spine_switch_association_type          = "range"
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraNodeBlk"
 - Distinguished Name: "uni/infra/spprof-{name}/spines-{name}-typ-range/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {name}: Spine Selectors [{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spine_profile_node_blocks" {
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_association.spine_profiles
  ]
  for_each   = { for k, v in local.switch_profiles : k => v if v.node_type == "spine" }
  dn         = "uni/infra/spprof-${each.value.name}/spines-${each.value.name}-typ-range/nodeblk-blk${each.key}-${each.key}"
  class_name = "infraNodeBlk"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    from_ = each.key
    to_   = each.key
    name  = "blk${each.key}-${each.key}"
  }
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
  for_each                  = { for k, v in local.interface_selectors : k => v if v.node_type != "spine" }
  leaf_interface_profile_dn = aci_leaf_interface_profile.leaf_interface_profiles[each.value.key1].id
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  description               = each.value.selector_description
  name                      = each.value.interface_name
  access_port_selector_type = "range"
  relation_infra_rs_acc_base_grp = length(regexall(
    "access", each.value.port_type)) > 0 && length(compact([each.value.interface_policy_group])
    ) > 0 ? aci_leaf_access_port_policy_group.policy_groups[each.value.interface_policy_group
    ].id : length(regexall(
    "breakout", each.value.port_type)) > 0 && length(compact([each.value.interface_policy_group])
    ) > 0 ? aci_leaf_breakout_port_group.policy_groups[each.value.interface_policy_group].id : length(regexall(
    "(port-channel|vpc)", each.value.port_type)) > 0 && length(compact([each.value.interface_policy_group])
  ) > 0 ? aci_leaf_access_bundle_policy_group.policy_groups[each.value.interface_policy_group].id : ""
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
  for_each                = { for k, v in local.interface_selectors : k => v if v.sub_port == "" && v.node_type != "spine" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
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
  for_each                = { for k, v in local.interface_selectors : k => v if v.sub_port != "" && v.node_type != "spine" }
  access_port_selector_dn = aci_access_port_selector.leaf_interface_selectors[each.key].id
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
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
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "spine_interface_selectors" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each   = { for k, v in local.interface_selectors : k => v if v.node_type == "spine" }
  dn         = "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.interface_name}-typ-range"
  class_name = "infraSHPortS"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name  = each.value.interface_name
    descr = each.value.selector_description
  }
  child {
    rn         = "portblk-${each.value.interface_name}"
    class_name = "infraPortBlk"
    content = {
      fromCard = each.value.module
      fromPort = each.value.port
      toCard   = each.value.module
      toPort   = each.value.port
      name     = each.value.interface_name
    }
  }
  child {
    rn         = "rsspAccGrp"
    class_name = "infraRsSpAccGrp"
    content = {
      tDn = "uni/infra/funcprof/spaccportgrp-${each.value.interface_policy_group}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtRsInBStNode" or "mgmtRsOoBStNode"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{management_epg}/rsinBStNode-[topology/pod-{pod_id}/node-{node_id}]"
 or
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{management_epg}/rsooBStNode-[topology/pod-{pod_id}/node-{node_id}]"
GUI Location:
 - Tenants > mgmt > Node Management Addresses > Static Node Management Addresses
_______________________________________________________________________________________________________________________
*/
resource "aci_static_node_mgmt_address" "static_node_mgmt_addresses" {
  depends_on = [
    aci_rest_managed.fabric_membership
  ]
  for_each          = local.static_node_mgmt_addresses
  management_epg_dn = "uni/tn-mgmt/mgmtp-default/${management_epg_type}-${management_epg}"
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
  type              = each.value.management_epg_type == "inb" ? "in_band" : "out_of_band"
  description       = each.value.description
  addr              = each.value.ipv4_address
  annotation        = each.value.annotation != "" ? each.value.annotation : var.annotation
  gw                = each.value.ipv4_gateway
  v6_addr           = each.value.ipv6_address
  v6_gw             = each.value.ipv6_gateway
}