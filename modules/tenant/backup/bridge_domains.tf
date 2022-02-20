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
  for_each            = local.subnets
  description         = each.value.description
  name                = each.key
  annotation          = each.value.annotation
  arp_flood           = each.value.arp_flooding
  bridge_domain_type  = each.value.type
  ep_clear            = each.value.endpoint_clear
  ep_move_detect_mode = each.value.ep_move_detection_mode
  host_based_routing  = each.value.advertise_host_routes
  intersite_bum_traffic_allow = length(regexall(
    "yes", each.value.bd_stretched_to_remote_sites)
  ) > 0 ? each.value.allow_bum_traffic_on_stretched_bd : "no"
  intersite_l2_stretch      = each.value.bd_stretched_to_remote_sites
  ip_learning               = each.value.ip_data_plane_learning
  ipv6_mcast_allow          = each.value.pimv6
  limit_ip_learn_to_subnets = each.value.limit_ip_learn_to_subnets
  ll_addr                   = each.value.link_local_ipv6_address
  mac                       = each.value.custom_mac_address
  mcast_allow               = each.value.pim
  multi_dst_pkt_act         = each.value.multi_destination_flooding
  name_alias                = each.value.name_alias
  optimize_wan_bandwidth = length(regexall(
    "yes", each.value.bd_stretched_to_remote_sites)) > 0 && length(regexall(
    "yes", each.value.allow_bum_traffic_on_stretched_bd)
  ) > 0 ? each.value.optimize_wan_bandwidth : "no"
  relation_fv_rs_ctx = length(regexall(
    each.value.tenant, each.value.vrf_tenant)
    ) > 0 ? aci_vrf.vrfs[each.value.vrf].id : length(regexall(
    "[[:alnum:]]+", each.value.vrf_tenant)
  ) > 0 ? local.common_vrfs[each.value.vrf].id : ""
  relation_fv_rs_abd_pol_mon_pol = "{monEPGPol}"
  relation_fv_rs_bd_to_out = length(regexall(
    each.value.tenant, each.value.l3out_tenant)
    ) > 0 ? [aci_l3_outside.l3outs[each.value.l3out].id] : length(regexall(
    each.value.tenant, each.value.l3out_tenant)
  ) > 0 ? [local.common_l3outs[each.value.l3out].id] : []
  relation_fv_rs_bd_to_ep_ret              = each.value.endpoint_retention_policy
  relation_fv_rs_bd_to_netflow_monitor_pol = [each.value.netflow_monitor_policies]
  relation_fv_rs_bd_to_profile             = each.value.l3out_for_route_profile
  relation_fv_rs_mldsn                     = each.value.mld_snooping_policy
  relation_fv_rs_bd_to_nd_p                = each.value.nd_policy
  relation_fv_rs_bd_flood_to               = [each.value.vzfilter]
  relation_fv_rs_bd_to_fhs                 = each.value.first_hop_security_policy
  relation_fv_rs_bd_to_relay_p             = each.value.dhcp_relay_policy
  relation_fv_rs_igmpsn                    = each.value.igmp_snooping_policy
  tenant_dn                                = aci_tenant.tenants[each.value.tenant].id
  unicast_route                            = each.value.unicast_routing
  unk_mac_ucast_act                        = each.value.l2_unknown_unicast
  unk_mcast_act                            = each.value.l3_unknown_multicast_flooding
  v6unk_mcast_act                          = each.value.ipv6_l3_unknown_multicast
  vmac                                     = each.value.virtual_mac_address
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
  for_each                            = local.subnets
  parent_dn                           = aci_bridge_domain.bridge_domains[each.value.bridge_domain].id
  ctrl                                = each.value.subnet_control
  description                         = each.value.description
  ip                                  = each.value.subnet
  preferred                           = each.value.make_this_ip_address_primary
  relation_fv_rs_bd_subnet_to_out     = [each.value.l3_out_for_route_profile]
  relation_fv_rs_bd_subnet_to_profile = each.value.route_profile
  relation_fv_rs_nd_pfx_pol           = each.value.nd_ra_prefix_policy
  scope                               = [each.value.scope]
  virtual                             = each.value.treat_as_virtual_ip_address
}
