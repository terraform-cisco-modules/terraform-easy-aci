variable "vrfs" {
  default = {
    "default" = {
      annotation                      = ""
      bd_enforcement_status           = false
      bgp_timers                      = "default"
      bgp_timers_per_address_family   = []
      communities                     = []
      contracts                       = []
      description                     = ""
      eigrp_timers_per_address_family = []
      endpoint_retention_policy       = "default"
      ip_data_plane_learning          = "enabled"
      layer3_multicast                = true
      level                           = "template"
      monitoring_policy               = ""
      name_alias                      = ""
      ospf_timers                     = "default"
      ospf_timers_per_address_family  = []
      policy_enforcement_direction    = "ingress"  # "egress"
      policy_enforcement_preference   = "enforced" # unenforced
      preferred_group                 = "disabled"
      schema                          = "common"
      sites                           = []
      tags                            = []
      template                        = ""
      tenant                          = "common"
      transit_route_tag_policy        = ""
      type                            = "apic"
      vendor                          = "cisco"
    }
  }
  description = <<-EOT
  Key: Name of the VRF.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bgp_context_per_address_family: 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
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
      annotation            = optional(string)
      bd_enforcement_status = optional(bool)
      bgp_timers            = optional(string)
      bgp_timers_per_address_family = optional(list(object(
        {
          address_family = optional(string)
          policy         = string
        }
      )))
      communities = optional(list(object(
        {
          community = number
        }
      )))
      contracts = optional(list(object(
        {
          match_type = optional(string)
          name       = string
          qos_class  = optional(string)
          schema     = optional(string)
          template   = optional(string)
          tenant     = string
          type       = string
        }
      )))
      description = optional(string)
      eigrp_timers_per_address_family = optional(list(object(
        {
          address_family = optional(string)
          policy         = string
        }
      )))
      endpoint_retention_policy = optional(string)
      ip_data_plane_learning    = optional(string)
      layer3_multicast          = optional(bool)
      level                     = optional(string)
      name_alias                = optional(string)
      monitoring_policy         = optional(string)
      ospf_timers               = optional(string)
      ospf_timers_per_address_family = optional(list(object(
        {
          address_family = optional(string)
          policy         = string
        }
      )))
      policy_enforcement_direction  = optional(string)
      policy_enforcement_preference = optional(string)
      preferred_group               = optional(string)
      schema                        = optional(string)
      sites                         = optional(list(string))
      tags = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      template                 = optional(string)
      tenant                   = optional(string)
      transit_route_tag_policy = optional(string)
      type                     = optional(string)
      vendor                   = optional(string)
    }
  ))
}

variable "snmp_community_1" {
  default     = ""
  description = "SNMP Community 1."
  sensitive   = true
  type        = string
}

variable "snmp_community_2" {
  default     = ""
  description = "SNMP Community 2."
  sensitive   = true
  type        = string
}

variable "snmp_community_3" {
  default     = ""
  description = "SNMP Community 3."
  sensitive   = true
  type        = string
}

variable "snmp_community_4" {
  default     = ""
  description = "SNMP Community 4."
  sensitive   = true
  type        = string
}

variable "snmp_community_5" {
  default     = ""
  description = "SNMP Community 5."
  sensitive   = true
  type        = string
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
  for_each = { for k, v in local.vrfs : k => v if v.type == "apic" }
  # annotation             = each.value.annotation != "" ? each.value.annotation : var.annotation
  bd_enforced_enable     = each.value.bd_enforcement_status == true ? "yes" : "no"
  description            = each.value.description
  ip_data_plane_learning = each.value.ip_data_plane_learning
  knw_mcast_act          = each.value.layer3_multicast == true ? "permit" : "deny"
  name                   = each.key
  name_alias             = each.value.name_alias
  pc_enf_dir             = each.value.policy_enforcement_direction
  pc_enf_pref            = each.value.policy_enforcement_preference
  relation_fv_rs_ctx_to_ep_ret = length(regexall(
    "[[:alnum:]]", each.value.endpoint_retention_policy)
  ) > 0 ? aci_end_point_retention_policy.endpoint_retention_policies[each.value.endpoint_retention_policy].id : ""
  relation_fv_rs_ctx_mon_pol = length(regexall(
    "uni\\/tn\\-", each.value.monitoring_policy)
    ) > 0 ? each.value.monitoring_policy : length(regexall(
    "[[:alnum:]]", each.value.monitoring_policy)
  ) > 0 ? "uni/tn-common/monepg-${each.value.monitoring_policy}" : ""
  relation_fv_rs_bgp_ctx_pol = length(regexall(
    "uni\\/tn\\-", each.value.bgp_timers)
    ) > 0 ? each.value.bgp_timers : length(regexall(
    "[[:alnum:]]", each.value.bgp_timers)
  ) > 0 ? "uni/tn-common/bgpCtxP-${each.value.bgp_timers}" : ""
  dynamic "relation_fv_rs_ctx_to_bgp_ctx_af_pol" {
    for_each = each.value.bgp_timers_per_address_family
    content {
      af = "${relation_fv_rs_ctx_to_bgp_ctx_af_pol.value.address_family}-ucast"
      tn_bgp_ctx_af_pol_name = length(regexall(
        "uni\\/tn\\-", relation_fv_rs_ctx_to_bgp_ctx_af_pol.value.policy)
        ) > 0 ? relation_fv_rs_ctx_to_bgp_ctx_af_pol.value.policy : length(regexall(
        "[[:alnum:]]", relation_fv_rs_ctx_to_bgp_ctx_af_pol.value.policy)
      ) > 0 ? "uni/tn-common/bgpCtxAfP-${relation_fv_rs_ctx_to_bgp_ctx_af_pol.value.policy}" : ""
    }
  }
  dynamic "relation_fv_rs_ctx_to_eigrp_ctx_af_pol" {
    for_each = each.value.eigrp_timers_per_address_family
    content {
      af = "${relation_fv_rs_ctx_to_eigrp_ctx_af_pol.value.address_family}-ucast"
      tn_eigrp_ctx_af_pol_name = length(regexall(
        "uni\\/tn\\-", relation_fv_rs_ctx_to_eigrp_ctx_af_pol.value.policy)
        ) > 0 ? relation_fv_rs_ctx_to_eigrp_ctx_af_pol.value.policy : length(regexall(
        "[[:alnum:]]", relation_fv_rs_ctx_to_eigrp_ctx_af_pol.value.policy)
      ) > 0 ? "uni/tn-common/eigrpCtxAfP-${relation_fv_rs_ctx_to_eigrp_ctx_af_pol.value.policy}" : ""
    }
  }
  relation_fv_rs_ospf_ctx_pol = length(regexall(
    "uni\\/tn\\-", each.value.ospf_timers)
    ) > 0 ? each.value.ospf_timers : length(regexall(
    "[[:alnum:]]", each.value.ospf_timers)
  ) > 0 ? "uni/tn-common/ospfCtxP-${each.value.ospf_timers}" : ""
  dynamic "relation_fv_rs_ctx_to_ospf_ctx_pol" {
    for_each = each.value.ospf_timers_per_address_family
    content {
      af = "${relation_fv_rs_ctx_to_ospf_ctx_pol.value.address_family}-ucast"
      tn_ospf_ctx_pol_name = length(regexall(
        "uni\\/tn\\-", relation_fv_rs_ctx_to_ospf_ctx_pol.value.policy)
        ) > 0 ? relation_fv_rs_ctx_to_ospf_ctx_pol.value.policy : length(regexall(
        "[[:alnum:]]", relation_fv_rs_ctx_to_ospf_ctx_pol.value.policy)
      ) > 0 ? "uni/tn-common/ospfCtxAfP-${relation_fv_rs_ctx_to_ospf_ctx_pol.value.policy}" : ""
    }
  }
  relation_fv_rs_ctx_to_ext_route_tag_pol = length(regexall(
    "uni\\/tn\\-", each.value.transit_route_tag_policy)
    ) > 0 ? each.value.transit_route_tag_policy : length(regexall(
    "[[:alnum:]]", each.value.transit_route_tag_policy)
  ) > 0 ? "uni/tn-common/rttag-${each.value.transit_route_tag_policy}" : ""
  # relation_fv_rs_ctx_mcast_to             = ["{vzFilter}"]
  tenant_dn = aci_tenant.tenants[each.value.tenant].id
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
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  name       = each.key
  name_alias = ""
  vrf_dn     = aci_vrf.vrfs[each.key].id
}


/*_____________________________________________________________________________________________________________________

GUI Location:
Tenants > {tenant} > Networking > VRFs > {vrf} > Create SNMP Context: Community Profiles
_______________________________________________________________________________________________________________________
*/
resource "aci_snmp_community" "vrf_communities" {
  depends_on = [
    aci_vrf_snmp_context.vrf_snmp_contexts
  ]
  for_each   = local.vrf_communities
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  name = length(regexall(
    5, each.value.community)) > 0 ? var.snmp_community_5 : length(regexall(
    4, each.value.community)) > 0 ? var.snmp_community_4 : length(regexall(
    3, each.value.community)) > 0 ? var.snmp_community_3 : length(regexall(
  2, each.value.community)) > 0 ? var.snmp_community_2 : var.snmp_community_1
  name_alias = ""
  parent_dn  = aci_vrf_snmp_context.vrf_snmp_contexts[each.value.vrf].id
}
/*_____________________________________________________________________________________________________________________

GUI Location:
 - Tenants > {Tenant} > Networking > VRFs > {VRF} > EPG Collection for VRF: [Provided/Consumed Contracts]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "vzany_provider_contracts" {
  for_each   = { for k, v in local.vzany_contracts : k => v if v.type == "apic" && v.contract_type == "provider" }
  dn         = "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}/any/rsanyToCons-${each.value.contract}"
  class_name = "vzRsAnyToProv"
  content = {
    tDn    = "uni/tn-${each.value.contract_tenant}/brc-${each.value.contract}"
    matchT = each.value.match_type
    prio   = each.value.qos_class
  }
}

resource "aci_rest_managed" "vzany_contracts" {
  for_each = { for k, v in local.vzany_contracts : k => v if v.type == "apic" && v.contract_type != "provider" }
  dn = length(regexall(
    "consumer", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}/any/rsanyToCons-${each.value.contract}" : length(regexall(
    "interface", each.value.contract_type)
  ) > 0 ? "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}/any/rsanyToCons-${each.value.contract}" : ""
  class_name = length(regexall(
    "consumer", each.value.contract_type)
    ) > 0 ? "vzRsAnyToCons" : length(regexall(
    "interface", each.value.contract_type)
  ) > 0 ? "vzRsAnyToConsIf" : ""
  content = {
    tDn  = "uni/tn-${each.value.contract_tenant}/brc-${each.value.contract}"
    prio = each.value.qos_class
  }
}

resource "mso_schema_template_vrf_contract" "vzany_contracts" {
  depends_on = [
    mso_schema_template_vrf.vrfs
  ]
  for_each          = { for k, v in local.vzany_contracts : k => v if v.type == "ndo" && v.level == "template" }
  schema_id         = mso_schema.schemas[each.value.schema].id
  template_name     = each.value.template
  vrf_name          = each.value.vrf
  relationship_type = each.value.contract_type
  contract_name     = each.value.contract
  contract_schema_id = length(regexall(
    each.value.tenant, each.value.contract_tenant)
    ) > 0 ? mso_schema.schemas[each.value.contract_schema].id : length(regexall(
    "[[:alnum:]]+", each.value.contract_tenant)
  ) > 0 ? local.rs_schemas[each.value.contract_schema].id : ""
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
  for_each     = { for k, v in local.vrfs : k => v if v.type == "apic" && v.preferred_group == "enabled" }
  vrf_dn       = aci_vrf.vrfs[each.value.vrf].id
  description  = each.value.description
  pref_gr_memb = "enabled"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAnnotation"
 - Distinguished Name: "uni/tn-{tenant}/ctx-{vrf}/annotationKey-[{key}]"
GUI Location:
 - Tenants > {Tenant} > Networking > VRFs > {VRF}: {annotations}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "vrf_tags" {
  for_each   = { for k, v in local.vrf_tags : k => v if v.type == "apic" }
  dn         = "uni/tn-${each.value.tenant}/ctx-${each.value.vrf}/annotationKey-[${each.value.key}]"
  class_name = "tagAnnotation"
  content = {
    key   = each.value.key
    value = each.value.value
  }
}

