variable "application_profiles" {
  default = {
    "default" = {
      alias             = ""
      annotation        = ""
      description       = ""
      monitoring_policy = ""
      qos_class         = "unspecified"
      schema            = ""
      template          = "common"
      tenant = "common"
      type              = "apic"
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
      qos_class         = optional(string)
      schema            = optional(string)
      template          = optional(string)
      tenant = optional(string)
      type              = optional(string)
      vendor            = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Location:
 - Class: "fvAp"
 - Distinguished Name: "uni/tn-[tenant]/ap-{application_profile}"
GUI Location:
 - Tenants > {tenant} > Application Profiles > {application_profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_application_profile" "application_profiles" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = { for k, v in local.application_profiles: k => v if v.type == "apic"}
  tenant_dn                  = aci_tenant.tenants[each.value.tenant].id
  annotation                 = each.value.annotation
  description                = each.value.description
  name                       = each.key
  name_alias                 = each.value.alias
  prio                       = each.value.qos_class
  relation_fv_rs_ap_mon_pol = each.value.monitoring_policy != "" ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
}
