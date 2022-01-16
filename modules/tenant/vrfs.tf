variable "vrfs" {
  default = {
    "default" = {
      alias                 = ""
      annotation            = ""
      bd_enforcement_status = ""
      bgp_context_per_address_family = [
        {
          address_family = ""
          policy_name    = ""
        }
      ]
      bgp_timers = "default"
      communities = [
        {
          community = 0
        }
      ]
      contracts = [
        {
          match_type = "AlteastOne"
          name       = ""
          qos_class  = "Unspecified"
          template   = "common"
          tenant     = "common"
          type       = "consumer|interface|provider"
        }
      ]
      description               = ""
      endpoint_retention_policy = "default"
      eigrp_context_per_address_family = [
        {
          address_family = ""
          policy_name    = ""
        }
      ]
      ip_data_plane_learning = "yes"
      layer3_multicast       = true
      level                  = "template"
      monitoring_policy      = ""
      ospf_context_per_address_family = [
        {
          address_family = ""
          policy_name    = ""
        }
      ]
      ospf_timers                   = "default"
      policy_enforcement_direction  = ""
      policy_enforcement_preference = ""
      preferred_group               = "disabled"
      sites                         = []
      template                      = ""
      tenant                        = "common"
      transit_route_tag_policy      = ""
      type                          = "apic"
      vendor                        = "cisco"
      vzany_match_type = "AtleastOne"
    }
  }
  description = <<-EOT
  Key: Name of the VRF.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * type: What is the type of controller.  Options are:
    - apic: For APIC Controllers
    - ndo: For Nexus Dashboard Orchestrator
  * vendor: When using Nexus Dashboard Orchestrator the vendor attribute is used to distinguish the cloud types.  Options are:
    - aws
    - azure
    - cisco (Default)
  EOT
  type = map(object(
    {
      alias                 = optional(string)
      annotation            = optional(string)
      bd_enforcement_status = optional(string)
      bgp_context_per_address_family = optional(map(string(
        {
          address_family = optional(string)
          policy_name    = string
        }
      )))
      bgp_timers = optional(string)
      communities = optional(list(object(
        {
          community = number
        }
      )))
      contracts = optional(list(object(
        {
          name       = string
          qos_class  = optional(string)
          template   = optional(string)
          tenant     = string
          type       = string
        }
      )))
      description = optional(string)
      endpoint_retention_policy = optional(string)
      eigrp_context_per_address_family = optional(map(string(
        {
          address_family = optional(string)
          policy_name    = string
        }
      )))
      ip_data_plane_learning = optional(string)
      layer3_multicast       = optional(bool)
      level                  = optional(string)
      monitoring_policy      = optional(string)
      name                   = string
      ospf_context_per_address_family = optional(map(string(
        {
          address_family = optional(string)
          policy_name    = string
        }
      )))
      ospf_timers                   = optional(string)
      policy_enforcement_direction  = optional(string)
      policy_enforcement_preference = optional(string)
      preferred_group               = optional(string)
      sites                         = optional(list(string))
      template                      = optional(string)
      tenant                        = optional(string)
      transit_route_tag_policy      = optional(string)
      type                          = optional(string)
      vendor                        = optional(string)
      vzany_match_type = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvCtx"
 - Distinguished Name: "uni/tn-{Tenant}/ctx-{VRF}"
GUI Location:
 - Tenants > {Tenant} > Networking > VRFs > {VRF}
_______________________________________________________________________________________________________________________
*/
resource "aci_vrf" "vrfs" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each                     = { for k, v in local.vrfs : k => v if v.type == "apic" }
  annotation                   = each.value.annotation
  bd_enforced_enable           = each.value.bd_enforcement_status
  description                  = each.value.description
  ip_data_plane_learning       = each.value.ip_data_plane_learning
  knw_mcast_act                = each.value.layer3_multicast == true ? "permit" : "deny"
  name                         = each.key
  name_alias                   = each.value.alias
  pc_enf_dir                   = each.value.policy_enforcement_direction
  pc_enf_pref                  = each.value.policy_enforcement_preference
  relation_fv_rs_ctx_to_ep_ret = each.value.endpoint_retention_policy
  relation_fv_rs_ctx_mon_pol   = each.value.monitoring_policy
  relation_fv_rs_bgp_ctx_pol   = each.value.bgp_timers
  dynamic "relation_fv_rs_ctx_to_bgp_ctx_af_pol" {
    for_each = each.value.bgp_context_per_address_family
    content {
      af                     = each.value.address_family
      tn_bgp_ctx_af_pol_name = each.value.polcy_name
    }
  }
  dynamic "relation_fv_rs_ctx_to_eigrp_ctx_af_pol" {
    for_each = each.value.eigrp_context_per_address_family
    content {
      af                       = each.value.address_family
      tn_eigrp_ctx_af_pol_name = each.value.polcy_name
    }
  }
  relation_fv_rs_ospf_ctx_pol = each.value.ospf_timers
  dynamic "relation_fv_rs_ctx_to_ospf_ctx_pol" {
    for_each = each.value.ospf_context_per_address_family
    content {
      af                      = each.value.address_family
      tn_ospf_ctx_af_pol_name = each.value.polcy_name
    }
  }
  # relation_fv_rs_vrf_validation_pol       = "{l3extVrfValidationPol}"
  relation_fv_rs_ctx_to_ext_route_tag_pol = each.value.transit_route_tag_policy
  # relation_fv_rs_ctx_mcast_to             = ["{vzFilter}"]
  tenant_dn = aci_tenant.tenants[each.value.tenant]
}

resource "mso_schema_site_vrf" "vrfs" {
  provider = mso
  depends_on = [
    aci_tenant.tenants,
    mso_schema.schemas
  ]
  for_each      = { for k, v in local.vrfs : k => v if v.type == "ndo" && v.level == "site" }
  template_name = each.value.template
  schema_id     = mso_schema.schemas[each.value.schema].id
  site_id       = data.mso_site.sites[each.value.site].id
  vrf_name      = each.key
}

resource "mso_schema_template_vrf" "vrfs" {
  provider = mso
  depends_on = [
    aci_tenant.tenants,
    mso_schema.schemas
  ]
  for_each         = { for k, v in local.vrfs : k => v if v.type == "ndo" && v.level == "template" }
  schema_id        = mso_schema.schemas[each.value.schema].id
  template         = each.value.template
  name             = each.key
  display_name     = each.key
  layer3_multicast = each.value.layer3_multicast
  vzany            = length(each.value.contracts) > 0 ? true : false
}

/*_____________________________________________________________________________________________________________________

GUI Location:
 - Tenants > {Tenant} > Networking > VRFs > {VRF} > EPG Collection for VRF: [Provided/Consumed Contracts]
_______________________________________________________________________________________________________________________
*/
resource "aci_any" "vzany_contracts" {
  depends_on = [
    aci_vrf.vrfs
  ]
  for_each                      = { for k, v in local.vzany_contracts : k => v if v.type == "apic" }
  vrf_dn                        = aci_vrf.vrfs[each.value.vrf].id
  description                   = each.value.description
  match_t                       = each.value.match_type[each.value.consumed_contracts]
  relation_vz_rs_any_to_cons    = length(each.value.consumed_contracts) > 0 
  relation_vz_rs_any_to_cons_if = [each.value.contract_interfaces]
  relation_vz_rs_any_to_prov    = [each.value.provided_contracts]
}

resource "mso_schema_template_vrf_contract" "vzany" {
  depends_on = [
    mso_schema_template_vrf.vrfs
  ]
  for_each          = { for k, v in local.vrfs_vzany : k => v if v.type == "ndo" && v.level == "template" }
  schema_id         = mso_schema.schemas[each.value.schema].id
  template_name     = each.value.template
  vrf_name          = each.value.vrf
  relationship_type = each.value.type
  contract_name     = each.value.name
  contract_schema_id = length(regexall(
    each.value.tenant, each.value.contract_tenant)
    ) > 0 ? mso_schema.schemas[each.value.schema].id : length(regexall(
    "[[:alnum:]]+", each.value.contract_tenant)
  ) > 0 ? local.common_schemas[each.value.schema].id : ""
  contract_template_name = each.value.contract_template
}

/*_____________________________________________________________________________________________________________________

GUI Location:
 - Tenants > {Tenant} > Networking > VRFs > {VRF}: Policy >  Preferred Group
_______________________________________________________________________________________________________________________
*/
resource "aci_any" "vrf_preferred_group" {
  depends_on = [
    aci_vrf.vrfs
  ]
  for_each     = { for k, v in local.vrfs : k => v if v.preferred_group == "enabled" && v.type == "apic" }
  vrf_dn       = aci_vrf.vrfs[each.value.vrf].id
  description  = each.value.description
  pref_gr_memb = "enabled"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpCtxP"
 - Distinguished Name: "uni/tn-{tenant}/ctx-{vrf}/snmpctx"
GUI Location:
 - Tenants > {tenant} > Networking > VRFs > {vrf} > Create SNMP Context
_______________________________________________________________________________________________________________________
*/
resource "aci_vrf_snmp_context" "vrf_snmp_contexts" {
  depends_on = [
    aci_vrf.vrfs
  ]
  for_each   = { for k, v in local.vrfs : k => v if v.type == "apic" }
  annotation = each.value.annotation
  name       = each.key
  name_alias = each.value.alias
  vrf_dn     = aci_vrf.vrfs[each.key].id
}


/*_____________________________________________________________________________________________________________________

GUI Location:
Tenants > {tenant} > Networking > VRFs > {vrf} > Create SNMP Context: Community Profiles
_______________________________________________________________________________________________________________________
*/
resource "aci_vrf_snmp_context_community" "example" {
  depends_on = [
    aci_vrf_snmp_context.vrf_snmp_contexts
  ]
  for_each   = local.vrf_commmunities
  annotation = each.value.annotation
  name = length(regexall(
    5, each.value.community)) > 0 ? var.snmp_community_5 : length(regexall(
    4, each.value.community)) > 0 ? var.snmp_community_4 : length(regexall(
    3, each.value.community)) > 0 ? var.snmp_community_3 : length(regexall(
  2, each.value.community)) > 0 ? var.snmp_community_2 : var.snmp_community_1
  name_alias          = each.value.alias
  vrf_snmp_context_dn = aci_vrf_snmp_context.vrf_snmp_contexts[each.value.vrf].id
}
