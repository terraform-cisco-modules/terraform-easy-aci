variable "application_profiles" {
  default = {
    "default" = {
      annotation        = ""
      controller_type   = "apic"
      description       = ""
      monitoring_policy = ""
      name_alias        = ""
      qos_class         = "unspecified"
      sites             = []
      schema            = ""
      template          = "common"
      tenant            = "common"
    }
  }
  description = <<-EOT
  Key: Name of the Application Profile.
  * controller_type: (Required) - The type of controller.  Options are:
    - apic: For APIC Controllers.
    - ndo: For Nexus Dashboard Orchestrator.
  APIC Specific Attributes:
  * annotation: (Optional) - A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: (Optional) - Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * monitoring_poicy: (Optional) - Default is default.  To keep it simple the monitoring policy must be in the common Tenant.
  * name_alias: (Optional) - A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  * qos_class: (Optional) - Default is unspecified.  The priority class identifier. Allowed values are "unspecified", "level1", "level2", "level3", "level4", "level5" and "level6".
  NDO Specific Attributes:
  * schema: (Required) - Schema Name the Template is assigned to.
  * sites: (Optional) - Name of the Site to assign the Application Profile to if doing a Site specific assignment.
  * template: (Required) - Name of the Template to assign the Application Profile to.
  EOT
  type = map(object(
    {
      annotation        = optional(string)
      controller_type   = optional(string)
      description       = optional(string)
      monitoring_policy = optional(string)
      name_alias        = optional(string)
      qos_class         = optional(string)
      schema            = optional(string)
      sites             = optional(list(string))
      template          = optional(string)
      tenant            = optional(string)
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
  for_each                  = { for k, v in local.application_profiles : k => v if v.controller_type == "apic" }
  tenant_dn                 = aci_tenant.tenants[each.value.tenant].id
  annotation                = each.value.annotation
  description               = each.value.description
  name                      = each.key
  name_alias                = each.value.name_alias
  prio                      = each.value.qos_class
  relation_fv_rs_ap_mon_pol = each.value.monitoring_policy != "" ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
}

resource "mso_schema_template_anp" "application_profiles" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
    mso_schema_template.templates
  ]
  for_each     = { for k, v in local.application_profiles : k => v if v.controller_type == "ndo" }
  display_name = each.key
  name         = each.key
  schema_id    = mso_schema.schemas[each.value.schema].id
  template     = each.value.template
}

resource "mso_schema_site_anp" "application_profiles" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
    mso_schema_template.templates
  ]
  for_each      = { for k, v in local.application_profiles : k => v if v.controller_type == "ndo" && v.sites != [] }
  anp_name      = each.key
  schema_id     = mso_schema.schemas[each.value.schema].id
  site_id       = data.mso_site.sites[each.value.site].id
  template_name = each.value.template
}
