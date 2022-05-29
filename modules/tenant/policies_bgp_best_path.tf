variable "bgp_best_path_policies" {
  default = {
    "default" = {
      alias                     = ""
      annotation                = ""
      description               = ""
      relax_as_path_restriction = false
      tenant                    = "common"
    }
  }
  description = <<-EOT
  Key - Name of the BGP Best Path Policies
  * alias - (Optional) Name alias for object BGP Best Path Policy.
  * tenant_dn - (Required) Distinguished name of parent tenant object.
  * annotation - (Optional) Annotation for object BGP Best Path Policy.
  * description - (Optional) Description for object BGP Best Path Policy.
  * relax_as_path_restriction - (Optional) The control state.  Allowed values: "asPathMultipathRelax", "0". Default Value: "0".
  * tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias                     = optional(string)
      annotation                = optional(string)
      description               = optional(string)
      relax_as_path_restriction = optional(bool)
      tenant                    = optional(string)
    }
  ))
}

resource "aci_bgp_best_path_policy" "bgp_best_path_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.bgp_best_path_policies
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl        = each.value.relax_as_path_restriction == true ? "asPathMultipathRelax" : "0"
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
