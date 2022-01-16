/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzFilter"
 - Distinguished Name: "uni/tn-{Tenant}/flt{filter}"
GUI Location:
 - Tenants > {tenant} > Contracts > Filters: {filter}
_______________________________________________________________________________________________________________________
*/
resource "aci_filter" "filters" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each                       = local.filters
  tenant_dn                      = aci_tenant.tenants[each.value.tenant].id
  annotation                     = each.value.annotation
  description                    = each.value.description
  name                           = each.value.filter
  name_alias                     = each.value.alias
  relation_vz_rs_filt_graph_att  = ""
  relation_vz_rs_fwd_r_flt_p_att = ""
  relation_vz_rs_rev_r_flt_p_att = ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzEntry"
 - Distinguished Name: "uni/tn-{tenant}/flt{filter}/e-{filter_entry}"
GUI Location:
 - Tenants > {tenant} > Contracts > Filters: {filter} > Filter Entry: {filter_entry}
_______________________________________________________________________________________________________________________
*/
resource "aci_filter_entry" "filter_entry" {
  depends_on = [
    aci_tenant.tenants,
    aci_filter.filters
  ]
  for_each      = local.filter_entries
  filter_dn     = aci_filter.filters[each.value.filter].id
  description   = each.value.description
  name          = each.value.name
  name_alias    = each.value.alias
  ether_t       = each.value.ethertype
  prot          = each.value.ip_protocol
  arp_opc       = each.value.arp_flag
  icmpv4_t      = each.value.icmpv4_type
  icmpv6_t      = each.value.icmpv6_type
  match_dscp    = each.value.match_dscp
  apply_to_frag = each.value.match_only_fragment
  s_from_port   = each.value.source_port_from
  s_to_port     = each.value.source_port_to
  d_from_port   = each.value.destination_port_from
  d_to_port     = each.value.destination_port_to
  stateful      = each.value.stateful
  tcp_rules     = each.value.tcp_session_rules
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzRsSubjFiltAtt"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{name}/subj-{subject}/rssubjFiltAtt-{filter}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {contract}: Subjects
_______________________________________________________________________________________________________________________
*/
# resource "aci_rest" "oob_contract_subject_filters" {
#   provider   = netascode
#   depends_on  = [
#     aci_rest.oob_contract_subjects
#   ]
#   for_each   = local.oob_contract_subject_filters
#   dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}/subj-${each.value.subject}/rssubjFiltAtt-${each.value.filter}"
#   class_name = "vzRsSubjFiltAtt"
#   content = {
#     tnVzFilterName = each.value.filter
#   }
# }

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
  for_each    = { for k, v in local.contracts : k => v if contract_type == "standard" }
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  annotation  = each.value.annotation
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
resource "aci_rest" "oob_contracts" {
  provider = netascode
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = { for k, v in local.contracts : k => v if contract_type == "oob" }
  dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}"
  class_name = "vzOOBBrCP"
  content = {
    annotation = each.value.annotation
    descr      = each.value.description
    name       = each.key
    nameAlias  = ach.value.alias
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
resource "aci_taboo_contract" "taboo_contracts" {
  depends_on = [
    aci_tenant.tenants,
  ]
  for_each    = { for k, v in local.contracts : k => v if contract_type == "taboo" }
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
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
    aci_rest.oob_contracts,
    aci_taboo_contract.taboo_contracts,
    aci_filter.filters,
  ]
  for_each   = { for k, v in local.subjects : k => v }
  annotation = each.value.annotation
  contract_dn = length(regexall(
    "oob", each.value.contract_type)
    ) > 0 ? aci_rest.oob_contracts[each.value.contract].id : length(regexall(
    "standard", each.value.contract_type)
    ) > 0 ? aci_contract.contracts[each.value.contract].id : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? aci_taboo_contract.taboo_contracts[each.value.contract].id : ""
  cons_match_t                 = each.value.consumer_match_type
  description                  = each.value.description
  name                         = each.value.name
  name_alias                   = each.value.alias
  prio                         = each.value.qos_priority
  prov_match_t                 = each.value.provider_match_type
  rev_flt_ports                = each.value.reverse_filter_ports
  target_dscp                  = each.value.target_dscp
  relation_vz_rs_subj_filt_att = each.value.filter_relationships
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzSubj"
 - Distinguished Name: "uni/tn-{tenant}/oobbrc-{Name}/subj-{subject}"
GUI Location:
 - Tenants > {tenant} > Contracts > Out-Of-Band Contracts: {name}: Subjects
_______________________________________________________________________________________________________________________
*/
# resource "aci_rest" "oob_contract_subjects" {
#   provider   = netascode
#   depends_on  = [
#     aci_rest.oob_contracts
#   ]
#   for_each   = { for k, v in local.subjects: k => v if contract_type == "oob" }
#   dn         = "uni/tn-${each.value.tenant}/oobbrc-${each.value.contract}/subj-${each.value.subject}"
#   class_name = "vzSubj"
#   content = {
#     consMatchT  = each.value.consumer_match_type
#     descr       = each.value.description
#     name        = each.value.name
#     nameAlias   = each.value.alias
#     prio        = each.value.qos_priority
#     provMatchT  = each.value.provider_match_type
#     revFltPorts = each.value.reverse_filter_ports
#     targetDscp  = each.value.target_dscp
#   }
# }

