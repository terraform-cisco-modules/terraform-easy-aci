/*_____________________________________________________________________________________________________________________

Global — Attachable Access Entity Profile — Variables
_______________________________________________________________________________________________________________________
*/
variable "global_attachable_access_entity_profiles" {
  default = {
    "default" = {
      annotation       = ""
      description      = ""
      layer3_domains   = []
      physical_domains = []
      vmm_domains      = []
    }
  }
  description = <<-EOT
    Key — Name of the Attachable Access Entity Profile Policy.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description — Description to add to the Object.  The description can be up to 128 characters.
    * layer3_domains — A List of Layer3 Domains to Attach to this AAEP Policy.
    * physical_domains — A List of Physical Domains to Attach to this AAEP Policy.
    * vmm_domains — A List of Virtual Domains to Attach to this AAEP Policy.
  EOT
  type = map(object(
    {
      annotation       = optional(string)
      description      = optional(string)
      layer3_domains   = optional(list(string))
      physical_domains = optional(list(string))
      vmm_domains      = optional(list(string))
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_attachable_access_entity_profile" "global_attachable_access_entity_profiles" {
  depends_on = [
    aci_l3_domain_profile.domains_layer3,
    aci_physical_domain.domains_physical,
    aci_vmm_domain.domains_vmm
  ]
  for_each                = local.global_attachable_access_entity_profiles
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  description             = each.value.description
  name                    = each.key
  relation_infra_rs_dom_p = each.value.domains
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraGeneric"
 - Distinguished Name: "uni/infra/attentp-{name}/gen-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}: Application EPGs
_______________________________________________________________________________________________________________________
*/
resource "aci_access_generic" "access_generic" {
  depends_on = [
    aci_attachable_access_entity_profile.global_attachable_access_entity_profiles
  ]
  for_each                            = local.global_attachable_access_entity_profiles
  annotation                          = each.value.annotation != "" ? each.value.annotation : var.annotation
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.global_attachable_access_entity_profiles[each.key].id
  name                                = "default"
}
