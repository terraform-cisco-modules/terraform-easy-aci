
variable "tenants" {
  default = {
    "default" = {
      alias             = ""
      description       = ""
      monitoring_policy = ""
      name              = "common"
      sites             = []
      tags              = ""
      type              = "apic" # apic or ndo
      users             = []
      vendor            = "cisco"
    }
  }
  type = map(object(
    {
      alias             = optional(string)
      description       = optional(string)
      monitoring_policy = optional(string)
      name              = string
      sites             = optional(list(string))
      tags              = optional(string)
      type              = optional(string)
      users             = optional(list(string))
      vendor            = optional(string)
    }
  ))
}
/*
API Information:
 - Class: "fvTenant"
 - Distinguished Name: "uni/tn-{tenant}""
GUI Location:
 - Tenants > Create Tenant > {tenant}
*/
resource "aci_tenant" "apic_tenants" {
  for_each                      = { for k, v in local.tenants : k => v if v.type == "apic" }
  annotation                    = each.value.tags
  description                   = each.value.description
  name                          = each.value.name
  name_alias                    = each.value.alias
  relation_fv_rs_tenant_mon_pol = each.value.monitoring_policy != "" ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
}

resource "mso_tenant" "ndo_cisco_tenants" {
  provider = mso
  depends_on = [
    data.mso_site.sites,
    data.mso_user.users
  ]
  for_each     = { for k, v in local.tenants : k => v if v.type == "ndo" && v.vendor == "cisco" }
  name         = each.value.name
  display_name = each.value.name
  dynamic "site_associations" {
    for_each = toset(each.value.sites)
    content {
      site_id = data.mso_site.sites[site_associations.value].id
    }
  }
  dynamic "user_associations" {
    for_each = toset(each.value.users)
    content {
      user_id = data.mso_user.users[user_associations.value].id
    }
  }
}


output "tenants" {
  value = {
    apic_tenants = var.tenants != {} ? { for v in sort(
    keys(aci_tenant.apic_tenants)
    ) : v => aci_tenant.apic_tenants[v].id } : {}
    ndo_cisco_tenants = var.tenants != {} ? { for v in sort(
    keys(mso_tenant.ndo_cisco_tenants)
    ) : v => mso_tenant.ndo_cisco_tenants[v].id } : {}
  }
}
