/*_____________________________________________________________________________________________________________________

Tenant — Bridge Domain — Variables
_______________________________________________________________________________________________________________________
*/
variable "bridge_domains" {
  default = {
    "default" = {
      advanced_troubleshooting = [
        {
          disable_ip_data_plane_learning_for_pbr = false
          endpoint_clear                         = false
          first_hop_security_policy              = ""
          intersite_bum_traffic_allow            = false
          intersite_l2_stretch                   = false
          monitoring_policy                      = ""
          netflow_monitor_policies               = []
          optimize_wan_bandwidth                 = false
          rogue_coop_exception_list              = []
        }
      ]
      controller_type   = "apic"
      dhcp_relay_labels = []
      /* example dhcp_relay_labels
      dhcp_relay_labels = [
        {
          dhcp_option_policy = ""
          names = ["default"]
          scope = "infra"
        }
      ]
      */
      general = [
        {
          advertise_host_routes         = false
          alias                         = ""
          annotation                    = ""
          annotations                   = []
          arp_flooding                  = false
          description                   = ""
          endpoint_retention_policy     = ""
          global_alias                  = ""
          igmp_interface_policy         = ""
          igmp_snooping_policy          = ""
          ipv6_l3_unknown_multicast     = "flood"
          l2_unknown_unicast            = "flood"
          l3_unknown_multicast_flooding = "flood"
          limit_ip_learn_to_subnets     = true
          mld_snoop_policy              = ""
          multi_destination_flooding    = "bd-flood"
          pim                           = false
          pimv6                         = false
          type                          = "regular"
          vrf                           = "default"
          /* If undefined the Bridge Domain Tenant will be used
          vrf_schema                    = bd.tenant
          vrf_template                  = bd.tenant
          vrf_tenant                    = bd.tenant
          */
        }
      ]
      l3_configurations = [
        {
          associated_l3outs = [
            {
              l3out         = ["default"]
              route_profile = "" # Only one L3out can have a route_profile associated to it for the BD
              /* If undefined the Bridge Domain Tenant will be used
              tenant        = bd.tenant
              */
            }
          ]
          custom_mac_address      = ""
          ep_move_detection_mode  = false
          link_local_ipv6_address = "::"
          subnets = {
            "198.18.5.1/24" = {
              description                  = ""
              ip_data_plane_learning       = "enabled"
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
          }
          unicast_routing     = true
          virtual_mac_address = ""
        }
      ]
      sites = []
      /* If undefined the variable of local.first_tenant will be used for:
      policy_source_tenant = local.first_tenant
      schema               = local.first_tenant
      tenant               = local.first_tenant
      template             = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key — Name of the Bridge Domain.
    * advanced_troubleshooting: (optional) — Map of Advanced/Troubleshooting Configuration Parameters for the Bridge Domain.
      - disable_ip_data_plane_learning_for_pbr: (optional) — Controls whether the remote leaf switch should update the IP-to-VTEP information with the source VTEP of traffic coming from this bridge domain. The options are:
        * false: (default)
        * true - Change this setting to true, only if the bridge domain is to be associated with policy-based redirect (PBR) enabled endpoint groups.
        * Note: Use caution when changing the default setting for this field. Setting this option to no can cause suboptimal traffic forwarding for non-PBR scenarios.   Options are:
      - endpoint_clear: (optional) — Set this to Clear the Endpoint Table on the Bridge Domain.  Options are:
        * false: (default)
        * true
      - first_hop_security_policy: (optional) — The name of a First Hop Security Policy to Associate.
      - intersite_bum_traffic_allow: (optional) — When extending the bridge domain between sites this option is to permit broadcast unknown multicast (BUM) traffic between the sites.  Options are:
        * false: (default)
        * true
      - intersite_l2_stretch: (optional) — Extend the Bridge Domain between ACI Fabrics.  Options are:
        * false: (default)
        * true
      - monitoring_policy: (APIC Only) (optional) — The name of a Monitoring Policy to Associate.
      - netflow_monitor_policies: (optional) — A NetFlow Monitor Policy identifies packet flows for ingress IP packets and provides statistics based on these packet flows.
        * filter_type: (optional) — The Type of IP Traffic to provide statistics for.  Options are:
          - ce
          - ipv4: (default)
          - ipv6
        * netflow_policy: (required) - Name of a Netflow Policy to assign to the Bridge Domain.
      - optimize_wan_bandwidth: (optional) — Any defined bridge domain is associated with a multicast group address (or a set of multicast addresses), usually referred to as the GIPo address. Depending on the number of configured bridge domains, the same GIPo address may be associated with different bridge domains. Thus, when flooding for one of those bridge domains is enabled across sites, BUM traffic for the other bridge domains using the same GIPo address is also sent across the sites and will then be dropped on the received spine nodes. This behavior can increase the bandwidth utilization in the intersite network.  Because of this behavior, when a bridge domain is configured as stretched with BUM flooding enabled from the Cisco Multi-Site Orchestrator GUI, by default a GIPo address is assigned from a separate range of multicast addresses. This is reflected in the GUI by the “OPTIMIZE WAN BANDWIDTH”.  Options are:
        * false: (default)
        * true
      - rogue_coop_exception_list: (optional) — A list of MAC addresses for which you want to have a higher tolerance for endpoint movement with rogue endpoint control before the endpoints get marked as rogue. Endpoints in the rogue/COOP exception list get marked as rogue only if they move 3000 or more times within 10 minutes. After an endpoint is marked as rogue, the endpoint is kept static so that learning is prevented and the traffic to and from the endpoint is dropped. The rogue endpoint is deleted after 30 seconds.
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * dhcp_relay_labels: (optional) — DHCP Relay Policies to assign to the bridge domain.
      - dhcp_option_policy: (optional) — Name of the DHCP option policy to assign to the relay labels.
      - names: (required) — List of DHCP Relay Policies to assign to the bridge domain
      - scope: (default: infra) —  The owner of the target relay. The DHCP relay is any host that forwards DHCP packets between clients and servers. The relays are used to forward requests and replies between clients and servers when they are not on the same physical subnet. The relay owner can be:
        * infra — The owner is the infrastructure
        * tenant — The owner is the tenant
    * general: (optional) — Map of General Configuration Parameters for the Bridge Domain.
      - advertise_host_routes: (optional) — .  Options are:
        * false: (default)
        * true
      - alias: (APIC Only) (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
      - annotation: (APIC Only) (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
      - annotations: (APIC Only) (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
      - arp_flooding: (optional) — .  Options are:
        * false: (default)
        * true
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - endpoint_retention_policy: (APIC Only) (optional) — Provides the parameters for the lifecycle of the endpoint group in the bridge domain.  This will assign the policy to the BD.
      - igmp_interface_policy: (APIC Only) (optional) — Name of the IGMP Interface Policy to assign to the Bridge Domain.
      - igmp_snooping_policy: (APIC Only) (optional) — Name of the IGMP Snooping Policy to assign to the Bridge Domain.  IGMP snooping is the process of listening to Internet Group Management Protocol (IGMP) network traffic. The feature allows a network switch to listen in on the IGMP conversation between hosts and routers and filter multicasts links that do not need them, thus controlling which ports receive specific multicast traffic.
      - ipv6_l3_unknown_multicast: (optional) — The node forwarding parameter for Layer 3 unknown Multicast destinations. The value can be:
        * flood: (default) — Send the data to the front panel ports if a router port exists on any bridge domain or send the data to the fabric if the data is in transit.
        * opt-flood — Send the data only to router ports in the fabric.
      - l2_unknown_unicast: (optional) — By default, unicast traffic is flooded to all Layer 2 ports. If enabled, unicast traffic flooding is blocked at a specific port, only permitting egress traffic with MAC addresses that are known to exist on the port. The method can be:
        * flood
        * proxy: (default)
        * NOTE: When the BD has L2 Unknown Unicast set to Flood, if an endpoint is deleted the system deletes it from both the local leaf switches as well as the remote leaf switches where the BD is deployed, by selecting Clear Remote MAC Entries. Without this feature, the remote leaf continues to have this endpoint learned until the timer expires.
        * CAUTION:  Modifying the L2 Unknown Unicast setting causes traffic to bounce (go down and up) on interfaces to devices attached to EPGs associated with this bridge domain.
      - l3_unknown_multicast_flooding: (optional) — The node forwarding parameter for Layer 3 unknown Multicast destinations. The value can be:
        * flood: (default) — Send the data to the front panel ports if a router port exists on any bridge domain or send the data to the fabric if the data is in transit.
        * opt-flood — Send the data only to router ports in the fabric.
      - limit_ip_learn_to_subnets: (APIC Only) (optional) — .  Options are:
        * false
        * true: (default)
      - mld_snoop_policy: (APIC Only) (optional) — Name of the MLD Snooping Policy to assign to the Bridge Domain.  The Multicast Listener Discovery (MLD) Snooping policy enables the efficient distribution of IPv6 multicast traffic between hosts and routers. It is a Layer 2 feature that restricts IPv6 multicast traffic within a bridge domain to a subset of ports that have transmitted or received MLD queries or reports.
      - multi_destination_flooding: (optional) — The multiple destination forwarding method for L2 Multicast, Broadcast, and Link Layer traffic types. The method can be:
        * bd-flood: (default) — Sends the data to all ports on the same bridge domain.
        * drop — Drops Packet. Never sends the data to any other ports.
        * encap-flood — Sends the data to the ports on the same VLAN within the bridge domain regardless of the EPG, with the exception that data for the following protocols is flooded to the entire bridge domain:
          - ARP/GARP
          - BGP
          - EIGRP
          - IGMP
          - IS-IS
          - OSPF/OSPFv6
          - ND
          - PIM
      - global_alias: (APIC Only) (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
      - pim: (APIC Only) (optional) — Enables the Protocol Independent Multicast (PIM) protocol.  Options are:
        * false: (default)
        * true
      - pimv6: (APIC Only) (optional) — Enables the Protocol Independent Multicast (PIM) IPv6 protocol.  Options are:
        * false: (default)
        * true
      - type: (APIC Only) (optional) — The Type of bridge domain to create.  Options are:
        * fc
        * regular: (default)
      - vrf: (default: default) — Name of the VRF to Assign to the Bridge Domain.
      - vrf_schema: (optional) — local.first_tenant will be used if this is not defined.  This is an NDO Specific Attribute.
      - vrf_template: (optional) — local.first_tenant will be used if this is not defined.  This is an NDO Specific Attribute.
      - vrf_tenant: (optional) — local.first_tenant will be used if this is not defined
    * l3_configurations: (optional) — Map of Layer 3 Configuration Parameters for the Bridge Domain.
      - associated_l3outs: (optional) — List of L3Outs to Associate to the Bridge Domain.
        * l3out: (optional) — Names of the L3Outs to Associate. One L3Out with APIC, One per site for Nexus Dashboard Orchestrator
        * route_profile: (optional) — Name of a Route Profile to associate to the L3Out.
          - **Note: Only one L3out can have a route_profile associated to it for the BD
        * tenant: (default: bd.tenant) —  The Name of the tenant for the L3Out.  If Undefined the Bridge Domain tenant will be utilized.
      - custom_mac_address: (SVI MAC Address in NDO) (optional) — The MAC address of the bridge domain (BD) or switched virtual interface (SVI). By default, a BD takes the fabric wide default MAC address of 00:22:BD:F8:19:FF. Configure this property to override the default address.
      - ep_move_detection_mode: (optional) — When the GARP based detection option is enabled, Cisco ACI will trigger an endpoint move based on GARP packets if the move occurs on the same interface and same EPG.  The Default is "false", but it is a best practice to set to "true", if ARP Flooding is enabled.
        * false: (default)
        * true
        * Note: This can only be used when ARP Flooding is enabled.
      - link_local_ipv6_address: (optional) — Link-Local IPv6 address (LLA) for the bridge domain.
      - subnets: (optional) — List of Subnets and their Settings to Assign to the Bridge Domain.
        * Key: (required) — Subnet to Add. "X.X.X.X/Prefix" is the format.
        * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
        * ip_data_plane_learning: (APIC Only) (optional) — Choose whether to enable or disable IP address learning for this subnet. The possible values are:
          - disabled — Disables IP address learning for this subnet.
          - enabled: (default) — Enables IP address learning for this subnet.
        * make_this_ip_address_primary: (optional) — Indicates if the subnet is the primary IP address for the bridge domain (preferred over the available alternatives).
          - false: (default)
          - true
        * scope: (optional) — The network visibility of the subnet. The scope can be:
          - advertise_externally: (optional) — The subnet can be exported to a routed connection.  Options are:
            * false: (default)
            * true
          - shared_between_vrfs: (optional) — The subnet can be shared with and exported to multiple contexts (VRFs) in the same tenant or across tenants as part of a shared service. An example of a shared service is a routed connection to an EPG present in another context (VRF) in a different tenant. This enables traffic to pass in both directions across contexts (VRFs). An EPG that provides a shared service must have its subnet configured under that EPG (not under a bridge domain), and its scope must be set to advertised externally, and shared between VRFs.
            * false: (default)
            * true
            * Note: Shared subnets must be unique across the contexts (VRF) involved in the communication. When a subnet under an EPG provides a Layer 3 external network shared service, such a subnet must be globally unique within the entire ACI fabric.
        * subnet_control: (optional) — 
          - neighbor_discovery: (APIC Only) (optional) — Enables Neighbor Discovery on the subnet. Options are:
            * false
            * true: (default)
          - no_default_svi_gateway: (optional) — When using Cisco ACI Multi-Site with this APIC fabric domain (site), indicates that the VRF, EPG, or BD using this subnet are mirrored from another site, which has a relationship to this site through a contract. Do not modify or delete the mirrored objects. Options are:
            * false: (default)
            * true
          - querier_ip: (optional) — Enables IGMP Snooping on the subnet.  Options are:
            * false: (default)
            * true
        * treat_as_virtual_ip_address: (optional) — An IP address that doesn't correspond to an actual physical network interface, that is shared by multiple devices.  This is typically used for the Common Pervasive Gateway use case. For more information, see Common Pervasive Gateway in Cisco APIC Layer 3 Configuration Guide.   Options are:
          - false: (default)
          - true
      - unicast_routing: (APIC Only) (optional) — Enable or disable unicast routing on the Bridge Domain.   Options are:
        * false
        * true: (default)
        * Note: We recommend disabling, if you have not configured a subnet on the BD.
      - virtual_mac_address: (optional) — The Bridge Domain Virtual MAC address.  The BD virtual MAC address and the subnet virutal IP address must be the same for all ACI fabrics for that bridge domain. Multiple bridge domains can be configured to communicate across connected ACI fabrics. The virtual MAC address and the virtual IP address can be shared across bridge domains.
    * policy_source_tenant: (default: local.first_tenant) — Name of the tenant that contains the policies to assign to the Bridge Domain.
    * tenant: (default: local.tenant) — The Name of the Tenant to create the Bridge Domain within.
    NDO Specific Attributes:
    * schema: (required) — Schema Name.
    * sites: (optional) — List of Site Names to assign site specific attributes.
    * template: (required) — The Template name to create the object within.
  EOT
  type = map(object(
    {
      advanced_troubleshooting = optional(list(object(
        {
          disable_ip_data_plane_learning_for_pbr = optional(bool)
          endpoint_clear                         = optional(bool)
          first_hop_security_policy              = optional(string)
          intersite_bum_traffic_allow            = optional(bool)
          intersite_l2_stretch                   = optional(bool)
          monitoring_policy                      = optional(string)
          netflow_monitor_policies = optional(list(object(
            {
              filter_type    = optional(string)
              netflow_policy = string
            }
          )))
          optimize_wan_bandwidth    = optional(bool)
          rogue_coop_exception_list = optional(list(string))
        }
      )))
      controller_type = optional(string)
      dhcp_relay_labels = optional(list(object(
        {
          dhcp_option_policy = optional(string)
          names              = list(string)
          scope              = optional(string)
        }
      )))
      general = list(object(
        {
          advertise_host_routes         = optional(bool)
          alias                         = optional(string)
          annotation                    = optional(string)
          annotations                   = optional(list(map(string)))
          arp_flooding                  = optional(bool)
          description                   = optional(string)
          endpoint_retention_policy     = optional(string)
          global_alias                  = optional(string)
          igmp_interface_policy         = optional(string)
          igmp_snooping_policy          = optional(string)
          ipv6_l3_unknown_multicast     = optional(string)
          l2_unknown_unicast            = optional(string)
          l3_unknown_multicast_flooding = optional(string)
          limit_ip_learn_to_subnets     = optional(bool)
          mld_snoop_policy              = optional(string)
          multi_destination_flooding    = optional(string)
          pim                           = optional(bool)
          pimv6                         = optional(bool)
          type                          = optional(string)
          vrf                           = optional(string)
          vrf_schema                    = optional(string)
          vrf_template                  = optional(string)
          vrf_tenant                    = optional(string)
        }
      ))
      l3_configurations = list(object(
        {
          associated_l3outs = optional(list(object(
            {
              l3out         = list(string)
              route_profile = optional(string)
              tenant        = optional(string)
            }
          )))
          custom_mac_address      = optional(string)
          ep_move_detection_mode  = optional(bool)
          link_local_ipv6_address = optional(string)
          subnets = optional(map(object(
            {
              description                  = optional(string)
              ip_data_plane_learning       = optional(string)
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
          unicast_routing     = optional(bool)
          virtual_mac_address = optional(string)
        }
      ))
      policy_source_tenant = optional(string)
      schema               = optional(string)
      sites                = optional(list(string))
      tenant               = optional(string)
      template             = optional(string)
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvBD"
 - Distinguised Name: "/uni/tn-{Tenant}/BD-{bridge_domain}"
GUI Location:
 - Tenants > {tenant} > Networking > Bridge Domains > {bridge_domain}
_______________________________________________________________________________________________________________________
*/
resource "aci_bridge_domain" "bridge_domains" {
  depends_on = [
    aci_tenant.tenants,
    aci_vrf.vrfs,
    # aci_l3_outside.l3outs
  ]
  for_each = { for k, v in local.bridge_domains : k => v if v.controller_type == "apic" }
  # General
  annotation                = each.value.general[0].annotation != "" ? each.value.general[0].annotation : var.annotation
  arp_flood                 = each.value.general[0].arp_flooding == true ? "yes" : "no"
  bridge_domain_type        = each.value.general[0].type
  description               = each.value.general[0].description
  host_based_routing        = each.value.general[0].advertise_host_routes == true ? "yes" : "no"
  ipv6_mcast_allow          = each.value.general[0].pimv6 == true ? "yes" : "no"
  limit_ip_learn_to_subnets = each.value.general[0].limit_ip_learn_to_subnets == true ? "yes" : "no"
  mcast_allow               = each.value.general[0].pim == true ? "yes" : "no"
  name                      = each.key
  name_alias                = each.value.general[0].alias
  multi_dst_pkt_act         = each.value.general[0].multi_destination_flooding
  relation_fv_rs_bd_to_ep_ret = each.value.general[0
  ].endpoint_retention_policy != "" ? "uni/tn-${each.value.policy_source_tenant}/epRPol-${each.value.general[0].endpoint_retention_policy}" : ""
  relation_fv_rs_ctx = each.value.general[0
  ].vrf != "" ? "uni/tn-${each.value.general[0].vrf_tenant}/ctx-${each.value.general[0].vrf}" : ""
  relation_fv_rs_igmpsn = each.value.general[0
  ].igmp_snooping_policy != "" ? "uni/tn-${each.value.policy_source_tenant}/snPol-${each.value.general[0].igmp_snooping_policy}" : ""
  relation_fv_rs_mldsn = each.value.general[0
  ].mld_snoop_policy != "" ? "uni/tn-${each.value.policy_source_tenant}/mldsnoopPol-${each.value.general[0].mld_snoop_policy}" : ""
  tenant_dn         = aci_tenant.tenants[each.value.general[0].tenant].id
  unk_mac_ucast_act = each.value.general[0].l2_unknown_unicast
  unk_mcast_act     = each.value.general[0].l3_unknown_multicast_flooding
  v6unk_mcast_act   = each.value.general[0].ipv6_l3_unknown_multicast
  # L3 Configurations
  ep_move_detect_mode = each.value.l3_configurations[0].ep_move_detection_mode == true ? "garp" : "disable"
  ll_addr             = each.value.l3_configurations[0].link_local_ipv6_address
  mac                 = each.value.l3_configurations[0].custom_mac_address
  # class: l3extOut
  relation_fv_rs_bd_to_out = length(each.value.l3_configurations[0].associated_l3outs
  ) > 0 ? [for k, v in each.value.l3_configurations[0].associated_l3outs : "uni/tn-${v.tenant}/out-${v.l3out[0]}"] : []
  # class: rtctrlProfile
  relation_fv_rs_bd_to_profile = join(",", [
    for k, v in each.value.l3_configurations[0
    ].associated_l3outs : "uni/tn-${v.tenant}/out-${v.l3out[0]}/prof-${v.route_profile}" if v.route_profile != ""
  ])
  # class: monEPGPol
  # relation_fv_rs_bd_to_nd_p = length(
  # [each.value.nd_policy]) > 0 ? "uni/tn-${each.value.policy_source_tenant}/ndifpol-${each.value.nd_policy}" : ""
  unicast_route = each.value.l3_configurations[0].unicast_routing == true ? "yes" : "no"
  vmac          = each.value.l3_configurations[0].virtual_mac_address != "" ? each.value.l3_configurations[0].virtual_mac_address : "not-applicable"
  # Advanced/Troubleshooting
  ep_clear    = each.value.advanced_troubleshooting[0].endpoint_clear == true ? "yes" : "no"
  ip_learning = each.value.advanced_troubleshooting[0].disable_ip_data_plane_learning_for_pbr == true ? "no" : "yes"
  intersite_bum_traffic_allow = length(regexall(
    true, each.value.advanced_troubleshooting[0].intersite_l2_stretch)
  ) > 0 && length(regexall(true, each.value.advanced_troubleshooting[0].intersite_bum_traffic_allow)) > 0 ? "yes" : "no"
  intersite_l2_stretch   = each.value.advanced_troubleshooting[0].intersite_l2_stretch == true ? "yes" : "no"
  optimize_wan_bandwidth = length(regexall(true, each.value.advanced_troubleshooting[0].optimize_wan_bandwidth)) > 0 ? "yes" : "no"
  # class: monEPGPol
  relation_fv_rs_abd_pol_mon_pol = each.value.advanced_troubleshooting[0
  ].monitoring_policy != "" ? "uni/tn-${each.value.policy_source_tenant}/monepg-${each.value.advanced_troubleshooting[0].monitoring_policy}" : ""
  # class: netflowMonitorPol
  dynamic "relation_fv_rs_bd_to_netflow_monitor_pol" {
    for_each = each.value.advanced_troubleshooting[0].netflow_monitor_policies
    content {
      flt_type                    = relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.filter_type # ipv4|ipv6|ce
      tn_netflow_monitor_pol_name = "uni/tn-${each.value.policy_source_tenant}/monitorpol-${relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.netflow_policy}"
    }
  }
  # class: fhsBDPol
  relation_fv_rs_bd_to_fhs = each.value.advanced_troubleshooting[0
    ].first_hop_security_policy != "" ? "uni/tn-${each.value.policy_source_tenant}/bdpol-${each.value.advanced_troubleshooting[0
  ].first_hop_security_policy}" : ""
  # class: dhcpRelayP
  # dynamic "relation_fv_rs_bd_to_relay_p" {
  #   for_each = each.value.dhcp_relay_labels
  #   content {
  #     owner = relation_fv_rs_bd_to_relay_p.value.owner
  #     name = relation_fv_rs_bd_to_relay_p.value.name
  #   }
  # }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dhcpLbl"
 - Distinguished Name: "/uni/tn-{tenant}/BD-{bridge_domain}/dhcplbl-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Bridge Domains > {bridge_domain} > DHCP Relay > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bd_dhcp_label" "bridge_domain_dhcp_relay_labels" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
  ]
  for_each         = { for k, v in local.bridge_domain_dhcp_relay_labels : k => v if v.controller_type == "apic" }
  annotation       = each.value.annotation != "" ? each.value.annotation : var.annotation
  bridge_domain_dn = "uni/tn-${each.value.tenant}/BD-${each.value.bridge_domain}"
  name             = each.value.name
  owner            = each.value.scope
  relation_dhcp_rs_dhcp_option_pol = length(compact([each.value.dhcp_option_policy])
  ) > 0 ? "uni/tn-${each.value.tenant}/dhcpoptpol-${each.value.dhcp_option_policy}" : ""
  # description      = each.value.description
  # tag              = each.value.tag
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvSubnet"
 - Distinguished Name: "/uni/tn-{tenant}/BD-{bridge_domain}/subnet-[{subnet}]"
GUI Location:
 - Tenants > {tenant} > Networking > Bridge Domains > {bridge_domain} > Subnets
_______________________________________________________________________________________________________________________
*/
resource "aci_subnet" "bridge_domain_subnets" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
    # aci_l3_outside.l3outs
  ]
  for_each  = { for k, v in local.bridge_domain_subnets : k => v if v.controller_type == "apic" }
  parent_dn = aci_bridge_domain.bridge_domains[each.value.bridge_domain].id
  ctrl = anytrue([each.value.subnet_control[0]["neighbor_discovery"
    ], each.value.subnet_control[0]["no_default_svi_gateway"], each.value.subnet_control[0]["querier_ip"]
    ]) ? compact(concat([
      length(regexall(true, each.value.subnet_control[0]["neighbor_discovery"])) > 0 ? "nd" : ""], [
      length(regexall(true, each.value.subnet_control[0]["no_default_svi_gateway"])) > 0 ? "no-default-gateway" : ""], [
    length(regexall(true, each.value.subnet_control[0]["querier_ip"])) > 0 ? "querier" : ""]
  )) : ["unspecified"]
  description = each.value.description
  ip          = each.value.gateway_ip
  preferred   = each.value.make_this_ip_address_primary == true ? "yes" : "no"
  # class: rtctrlProfile
  # relation_fv_rs_bd_subnet_to_out = length(compact(
  #   [each.value.l3out])
  # ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}" : ""
  # relation_fv_rs_bd_subnet_to_profile = length(compact(
  #   [each.value.route_profile])
  # ) > 0 ? each.value.route_profile : ""
  scope = anytrue([each.value.scope[0]["advertise_externally"
    ], each.value.scope[0]["shared_between_vrfs"]]) ? compact(concat([
    length(regexall(true, each.value.scope[0]["advertise_externally"])) > 0 ? "public" : ""], [
    length(regexall(true, each.value.scope[0]["shared_between_vrfs"])) > 0 ? "shared" : ""]
  )) : ["private"]
  virtual = each.value.treat_as_virtual_ip_address == true ? "yes" : "no"
}


resource "mso_schema_template_bd" "bridge_domains" {
  provider = mso
  depends_on = [
    mso_schema.schemas,
    mso_schema_site.sites
  ]
  for_each     = { for k, v in local.bridge_domains : k => v if v.controller_type == "ndo" }
  arp_flooding = each.value.general[0].arp_flooding
  # dynamic "dhcp_policy" {
  #   for_each = each.value.dhcp_relay_policy
  #   content {
  #     name                       = dhcp_policy.value.name
  #     version                    = dhcp_policy.value.version
  #     dhcp_option_policy_name    = dhcp_policy.value.dhcp_option_policy_name
  #     dhcp_option_policy_version = dhcp_policy.value.dhcp_option_policy_version
  #   }
  # }
  display_name                    = each.key
  name                            = each.key
  intersite_bum_traffic           = each.value.advanced_troubleshooting[0].intersite_bum_traffic_allow
  ipv6_unknown_multicast_flooding = each.value.general[0].ipv6_l3_unknown_multicast
  multi_destination_flooding = length(regexall(
    each.value.general[0].multi_destination_flooding, "bd-flood")
    ) > 0 ? "flood_in_bd" : length(regexall(
    each.value.general[0].multi_destination_flooding, "encap-flood")
  ) > 0 ? "flood_in_encap" : "drop"
  layer2_unknown_unicast     = each.value.general[0].l2_unknown_unicast
  layer2_stretch             = each.value.advanced_troubleshooting[0].intersite_l2_stretch
  layer3_multicast           = each.value.general[0].pim
  optimize_wan_bandwidth     = each.value.advanced_troubleshooting[0].optimize_wan_bandwidth
  schema_id                  = mso_schema.schemas[each.value.schema].id
  template_name              = each.value.template
  unknown_multicast_flooding = each.value.general[0].l3_unknown_multicast_flooding
  unicast_routing            = each.value.l3_configurations[0].unicast_routing
  virtual_mac_address        = each.value.l3_configurations[0].virtual_mac_address
  vrf_name                   = each.value.general[0].vrf
  vrf_schema_id = each.value.general[0].vrf != "" && length(compact(
    [each.value.general[0].vrf_schema])
    ) > 0 ? data.mso_schema.schemas[each.value.general[0].vrf_schema].id : length(compact(
    [each.value.general[0].vrf])
  ) > 0 ? data.mso_schema.schemas[each.value.schema].id : ""
  vrf_template_name = each.value.general[0].vrf != "" && length(compact(
    [each.value.general[0].vrf_template])
    ) > 0 ? each.value.general[0].vrf_template : length(compact(
    [each.value.general[0].vrf])
  ) > 0 ? each.value.template : ""
}

resource "mso_schema_site_bd" "bridge_domains" {
  provider = mso
  depends_on = [
    mso_schema_template_bd.bridge_domains
  ]
  for_each      = { for k, v in local.bridge_domain_sites : k => v if v.controller_type == "ndo" }
  bd_name       = each.value.bridge_domain
  host_route    = each.value.advertise_host_routes
  schema_id     = mso_schema.schemas[each.value.schema].id
  site_id       = data.mso_site.ndo_sites[each.value.site].id
  template_name = each.value.template
}

resource "mso_schema_site_bd_l3out" "bridge_domain_l3outs" {
  provider = mso
  depends_on = [
    mso_schema_site_bd.bridge_domains
  ]
  for_each      = { for k, v in local.bridge_domain_sites : k => v if v.controller_type == "ndo" }
  bd_name       = each.key
  l3out_name    = each.value.l3out
  schema_id     = mso_schema.schemas[each.value.schema].id
  site_id       = data.mso_site.ndo_sites[each.value.site].id
  template_name = each.value.template
}

resource "mso_schema_template_bd_subnet" "bridge_domain_subnets" {
  provider = mso
  depends_on = [
    mso_schema_template_bd.bridge_domains
  ]
  for_each           = { for k, v in local.bridge_domain_subnets : k => v if v.controller_type == "ndo" }
  bd_name            = each.value.bridge_domain
  description        = each.value.description
  ip                 = each.value.gateway_ip
  no_default_gateway = each.value.subnet_control[0]["no_default_svi_gateway"]
  schema_id          = mso_schema.schemas[each.value.schema].id
  scope              = each.value.scope[0]["advertise_externally"] == true ? "public" : "private"
  template_name      = each.value.template
  shared             = each.value.scope[0]["shared_between_vrfs"]
  querier            = each.value.subnet_control[0]["querier_ip"]
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRogueExceptionMac"
 - Distinguished Name: "uni/tn-{tenant}/BD-{bridge_domain}/rgexpmac-{mac_address}"
GUI Location:
 - Tenants > {tenant} > Networking > Bridge Domains > {bridge_domain} > Policy > Advanced/Troubleshooting > Rogue/Coop Exception List.
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "rogue_coop_exception_list" {
  depends_on = [
    aci_bridge_domain.bridge_domains
  ]
  for_each   = local.rogue_coop_exception_list
  dn         = "uni/tn-${each.value.tenant}/BD-${each.value.bridge_domain}/rgexpmac-${each.value.mac_address}"
  class_name = "fvRogueExceptionMac"
  content = {
    mac = each.value.mac_address
  }
}
