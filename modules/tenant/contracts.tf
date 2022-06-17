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
      log             = false
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
    * contract_type: (required) — Select the Contract Type.  Note: intra_epg and taboo are not valid for target_type VRF.  Options are:
      - oob
      - standard
      - taboo
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * qos_class: (optional) — The priority class identifier. Allowed values are:
      - level1
      - level2
      - level3
      - level4
      - level5
      - level6
      - unspecified: (default)
    * scope: (optional) — The Scope of the contract, if the contract is of Type Standard or Out-of-Band.  Options are:
      - application-profile
      - context: (default)
      - global
      - tenant
      - Note:  Ignored for Taboo Contracts.
    * subjects: (optional) — 
      - action: (optional) — You can set the following actions for the filter:
        * deny
        * permit: (default)
      - apply_both_directions: (optional) — Sets the contract filter to apply on both ingress and egress traffic directions.  Options are:
        * false
        * true: (default)
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - directives: (optional) — Some features, such as statistics, will be unavailable while Policy Compression is active. Filters containing prio, qos and markDscp are not considered for compression.
        * enable_policy_compression: (optional) — Enables contract data storage optimization.
          - false: (default)
          - true
        * log: (optional) — Enables contract permit and deny logging.
          - false: (default)
          - true
      - filters: (optional) — List of Filters to add to the Subject.
      - match_type: (optional) — The Match criteria can be:
        * All
        * AtleastOne
        * AtmostOne
        * None
      - name: (required) — The Name for the Subject/Filter.
      - qos_class: (optional) — The priority class identifier. Allowed values are:
        * level1
        * level2
        * level3
        * level4
        * level5
        * level6
        * unspecified: (default)
      - target_dscp: (optional) — The target differentiated services code point (DSCP) of the lsubject. The options are as follows:
        * AF11 — low drop Priority
        * AF12 — medium drop Priority
        * AF13 — high drop Priority
        * AF21 — low drop Immediate
        * AF22 — medium drop Immediate
        * AF23 — high drop Immediate
        * AF31 — low drop Flash
        * AF32 — medium drop Flash
        * AF33 — high drop Flash
        * AF41 — low drop—Flash Override
        * AF42 — medium drop Flash Override
        * AF43 — high drop Flash Override
        * CS0 — class of service level 0
        * CS1 — class of service level 1
        * CS2 — class of service level 2
        * CS3 — class of service level 3
        * CS4 — class of service level 4
        * CS5 — class of service level 5
        * CS6 — class of service level 6
        * CS7 — class of service level 7
        * EF — Expedited Forwarding Critical
        * VA — Voice Admit
        * unspecified: (default)
    * target_dscp: (optional) — The target differentiated services code point (DSCP) of the lsubject. The options are as follows:
      - AF11 — low drop Priority
      - AF12 — medium drop Priority
      - AF13 — high drop Priority
      - AF21 — low drop Immediate
      - AF22 — medium drop Immediate
      - AF23 — high drop Immediate
      - AF31 — low drop Flash
      - AF32 — medium drop Flash
      - AF33 — high drop Flash
      - AF41 — low drop—Flash Override
      - AF42 — medium drop Flash Override
      - AF43 — high drop Flash Override
      - CS0 — class of service level 0
      - CS1 — class of service level 1
      - CS2 — class of service level 2
      - CS3 — class of service level 3
      - CS4 — class of service level 4
      - CS5 — class of service level 5
      - CS6 — class of service level 6
      - CS7 — class of service level 7
      - EF — Expedited Forwarding Critical
      - VA — Voice Admit
      - unspecified: (default)
    * tenant: (default: local.tenant) — The Name of the Tenant to create the Bridge Domain within.
    APIC Specific Attributes:
    * alias: (optional) — A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    * annotation: (optional) — A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
      - key — Key string.
      - value — Value string.
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    Nexus Dashboard Orchestrator Specific Attributes:
    * schema: (required) — Schema Name.
    * sites: (optional) — List of Site Names to assign site specific attributes.
    * template: (required) — The Template name to create the object within.
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
      contract_type   = optional(string)
      controller_type = optional(string)
      description     = optional(string)
      global_alias    = optional(string)
      log             = optional(bool)
      qos_class       = optional(string)
      schema          = optional(string)
      scope           = optional(string)
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
  dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.key}"
  class_name = "vzOOBBrCP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
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
    prio        = each.value.qos_class
    provMatchT  = each.value.match_type
    revFltPorts = each.value.apply_both_directions == true ? "yes" : "no"
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
