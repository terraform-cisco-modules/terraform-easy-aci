variable "schemas" {
  default = {
    "default" = { # By default the default name will be local.first_tenant
      /* If undefined the variable of local.first_tenant will be used for:
      primary_template = local.first_tenant
      schema_tenant    = local.first_tenant
      */
      templates = [
        {
          /* If undefined the variable of local.first_tenant will be used for:
          name  = local.first_tenant
          */
          sites = ["site1", "site2"]
        }
      ]
    }
  }
  type = map(object(
    {
      primary_template = optional(string)
      schema_tenant    = optional(string)
      templates = list(object(
        {
          name  = optional(string)
          sites = list(string)
        }
      ))
    }
  ))
}
data "mso_schema" "schemas" {
  provider = mso
  depends_on = [
    mso_schema.schemas
  ]
  for_each = local.schemas
  name     = each.key

}

resource "mso_schema" "schemas" {
  provider = mso
  depends_on = [
    mso_tenant.tenants
  ]
  for_each      = { for k, v in local.schemas: k => v if v.tenant == local.first_tenant }
  name          = each.key
  tenant_id     = mso_tenant.tenants[each.value.tenant].id
  template_name = each.value.primary_template
}

resource "mso_schema_template" "templates" {
  provider = mso
  depends_on = [
    mso_schema.schemas
  ]
  for_each     = { for k, v in local.schema_templates : k => v if v.name != v.primary_template }
  display_name = each.value.name
  name         = each.value.name
  schema_id    = mso_schema.schemas[each.value.schema].id
  tenant_id    = mso_tenant.tenants[each.value.tenant].id
}

resource "mso_schema_site" "sites" {
  provider = mso
  depends_on = [
    mso_schema_template.templates
  ]
  for_each      = local.template_sites
  schema_id     = mso_schema.schemas[each.value.schema].id
  site_id       = data.mso_site.ndo_sites[each.value.site].id
  template_name = each.value.name
}

output "schemas" {
  value = {
    schemas = var.schemas != {} ? { for v in sort(
      keys(mso_schema.schemas)
    ) : v => mso_schema.schemas[v].id } : {}
    schema_templates = var.schemas != {} ? { for v in sort(
      keys(mso_schema_template.templates)
    ) : v => mso_schema_template.templates[v].id } : {}
    # schema_sites = var.schemas != {} ? { for v in sort(
    #   keys(mso_schema_site.sites)
    # ) : v => mso_schema_site.sites[v].id } : {}
  }
}
