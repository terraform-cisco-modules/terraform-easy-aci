#------------------------------------------
# Create Spine Port Policy Groups
#------------------------------------------

variable "spine_port_policy_groups" {
  default = {
    "default" = {
      aep_policy        = "**REQUIRED**"
      alias             = ""
      cdp_policy        = "default"
      description       = ""
      link_level_policy = "default"
      macsec_policy     = "default"
    }
  }
  description = <<-EOT
  key - Name of the Spine Interface Policy Group.
    * aep_policy: Name of the Access Entity Profile Policy.  An Attached Entity Profile (AEP) provides a template to deploy hypervisor policies or application EPGs on a large set of ports.
    * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    * cdp_policy: Name of the CDP Policy.  Cisco Discovery Protocol (CDP) policy to obtain protocol addresses of neighboring devices and discover the platform of these devices.
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    * link_level_policy: Name of the Link Level Policy.  Link Level policy specifies Layer 1 parameters for host facing ports.
    * macsec_policy: Name of the MACsec Policy.  
  EOT
  type = map(object(
    {
      aep_policy        = string
      alias             = optional(string)
      cdp_policy        = optional(string)
      description       = optional(string)
      link_level_policy = optional(string)
      macsec_policy     = optional(string)
    }
  ))
}

/*
API Information:
 - Class: "infraSpAccPortGrp"
 - Distinguished Name: "uni/infra/funcprof/spaccportgrp-{name}"
GUI Location:
 - Fabric > Interfaces > Spine Interfaces > Policy Groups > {name}
*/
resource "aci_spine_port_policy_group" "spine_port_policy_groups" {
  depends_on = [
    aci_attachable_access_entity_profile.aep_policies,
    aci_cdp_interface_policy.cdp_interface_policies,
    aci_fabric_if_pol.link_level_policies,
  ]
  for_each    = local.spine_port_policy_groups
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  # class: infraAttEntityP
  # DN: "uni/infra/attentp-{aep_policy}"
  relation_infra_rs_att_ent_p = length(
    regexall("[a-zA-Z0-9]", coalesce(each.value.aaep_policy, "_EMPTY"))
  ) > 0 ? aci_attachable_access_entity_profile.aaep_policies[each.value.aaep_policy].id : ""
  # class: cdpIfPol
  # DN: "uni/infra/cdpIfP-{cdp_policy}"
  relation_infra_rs_cdp_if_pol = length(
    regexall("[a-zA-Z0-9]", coalesce(each.value.cdp_policy, "_EMPTY"))
  ) > 0 ? aci_cdp_interface_policy.cdp_interface_policies[each.value.cdp_policy].id : ""
  # class: fabricHIfPol
  # DN: "uni/infra/hintfpol-{{Link_Level}}"
  relation_infra_rs_h_if_pol = length(
    regexall("[a-zA-Z0-9]", coalesce(each.value.link_level_policy, "_EMPTY"))
  ) > 0 ? aci_fabric_if_pol.link_level_policies[each.value.link_level_policy].id : ""
  # class: macsecIfPol
  # DN: "uni/infra/macsecifp-{{MACsec}}"
  relation_infra_rs_macsec_if_pol = length(
    regexall("[a-zA-Z0-9]", coalesce(each.value.macsec_policy, "_EMPTY"))
  ) > 0 ? "uni/infra/macsecifp-${macsec_policy}" : ""
}
