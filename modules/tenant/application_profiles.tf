/*_____________________________________________________________________________________________________________________

Tenant — Application Profile — Variables
_______________________________________________________________________________________________________________________
*/
variable "application_profiles" {
  default = {
    "default" = {
      alias             = ""
      annotation        = ""
      annotations       = []
      controller_type   = "apic"
      description       = ""
      monitoring_policy = ""
      qos_class         = "unspecified"
      sites             = []
      /*  If undefined the variable of local.first_tenant will be used for:
      schema            = local.first_tenant
      template          = local.first_tenant
      tenant            = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key — Name of the Application Profile.
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * tenant: (default: local.first_tenant) — The name of the tenant to for the Application Profile.
    APIC Specific Attributes:
    * alias: (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    * monitoring_poicy: (default: default) — To keep it simple the monitoring policy must be in the common Tenant.
    * qos_class: (default: unspecified) — The priority class identifier. Allowed values are "unspecified", "level1", "level2", "level3", "level4", "level5" and "level6".
    NDO Specific Attributes:
    * schema: (required) - Schema Name.
    * sites: (optional) — List of Site Names to assign site specific attributes.
    * template: (required) - The Template name to create the object within.
  EOT
  type = map(object(
    {
      alias      = optional(string)
      annotation = optional(string)
      annotations = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      controller_type   = optional(string)
      description       = optional(string)
      monitoring_policy = optional(string)
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
  annotation                = each.value.annotation != "" ? each.value.annotation : var.annotation
  description               = each.value.description
  name                      = each.key
  name_alias                = each.value.alias
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
