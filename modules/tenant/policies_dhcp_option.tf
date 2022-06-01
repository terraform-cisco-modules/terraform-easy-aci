variable "policies_dhcp_option" {
  default = {
    "default" = {
      alias       = ""
      annotation  = ""
      description = ""
      options     = []
      tenant      = "common"
    }
  }
  description = <<-EOT
  Argument Reference
  tenant - (Required) Name of parent Tenant object.
  name - (Required) Name of Object DHCP Option Policy.
  annotation - (Optional) Annotation for object DHCP Option Policy.
  description - (Optional) Description for object DHCP Option Policy.
  name_alias - (Optional) Name name_alias for object DHCP Option Policy.
  dhcp_option - (Optional) To manage DHCP Option from the DHCP Option Policy resource. It has the attributes like name, annotation,data,dhcp_option_id and name_alias.
  dhcp_option.name - (Required) Name of Object DHCP Option.
  dhcp_option.annotation - (Optional) Annotation for object DHCP Option.
  dhcp_option.data - (Optional) DHCP Option data.
  dhcp_option.dhcp_option_id - (Optional) DHCP Option id (Unsigned Integer).
  dhcp_option.name_alias - (Optional) Name name_alias for object DHCP Option.
  EOT
  type = map(object(
    {
      alias       = optional(string)
      annotation  = optional(string)
      description = optional(string)
      options = optional(list(object(
        {
          alias          = optional(string)
          annotation     = optional(string)
          data           = string
          dhcp_option_id = string
          name           = string
        }
      )))
      tenant = optional(string)
    }
  ))
}
resource "aci_dhcp_option_policy" "policies_dhcp_option" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.policies_dhcp_option
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "dhcp_option" {
    for_each = each.value.options
    content {
      annotation     = dhcp_option.value.annotation
      data           = dhcp_option.value.data
      dhcp_option_id = dhcp_option.value.dhcp_option_id
      name           = dhcp_option.value.name
      name_alias     = dhcp_option.value.alias
    }
  }
}
