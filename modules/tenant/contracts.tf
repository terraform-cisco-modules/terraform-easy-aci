variable "contracts" {
  default = {
    "default" = {
      annotation          = ""
      consumer_match_type = "AtleastOne"
      contract_type       = "standard" # oob|taboo
      controller_type     = "apic"
      description         = ""
      filters = [
        {
          action   = "permit"
          name     = "default"
          tenant   = "common"
          template = "common"
        }
      ]
      log_packets          = false
      name_alias           = ""
      qos_class            = "unspecified"
      provider_match_type  = "AtleastOne"
      reverse_filter_ports = true
      schema               = "common"
      scope                = "context" # application-profile|context|global|tenant
      tags                 = []
      target_dscp          = "unspecified"
      template             = "common"
      tenant               = "common"
    }
  }
  description = <<-EOT
  Key: Name of the Contract.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bgp_context_per_address_family: 
  * controller_type: What is the type of controller.  Options are:
    - apic: For APIC Controllers
    - ndo: For Nexus Dashboard Orchestrator
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  EOT
  type = map(object(
    {
      annotation          = optional(string)
      consumer_match_type = optional(string)
      contract_type       = optional(string)
      controller_type     = optional(string)
      description         = optional(string)
      filters = optional(list(object(
        {
          action   = optional(string)
          name     = optional(string)
          tenant   = optional(string)
          template = optional(string)
        }
      )))
      log_packets          = optional(bool)
      name_alias           = optional(string)
      provider_match_type  = optional(string)
      qos_class            = optional(string)
      reverse_filter_ports = optional(bool)
      schema               = optional(string)
      scope                = optional(string)
      qos_class            = optional(string)
      tags = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      target_dscp = optional(string)
      template    = optional(string)
      tenant      = optional(string)
    }
  ))
}

#------------------------------------------
# Create a Standard Contract
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzBrCP"
 - Distinguished Name: "uni/tn-{tenant}/brc-{contract}"
GUI Location:
 - Tenants > {tenant} > Contracts > Standard: {contract}
_______________________________________________________________________________________________________________________
*/
resource "aci_contract" "contracts" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = { for k, v in local.contracts : k => v if v.controller_type == "apic" && v.contract_type == "standard" }
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
  prio        = each.value.qos_class
  scope       = each.value.scope
  target_dscp = each.value.target_dscp
}

#------------------------------------------
# Create a Out-Of-Band Contract
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzOOBBrCP"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{contract}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {contract}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_contracts" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = { for k, v in local.contracts : k => v if v.controller_type == "apic" && v.contract_type == "oob" }
  dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}"
  class_name = "vzOOBBrCP"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr      = each.value.description
    name       = each.key
    nameAlias  = each.value.name_alias
    prio       = each.value.qos_class
    scope      = each.value.scope
    targetDscp = each.value.target_dscp
  }
}

#------------------------------------------
# Create a Taboos Contract
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzBrCP"
 - Distinguished Name: "uni/tn-{tenant}/taboo-{contract}"
GUI Location:
 - Tenants > {tenant} > Contracts > Taboos: {contract}
_______________________________________________________________________________________________________________________
*/
resource "aci_taboo_contract" "contracts" {
  depends_on = [
    aci_tenant.tenants,
  ]
  for_each    = { for k, v in local.contracts : k => v if v.controller_type == "apic" && v.contract_type == "taboo" }
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
}

resource "mso_schema_template_contract" "contracts" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
  ]
  for_each      = { for k, v in local.contracts : k => v if v.controller_type == "ndo" }
  schema_id     = mso_schema.schemas[each.value.schema].id
  template_name = each.value.template
  contract_name = each.key
  display_name  = each.key
  filter_type   = each.value.reverse_filter_ports == true ? "bothWay" : "oneWay"
  scope         = each.value.scope
  dynamic "filter_relationship" {
    for_each = each.value.filters
    content {
      filter_schema_id = length(regexall(
        filter_relationship.value.tenant, each.value.tenant)
        ) > 0 ? mso_schema_template_filter_entry.filter_entries[filter_relationship.value.name].id : length(regexall(
        "[[:alnum:]]", each.value.tenant)
      ) > 0 ? local.rs_mso_filter_entries[filter_relationship.value.name].id : ""
      filter_template_name = filter_relationship.value.template
      filter_name          = filter_relationship.value.name
    }
  }
  directives = each.value.log_packets == true ? ["log"] : ["none"]
}
/*_____________________________________________________________________________________________________________________

# Out-of-Band Contract Subjects
API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{contract}/subj-{subject}"
GUI Locations:
 - Tenants > mgmt > Contracts > Out-Of-Band Contracts: {contract} > {subject}

# Standard Contract Subjects
API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/brc-{contract}/subj-{subject}"
GUI Locations:
 - Tenants > mgmt > Contracts > Standard: {contract} > {subject}

# Taboo Contract Subjects
API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/taboo-{contract}/subj-{subject}"
GUI Location:
 - Tenants > mgmt > Contracts > Taboos: {contract} > {subject}
_______________________________________________________________________________________________________________________
*/
resource "aci_contract_subject" "contract_subjects" {
  depends_on = [
    aci_contract.contracts,
    aci_filter.filters,
    aci_rest_managed.oob_contracts,
    aci_taboo_contract.contracts,
  ]
  for_each   = { for k, v in local.contract_subjects : k => v if v.controller_type == "apic" }
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  contract_dn = length(regexall(
    "oob", each.value.contract_type)
    ) > 0 ? aci_rest_managed.oob_contracts[each.key].id : length(regexall(
    "standard", each.value.contract_type)
    ) > 0 ? aci_contract.contracts[each.key].id : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? aci_taboo_contract.contracts[each.key].id : ""
  cons_match_t  = each.value.consumer_match_type
  description   = each.value.description
  name          = each.key
  name_alias    = each.value.name_alias
  prio          = each.value.qos_class
  prov_match_t  = each.value.provider_match_type
  rev_flt_ports = each.value.reverse_filter_ports == true ? "yes" : "no"
  target_dscp   = each.value.target_dscp
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzRsSubjFiltAtt"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{name}/subj-{subject}/rssubjFiltAtt-{filter}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {contract}: Subjects
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "contract_subject_filter_atrributes" {
  depends_on = [
    aci_contract_subject.contract_subjects
  ]
  for_each   = local.apic_contract_filters
  dn         = "${aci_contract.contracts[each.value.contract].id}/subj-${each.value.contract}/rssubjFiltAtt-${each.value.name}"
  class_name = "vzRsSubjFiltAtt"
  content = {
    action = each.value.action
    # tDn            = each.value.filter
    tnVzFilterName = each.value.name
  }
}



/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{Name}/subj-{subject}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {name}: Subjects
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_contract_subjects" {
  depends_on = [
    aci_rest_managed.oob_contracts
  ]
  for_each   = { for k, v in local.contract_subjects : k => v if v.contract_type == "oob" }
  dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}/subj-${each.value.subject}"
  class_name = "vzSubj"
  content = {
    consMatchT  = each.value.consumer_match_type
    descr       = each.value.description
    name        = each.value.name
    nameAlias   = each.value.name_alias
    prio        = each.value.qos_priority
    provMatchT  = each.value.provider_match_type
    revFltPorts = each.value.reverse_filter_ports
    targetDscp  = each.value.target_dscp
  }
}

output "contracts" {
  value = {
    apic_contracts = var.contracts != {} ? { for v in sort(
      keys(aci_contract.contracts)
    ) : v => aci_contract.contracts[v].id } : {}
    apic_oob_contracts = var.contracts != {} ? { for v in sort(
      keys(aci_rest_managed.oob_contracts)
    ) : v => aci_rest_managed.oob_contracts[v].id } : {}
    apic_taboo_contracts = var.contracts != {} ? { for v in sort(
      keys(aci_taboo_contract.contracts)
    ) : v => aci_taboo_contract.contracts[v].id } : {}
    ndo_contracts = var.contracts != {} ? { for v in sort(
      keys(mso_schema_template_contract.contracts)
    ) : v => mso_schema_template_contract.contracts[v].id } : {}
  }
}
