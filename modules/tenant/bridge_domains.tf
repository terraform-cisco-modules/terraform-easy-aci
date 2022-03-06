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
              advertise_externally     = false
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
              shared_between_vrfs          = false
              subnet_control = [
                {
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
          allow_bum_traffic_on_stretched_bd      = false
          bd_stretched_to_remote_sites           = false
          disable_ip_data_plane_learning_for_pbr = false
          first_hop_security_policy              = ""
          monitoring_policy                      = ""
          netflow_monitor_policies               = []
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
              advertise_externally     = optional(bool)
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
              shared_between_vrfs          = optional(bool)
              subnet_control = optional(list(object(
                {
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
          allow_bum_traffic_on_stretched_bd      = optional(bool)
          bd_stretched_to_remote_sites           = optional(bool)
          disable_ip_data_plane_learning_for_pbr = optional(bool)
          first_hop_security_policy              = optional(string)
          monitoring_policy                      = optional(string)
          netflow_monitor_policies               = optional(list(string))
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
  for_each            = local.bridge_domains
  annotation          = each.value.annotation
  arp_flood           = each.value.arp_flooding == true ? "yes" : "no"
  bridge_domain_type  = each.value.type
  description         = each.value.description
  ep_clear            = each.value.endpoint_clear == true ? "yes" : "no"
  ep_move_detect_mode = each.value.ep_move_detection_mode
  host_based_routing  = each.value.advertise_host_routes
  intersite_bum_traffic_allow = length(regexall(
    true, each.value.bd_stretched_to_remote_sites)
  ) > 0 && length(regexall(true, each.value.allow_bum_traffic_on_stretched_bd)) > 0 ? "yes" : "no"
  intersite_l2_stretch      = each.value.bd_stretched_to_remote_sites == true ? "yes" : "no"
  ip_learning               = each.value.disable_ip_data_plane_learning_for_pbr == true ? "yes" : "no"
  ipv6_mcast_allow          = each.value.pimv6 == true ? "yes" : "no"
  limit_ip_learn_to_subnets = each.value.limit_ip_learn_to_subnets == true ? "yes" : "no"
  ll_addr                   = each.value.link_local_ipv6_address
  mac                       = each.value.custom_mac_address
  mcast_allow               = each.value.pim == true ? "yes" : "no"
  multi_dst_pkt_act         = each.value.multi_destination_flooding
  name                      = each.key
  name_alias                = each.value.alias
  optimize_wan_bandwidth = length(regexall(
    true, each.value.bd_stretched_to_remote_sites)) > 0 && length(regexall(
    true, each.value.allow_bum_traffic_on_stretched_bd)
  ) > 0 ? "yes" : "no"
  relation_fv_rs_ctx = each.value.vrf != "" ? "uni/tn-${each.value.vrf_tenant}/ctx-${each.value.vrf}" : ""
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
  tenant_dn         = aci_tenant.tenants[each.value.tenant].id
  unicast_route     = each.value.unicast_routing == true ? "yes" : "no"
  unk_mac_ucast_act = each.value.l2_unknown_unicast
  unk_mcast_act     = each.value.l3_unknown_multicast_flooding
  v6unk_mcast_act   = each.value.ipv6_l3_unknown_multicast
  # vmac              = each.value.virtual_mac_address
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
  for_each  = local.subnets
  parent_dn = aci_bridge_domain.bridge_domains[each.value.bridge_domain].id
  # ctrl                                = each.value.subnet_control
  description = each.value.description
  ip          = each.value.gateway_ip
  preferred   = each.value.make_this_ip_address_primary == true ? "yes" : "no"
  # relation_fv_rs_bd_subnet_to_out     = [each.value.l3_out_for_route_profile]
  # relation_fv_rs_bd_subnet_to_profile = each.value.route_profile
  # relation_fv_rs_nd_pfx_pol           = each.value.nd_ra_prefix_policy
  # scope                               = [each.value.scope]
  virtual = each.value.treat_as_virtual_ip_address == true ? "yes" : "no"
}

output "bridge_domains" {
  value = local.bridge_domains
}