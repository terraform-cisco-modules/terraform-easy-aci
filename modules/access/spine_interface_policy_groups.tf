/*_____________________________________________________________________________________________________________________

Spine Interface Policy Group Variables
_______________________________________________________________________________________________________________________
*/
variable "spine_interface_policy_groups" {
  default = {
    "default" = {
      attachable_entity_profile = "**REQUIRED**"
      annotation                = ""
      cdp_interface_policy      = "default"
      description               = ""
      global_alias              = ""
      link_level_policy         = "default"
      macsec_policy             = "default"
    }
  }
  description = <<-EOT
  key - Name of the Spine Interface Policy Group.
  * attachable_entity_profile: Name of the Access Entity Profile Policy.  An Attached Entity Profile (AEP) provides a template to deploy hypervisor policies or application EPGs on a large set of ports.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * cdp_interface_policy: Name of the CDP Interface Policy.  Cisco Discovery Protocol (CDP) policy to obtain protocol addresses of neighboring devices and discover the platform of these devices.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  * link_level_policy: Name of the Link Level Policy.  Link Level policy specifies Layer 1 parameters for host facing ports.
  * macsec_policy: Name of the MACsec Policy.  
  EOT
  type = map(object(
    {
      attachable_entity_profile = string
      annotation                = optional(string)
      cdp_interface_policy      = optional(string)
      description               = optional(string)
      global_alias              = optional(string)
      link_level_policy         = optional(string)
      macsec_policy             = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSpAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/spaccportgrp-{name}"
GUI Location:
 - Fabric > Interfaces > Spine Interfaces > Policy Groups > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spine_port_policy_group" "spine_interface_policy_groups" {
  depends_on = [
    aci_attachable_access_entity_profile.aaep_policies,
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_fabric_if_pol.link_level_policies,
  ]
  for_each    = local.spine_interface_policy_groups
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  # class: infraAttEntityP
  relation_infra_rs_att_ent_p = length(compact([each.value.attachable_entity_profile])
  ) > 0 ? "uni/infra/attentp-${each.value.attachable_entity_profile}" : ""
  # class: cdpIfPol
  relation_infra_rs_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  # class: fabricHIfPol
  relation_infra_rs_h_if_pol = length(compact([each.value.link_level_policy])
  ) > 0 ? "uni/infra/hintfpol-${each.value.link_level_policy}" : ""
  # class: macsecIfPol
  relation_infra_rs_macsec_if_pol = length(compact([each.value.macsec_policy])
  ) > 0 ? "uni/infra/macsecifp-${each.value.macsec_policy}" : ""
}
