/*_____________________________________________________________________________________________________________________

Tenant — Policies — OSPF Route Summarization — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_ospf_route_summarization" {
  default = {
    "default" = {
      annotation         = ""
      cost               = 0
      description        = ""
      inter_area_enabled = false
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant             = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the OSPF Route Summarization Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * cost: (default: 0) — The OSPF Area cost for the default summary LSAs. The Area cost is used with NSSA and stub area types only. Range of allowed values is "0" to "16777215". Default value: "unspecified".
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * inter_area_enabled: (optional) — Inter area enabled flag for object OSPF route summarization. Allowed values:
      - false: (default)
      - true
    * tag: (default: 0) — The color of a policy label.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation         = optional(string)
      cost               = optional(number)
      description        = optional(string)
      inter_area_enabled = optional(bool)
      tenant             = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfRtSummPol"
 - Distinguished Name: "/uni/tn-{tenant}/ospfrtsumm-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > OSPF >  OSPF Route Summarization > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_ospf_route_summarization" "policies_ospf_route_summarization" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each           = local.policies_ospf_route_summarization
  annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
  cost               = each.value.cost == 0 ? "unspecified" : each.value.cost # 0 to 16777215
  description        = each.value.description
  inter_area_enabled = each.value.inter_area_enabled == true ? "yes" : "no"
  name               = each.key
  tag                = 0
  tenant_dn          = aci_tenant.tenants[each.value.tenant].id
}
