/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvAEPg"
 - Distinguished Name: /uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_application_epg" "application_epgs" {
  depends_on = [
    aci_tenant.tenants,
    aci_application_profile.application_profiles,
    aci_bridge_domain.bridge_domains,
    aci_contract.contracts,
    aci_rest.oob_contracts,
    aci_taboo_contract.taboo_contracts,
  ]
  application_profile_dn = aci_application_profile.application_profiles[each.value.application_profile].id
  name                   = each.value.name
  description            = each.value.description
  annotation             = each.value.annotation
  exception_tag          = "{exception_tag}"
  flood_on_encap         = "{flood}"
  fwd_ctrl               = "{fwd_ctrl}"
  has_mcast_source       = "{has_mcast}"
  is_attr_based_epg      = "{is_attr_based}"
  match_t                = "{match_t}"
  name_alias             = each.value.alias
  pc_enf_pref            = "{pc_enf_pref}"
  pref_gr_memb           = "{pref_gr_memb}"
  prio                   = "{prio}"
  shutdown               = "{shutdown}"
  relation_fv_rs_bd = length(regexall(
    each.value.tenant, each.value.bd_tenant)
    ) > 0 ? aci_bridge_domain.bridge_domains[each.value.bridge_domain].id : length(regexall(
    "[[:alnum:]]+", each.value.bd_tenant)
  ) > 0 ? local.common_bds[each.value.bridge_domain].id : ""
  relation_fv_rs_sec_inherited = ["{Master_fvEPg}"].id
  relation_fv_rs_cons_if       = ["{vzCPIf}"]
  relation_fv_rs_prov_def      = ["{vzCtrctEPgCont}"]
  relation_fv_rs_prot_by       = ["{vzTaboo}"]
  relation_fv_rs_cust_qos_pol  = "{qosCustomPol}"
  relation_fv_rs_dpp_pol       = "{qosDppPol}"
  relation_fv_rs_intra_epg     = ["{intra_vzBrCP}"]
  relation_fv_rs_aepg_mon_pol  = "{monEPGPol}"
  relation_fv_rs_trust_ctrl    = "{fhsTrustCtrlPol}"
  relation_fv_rs_graph_def     = ["{vzGraphCont}"]
}


/*_____________________________________________________________________________________________________________________

API Information:
{%- if Type == 'in_band' %}
 - Class: "mgmtInB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{EPG}"
{%- else %}
 - Class: "mgmtOoB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{EPG}"
GUI Location:
{%- if Type == 'in_band' %}
 - Tenants > mgmt > Node Management EPGs > In-Band EPG - {EPG}
{%- else %}
 - Tenants > mgmt > Node Management EPGs > Out-of-Band EPG - {EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_node_mgmt_epg" "mgmt_epgs" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
    aci_contract.contracts,
    aci_rest.oob_contracts,
    aci_taboo_contract.taboo_contracts,
  ]
  management_profile_dn      = "uni/tn-mgmt/mgmtp-default"
  name                       = each.value.name
  annotation                 = each.value.annotation
  encap                      = each.value.epg_type == "in_band" ? "vlan-${each.value.vlan}" : ""
  match_t                    = each.value.epg_type == "in_band" ? each.value.match_t : ""
  name_alias                 = each.value.alias
  pref_gr_memb               = "exclude"
  prio                       = each.value.qos_class
  type                       = each.value.type
  relation_fv_rs_cons        = each.value.epg_type == "in_band" ? each.value.consumed_contracts : []
  relation_fv_rs_prov        = each.value.epg_type == "in_band" ? each.value.provided_contracts : []
  relation_mgmt_rs_oo_b_prov = each.value.epg_type == "out_of_band" ? each.value.consumed_contracts : []
  relation_mgmt_rs_mgmt_bd = length(regexall(
    each.value.tenant, each.value.bd_tenant)
    ) > 0 ? aci_bridge_domain.bridge_domains[each.value.bridge_domain].id : length(regexall(
    "[[:alnum:]]+", each.value.bd_tenant)
  ) > 0 ? local.common_bds[each.value.bridge_domain].id : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsDomAtt"
 - Distinguished Name: /uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/rsdomAtt-[uni/{Domain}]
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Domains (VMs and Bare-Metals)
_______________________________________________________________________________________________________________________
*/
resource "aci_epg_to_domain" "epg_to_domains" {
  application_epg_dn    = aci_application_epg.example.id
  tdn                   = aci_fc_domain.foofc_domain.id
  annotation            = "annotation"
  binding_type          = "none"
  allow_micro_seg       = "false"
  delimiter             = ""
  encap                 = "vlan-5"
  encap_mode            = "auto"
  epg_cos               = "Cos0"
  epg_cos_pref          = "disabled"
  instr_imedcy          = "lazy"
  lag_policy_name       = "0"
  netflow_dir           = "both"
  netflow_pref          = "disabled"
  num_ports             = "0"
  port_allocation       = "none"
  primary_encap         = "unknown"
  primary_encap_inner   = "unknown"
  res_imedcy            = "lazy"
  secondary_encap_inner = "unknown"
  switching_mode        = "native"
  vmm_allow_promiscuous = "accept"
  vmm_forged_transmits  = "reject"
  vmm_mac_changes       = "accept"
}

#------------------------------------------
# Assign Contract to EPG
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
{%- if Contract_Type == 'consumer' %}
 - Class: "fvRsCons"
 - Distinguished Name: "uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/rscons-{Contract}"
GUI Location:
 - Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Contracts
{%- elif Contract_Type == 'provider' %}
 - Class: "fvRsProv"
 - Distinguished Name: "uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/rscons-{Contract}"
GUI Location:
 - Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Contracts
{%- endif %}
_______________________________________________________________________________________________________________________
*/
# resource "aci_epg_to_contract" "Tenant_{Tenant}_contract_{Contract}" {
#     depends on          = [
#         aci_tenant.Tenant_{Tenant}
#         aci_application_epg.Tenant_{Tenant}_App_Profile_{App_Profile}_EPG_{EPG},
# {%- if Contract_Tenant == Tenant %}
#         aci_contract.Tenant_{Contract_Tenant}_Contract_{Contract}
# {%- else %}
#         data.aci_tenant.Tenant_{Contract_Tenant}
#         data.aci_contract.Tenant_{Contract_Tenant}_Contract_{Contract}
# {%- endif %}
# 
#     ]
#     application_epg_dn  = aci_application_epg.Tenant_{Tenant}_App_Profile_{App_Profile}_EPG_{EPG}.id
# {%- if Contract_Tenant == Tenant %}
#     contract_dn         = aci_contract.Tenant_{Contract_Tenant}_Contract_{Contract}
# {%- else %}
#     contract_dn         = data.aci_contract.Tenant_{Contract_Tenant}_Contract_{Contract}
# {%- endif %}
#     contract_type       = "{Contract_Type}"
# }

#------------------------------------------------------
# Create Attachable Access Entity Generic Encap Policy
#------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{AAEP}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {AAEP}
_______________________________________________________________________________________________________________________
*/
resource "aci_epgs_using_function" "epg_to_aaep" {
  depends_on = [
    aci_application_epg.application_epgs,
    local.aaep_policies
  ]
  for_each          = local.epg_to_aaep
  access_generic_dn = local.aaep_policies[each.value.aaep].id
  tdn               = aci_application_epg.application_epgs[each.value.epg].id
  encap             = "vlan-${each.value.vlan}"
  instr_imedcy      = "immediate"
  mode              = "regular"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsPathAtt"
 - Distinguished Name: "uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/{Static_Path}"
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Static Ports > {GUI_Static}
_______________________________________________________________________________________________________________________
*/
resource "aci_epg_to_static_path" "epg_to_static_paths" {
  depends_on = [
    aci_application_epg.application_epgs
  ]
  application_epg_dn = aci_application_epg.application_epgs[each.value.epg].id
  tdn                = each.value.tdn
  encap              = "vlan-${each.value.vlan}"
  mode               = each.value.mode
}
