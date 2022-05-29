/*_____________________________________________________________________________________________________________________

Physical Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "domains_physical" {
  default = {
    "default" = {
      annotation = ""
      vlan_pool  = ""
    }
  }
  description = <<-EOT
  Key: Name of the Physical Domain.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * vlan_pool: Name of the VLAN Pool to Associate to the Domain.
  EOT
  type = map(object(
    {
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
resource "aci_physical_domain" "domains_physical" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each                  = local.domains_physical
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.pools_vlan[each.value.vlan_pool].id
}
