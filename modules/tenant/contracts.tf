variable "contracts" {
  default = {
    "default" = {
      alias                 = ""
      annotation            = ""
      annotations           = []
      apply_both_directions = true
      consumer_match_type   = "AtleastOne"
      contract_type         = "standard" # oob|taboo
      controller_type       = "apic"
      description           = ""
      filters = [
        {
          action = "permit"
          directives = [
            {
              enable_policy_compression = false
              log_packets               = false
            }
          ]
          name = "default"
        }
      ]
      global_alias        = ""
      log_packets         = false
      qos_class           = "unspecified"
      provider_match_type = "AtleastOne"
      schema              = "common"
      scope               = "context" # application-profile|context|global|tenant
      tags                = []
      target_dscp         = "unspecified"
      template            = "common"
      tenant              = "common"
    }
  }
  description = <<-EOT
  Key: Name of the Contract.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bgp_context_per_address_family: 
  * controller_type: What is the type of controller.  Options are:
    - apic: For APIC Controllers
    - ndo: For Nexus Dashboard Orchestrator
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
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
      apply_both_directions = optional(bool)
      consumer_match_type   = optional(string)
      contract_type         = optional(string)
      controller_type       = optional(string)
      description           = optional(string)
      filters = optional(list(object(
        {
          action = optional(string)
          directives = optional(list(object(
            {
              enable_policy_compression = bool
              log_packets               = bool
            }
          )))
          name = optional(string)
        }
      )))
      global_alias        = optional(string)
      log_packets         = optional(bool)
      provider_match_type = optional(string)
      qos_class           = optional(string)
      schema              = optional(string)
      scope               = optional(string)
      qos_class           = optional(string)
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
  name_alias  = each.value.alias
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
    nameAlias  = each.value.alias
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
  name_alias  = each.value.alias
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
  filter_type   = each.value.apply_both_directions == true ? "bothWay" : "oneWay"
  scope         = each.value.scope
  dynamic "filter_relationship" {
    for_each = each.value.filters
    content {
      filter_schema_id     = mso_schema.schemas[each.value.schema].id
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
  name_alias    = each.value.alias
  prio          = each.value.qos_class
  prov_match_t  = each.value.provider_match_type
  rev_flt_ports = each.value.apply_both_directions == true ? "yes" : "no"
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
    directives = anytrue(
      [each.value.directives[0].enable_policy_compression, each.value.directives[0].log_packets]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.directives[0].enable_policy_compression)) > 0 ? "no_stats" : ""], [
        length(regexall(true, each.value.directives[0].log_packets)) > 0 ? "log" : ""]
    )), ","), ",,", ",") : "none"
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
    nameAlias   = each.value.alias
    prio        = each.value.qos_priority
    provMatchT  = each.value.provider_match_type
    revFltPorts = each.value.apply_both_directions
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
