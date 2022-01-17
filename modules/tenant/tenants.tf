
variable "tenants" {
  default = {
    "default" = {
      alias             = ""
      annotation        = ""
      description       = ""
      monitoring_policy = ""
      sites             = []
      type              = "apic" # apic or ndo
      users             = []
      vendor            = "cisco"
    }
  }
  description = <<-EOT
  Key: Name of the Tenant.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * type: What is the type of controller.  Options are:
    - apic: For APIC Controllers
    - ndo: For Nexus Dashboard Orchestrator
  * vendor: When using Nexus Dashboard Orchestrator the vendor attribute is used to distinguish the cloud types.  Options are:
    - aws
    - azure
    - cisco (Default)
  EOT
  type = map(object(
    {
      alias             = optional(string)
      annotation        = optional(string)
      description       = optional(string)
      monitoring_policy = optional(string)
      sites             = optional(list(string))
      type              = optional(string)
      users             = optional(list(string))
      vendor            = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvTenant"
 - Distinguished Name: "uni/tn-{tenant}""
GUI Location:
 - Tenants > Create Tenant > {tenant}
_______________________________________________________________________________________________________________________
*/
resource "aci_tenant" "tenants" {
  for_each                      = { for k, v in local.tenants : k => v if v.type == "apic" }
  annotation                    = each.value.annotation
  description                   = each.value.description
  name                          = each.key
  name_alias                    = each.value.alias
  relation_fv_rs_tenant_mon_pol = each.value.monitoring_policy != "" ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
}

resource "mso_tenant" "tenants" {
  provider = mso
  depends_on = [
    data.mso_site.sites,
    data.mso_user.users
  ]
  for_each     = { for k, v in local.tenants : k => v if v.type == "ndo" && v.vendor == "cisco" }
  name         = each.key
  display_name = each.key
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
      keys(aci_tenant.tenants)
    ) : v => aci_tenant.tenants[v].id } : {}
    ndo_tenants = var.tenants != {} ? { for v in sort(
      keys(mso_tenant.tenants)
    ) : v => mso_tenant.tenants[v].id } : {}
  }
}
