variable "bgp_route_summarization_policies" {
  default = {
    "default" = {
      alias                       = ""
      annotation                  = ""
      description                 = ""
      generate_as_set_information = false
      tenant                      = "common"
    }
  }
  description = <<-EOT
  Key - Name of the BGP Route Summarization Policies
  * alias - (Optional) Name alias for object BGP route summarization.
  * annotation - (Optional) Annotation for object BGP route summarization.
  * attrmap - (Optional) Summary attribute map.
  * generate_as_set_information - (Boolean) Generate AS-SET information
  * description - (Optional) Description for object BGP route summarization.
  * tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias                       = optional(string)
      annotation                  = optional(string)
      description                 = optional(string)
      generate_as_set_information = optional(bool)
      name                        = optional(string)
      tenant                      = optional(string)
    }
  ))
}

resource "aci_bgp_route_summarization" "bgp_route_summarization_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.bgp_route_summarization_policies
  #annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  # attrmap     = each.value.attrmap
  ctrl        = each.value.generate_as_set_information == true ? "as-set" : "none"
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
