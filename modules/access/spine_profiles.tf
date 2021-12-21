#------------------------------------------
# Create Spine 
#  - Spine Profiles
#  - Interface Profiles
#    - Interface Selectors
#  - Spine Policy Groups
#------------------------------------------

variable "spine_profiles" {
  default = {
    "default" = {
      alias              = ""
      description        = ""
      name               = "**REQUIRED**"
      spine_policy_group = "**REQUIRED**"
      pod_id             = "1"
      serial             = "**REQUIRED**"
      tags               = ""
      interfaces = {
        "default" = {
          interface_description  = ""
          interface_policy_group = "default"
          selector_description   = ""
        }
      }
    }
  }
  description = <<-EOT
  key - Node ID of the Spine
    * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    * name: Hostname of the Spine plus Name of the Spine Profile, Spine Interface Profile, and Spine Profile Selector.
    * interfaces:
      - Key: The Name of the Interface Selector.  This Must be in the format of X/X for a regular spine port or X/X/X for a breakout sub port.
        * interface_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
        * interface_policy_group: Name of the Interface Policy Group
        * selector_description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    * pod_id: Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.
    * serial: Manufacturing Serial Number of the Switch.
    * tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  EOT
  type = map(object(
    {
      alias              = optional(string)
      description        = optional(string)
      name               = string
      spine_policy_group = string
      node_type          = optional(string)
      pod_id             = optional(string)
      serial             = string
      tags               = optional(string)
      interfaces = map(object(
        {
          interface_description  = optional(string)
          interface_policy_group = optional(string)
          port_type              = optional(string)
          selector_description   = optional(string)
        }
      ))
    }
  ))
}


/*
API Information:
 - Class: "infraSpAccPortP"
 - Distinguished Name: "uni/infra/spaccportprof-{name}"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {name}
*/
resource "aci_spine_interface_profile" "spine_interface_profiles" {
  for_each    = local.spine_profiles
  annotation  = each.value.tags
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
}


/*
API Information:
 - Class: "infraHPortS"
 - Distinguished Name: "uni/infra/accportprof-{interface_profile}/hports-{interface_selector}-typ-range"
GUI Location:
 - Fabric > Access Policies > Interfaces > Spine Interfaces > Profiles > {interface_profile}:{interface_selector}
*/
resource "aci_rest" "spine_interface_selectors" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each   = local.spine_interface_selectors
  path       = "/api/node/mo/uni/infra/spaccportprof-${each.value.name}/shports-${each.value.name}-typ-range.json"
  class_name = "infraSHPortS"
  payload    = <<EOF
{
    "infraSHPortS": {
        "attributes": {
            "descr": "${each.value.selector_description}",
            "dn": "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.name}-typ-range",
            "name": "${each.value.name}",
        },
        "children": [
            {
                "infraPortBlk": {
                    "attributes": {
                        "descr": "${each.value.interface_description}",
                        "dn": "uni/infra/spaccportprof-${each.value.name}/shports-${each.value.name}-typ-range/portblk-${each.value.name}",
                        "fromCard": "${each.value.module}",
                        "fromPort": "${each.value.port}",
                        "toCard": "${each.value.module}",
                        "toPort": "${each.value.port}",
                        "name": "${each.value.name}",
                    }
                }
            },
            {
                "infraRsSpAccGrp": {
                    "attributes": {
                        "tDn": "uni/infra/funcprof/spaccportgrp-${each.value.policy_group}"
                    }
                }
            }
        ]
    }
}
    EOF
}


/*
API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/nprof-{Name}"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {Name}
*/
resource "aci_spine_profile" "spine_profiles" {
  depends_on = [
    aci_spine_interface_profile.spine_interface_profiles
  ]
  for_each    = local.spine_profiles
  annotation  = each.value.tags
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.alias
  relation_infra_rs_acc_port_p = [
    aci_spine_interface_profile.spine_interface_profiles[each.key].id
  ]
}


/*
API Information:
 - Class: "infraSpineS"
 - Distinguished Name: "uni/infra/spprof-{name}/spines-{name}-typ-range"
GUI Location:
 - Fabric > Access Policies > Switches > Spine Switches > Profiles > {name}: Spine Selectors [{name}]
*/
resource "aci_spine_switch_association" "spine_profile_assocations" {
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_policy_group.spine_policy_groups
  ]
  for_each         = local.spine_profile_assocations
  spine_profile_dn = aci_spine_profile.spine_profiles[each.key].id
  # description                             = each.value.description
  name                                   = each.value.name
  name_alias                             = each.value.alias
  relation_infra_rs_spine_acc_node_p_grp = aci_spine_switch_policy_group.spine_policy_groups[each.value.spine_policy_group].id
  spine_switch_association_type          = "range"
}

resource "aci_rest" "spine_profile_node_blocks" {
  depends_on = [
    aci_spine_profile.spine_profiles,
    aci_spine_switch_association.spine_profile_assocations
  ]
  for_each   = local.spine_profile_node_blocks
  path       = "/api/node/mo/uni/infra/spprof-${each.value.name}/spines-${each.value.name}-typ-range/nodeblk-blk${each.key}-${each.key}.json"
  class_name = "infraNodeBlk"
  payload    = <<EOF
{
    "infraNodeBlk": {
        "attributes": {
            "dn": "uni/infra/spprof-${each.value.name}/spines-${each.value.name}-typ-range/nodeblk-blk${each.key}-${each.key}",
            "from_": "${each.key}",
            "to_": "${each.key}",
            "name": "blk${each.key}-${each.key}",
        },
        "children": []
    }
}
  EOF
}
