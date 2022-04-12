variable "bridge_domains" {
  default = {
    "default" = {
      general = [
        {
          advertise_host_routes         = false
          alias                         = ""
          annotation                    = ""
          arp_flooding                  = false
          description                   = ""
          endpoint_clear                = false
          endpoint_retention_policy     = ""
          ep_move_detection_mode        = "disable"
          igmp_snooping_policy          = ""
          ipv6_l3_unknown_multicast     = "flood"
          l2_unknown_unicast            = "flood"
          l3_unknown_multicast_flooding = "flood"
          limit_ip_learn_to_subnets     = true
          mld_snoop_policy              = ""
          multi_destination_flooding    = "bd-flood"
          pim                           = false
          pimv6                         = false
          tenant                        = "common"
          type                          = "regular"
          vrf                           = "default"
          vrf_tenant                    = "common"
        }
      ]
      l3_configurations = [
        {
          unicast_routing         = true
          custom_mac_address      = ""
          link_local_ipv6_address = "::"
          subnets = [
            {

              description              = ""
              gateway_ip               = "198.18.5.1/24"
              l3_out_for_route_profile = ""
              associated_l3outs = [
                {
                  l3out        = "default"
                  l3out_tenant = "common"
                }
              ]
              make_this_ip_address_primary = false
              scope = [
                {
                  advertise_externally = false
                  shared_between_vrfs  = false
                }

              ]

              subnet_control = [
                {
                  neighbor_discovery     = true
                  no_default_svi_gateway = false
                  querier_ip             = false
                }
              ]
              treat_as_virtual_ip_address = false
            }
          ]
          virtual_mac_address = ""
        }
      ]
      troubleshooting_advanced = [
        {
          intersite_bum_traffic_allow            = false
          intersite_l2_stretch                   = false
          disable_ip_data_plane_learning_for_pbr = false
          first_hop_security_policy              = ""
          monitoring_policy                      = ""
          netflow_monitor_policies               = []
          optimize_wan_bandwidth                 = false
          rogue_coop_exception_list              = []
        }
      ]
    }
  }
  type = map(object(
    {
      general = list(object(
        {
          advertise_host_routes         = optional(bool)
          alias                         = optional(string)
          annotation                    = optional(string)
          arp_flooding                  = optional(bool)
          description                   = optional(string)
          endpoint_clear                = optional(bool)
          endpoint_retention_policy     = optional(string)
          ep_move_detection_mode        = optional(string)
          igmp_snooping_policy          = optional(string)
          ipv6_l3_unknown_multicast     = optional(string)
          l2_unknown_unicast            = optional(string)
          l3_unknown_multicast_flooding = optional(string)
          limit_ip_learn_to_subnets     = optional(bool)
          mld_snoop_policy              = optional(string)
          multi_destination_flooding    = optional(string)
          pim                           = optional(bool)
          pimv6                         = optional(bool)
          tenant                        = optional(string)
          type                          = optional(string)
          vrf                           = optional(string)
          vrf_tenant                    = optional(string)
        }
      ))
      l3_configurations = list(object(
        {
          unicast_routing         = optional(bool)
          custom_mac_address      = optional(string)
          link_local_ipv6_address = optional(string)
          subnets = optional(list(object(
            {
              description              = optional(string)
              gateway_ip               = string
              l3_out_for_route_profile = optional(string)
              associated_l3outs = optional(list(object(
                {
                  l3out        = optional(string)
                  l3out_tenant = optional(string)
                }
              )))
              make_this_ip_address_primary = optional(bool)
              scope = optional(list(object(
                {
                  advertise_externally = optional(bool)
                  shared_between_vrfs  = optional(bool)
                }
              )))
              subnet_control = optional(list(object(
                {
                  neighbor_discovery     = optional(bool)
                  no_default_svi_gateway = optional(bool)
                  querier_ip             = optional(bool)
                }
              )))
              treat_as_virtual_ip_address = optional(bool)
            }
          )))
          virtual_mac_address = optional(string)
        }
      ))
      troubleshooting_advanced = list(object(
        {
          intersite_bum_traffic_allow            = optional(bool)
          intersite_l2_stretch                   = optional(bool)
          disable_ip_data_plane_learning_for_pbr = optional(bool)
          first_hop_security_policy              = optional(string)
          monitoring_policy                      = optional(string)
          netflow_monitor_policies               = optional(list(string))
          optimize_wan_bandwidth                 = optional(bool)
          rogue_coop_exception_list              = optional(list(string))
        }
      ))
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvBD"
 - Distinguised Name: "/uni/tn-{Tenant}/BD-{Bridge_Domain}"
GUI Location:
 - Tenants > {Tenant} > Networking > Bridge Domains > {Bridge_Domain}
_______________________________________________________________________________________________________________________
*/
resource "aci_bridge_domain" "bridge_domains" {
  depends_on = [
    aci_tenant.tenants,
    aci_vrf.vrfs,
    aci_l3_outside.l3outs
  ]
  for_each = local.bridge_domains
  # General
  annotation         = each.value.annotation
  arp_flood          = each.value.arp_flooding == true ? "yes" : "no"
  bridge_domain_type = each.value.type
  description        = each.value.description
  host_based_routing = each.value.advertise_host_routes == true ? "yes" : "no"
  ipv6_mcast_allow   = each.value.pimv6 == true ? "yes" : "no"
  mcast_allow        = each.value.pim == true ? "yes" : "no"
  name               = each.key
  name_alias         = each.value.name_alias
  multi_dst_pkt_act  = each.value.multi_destination_flooding
  unk_mac_ucast_act  = each.value.l2_unknown_unicast
  unk_mcast_act      = each.value.l3_unknown_multicast_flooding
  v6unk_mcast_act    = each.value.ipv6_l3_unknown_multicast
  # L3 Configurations
  ip_learning               = each.value.disable_ip_data_plane_learning_for_pbr == true ? "yes" : "no"
  limit_ip_learn_to_subnets = each.value.limit_ip_learn_to_subnets == true ? "yes" : "no"
  ll_addr                   = each.value.link_local_ipv6_address
  mac                       = each.value.custom_mac_address
  unicast_route             = each.value.unicast_routing == true ? "yes" : "no"
  vmac                      = each.value.virtual_mac_address
  # Advanced/Troubleshooting
  ep_clear            = each.value.endpoint_clear == true ? "yes" : "no"
  ep_move_detect_mode = each.value.ep_move_detection_mode
  intersite_bum_traffic_allow = length(regexall(
    true, each.value.intersite_l2_stretch)
  ) > 0 && length(regexall(true, each.value.intersite_bum_traffic_allow)) > 0 ? "yes" : "no"
  intersite_l2_stretch   = each.value.intersite_l2_stretch == true ? "yes" : "no"
  optimize_wan_bandwidth = length(regexall(true, each.value.optimize_wan_bandwidth)) > 0 ? "yes" : "no"
  relation_fv_rs_ctx     = each.value.vrf != "" ? "uni/tn-${each.value.vrf_tenant}/ctx-${each.value.vrf}" : ""
  tenant_dn              = aci_tenant.tenants[each.value.tenant].id
  # relation_fv_rs_ctx = length(regexall(
  #   each.value.tenant, each.value.vrf_tenant)
  #   ) > 0 ? aci_vrf.vrfs[each.value.vrf].id : length(regexall(
  #   "[[:alnum:]]+", each.value.vrf_tenant)
  # ) > 0 ? local.common_vrfs[each.value.vrf].id : ""
  # relation_fv_rs_abd_pol_mon_pol = "{monEPGPol}"
  # relation_fv_rs_bd_to_out = each.value.l3out != "" ? "uni/tn-${each.value.l3out_tenant}/out-${each.value.l3out}" : ""
  # relation_fv_rs_bd_to_out = length(regexall(
  #   each.value.tenant, each.value.l3out_tenant)
  #   ) > 0 ? [aci_l3_outside.l3outs[each.value.l3out].id] : length(regexall(
  #   each.value.tenant, each.value.l3out_tenant)
  # ) > 0 ? [local.common_l3outs[each.value.l3out].id] : []
  # relation_fv_rs_bd_to_ep_ret              = each.value.endpoint_retention_policy
  # relation_fv_rs_bd_to_netflow_monitor_pol = [each.value.netflow_monitor_policies]
  # relation_fv_rs_bd_to_profile             = each.value.l3out_for_route_profile
  # relation_fv_rs_mldsn                     = each.value.mld_snoop_policy
  # relation_fv_rs_bd_to_nd_p                = each.value.nd_policy
  # relation_fv_rs_bd_flood_to               = [each.value.vzfilter]
  # relation_fv_rs_bd_to_fhs                 = each.value.first_hop_security_policy
  # relation_fv_rs_bd_to_relay_p             = each.value.dhcp_relay_policy
  # relation_fv_rs_igmpsn                    = each.value.igmp_snooping_policy
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvSubnet"
 - Distinguished Name: "/uni/tn-{Tenant}/BD-{Bridge_Domain}/subnet-[{Subnet}]"
GUI Location:
 - Tenants > {Tenant} > Networking > Bridge Domains > {Bridge_Domain} > Subnets
_______________________________________________________________________________________________________________________
*/
resource "aci_subnet" "subnets" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
    aci_l3_outside.l3outs
  ]
  for_each  = { for k, v in local.subnets : k => v if v.controller_type == "apic" }
  parent_dn = aci_bridge_domain.bridge_domains[each.value.bridge_domain].id
  ctrl = alltrue([each.value.subnet_control["neighbor_discovery"
    ], each.value.subnet_control["no_default_svi_gateway"], each.value.subnet_control["querier_ip"]
    ]) ? ["nd", "no-default-gateway", "querier"] : anytrue([each.value.subnet_control["neighbor_discovery"
    ], each.value.subnet_control["no_default_svi_gateway"], each.value.subnet_control["querier_ip"]
    ]) ? compact(concat([
      length(regexall(true, each.value.subnet_control["neighbor_discovery"])) > 0 ? "nd" : ""], [
      length(regexall(true, each.value.subnet_control["no_default_svi_gateway"])) > 0 ? "no-default-gateway" : ""], [
    length(regexall(true, each.value.subnet_control["querier_ip"])) > 0 ? "querier" : ""]
  )) : ["unspecified"]
  description = each.value.description
  ip          = each.value.gateway_ip
  preferred   = each.value.make_this_ip_address_primary == true ? "yes" : "no"
  # relation_fv_rs_bd_subnet_to_out     = [each.value.l3_out_for_route_profile]
  # relation_fv_rs_bd_subnet_to_profile = each.value.route_profile
  # relation_fv_rs_nd_pfx_pol           = each.value.nd_ra_prefix_policy
  scope = alltrue([each.value.scope["advertise_externally"], each.value.scope["shared_between_vrfs"]
    ]) ? ["public", "shared"] : anytrue([each.value.scope["advertise_externally"
      ], each.value.scope["shared_between_vrfs"]]) ? compact(concat([
      length(regexall(true, each.value.scope["advertise_externally"])) > 0 ? "public" : ""], [
    length(regexall(true, each.value.scope["shared_between_vrfs"])) > 0 ? "shared" : ""]
  )) : ["private"]
  virtual = each.value.treat_as_virtual_ip_address == true ? "yes" : "no"
}

output "bridge_domains" {
  value = local.bridge_domains
}

resource "mso_schema_template_bd" "bridge_domains" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
    mso_schema_template.templates
  ]
  for_each     = { for k, v in local.bridge_domains : k => v if v.controller_type == "ndo" }
  arp_flooding = each.value.arp_flooding
  dynamic "dhcp_policy" {
    for_each = each.value.dhcp_relay_policy
    content {
      name                       = dhcp_policy.value.name
      version                    = dhcp_policy.value.version
      dhcp_option_policy_name    = dhcp_policy.value.dhcp_option_policy_name
      dhcp_option_policy_version = dhcp_policy.value.dhcp_option_policy_version
    }
  }
  display_name                    = each.key
  name                            = each.key
  intersite_bum_traffic           = each.value.intersite_bum_traffic_allow
  ipv6_unknown_multicast_flooding = each.value.ipv6_l3_unknown_multicast
  multi_destination_flooding      = each.value.multi_destination_flooding
  layer2_unknown_unicast          = each.value.l2_unknown_unicast
  layer2_stretch                  = each.value.intersite_l2_stretch
  layer3_multicast                = each.value.pim
  optimize_wan_bandwidth          = each.value.optimize_wan_bandwidth
  schema_id                       = mso_schema.schemas[each.value.schema].id
  template_name                   = each.value.template
  unknown_multicast_flooding      = each.value.unknown_multicast_flooding
  unicast_routing                 = each.value.unicast_routing
  virtual_mac_address             = each.value.virtual_mac_address
  vrf_name                        = each.value.vrf
  vrf_schema_id = each.value.vrf != "" && length(compact(
    [each.value.vrf_schema])
    ) > 0 ? mso_schema.schemas[each.value.vrf_schema].id : length(compact(
    [each.value.vrf])
  ) > 0 ? mso_schema.schemas[each.value.schema].id : ""
  vrf_template_name = each.value.vrf != "" && length(compact(
    [each.value.vrf_template])
    ) > 0 ? each.value.vrf_template : length(compact(
    [each.value.vrf])
  ) > 0 ? each.value.template : ""
}

resource "mso_schema_site_bd" "bridge_domains" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
    mso_schema_template.templates
  ]
  for_each     = { for k, v in local.bridge_domains : k => v if v.controller_type == "ndo" && v.site != "" }
  schema_id     = mso_schema.schemas[each.value.schema].id
  bd_name       = each.key
  template_name = each.value.template
  site_id       = data.mso_site.sites[each.value.site].id
  host_route    = each.value.advertise_host_routes
}

resource "mso_schema_template_bd_subnet" "subnets" {
  provider = mso
  depends_on = [
    mso_schema_template_bd.bridge_domains
  ]
  for_each           = { for k, v in local.subnets : k => v if v.controller_type == "ndo" && v.site == "" }
  bd_name            = each.value.bridge_domain
  description        = each.value.description
  ip                 = each.value.gateway_ip
  no_default_gateway = each.value.subnet_control["no_default_svi_gateway"]
  schema_id          = mso_schema.schemas[each.value.schema].id
  scope              = each.value.scope["advertise_externally"] == true ? "public" : "private"
  template_name      = each.value.template
  shared             = each.value.scope["shared_between_vrfs"]
  querier            = each.value.subnet_control["querier_ip"]
}