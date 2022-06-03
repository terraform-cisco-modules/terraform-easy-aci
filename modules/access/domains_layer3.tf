/*_____________________________________________________________________________________________________________________

Layer 3 Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "domains_layer3" {
  default = {
    "default" = {
      annotation = ""
      vlan_pool  = ""
    }
  }
  description = <<-EOT
    Key — Name of the Layer 3 Domain.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * vlan_pool — The Name of the VLAN Pool to Associate to the Domain.
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
 - Class: "l3extDomP"
 - Distinguished Name: "uni/l3dom-{{name}}"
GUI Location:
 - Fabric > Access Policies > Physical and External Domains > L3 Domains: {{name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_domain_profile" "domains_layer3" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each                  = local.domains_layer3
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                      = each.key
  relation_infra_rs_vlan_ns = aci_vlan_pool.pools_vlan[each.value.vlan_pool].id
}
