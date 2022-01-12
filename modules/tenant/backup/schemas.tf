resource "mso_schema" "schemas" {
  name          = each.value.name
  template_name = each.value.template
  tenant_id     = mso_tenant.tenants[each.value.tenant].id
}