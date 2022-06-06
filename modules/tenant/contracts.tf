/*_____________________________________________________________________________________________________________________

Tenant — Contracts — Variables
_______________________________________________________________________________________________________________________
*/
variable "contracts" {
  default = {
    "default" = {
      alias           = ""
      annotation      = ""
      annotations     = []
      contract_type   = "standard" # oob|taboo
      controller_type = "apic"
      description     = ""
      global_alias    = ""
      qos_class       = "unspecified"
      scope           = "context" # application-profile|context|global|tenant
      subjects = [
        {
          action                = "permit"
          apply_both_directions = true
          description           = ""
          directives = [
            {
              enable_policy_compression = false
              log                       = false
            }
          ]
          filters     = []
          match_type  = "AtleastOne"
          name        = "**REQUIRED**"
          qos_class   = "unspecified"
          target_dscp = "unspecified"
        }
      ]
      target_dscp = "unspecified"
      /* If undefined the variable of local.first_tenant will be used for:
      schema              = local.first_tenant
      template            = local.first_tenant
      tenant              = local.first_tenant
      */
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
      contract_type         = optional(string)
      controller_type       = optional(string)
      description           = optional(string)
      global_alias          = optional(string)
      log                   = optional(bool)
      qos_class             = optional(string)
      schema                = optional(string)
      scope                 = optional(string)
      subjects = optional(list(object(
        {
          action                = optional(string)
          apply_both_directions = optional(bool)
          description           = optional(string)
          directives = optional(list(object(
            {
              enable_policy_compression = optional(bool)
              log                       = optional(bool)
            }
          )))
          filters     = list(string)
          match_type  = optional(string)
          name        = string
          qos_class   = optional(string)
          target_dscp = optional(string)
        }
      )))
      qos_class   = optional(string)
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
    for_each = toset(each.value.filters)
    content {
      filter_schema_id     = mso_schema.schemas[each.value.schema].id
      filter_template_name = each.value.template
      filter_name          = filter_relationship.value
    }
  }
  directives = each.value.log == true ? ["log"] : ["none"]
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/brc-{contract}/subj-{subject}"
GUI Locations:
 - Tenants > mgmt > Contracts > Standard: {contract} > {subject}
_______________________________________________________________________________________________________________________
*/
resource "aci_contract_subject" "contract_subjects" {
  depends_on = [
    aci_contract.contracts,
    aci_filter.filters,
    aci_rest_managed.oob_contracts,
    aci_taboo_contract.contracts,
  ]
  for_each      = { for k, v in local.contract_subjects : k => v if v.contract_type == "standard" }
  annotation    = var.annotation
  contract_dn   = aci_contract.contracts[each.value.contract].id
  cons_match_t  = each.value.match_type
  description   = each.value.description
  name          = each.value.name
  prio          = each.value.qos_class
  prov_match_t  = each.value.match_type
  rev_flt_ports = each.value.apply_both_directions == true ? "yes" : "no"
  target_dscp   = each.value.target_dscp
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/taboo-{Name}/subj-{subject}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {name}: Subjects
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_contract_subjects" {
  depends_on = [
    aci_rest_managed.oob_contracts
  ]
  for_each   = { for k, v in local.contract_subjects : k => v if v.contract_type == "oob" }
  dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}/subj-${each.value.name}"
  class_name = "vzSubj"
  content = {
    consMatchT  = each.value.match_type
    descr       = each.value.description
    name        = each.value.name
    prio        = each.value.qos_priority
    provMatchT  = each.value.match_type
    revFltPorts = each.value.apply_both_directions
    targetDscp  = each.value.target_dscp
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzTSubj"
 - Distinguished Name: "uni/tn-{tenant}/taboo-{Name}/subj-{subject}"
GUI Location:
 - Tenants > {tenant} > Contracts > Taboo Contracts: {name}: Subjects
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "taboo_contract_subjects" {
  depends_on = [
    aci_rest_managed.oob_contracts
  ]
  for_each   = { for k, v in local.contract_subjects : k => v if v.contract_type == "taboo" }
  dn         = "${aci_taboo_contract.contracts[each.value.contract].id}/tsubj-${each.value.name}"
  class_name = "vzTSubj"
  content = {
    descr = each.value.description
    name  = each.value.name
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzRsSubjFiltAtt"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{name}/subj-{subject}/rssubjFiltAtt-{filter}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {contract}: Subjects
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "contract_subject_filter" {
  depends_on = [
    aci_contract_subject.contract_subjects,
    aci_rest_managed.oob_contract_subjects,
  ]
  for_each = { for k, v in local.subject_filters : k => v if v.contract_type != "taboo" }
  dn = length(regexall("standard", each.value.contract_type)
    ) > 0 ? "${aci_contract.contracts[each.value.contract].id}/subj-${each.value.subject}/rssubjFiltAtt-${each.value.filter}" : length(
    regexall("oob", each.value.contract_type)
  ) > 0 ? "${aci_rest_managed.oob_contracts[each.value.contract].id}/subj-${each.value.subject}/rssubjFiltAtt-${each.value.filter}" : ""
  class_name = "vzRsSubjFiltAtt"
  content = {
    action = each.value.action
    directives = anytrue(
      [each.value.directives[0].enable_policy_compression, each.value.directives[0].log]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.directives[0].enable_policy_compression)) > 0 ? "no_stats" : ""], [
        length(regexall(true, each.value.directives[0].log)) > 0 ? "log" : ""]
    )), ","), ",,", ",") : ""
    # tDn            = each.value.filter
    tnVzFilterName = each.value.filter
  }
}

resource "aci_rest_managed" "taboo_subject_filter" {
  depends_on = [
    aci_rest_managed.taboo_contract_subjects,
  ]
  for_each   = { for k, v in local.subject_filters : k => v if v.contract_type == "taboo" }
  dn         = "${aci_taboo_contract.contracts[each.value.contract].id}/tsubj-${each.value.subject}/rsdenyRule-${each.value.filter}"
  class_name = "vzRsDenyRule"
  content = {
    directives = anytrue(
      [each.value.directives[0].enable_policy_compression, each.value.directives[0].log]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.directives[0].enable_policy_compression)) > 0 ? "no_stats" : ""], [
        length(regexall(true, each.value.directives[0].log)) > 0 ? "log" : ""]
    )), ","), ",,", ",") : ""
    # tDn            = each.value.filter
    tnVzFilterName = each.value.filter
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
