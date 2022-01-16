locals {
  #__________________________________________________________
  #
  # Tenant Variables
  #__________________________________________________________

  tenants = {
    for k, v in var.tenants : k => {
      alias             = v.alias != null ? v.alias : ""
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : ""
      name              = v.name != null ? v.name : "common"
      sites             = v.sites != null ? v.sites : []
      annotation        = v.annotation != null ? v.annotation : ""
      type              = v.type != null ? v.type : "apic"
      users             = v.users != null ? v.users : []
      vendor            = v.vendor != null ? v.vendor : "cisco"
    }
  }


  #__________________________________________________________
  #
  # Schema Variables
  #__________________________________________________________

  schemas = {
    for k, v in var.schemas : k => {
      primary_template = v.primary_template
      tenant           = v.tenant
      templates        = v.templates
    }
  }

  schema_templates_loop = flatten([
    for key, value in local.schemas : [
      for k, v in value.templates : {
        name   = v.name
        key1   = key
        schema = key
        sites  = v.sites
        tenant = value.tenant
      }
    ]
  ])

  schema_templates = { for k, v in local.schema_templates_loop : "${v.key1}_${v.name}" => v }


  templates_sites_loop = flatten([
    for k, v in local.schema_templates : [
      for s in v.sites : {
        name = v.name
        key1 = v.key1
        site = s
      }
    ]
  ])

  template_sites = { for k, v in local.templates_sites_loop : "${v.key1}_${v.site}" => v }

}