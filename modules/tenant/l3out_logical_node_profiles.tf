/*_____________________________________________________________________________________________________________________

L3Out - Logical Node Profile — Variables
_______________________________________________________________________________________________________________________
*/
variable "l3out_logical_node_profiles" {
  default = {
    "default" = {
      alias           = ""
      annotation      = ""
      annotations     = []
      color_tag       = "yellow-green"
      controller_type = "apic"
      description     = ""
      interface_profiles = [
        {
          arp_policy                  = ""
          auto_state                  = "disabled"
          color_tag                   = "yellow-green"
          custom_qos_policy           = ""
          description                 = ""
          egress_data_plane_policing  = ""
          encapsulation_scope         = "local"
          encapsulation_vlan          = 1
          ingress_data_plane_policing = ""
          hsrp_interface_profiles     = []
          /* example
          hsrp_interface_profiles = [
            {
              alias       = ""
              annotation  = ""
              description = ""
              groups = [
                {
                  alias                 = ""
                  annotation            = ""
                  description           = ""
                  group_id              = 0
                  group_name            = ""
                  group_type            = "ipv4"
                  hsrp_group_policy     = ""
                  ip_address            = ""
                  ip_obtain_mode        = "admin"
                  mac_address           = ""
                  name                  = "default"
                  secondary_virtual_ips = []
                }
              ]
              hsrp_interface_policy = "default"
              version               = "v1"
            }
          ]
          */
          interface_or_policy_group = "eth1/1"
          interface_type            = "l3-port" # ext-svi|l3-port|sub-interface
          ipv6_dad                  = "enabled"
          link_local_addresses      = "::"
          mac_address               = "00:22:BD:F8:19:FF"
          mode                      = "regular"
          mtu                       = "inherit" # 576 to 9216
          name                      = "default"
          nd_policy                 = ""
          netflow_policies          = []
          nodes                     = [201]
          ospf_interface_profiles   = []
          /* Example
          ospf_interface_profile = [
            {
              description           = ""
              authentication_type   = "none" # md5,none,simple
              name                  = "default"
              ospf_key              = 0
              ospf_interface_policy = "default"
              policy_source_tenant  = "**l3out_tenant**"
            }
          ]
          */
          primary_preferred_addresses = "198.18.1.1/24"
          qos_class                   = "unspecified"
          secondary_addresses         = [] # "198.18.3.1/24"
          svi_addresses               = []
          /* Example
          svi_addresses               = [
            {
              link_local_address  = "::"
              preferred_address   = "198.18.1.1/24"
              secondary_addresses = []
              side                = "A"
            },
            {
              link_local_address  = "::"
              preferred_address   = "198.18.1.2/24"
              secondary_addresses = []
              side                = "B"
            }
          ]
          */
        }
      ]
      l3out = "**REQUIRED**"
      nodes = [
        {
          node_id                   = 201
          router_id                 = "198.18.0.1"
          use_router_id_as_loopback = true
        }
      ]
      pod_id = 1
      static_routes = [
        {
          description         = ""
          fallback_preference = 1
          next_hop_addresses = [
            {
              description   = ""
              preference    = 0
              next_hop_ip   = "**REQUIRED**"
              next_hop_type = "prefix"
              ip_sla_policy = ""
              track_policy  = ""
            }
          ]
          prefix            = "**REQUIRED**"
          route_control_bfd = false
          track_policy      = ""
        }
      ]
      sites       = []
      target_dscp = "unspecified"
      /* If undefined the variable of local.first_tenant will be used for:
      policy_source_tenant = local.first_tenant
      schema               = local.first_tenant
      template             = local.first_tenant
      tenant               = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key: Name of the L3Out Logical Node Profile.
    * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
    * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
    * controller_type: What is the type of controller.  Options are:
      - apic: For APIC Controllers
      - ndo: For Nexus Dashboard Orchestrator
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    hsrp_interface_profiles - Group of Objects to add as an HSRP interface profile
    * alias: (optional) — Name name_alias for object L3-out HSRP interface profile.
    * annotation: (optional) — Annotation for object L3-out HSRP interface profile.
    * description: (optional) — Description for object L3-out HSRP interface profile.
    * groups - Map of group objects
      - alias: (optional) — alias for L3out HSRP interface group object.
      - annotation: (optional) — Annotation for L3out HSRP interface group object.
      - description: (optional) — Description for L3out HSRP interface group object.
      - group_id: (optional) — Group id for L3out HSRP interface group object.
      - group_name: (optional) — Group name for L3out HSRP interface group object.
      - group_type: (optional) — Group address-family type for L3out HSRP interface group object.  Options are:
        * ipv4
        * ipv6
        Default value is ipv4.
      - hsrp_group_policy: (optional) — Name of the HSRP Group Policy
      - ip: (optional) — IP address for L3out HSRP interface group object.
      - ip_obtain_mode: (optional) — IP obtain mode for L3out HSRP interface group object. Allowed values are:
        * admin - Address is configured.
        * auto - Auto configure IPv6 address.
        * learn - Learn IP from HSRP Peer.
        Default value is admin
      - mac_address: (optional) — MAC address for L3out HSRP interface group object.
      - name: (required) — Name of L3out HSRP interface group object.
      - secondary_virtual_ips: (optional) — - List of secondary virtual IP's to assign to the group.
    * hsrp_interface_policy: (optional) — Name of the HSRP Interface Policy.
    * policy_source_tenant: (optional) — - Name of the tenant that contains the HSRP Interface and Group Policies.
    * version: (optional) — Compatibility catalog version.
      - v1
      - v2
    * nodes: map of Nodes to attach to the interface profile
      - static_routes: Map of Static route attributes
        * aggregate: (optional) — Aggregated Route for object l3out static route. Allowed values: true, false, default false
        * alias: (optional) — Name name_alias for object l3out static route.
        * annotation: (optional) — Annotation for object l3out static route.
        * description: (optional) — Description for object l3out static route.
        * preference: (optional) — The administrative preference value for this route. This value is useful for resolving routes advertised from different protocols. Range of allowed values is "1" to "255". Default value is "1".
        * prefix: (required) — The static route IP address assigned to the outside network.
        * route_control_bfd: (optional) — Route control for object l3out static route. Allowed values: "bfd", "unspecified". Default value is "unspecified".
        * next_hop_addresses
          - alias: (optional) — Name name_alias for object l3out static route next hop.
          - annotation: (optional) — Annotation for object l3out static route next hop.
          - description: (optional) — Description for object l3out static route next hop.
          - next_hop_ip: (required) — The nexthop IP address for the static route to the outside network.
          - next_hop_type: (optional) — Component type.
          - Allowed values: "none", "prefix". Default value: "prefix".
          - preference: (optional) — Administrative preference value for this route. Range: "1" to "255" Allowed values: "unspecified". Default value: "unspecified".
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
      color_tag       = optional(string)
      controller_type = optional(string)
      description     = optional(string)
      interface_profiles = optional(list(object(
        {
          arp_policy                  = optional(string)
          auto_state                  = optional(string)
          color_tag                   = optional(string)
          custom_qos_policy           = optional(string)
          description                 = optional(string)
          egress_data_plane_policing  = optional(string)
          encapsulation_scope         = optional(string)
          encapsulation_vlan          = optional(number)
          ingress_data_plane_policing = optional(string)
          hsrp_interface_profile = optional(map(object(
            {
              alias       = optional(string)
              annotation  = optional(string)
              description = optional(string)
              groups = optional(list(object(
                {
                  alias                 = optional(string)
                  annotation            = optional(string)
                  description           = optional(string)
                  group_id              = optional(number)
                  group_name            = optional(string)
                  group_type            = optional(string)
                  hsrp_group_policy     = optional(string)
                  ip_address            = optional(string)
                  ip_obtain_mode        = optional(string)
                  mac_address           = optional(string)
                  name                  = optional(string)
                  secondary_virtual_ips = optional(list(string))
                }
              )))
              hsrp_interface_policy = optional(string)
              policy_source_tenant  = optional(string)
              version               = optional(string)
            }
          )))
          interface_or_policy_group = string
          interface_type            = optional(string)
          ipv6_dad                  = optional(string)
          link_local_address        = optional(string)
          mac_address               = optional(string)
          mode                      = optional(string)
          mtu                       = optional(string)
          name                      = string
          nd_policy                 = optional(string)
          netflow_policies          = optional(list(string))
          nodes                     = optional(list(string))
          ospf_interface_profile = optional(list(object(
            {
              description           = optional(string)
              authentication_type   = optional(string)
              name                  = string
              ospf_key              = optional(number)
              ospf_interface_policy = optional(string)
              policy_source_tenant  = optional(string)
            }
          )))
          preferred_address   = optional(string)
          qos_class           = optional(string)
          secondary_addresses = optional(list(string))
          svi_addresses = optional(list(object(
            {
              link_local_address  = optional(string)
              preferred_address   = string
              secondary_addresses = optional(list(string))
              side                = string
            },
          )))
        }
      )))
      l3out = string
      nodes = list(object(
        {
          node_id                   = optional(number)
          router_id                 = optional(string)
          use_router_id_as_loopback = optional(bool)
        }
      ))
      pod_id = optional(string)
      static_routes = optional(list(object(
        {
          description         = optional(string)
          fallback_preference = optional(number)
          next_hop_addresses = optional(list(object(
            {
              description   = optional(string)
              preference    = optional(number)
              next_hop_type = optional(string)
              ip_sla_policy = optional(string)
              track_policy  = optional(string)
            }
          )))
          prefix            = string
          route_control_bfd = optional(bool)
          track_policy      = optional(string)
        }
      )))
      sites       = optional(list(string))
      target_dscp = optional(string)
      template    = optional(string)
      tenant      = optional(string)
    }
  ))
}

variable "bgp_password_1" {
  default     = ""
  description = "BGP Password 1."
  sensitive   = true
  type        = string
}

variable "bgp_password_2" {
  default     = ""
  description = "BGP Password 2."
  sensitive   = true
  type        = string
}

variable "bgp_password_3" {
  default     = ""
  description = "BGP Password 3."
  sensitive   = true
  type        = string
}

variable "bgp_password_4" {
  default     = ""
  description = "BGP Password 4."
  sensitive   = true
  type        = string
}

variable "bgp_password_5" {
  default     = ""
  description = "BGP Password 5."
  sensitive   = true
  type        = string
}

variable "ospf_key_1" {
  default     = ""
  description = "OSPF Key 1."
  sensitive   = true
  type        = string
}

variable "ospf_key_2" {
  default     = ""
  description = "OSPF Key 2."
  sensitive   = true
  type        = string
}

variable "ospf_key_3" {
  default     = ""
  description = "OSPF Key 3."
  sensitive   = true
  type        = string
}

variable "ospf_key_4" {
  default     = ""
  description = "OSPF Key 4."
  sensitive   = true
  type        = string
}

variable "ospf_key_5" {
  default     = ""
  description = "OSPF Key 5."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extLNodeP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}"
GUI Location:
tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile}
_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Create Logical Node Profiles
#------------------------------------------------
resource "aci_logical_node_profile" "l3out_node_profiles" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each      = local.l3out_node_profiles
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = each.value.description
  name          = each.key
  name_alias    = each.value.alias
  tag           = each.value.color_tag
  target_dscp   = each.value.target_dscp
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsNodeL3OutAtt"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/rsnodeL3OutAtt-[topology/pod-{pod_id}/node-{node_id}]"
GUI Location:
tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile}: Nodes > {node_id}
_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Assign a Node to a Logical Node Profiles
#------------------------------------------------
resource "aci_logical_node_to_fabric_node" "l3out_node_profiles_nodes" {
  depends_on = [
    aci_logical_node_profile.l3out_node_profiles
  ]
  for_each                = local.l3out_node_profiles_nodes
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  logical_node_profile_dn = aci_logical_node_profile.l3out_node_profiles[each.value.node_profile].id
  tdn                     = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
  rtr_id                  = each.value.router_id
  rtr_id_loop_back        = each.value.use_router_id_as_loopback == true ? "yes" : "no"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extLIfP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{name}"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}
_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Create Logical Interface Profile
#------------------------------------------------
resource "aci_logical_interface_profile" "l3out_interface_profiles" {
  depends_on = [
    aci_logical_node_profile.l3out_node_profiles
  ]
  for_each                = local.l3out_interface_profiles
  logical_node_profile_dn = aci_logical_node_profile.l3out_node_profiles[each.value.node_profile].id
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  description             = each.value.description
  name                    = each.value.name
  name_alias              = ""
  prio                    = each.value.qos_class
  tag                     = each.value.color_tag
  relation_l3ext_rs_arp_if_pol = length(regexall(
    "[[:alnum:]]+", each.value.arp_policy)
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/arpifpol-${each.value.arp_policy}" : ""
  relation_l3ext_rs_egress_qos_dpp_pol = length(regexall(
    "[[:alnum:]]+", each.value.egress_data_plane_policing)
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/qosdpppol-${each.value.egress_data_plane_policing}" : ""
  relation_l3ext_rs_ingress_qos_dpp_pol = length(regexall(
    "[[:alnum:]]+", each.value.ingress_data_plane_policing)
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/qosdpppol-${each.value.ingress_data_plane_policing}" : ""
  relation_l3ext_rs_l_if_p_cust_qos_pol = length(regexall(
    "[[:alnum:]]+", each.value.custom_qos_policy)
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/qoscustom-${each.value.custom_qos_policy}" : ""
  relation_l3ext_rs_nd_if_pol = each.value.nd_policy
  dynamic "relation_l3ext_rs_l_if_p_to_netflow_monitor_pol" {
    for_each = each.value.netflow_policies
    content {
      tn_netflow_monitor_pol_name = relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.netflow_policy
      flt_type                    = relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.filter_type # ipv4|ipv6|ce
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/{PATH}/pathep-[{interface_or_pg}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Sub-Interfaces

 - Assign all the default Policies to this Policy Group
_______________________________________________________________________________________________________________________
*/
#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------
resource "aci_l3out_path_attachment" "l3out_path_attachments" {
  depends_on = [
    aci_logical_interface_profile.l3out_interface_profiles
  ]
  for_each                     = local.l3out_interface_profiles
  logical_interface_profile_dn = aci_logical_interface_profile.l3out_interface_profiles[each.key].id
  target_dn = length(regexall(
    "ext-svi", each.value.interface_type)
    ) > 0 ? "topology/pod-${each.value.pod_id}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.interface_or_policy_group}]" : length(regexall(
    "[[:alnum:]]+", each.value.interface_type)
  ) > 0 ? "topology/pod-${each.value.pod_id}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.interface_or_policy_group}]" : ""
  if_inst_t   = each.value.interface_type
  addr        = each.value.interface_type != "ext-svi" ? each.value.preferred_address : ""
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  autostate   = each.value.interface_type != "ext-svi" ? each.value.auto_state : "disabled"
  encap       = each.value.interface_type != "l3-port" ? "vlan-${each.value.encapsulation_vlan}" : "unknown"
  mode        = each.value.mode == "trunk" ? "regular" : "native"
  encap_scope = each.value.interface_type != "l3-port" ? each.value.encapsulation_scope : "local"
  ipv6_dad    = each.value.ipv6_dad
  ll_addr     = each.value.interface_type != "ext-svi" ? each.value.link_local_address : "::"
  mac         = each.value.mac_address
  mtu         = each.value.mtu
  target_dscp = each.value.target_dscp
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/protpaths-{node1_id}-{node2_id}//pathep-[{policy_group}]]/mem-{side}"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
_______________________________________________________________________________________________________________________
*/
#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------
resource "aci_l3out_vpc_member" "l3out_vpc_member" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  for_each     = local.l3out_paths_svi_addressing
  addr         = each.value.preferred_address
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = ""
  ipv6_dad     = each.value.ipv6_dad
  leaf_port_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.path].id
  ll_addr      = each.value.link_local_address
  side         = each.value.side
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/{PATH}/pathep-[{interface_or_pg}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Sub-Interfaces

_______________________________________________________________________________________________________________________
*/
#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------
resource "aci_l3out_path_attachment_secondary_ip" "l3out_paths_secondary_ips" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  for_each                 = local.l3out_paths_secondary_ips
  l3out_path_attachment_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.l3out_path].id
  addr                     = each.value.secondary_ip_address
  annotation               = each.value.annotation != "" ? each.value.annotation : var.annotation
  ipv6_dad                 = each.value.ipv6_dad
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpPeerP"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{Interface_Profile}/rspathL3OutAtt-[topology/pod-{Pod_ID}/{PATH}/pathep-[{Interface_or_PG}]]/peerP-[{Peer_IP}]"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile {node_profile} > Logical Interface Profile > {Interface_Profile} > OSPF Interface Profile

_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Create a BGP Peer Connectivity Profile
#------------------------------------------------
# resource "aci_bgp_peer_connectivity_profile" "bgp_peer_connectivity_profiles" {
#   depends_on = [
#     aci_logical_node_profile.l3out_node_profiles,
#     aci_logical_interface_profile.l3out_interface_profiles,
#     aci_bgp_peer_prefix.policies_bgp_peer_prefix
#   ]
#   for_each            = local.bgp_peer_connectivity_profiles
#   addr                = each.value.bgp_peer
#   addr_t_ctrl         = each.value.address_type_controls
#   allowed_self_as_cnt = each.value.allowed_self_as_count
#   as_number           = each.value.remote_as
#   ctrl                = each.value.bgp_controlls
#   description         = each.value.description
#   logical_node_profile_dn = length(
#     regexall("interface", each.value.peer_level)
#     ) > 0 ? aci_logical_interface_profile.l3out_interface_profiles[each.value.interface_profile].id : length(
#     regexall("loopback", each.value.peer_level)
#   ) > 0 ? aci_logical_node_profile.l3out_node_profiles[each.value.node_profile].id : ""
#   password = length(
#     regexall(5, each.value.bgp_password)) > 0 ? var.bgp_password_5 : length(
#     regexall(4, each.value.bgp_password)) > 0 ? var.bgp_password_4 : length(
#     regexall(3, each.value.bgp_password)) > 0 ? var.bgp_password_3 : length(
#     regexall(2, each.value.bgp_password)) > 0 ? var.bgp_password_2 : length(
#   regexall(1, each.value.bgp_password)) > 0 ? var.bgp_password_1 : ""
#   peer_ctrl           = each.value.peer_controls
#   private_a_sctrl     = each.value.private_as_control
#   ttl                 = each.value.ebgp_multihop_ttl
#   weight              = each.value.weight_for_routes_from_neighbor
#   local_asn           = each.value.local_as_number
#   local_asn_propagate = each.value.local_as_number_config
#   relation_bgp_rs_peer_pfx_pol = length(
#     regexall(each.value.prefix_tenant == each.value.tenant)
#     ) > 0 ? aci_bgp_peer_prefix.policies_bgp_peer_prefix[each.value.bgp_peer_prefix_policy].id : length(
#     regexall("[:alnum:]", each.value.prefix_tenant)
#   ) > 0 ? "rs_bgp_peer_prefix_policy.policies_bgp_peer_prefix[each.value.bgp_peer_prefix_policy].id" : ""
#   dynamic "relation_bgp_rs_peer_to_profile" {
#     for_each = each.value.route_control_profiles
#     content {
#       direction = relation_bgp_rs_peer_to_profile.value.direction
#       target_dn = "uni/tn-${relation_bgp_rs_peer_to_profile.value.tenant}/prof-${relation_bgp_rs_peer_to_profile.value.route_map}"
#     }
#   }
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpIfP"
 - Distinguished Name:  uni/tn-{tenant}/out-{l3out}/lnodep-{logical_node_profile}/lifp-{logical_interface_profile}/hsrpIfP
GUI Location:
Tenants > {tenant} > L3Outs > {l3out} > Logical Node Profiles > {logical_node_profile} > Logical Interface Profiles >
{logical_interface_profile} > Create HSRP Interface Profile
_______________________________________________________________________________________________________________________
*/
# resource "aci_l3out_floating_svi" "l3out_floating_svis" {
#   depends_on = [
#     aci_logical_interface_profile.l3out_interface_profiles
#   ]
#   for_each                     = local.l3out_floating_svis
#   addr                         = each.value.address
#   annotation                   = each.value.annotation
#   autostate                    = each.value.auto_state
#   description                  = each.value.description
#   encap_scope                  = each.value.encap_scope
#   if_inst_t                    = each.value.interface_type
#   ipv6_dad                     = each.value.ipv6_dad
#   ll_addr                      = each.value.link_local_address
#   logical_interface_profile_dn = aci_logical_interface_profile.l3out_interface_profiles[each.key].id
#   node_dn                      = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
#   encap                        = "vlan-${each.value.vlan}"
#   mac                          = each.value.mac_address
#   mode                         = each.value.mode
#   mtu                          = each.value.mtu
#   target_dscp                  = each.value.target_dscp
# }


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpIfP"
 - Distinguished Name:  uni/tn-{tenant}/out-{l3out}/lnodep-{logical_node_profile}/lifp-{logical_interface_profile}/hsrpIfP
GUI Location:
Tenants > {tenant} > L3Outs > {l3out} > Logical Node Profiles > {logical_node_profile} > Logical Interface Profiles >
{logical_interface_profile} > Create HSRP Interface Profile
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_hsrp_interface_profile" "hsrp_interface_profile" {
  depends_on = [
    aci_logical_interface_profile.l3out_interface_profiles
  ]
  for_each = local.hsrp_interface_profile
  logical_interface_profile_dn = length(compact([each.value.interface_profile])
  ) > 0 ? aci_logical_interface_profile.l3out_interface_profiles[each.value.interface_profile].id : ""
  annotation              = each.value.annotation
  description             = each.value.description
  name_alias              = each.value.alias
  relation_hsrp_rs_if_pol = "uni/tn-${each.value.policy_source_tenant}/hsrpIfPol-${each.value.hsrp_interface_policy}"
  version                 = each.value.version
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpGroupP"
 - Distinguished Name: uni/tn-{tenant}/out-{l3out}/lnodep-{logical_node_profile}/lifp-{logical_interface_profile}/hsrpIfP/hsrpGroupP-{name}
GUI Location:
Tenants > {tenant} > L3Outs > {l3out} > Logical Node Profiles > {logical_node_profile} > Logical Interface Profiles >
{logical_interface_profile} > Create HSRP Interface Profile
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_hsrp_interface_group" "hsrp_interface_profile_groups" {
  depends_on = [
    aci_l3out_hsrp_interface_profile.hsrp_interface_profile
  ]
  for_each                        = local.hsrp_interface_profile_groups
  l3out_hsrp_interface_profile_dn = aci_l3out_hsrp_interface_profile.hsrp_interface_profile[each.value.key1].id
  name_alias                      = each.value.alias
  annotation                      = each.value.annotation
  group_af                        = each.value.address_family
  group_id                        = each.value.group_id
  group_name                      = each.value.group_name
  ip                              = each.value.ip_address
  ip_obtain_mode                  = each.value.ip_obtain_mode
  mac                             = each.value.mac_address
  name                            = each.value.name
  relation_hsrp_rs_group_pol      = "uni/tn-${each.value.policy_source_tenant}/hsrpGroupPol-${each.value.hsrp_group_policy}"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpSecVip"
 - Distinguished Name: uni/tn-{tenant}/out-{l3out}/lnodep-{logical_node_profile}/lifp-{logical_interface_profile}/hsrpIfP/hsrpGroupP-{name}/hsrpSecVip-[{secondar_ip}]
GUI Location:
Tenants > {tenant} > L3Outs > {l3out} > Logical Node Profiles > {logical_node_profile} > Logical Interface Profiles >
{logical_interface_profile} > Create HSRP Interface Profile
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_hsrp_secondary_vip" "hsrp_interface_profile_group_secondaries" {
  depends_on = [
    aci_l3out_hsrp_interface_group.hsrp_interface_profile_groups
  ]
  for_each                      = local.hsrp_interface_profile_group_secondaries
  l3out_hsrp_interface_group_dn = aci_l3out_hsrp_interface_group.hsrp_interface_profile_groups[each.value.key1].id
  ip                            = each.value.secondary_ip
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/nodep-{node_profile}/lifp-{interface_profile}/ospfIfP"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile {node_profile} > Logical Interface Profile > {interface_profile} > OSPF Interface Profile
_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------
resource "aci_l3out_ospf_interface_profile" "l3out_ospf_interface_profiles" {
  depends_on = [
    aci_logical_interface_profile.l3out_interface_profiles,
    aci_ospf_interface_policy.policies_ospf_interface,
  ]
  for_each   = local.l3out_ospf_interface_profiles
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  auth_key = length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.ospf_key == 5 ? var.ospf_key_5 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.ospf_key == 4 ? var.ospf_key_4 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.ospf_key == 3 ? var.ospf_key_3 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.ospf_key == 2 ? var.ospf_key_2 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
  ) > 0 && each.value.ospf_key == 1 ? var.ospf_key_1 : ""
  auth_key_id                  = each.value.authentication_type == "md5" ? each.value.ospf_key : ""
  auth_type                    = each.value.authentication_type
  description                  = each.value.description
  logical_interface_profile_dn = aci_logical_interface_profile.l3out_interface_profiles[each.value.interface_profile].id
  relation_ospf_rs_if_pol      = "uni/tn-${each.value.policy_source_tenant}/ospfIfPol-${each.value.ospf_interface_policy}"
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ipRouteP"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/rsnodeL3OutAtt-[topology/pod-{pod_id}/node-{node_id}]/rt-[{route}]/"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile {node_profile} > Logical Interface Profile > {interface_profile} > Nodes > {node_id} > Static Routes
_______________________________________________________________________________________________________________________
*/
# resource "aci_l3out_static_route" "l3out_node_profile_static_routes" {
#   depends_on = [
#     aci_logical_node_to_fabric_node.l3out_node_profiles_nodes
#   ]
#   for_each = local.l3out_node_profile_static_routes
#   # aggregate      = each.value.aggregate == true ? "yes" : "no"
#   annotation     = each.value.annotation
#   description    = each.value.description
#   fabric_node_dn = aci_logical_node_to_fabric_node.l3out_node_profiles_nodes[each.value.node].id
#   name_alias     = each.value.alias
#   ip             = each.value.prefix
#   pref           = each.value.preference
#   rt_ctrl        = each.value.route_control_bfd == true ? "bfd" : "unspecified"
#   # class fvTrackList
#   relation_ip_rs_route_track = ""
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ipNexthopP"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/rsnodeL3OutAtt-[topology/pod-{pod_id}/node-{node_id}]/rt-[{route}]/nh-[{next_hop_ip}]"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile {node_profile} > Logical Interface Profile > {interface_profile} > Nodes > {node_id} > Static Routes
_______________________________________________________________________________________________________________________
*/
# resource "aci_l3out_static_route_next_hop" "l3out_static_routes_next_hop" {
#   depends_on = [
#     aci_l3out_static_route.l3out_node_profile_static_routes
#   ]
#   for_each             = local.l3out_static_routes_next_hop
#   annotation           = each.value.annotation
#   description          = each.value.description
#   name_alias           = each.value.alias
#   nexthop_profile_type = each.value.next_hop_type
#   nh_addr              = each.value.next_hop_ip
#   pref                 = each.value.preference
#   static_route_dn      = aci_l3out_static_route.l3out_node_profile_static_routes[each.value.static_route].id
#   # class fvTrackList
#   # relation_ip_rs_nexthop_route_track = ""
#   # # Class "ipRsNHTrackMember"
#   # relation_ip_rs_nh_track_member = length(compact([each.value.ip_sla_policy])
#   # ) > 0 ? "" : ""
# }
