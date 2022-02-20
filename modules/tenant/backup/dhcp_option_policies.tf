resource "aci_dhcp_option_policy" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "dhcp_option" {
    for_each = each.value.dhcp_options
    content {
      annotation     = each.value.annotation
      data           = each.value.data
      dhcp_option_id = each.value.dhcp_option_id
      name           = each.value.name
      name_alias     = each.value.name_alias
    }
  }
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent Tenant object.
# name - (Required) Name of Object DHCP Option Policy.
# annotation - (Optional) Annotation for object DHCP Option Policy.
# description - (Optional) Description for object DHCP Option Policy.
# name_alias - (Optional) Name name_alias for object DHCP Option Policy.
# dhcp_option - (Optional) To manage DHCP Option from the DHCP Option Policy resource. It has the attributes like name, annotation,data,dhcp_option_id and name_alias.
# dhcp_option.name - (Required) Name of Object DHCP Option.
# dhcp_option.annotation - (Optional) Annotation for object DHCP Option.
# dhcp_option.data - (Optional) DHCP Option data.
# dhcp_option.dhcp_option_id - (Optional) DHCP Option id (Unsigned Integer).
# dhcp_option.name_alias - (Optional) Name name_alias for object DHCP Option.