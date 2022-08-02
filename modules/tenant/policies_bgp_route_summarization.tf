/*_____________________________________________________________________________________________________________________

Tenant — Policies — BGP Route Summarization — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bgp_route_summarization" {
  default = {
    "default" = {
      annotation                  = ""
      description                 = ""
      generate_as_set_information = false
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                      = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BGP Route Summarization Policies
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * attrmap: (optional) — Summary attribute map.
    * generate_as_set_information — (optional) Generate AS-SET information.  Options are:
      - false: (default)
      - true
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation                  = optional(string)
      description                 = optional(string)
      generate_as_set_information = optional(bool)
      name                        = optional(string)
      tenant                      = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpRtSummPol"
 - Distinguised Name: "uni/tn-{name}/bgprtsum-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > BGP > BGP Route Summarization > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bgp_route_summarization" "policies_bgp_route_summarization" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.policies_bgp_route_summarization
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  # attrmap     = each.value.attrmap
  ctrl        = each.value.generate_as_set_information == true ? "as-set" : "none"
  description = each.value.description
  name        = each.key
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
