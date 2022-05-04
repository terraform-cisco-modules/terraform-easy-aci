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
