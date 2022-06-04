/*_____________________________________________________________________________________________________________________

Tenant — Policies — BGP Best Path — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bgp_best_path" {
  default = {
    "default" = {
      annotation                = ""
      description               = ""
      relax_as_path_restriction = false
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                    = local.folder_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BGP Best Path Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * relax_as_path_restriction: (optional) — The control state.  Allowed values:
      - false: (default)
      - true
    * tenant: (default: local.folder_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation                = optional(string)
      description               = optional(string)
      relax_as_path_restriction = optional(bool)
      tenant                    = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpBestPathCtrlPol"
 - Distinguised Name: "uni/tn-{name}/bestpath-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > BGP > BGP Best Path > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bgp_best_path_policy" "policies_bgp_best_path" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.policies_bgp_best_path
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl        = each.value.relax_as_path_restriction == true ? "asPathMultipathRelax" : "0"
  description = each.value.description
  name        = each.key
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
