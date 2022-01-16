/*_____________________________________________________________________________________________________________________

Spine Profile Variables
_______________________________________________________________________________________________________________________
*/
variable "spine_profiles" {
  default = {
    "default" = {
      alias       = ""
      description = ""
      interfaces = {
        "default" = {
          interface_description  = ""
          interface_policy_group = "default"
          selector_description   = ""
        }
      }
      monitoring_policy  = "default"
      name               = "**REQUIRED**"
      spine_policy_group = "**REQUIRED**"
      pod_id             = "1"
      serial             = "**REQUIRED**"
      annotation         = ""
    }
  }
  description = <<-EOT
  key - Node ID of the Spine
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * interfaces:
    - Key: The Name of the Interface Selector.  This Must be in the format of X/X for a regular spine port or X/X/X for a breakout sub port.
      * interface_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
      * interface_policy_group: Name of the Interface Policy Group
      * selector_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * monitoring_policy: Name of the Monitoring Policy to assign to the Fabric Node Member.
  * name: Hostname of the Spine plus Name of the Spine Profile, Spine Interface Profile, and Spine Profile Selector.
  * pod_id: Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.
  * serial: Manufacturing Serial Number of the Switch.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  EOT
  type = map(object(
    {
      alias       = optional(string)
      description = optional(string)
      interfaces = map(object(
        {
          interface_description  = optional(string)
          interface_policy_group = optional(string)
          port_type              = optional(string)
          selector_description   = optional(string)
        }
      ))
      monitoring_policy  = optional(string)
      name               = string
      spine_policy_group = string
      node_type          = optional(string)
      pod_id             = optional(string)
      serial             = string
      annotation         = optional(string)
    }
  ))
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
  for_each    = local.spine_profiles
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {interface_profile}:{interface_selector}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "spine_interface_selectors" {
  provider = netascode
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each   = local.spine_interface_selectors
  dn         = "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.interface_name}-typ-range"
  class_name = "infraSHPortS"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name       = each.value.interface_name
    descr      = each.value.selector_description
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
  for_each    = local.spine_profiles
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
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
  for_each                               = local.spine_profiles
  annotation                             = each.value.annotation != "" ? each.value.annotation : var.annotation
  spine_profile_dn                       = aci_spine_profile.spine_profiles[each.key].id
  description                            = each.value.description
  name                                   = each.value.name
  name_alias                             = each.value.alias
  relation_infra_rs_spine_acc_node_p_grp = aci_spine_switch_policy_group.spine_policy_groups[each.value.spine_policy_group].id
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
resource "aci_rest" "spine_profile_node_blocks" {
  provider = netascode
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_association.spine_profiles
  ]
  for_each   = local.spine_profiles
  dn         = "uni/infra/spprof-${each.value.name}/spines-${each.value.name}-typ-range/nodeblk-blk${each.key}-${each.key}"
  class_name = "infraNodeBlk"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    from_      = each.key
    to_        = each.key
    name       = "blk${each.key}-${each.key}"
  }
}
