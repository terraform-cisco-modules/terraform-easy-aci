
/*_____________________________________________________________________________________________________________________

Tenants
_______________________________________________________________________________________________________________________
*/
variable "tenants" {
  default = {
    "default" = {
      alias             = ""
      annotation        = ""
      annotations       = []
      controller_type   = "apic"
      description       = ""
      monitoring_policy = "default"
      global_alias      = ""
      sites             = []
      users             = []
    }
  }
  description = <<-EOT
    Key — Name of the Tenant.
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    APIC Specific Attributes:
    * alias: (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    * monitoring_policy: (default: default) — To keep it simple the monitoring policy must be in the common Tenant.
    Nexus Dashboard Orchestrator Specific Attributes:
    * sites: (required when controller_type is ndo) — When using Nexus Dashboard Orchestrator the sites attribute is used to distinguish the site and cloud types.  Options are:
      - aws_access_key_id: (optional) — AWS Access Key Id. It must be provided if the AWS account is not trusted. This parameter will only have effect with vendor = aws.
      - aws_account_id: (optional) — Id of AWS account. It's required when vendor is set to aws. This parameter will only have effect with vendor = aws.
      - azure_access_type: (optional) — Type of Azure Account Configuration. Allowed values are managed, shared and credentials. Other Credentials are not required if azure_access_type is set to managed. This parameter will only have effect with vendor = azure.
        * credentials
        * managed: (default)
        * shared
      - azure_active_directory_id: (optional) — Azure Active Directory Id. It must be provided when azure_access_type to credentials. This parameter will only have effect with vendor = azure.
      - azure_application_id: (optional) — Azure Application Id. It must be provided when azure_access_type to credentials. This parameter will only have effect with vendor = azure.
      - azure_shared_account_id: (optional) — Azure shared account Id. It must be provided when azure_access_type to shared. This parameter will only have effect with vendor = azure.
      - azure_subscription_id: (optional) — Azure subscription id. It's required when vendor is set to azure. This parameter will only have effect with vendor = azure.
      - is_aws_account_trusted: (otpional) — Flag to Set the AWS Account to trusted.
      - site: (required) - Name of the Site to Associate to the Parent Tenant Object.
      - vendor: (optional) — The type of vendor to apply the tenant to.
        * aws
        * azure
        * cisco: (default)
    * users: (required when controller_type is ndo) — List of Users to associate to the Parent Tenant Object. 
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
      global_alias      = optional(string)
      monitoring_policy = optional(string)
      sites = optional(list(object(
        {
          aws_access_key_id         = optional(string)
          aws_account_id            = optional(string)
          azure_access_type         = optional(string)
          azure_active_directory_id = optional(string)
          azure_application_id      = optional(string)
          azure_shared_account_id   = optional(string)
          azure_subscription_id     = optional(string)
          is_aws_account_trusted    = optional(string)
          site                      = string
          vendor                    = optional(string)
        }
      )))
      users = optional(list(string))
    }
  ))
}

variable "aws_secret_key" {
  default     = ""
  description = "AWS Secret Key Id. It must be provided if the AWS account is not trusted. This parameter will only have effect with vendor = aws."
  sensitive   = true
  type        = string
}

variable "azure_client_secret" {
  default     = "1"
  description = "Azure Client Secret. It must be provided when azure_access_type to credentials. This parameter will only have effect with vendor = azure."
  sensitive   = true
  type        = string
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
  for_each = { for k, v in local.tenants : k => v if v.controller_type == "apic" }
  # annotation                    = each.value.annotation != "" ? each.value.annotation : var.annotation
  # description                   = each.value.description
  name                          = each.key
  name_alias                    = each.value.alias
  relation_fv_rs_tenant_mon_pol = each.value.monitoring_policy != "" ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAnnotation"
 - Distinguished Name: "uni/tn-{tenant}/annotationKey-[{key}]"
GUI Location:
 - Tenants > {tenant}: {annotations}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "tenants_annotations" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.tenants_annotations
  dn         = "uni/tn-${each.value.tenant}/annotationKey-[${each.value.key}]"
  class_name = "tagAnnotation"
  content = {
    key   = each.value.key
    value = each.value.value
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/tn-{tenant}/alias"
GUI Location:
 - Tenants > {tenant} > Networking > VRFs > {vrf}: global_alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "tenants_global_alias" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.tenants_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/tn-${each.value.tenant}/alias"
  content = {
    name = each.value.global_alias
  }
}


/*_____________________________________________________________________________________________________________________

Nexus Dashboard — Tenants
_______________________________________________________________________________________________________________________
*/
resource "mso_tenant" "tenants" {
  provider = mso
  depends_on = [
    data.mso_site.ndo_sites,
    data.mso_user.ndo_users
  ]
  for_each     = { for k, v in local.tenants : k => v if v.controller_type == "ndo" }
  name         = each.key
  display_name = each.key
  dynamic "site_associations" {
    for_each = { for k, v in each.value.sites : k => v if v.vendor == "aws" }
    content {
      aws_access_key_id = length(regexall(
        "aws", site_associations.value.vendor)
      ) > 0 ? site_associations.value.aws_access_key_id : ""
      aws_account_id = length(regexall(
        "aws", site_associations.value.vendor)
      ) > 0 ? site_associations.value.aws_account_id : ""
      aws_secret_key = length(regexall(
        "aws", site_associations.value.vendor)
      ) > 0 ? var.aws_secret_key : ""
      site_id = data.mso_site.sites[site_associations.value.site].id
      vendor  = site_associations.value.vendor
    }
  }
  dynamic "site_associations" {
    for_each = { for k, v in each.value.sites : k => v if v.vendor == "azure" }
    content {
      azure_access_type = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 ? site_associations.value.azure_access_type : ""
      azure_active_directory_id = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 && site_associations.value.azure_access_type == "credentials" ? site_associations.value.azure_active_directory_id : ""
      azure_application_id = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 && site_associations.value.azure_access_type == "credentials" ? site_associations.value.azure_application_id : ""
      azure_client_secret = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 && site_associations.value.azure_access_type == "credentials" ? var.azure_client_secret : ""
      azure_shared_account_id = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 && site_associations.value.azure_access_type == "shared" ? site_associations.value.azure_shared_account_id : ""
      azure_subscription_id = length(regexall(
        "azure", site_associations.value.vendor)
      ) > 0 ? site_associations.value.azure_subscription_id : ""
      site_id = data.mso_site.sites[site_associations.value.site].id
      vendor  = site_associations.value.vendor
    }
  }
  dynamic "site_associations" {
    for_each = { for k, v in each.value.sites : k => v if v.vendor == "cisco" }
    content {
      site_id = data.mso_site.ndo_sites[site_associations.value.site].id
    }
  }
  dynamic "user_associations" {
    for_each = toset(each.value.users)
    content {
      user_id = data.mso_user.ndo_users[user_associations.value].id
    }
  }
}
