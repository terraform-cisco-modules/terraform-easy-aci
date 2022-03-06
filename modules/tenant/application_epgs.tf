
variable "application_epgs" {
  default = {
    "default" = {
      annotation             = ""
      application_profile    = "default"
      bd_schema              = "common"
      bd_template            = "common"
      bd_tenant              = "common" # default is EPG Tenant
      bridge_domain          = "default"
      contract_exception_tag = null
      contracts              = []
      controller_type        = "apic"
      description            = ""
      domains                = []
      /* 
      - Physical Domain Example
      domains = [
        {
          domain      = "access"
        }
      ]
      - VMM Domain Example
      domains = [
        {
          domain        = "vds_example"
          domain_type   = "vmm"
          domain_vendor = "VMware"
          security = [
            {
              allow_promiscuous = "accept"
              forged_transmits  = "accept"
              mac_changes       = "reject"
            }
          ]
        }
      ]
      */
      epg_admin_state        = "admin_up"
      epg_type               = "standard"
      flood_in_encapsulation = "disabled"
      hasMcastSource         = false
      label_match_criteria   = "AtleastOne"
      name_alias             = ""
      intra_epg_isolation    = "unenforced"
      preferred_group_member = false
      qos_class              = "unspecified"
      schema                 = "common"
      static_paths           = []
      /* example
      static_paths = [
        {
          encapsulation_type = "vlan"
          epg                = "default"
          mode               = "trunk"
          name               = "1/1"
          nodes              = [201]
          path_type          = "port"
          pod                = 1
          vlans              = [1]
        }
      ]
      */
      template     = "common"
      tenant       = "common"
      useg_epg     = false
      vrf          = "default"
      vrf_schema   = "common"
      vrf_template = "common"
    }
  }
  description = <<-EOT
  key: Name of the EPG
  * static_paths: List of Paths to assign to the EPG.
    - encapsulation_type: The Type of Encapsulation to use on the Interface
      * micro_seg: 
      * qinq: Port Encapsulation is QinQ based.
      * vlan: Port Encapsulation is VLAN based.
      * vxlan: Port Encapsulation is VXLAN based.
    - epg: Name of the EPG to assign this path to.
    - mode:  Mode of the static association with the path.
      * access: Select this mode if the traffic from the host is untagged (without VLAN ID). When a leaf switch is configured for an EPG to be untagged, for every port this EPG uses, the packets will exit the switch untagged.
      * dot1p: Select this mode if the traffic from the host is tagged with a 802.1P tag. When an access port is configured with a single EPG in native 802.1p mode, its packets exit that port untagged. When an access port is configured with multiple EPGs, one in native 802.1p mode, and some with VLAN tags, all packets exiting that access port are tagged VLAN 0 for EPG configured in native 802.1p mode and for all other EPGs packets exit with their respective VLAN tags.
      * trunk: The default deployment mode. Select this mode if the traffic from the host is tagged with a VLAN ID.
    - name: Name of the Path.  For a Physical Port this will be the slot/port.  For PC/VPC this is the name of the Policy Group.
    - nodes: If the Path type is vpc this should be a list of 2 leaf's.  Otherwise a list of 1 leaf.
    - path_type: 
      * pc: Path Type is Port-Channel
      * port: Path Type is Physical Port
      * vpc: Path Type is Virtual-Port-Channel
    - pod: Identifier for the Pod the Nodes are assigned to for the static path.  Default value is 1.
    - vlans: For VLAN and VXLAN this is a list of 1.  For micro_seg and qinq this is a list of 2.
  EOT
  type = map(object(
    {
      annotation             = optional(string)
      application_profile    = string
      bd_schema              = optional(string)
      bd_template            = optional(string)
      bd_tenant              = optional(string)
      bridge_domain          = string
      contract_exception_tag = optional(number)
      contracts = optional(list(object(
        {
          contract        = string
          contract_tenant = optional(string)
          contract_type   = optional(string) # consumer|contract_interface|intra_epg|provider|taboo
          qos_class       = optional(string)

        }
      )))
      controller_type = optional(string)
      description     = optional(string)
      domains = optional(list(object(
        {
          annotation               = optional(string)
          allow_micro_segmentation = optional(bool)
          delimiter                = optional(string)
          domain                   = string
          domain_type              = optional(string)
          domain_vendor            = optional(string)
          port_binding             = optional(string)
          resolution_immediacy     = optional(string)
          security = optional(list(object(
            {
              allow_promiscuous = string
              forged_transmits  = string
              mac_changes       = string
            }
          )))
          vlan_mode = optional(string)
          vlans     = optional(list(number))
        }
      )))
      epg_admin_state        = optional(string)
      epg_type               = optional(string)
      flood_in_encapsulation = optional(string)
      hasMcastSource         = optional(bool)
      label_match_criteria   = optional(string)
      name_alias             = optional(string)
      intra_epg_isolation    = optional(string)
      preferred_group_member = optional(bool)
      qos_class              = optional(string)
      schema                 = optional(string)
      static_paths = optional(list(object(
        {
          encapsulation_type = optional(string)
          epg                = string
          mode               = optional(string)
          name               = string
          nodes              = list(string)
          path_type          = optional(string)
          pod                = optional(number)
          vlans              = list(number)
        }
      )))
      template     = optional(string)
      tenant       = optional(string)
      useg_epg     = optional(bool)
      vrf          = optional(string)
      vrf_schema   = optional(string)
      vrf_template = optional(string)
    }
  ))
}
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
    aci_bridge_domain.bridge_domains
  ]
  for_each               = { for k, v in local.application_epgs : k => v if v.epg_type == "standard" && v.controller_type == "apic" }
  annotation             = each.value.annotation
  application_profile_dn = aci_application_profile.application_profiles[each.value.application_profile].id
  description            = each.value.description
  exception_tag          = each.value.contract_exception_tag
  flood_on_encap         = each.value.flood_in_encapsulation
  fwd_ctrl               = each.value.intra_epg_isolation == true ? "proxy-arp" : "none"
  has_mcast_source       = each.value.hasMcastSource
  is_attr_based_epg      = each.value.useg_epg == true ? "yes" : "no"
  match_t                = each.value.label_match_criteria
  name                   = each.key
  name_alias             = each.value.name_alias
  pc_enf_pref            = each.value.intra_epg_isolation
  pref_gr_memb           = each.value.preferred_group_member == true ? "include" : "exclude"
  prio                   = each.value.qos_class
  shutdown               = each.value.epg_admin_state == "admin_shut" ? "yes" : "no"
  relation_fv_rs_bd      = "uni/tn-${each.value.bd_tenant}/BD-${each.value.bridge_domain}"
  # relation_fv_rs_sec_inherited = ["{Master_fvEPg}"].id
  # relation_fv_rs_cust_qos_pol  = "custom_qos"
  # relation_fv_rs_dpp_pol       = each.value.data_plane_policer
  # relation_fv_rs_aepg_mon_pol  = each.value.monitoring_policy
  # relation_fv_rs_trust_ctrl    = "{fhsTrustCtrlPol}"
  # relation_fv_rs_graph_def     = ["{vzGraphCont}"]
}

resource "mso_schema_template_anp_epg" "application_epgs" {
  provider = mso
  depends_on = [
    mso_tenant.tenants
  ]
  for_each                   = { for k, v in local.application_epgs : k => v if v.controller_type == "ndo" }
  anp_name                   = each.value.application_profile
  bd_name                    = each.value.bridge_domain
  bd_schema_id               = mso_schema.schemas[each.value.bd_schema].id
  bd_template_name           = each.value.bd_template
  display_name               = each.key
  intra_epg                  = each.value.intra_epg_isolation
  intersite_multicast_source = false
  name                       = each.key
  preferred_group            = each.value.preferred_group_member
  proxy_arp                  = each.value.intra_epg_isolation == true ? true : false
  schema_id                  = mso_schema.schemas[each.value.schema].id
  template_name              = each.value.template
  useg_epg                   = each.value.useg_epg
  vrf_name                   = each.value.vrf
  vrf_schema_id              = mso_schema.schemas[each.value.vrf_schema].id
  vrf_template_name          = each.value.vrf_template
}
/*_____________________________________________________________________________________________________________________

* Inband
API Information:
 - Class: "mgmtInB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{epg}"
GUI Location:
 - Tenants > mgmt > Node Management EPGs > In-Band EPG - {epg}

* Out-of-Band
API Information:
 - Class: "mgmtOoB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{epg}"
GUI Location:
 - Tenants > mgmt > Node Management EPGs > Out-of-Band EPG - {epg}
_______________________________________________________________________________________________________________________
*/
resource "aci_node_mgmt_epg" "mgmt_epgs" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
  ]
  for_each                 = { for k, v in local.application_epgs : k => v if length(regexall("band", v.epg_type)) > 0 && v.controller_type == "apic" }
  management_profile_dn    = "uni/tn-mgmt/mgmtp-default"
  name                     = each.key
  annotation               = each.value.annotation
  encap                    = each.value.epg_type == "in_band" ? "vlan-${each.value.vlan}" : ""
  match_t                  = each.value.epg_type == "in_band" ? each.value.label_match_criteria : ""
  name_alias               = each.value.name_alias
  pref_gr_memb             = "exclude"
  prio                     = each.value.qos_class
  type                     = each.value.epg_type
  relation_mgmt_rs_mgmt_bd = "uni/tn-${each.value.bd_tenant}/BD-${each.value.bridge_domain}"
  # relation_fv_rs_cons        = each.value.epg_type == "in_band" ? each.value.consumed_contracts : []
  # relation_fv_rs_prov        = each.value.epg_type == "in_band" ? each.value.provided_contracts : []
  # relation_mgmt_rs_oo_b_prov = each.value.epg_type == "out_of_band" ? each.value.consumed_contracts : []
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsDomAtt"
 - Distinguished Name: /uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/rsdomAtt-[uni/{domain}]
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Domains (VMs and Bare-Metals)
_______________________________________________________________________________________________________________________
*/
resource "aci_epg_to_domain" "epg_to_domains" {
  depends_on = [
    aci_application_epg.application_epgs
  ]
  for_each           = { for k, v in local.epg_to_domains : k => v if v.controller_type == "apic" }
  application_epg_dn = aci_application_epg.application_epgs[each.value.application_epg].id
  tdn = length(
    regexall("physical", each.value.domain_type)
    ) > 0 ? "uni/phys-${each.value.domain}" : length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "uni/vmmp-${each.value.domain_vendor}/dom-${each.value.domain}" : ""
  annotation = each.value.annotation
  binding_type = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.port_binding : "none"
  allow_micro_seg = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.allow_micro_segmentation : false
  delimiter = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.delimiter : ""
  encap = each.value.vlan_mode != "dynamic" && length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : "unknown"
  encap_mode = each.value.vlan_mode != "dynamic" && length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "vlan" : "auto"
  epg_cos = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.epg_cos : "Cos0"
  epg_cos_pref = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.epg_cos_pref : "disabled"
  instr_imedcy = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "immediate" : "lazy" # deploy_immediacy
  lag_policy_name = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.enhanced_lag_policy : 0
  netflow_dir = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.netflow_direction : "both"
  netflow_pref = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.netflow : "disabled"
  num_ports = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.num_ports : 0
  port_allocation = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.port_allocation : "none"
  primary_encap = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "vlan-${element(each.value.vlans, 1)}" : "unknown"
  primary_encap_inner = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.primary_encap_inner : "unknown"
  res_imedcy = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.resolution_immediacy : "lazy" # resolution_immediacy
  secondary_encap_inner = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.secondary_encap_inner : "unknown"
  switching_mode = "native"
  vmm_allow_promiscuous = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["allow_promiscuous"] : "" # "reject"
  vmm_forged_transmits = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["forged_transmits"] : "" # "reject"
  vmm_mac_changes = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["mac_changes"] : "" # "reject"
}


#------------------------------------------
# Assign Contract to EPG
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
* Consumer Contract
 - Class: "fvRsCons"
 - Distinguished Name: "uni/tn-{tenant}/ap-{application_profile}/epg-{epg}/rscons-{contract}"
* Provider Contract
 - Class: "fvRsProv"
 - Distinguished Name: "uni/tn-{tenant}/ap-{application_profile}/epg-{epg}/rsprov-{contract}"
GUI Location:
 - Tenants > {tenant} > Application Profiles > {application_profile} > Application EPGs > {epg} > Contracts
_______________________________________________________________________________________________________________________
*/
# resource "aci_epg_to_contract" "contract_to_epg" {
#     depends_on          = [
#         aci_tenant.tenants,
#         aci_application_epg.application_epgs,
#         aci_contract.contracts
#     ]
#     application_epg_dn  = aci_application_epg.application_epgs[each.value.application_epg].id
#     contract_dn         = length(regexall(
#       "oob", each.value.type)
#       ) > 0 ? aci_rest_managed.oob_contracts[each.value.contract].id : length(regexall(
#       "standard", each.value.type)
#       ) > 0 ? aci_contract.contracts[each.value.contract].id : length(regexall(
#       "taboo", each.value.type)
#     ) > 0 ? apic_taboo_contracts.contracts[each.value.contract].id : ""
#     contract_type       = each.value.type
# }

resource "aci_rest_managed" "contract_to_epgs" {
  depends_on = [
    aci_contract.contracts,
    aci_rest_managed.oob_contracts,
    aci_taboo_contract.contracts,
  ]
  for_each   = local.contract_to_epgs
  dn         = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.application_epg}/${each.value.contract_dn}-${each.value.contract}"
  class_name = each.value.contract_class
  content = {
    tDn = "uni/tn-${each.value.contract_tenant}/${each.value.contract_tdn}-${each.value.contract}"
    # matchT = each.value.match_type
    prio = each.value.qos_class
  }
}



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
# resource "aci_epgs_using_function" "epg_to_aaep" {
#   depends_on = [
#     aci_application_epg.application_epgs,
#     # local.aaep_policies
#   ]
#   for_each          = local.epg_to_aaep
#   access_generic_dn = local.aaep_policies[each.value.aaep].id
#   tdn               = aci_application_epg.application_epgs[each.value.epg].id
#   encap             = "vlan-${each.value.vlan}"
#   instr_imedcy      = "immediate"
#   mode              = "regular"
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsPathAtt"
 - Distinguished Name: "uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/{Static_Path}"
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Static Ports > {GUI_Static}
_______________________________________________________________________________________________________________________
*/
# resource "aci_rest_managed" "epg_to_static_paths" {
#   depends_on = [
#     aci_application_epg.application_epgs
#   ]
#   for_each = local.epg_to_static_paths
#   dn = length(
#     regexall("pc", each.value.path_type)
#     ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.name}]]" : length(
#     regexall("port", each.value.path_type)
#     ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[eth${each.value.name}]]" : length(
#     regexall("vpc", each.value.path_type)
#   ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.name}]]" : ""
#   class_name = "fvRsPathAtt"
#   content = {
#     encap = length(
#       regexall("micro_seg", each.value.encapsulation_type)
#       ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : length(
#       regexall("qinq", each.value.encapsulation_type)
#       ) > 0 ? "qinq-${element(each.value.vlans, 0)}-${element(each.value.vlans, 1)}" : length(
#       regexall("vlan", each.value.encapsulation_type)
#       ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : length(
#       regexall("vxlan", each.value.encapsulation_type)
#     ) > 0 ? "vxlan-${element(each.value.vlans, 0)}" : ""
#     mode = length(
#       regexall("dot1p", each.value.mode)
#       ) > 0 ? "native" : length(
#       regexall("access", each.value.mode)
#     ) > 0 ? "untagged" : "regular"
#     primaryEncap = each.value.encapsulation_type == "micro_seg" ? "vlan-${element(each.value.vlans, 1)}" : "unknown"
#     tDn = length(
#       regexall("pc", each.value.path_type)
#       ) > 0 ? "topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.name}]" : length(
#       regexall("port", each.value.path_type)
#       ) > 0 ? "topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[eth${each.value.name}]" : length(
#       regexall("vpc", each.value.path_type)
#     ) > 0 ? "topology/pod-${each.value.pod}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.name}]" : ""
#   }
# }
