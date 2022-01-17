variable "l3outs" {
  default = {
    "default" = {
      alias       = ""
      annotation  = ""
      description = ""
      l3_domain   = ""
      level       = "template"
      node_profiles = [
        {
          alias       = ""
          annotation  = ""
          color_tag   = "yellow-green"
          description = ""
          interface_profiles = [
            {

              name = "defualt"
            }
          ]
          name = "default"
          nodes = [
            {
              node_id                   = 101
              router_id                 = "198.18.0.1"
              use_router_id_as_loopback = "yes"
            }
          ]
          pod = 1
        }
      ]
      route_control_enforcement = [
        {
          export = false
          import = true
        }
      ]
      route_control_for_dampening = [
        {
          address_family = "ipv4"
          route_map      = "test2"
          tenant         = "common"
        }
      ]
      target_dscp = "unspecified"
      sites       = []
      tags        = []
      template    = ""
      tenant      = "common"
      type        = "apic"
      vendor      = "cisco"
      vrf         = "common"
    }
  }
  description = <<-EOT
  Key: Name of the VRF.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bgp_context_per_address_family: 
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

#------------------------------------------------
# Create L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extOut"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_outside" "l3outs" {
  depends_on = [
    local.l3_domains,
    aci_tenant.tenants,
    aci_vrf.vrfs
  ]
  for_each    = { for k, v in local.l3outs : k => v if v.type == "apic" }
  annotation  = each.value.annotation
  description = each.value.description
  enforce_rtctrl = alltrue(
    [each.value.export, each.value.import]
    ) ? "export,import" : anytrue(
    [each.value.export, each.value.import]
    ) ? replace(trim(join(",", concat([
      length(regexall(true, each.value.export)) > 0 ? "export" : ""], [
      length(regexall(true, each.value.import)) > 0 ? "import" : ""]
  )), ","), ",,", ",") : "export"
  name        = each.key
  name_alias  = each.value.alias
  target_dscp = each.value.target_dscp
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  relation_l3ext_rs_ectx = length(regexall(
    each.value.tenant, each.value.vrf_tenant)
    ) > 0 ? aci_vrf.vrfs[each.value.vrf].id : length(regexall(
    "[[:alnum:]]+", each.value.vrf_tenant)
  ) > 0 ? local.common_vrfs[each.value.vrf].id : ""
  relation_l3ext_rs_l3_dom_att = length(regexall(
    "[[:alnum:]]+", each.value.l3_domain)
  ) > 0 ? local.l3_domains[each.value.l3_domain].id : ""
  dynamic "relation_l3ext_rs_dampening_pol" {
    for_each = each.value.route_control_for_dampening
    content {
      af  = "${relation_l3ext_rs_dampening_pol.value.address_family}-ucast"
      tDn = "uni/tn-${relation_l3ext_rs_dampening_pol.value.tenant}/prof-${relation_l3ext_rs_dampening_pol.value.route_map}"
    }
  }
  relation_l3ext_rs_interleak_pol = "{route_profile_for_interleak}"
  # relation_l3ext_rs_out_to_bd_public_subnet_holder = ["{fvBDPublicSubnetHolder}"]
}

#------------------------------------------------
# Create a Logical Node Profile
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extLNodeP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}"
GUI Location:
Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_node_profile" "node_profiles" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each      = local.node_profiles
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  annotation    = each.value.annotation
  description   = each.value.description
  name          = each.value.name
  name_alias    = each.value.alias
  tag           = each.value.color_tag
  target_dscp   = each.value.target_dscp
}


#------------------------------------------------
# Assign a Node to a Logical Node Profile
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsNodeL3OutAtt"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/rsnodeL3OutAtt-[topology/pod-{pod_id}/node-{node_id}]"
GUI Location:
Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile}: Nodes > {node_id}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_node_to_fabric_node" "logical_node_to_fabric_nodes" {
  depends_on = [
    aci_logical_node_profile.node_profiles
  ]
  for_each                = local.node_profiles_nodes
  logical_node_profile_dn = aci_logical_node_profile.node_profiles[each.value.name].id
  tdn                     = "topology/pod-${pod_id}/node-${node_id}"
  rtr_id                  = each.value.router_id
  rtr_id_loop_back        = each.value.use_router_id_as_loopback
}


#------------------------------------------------
# Create Logical Interface Profile
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extLIfP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/lnodep-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_interface_profile" "interface_profiles" {
  depends_on = [
    aci_logical_node_profile.node_profiles
  ]
  logical_node_profile_dn               = aci_logical_node_profile.node_profiles[each.value.node_profile].id
  description                           = each.value.description
  name                                  = each.value.name
  name_alias                            = each.value.alias
  prio                                  = each.value.qos_class
  tag                                   = each.value.color_tag
  relation_l3ext_rs_arp_if_pol          = each.value.arp_policy
  relation_l3ext_rs_egress_qos_dpp_pol  = each.value.egress_data_plane_policing
  relation_l3ext_rs_ingress_qos_dpp_pol = each.value.ingress_data_plane_policing
  relation_l3ext_rs_l_if_p_cust_qos_pol = each.value.custom_qos_policy
  relation_l3ext_rs_nd_if_pol           = each.value.nd_policy
  relation_l3ext_rs_l_if_p_to_netflow_monitor_pol = length(
    each.value.netflow_policy
  ) > 0 ? [for s in each.value.netflow_policy : "uni/infra/monitorpol-${s}"] : []
}


#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/{PATH}/pathep-[{interface_or_pg}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Sub-Interfaces

 - Assign all the default Policies to this Policy Group
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_path_attachment" "l3out_path_attachments" {
  depends_on = [
    aci_logical_interface_profile.logical_interface_profiles
  ]
  logical_interface_profile_dn = aci_logical_interface_profile.logical_interface_profiles[each.value.interface_profile].id
  target_dn = length(regexall(
    "ext-svi", each.value.interface_type)
    ) > 0 ? "topology/pod-${each.value.pod}/protpaths-${each.value.node1}-${each.value.node2}/pathep-[${each.value.policy_group}]" : length(regexall(
    "[[:alnum:]]+", each.value.interface_type)
  ) > 0 ? "topology/pod-${each.value.pod}/paths-${each.value.node1}/pathep-[${each.value.interface}]" : ""
  if_inst_t   = each.value.interface_type
  addr        = each.value.primary_address
  annotation  = each.value.annotation
  autostate   = each.value.interface_type != "ext-svi" ? each.value.auto_state : ""
  encap       = each.value.vlan != "" ? "vlan-${vlan}" : ""
  mode        = each.value.vlan != "" ? each.value.mode : ""
  encap_scope = each.value.vlan != "" ? each.value.encap_scope : ""
  ipv6_dad    = each.value.ipv6_dad
  ll_addr     = each.value.a_link_local_address
  mac         = each.value.mac_address
  mtu         = each.value.mtu != "" ? each.value.mtu : "inherit"
  target_dscp = each.value.target_dscp
}


#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/protpaths-{node1_id}-{node2_id}//pathep-[{policy_group}]]/mem-{side}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_vpc_member" "l3out_vpc_member" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  for_each     = local.vpc_addressing
  addr         = each.value.primary_address
  description  = each.value.description
  ipv6_dad     = each.value.ipv6_dad
  leaf_port_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.l3out_path].id
  ll_addr      = each.value.link_local_address
  side         = each.value.side
}

#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{tenant}/out-{l3out}/lnodep-{node_profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{pod_id}/{PATH}/pathep-[{interface_or_pg}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile > {node_profile} > Logical Interface Profiles {interface_profile}: Routed Sub-Interfaces

_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_path_attachment_secondary_ip" "aci_l3out_path_attachment_secondary_ips" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  for_each                 = local.secondary_ips
  l3out_path_attachment_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.l3out_path].id
  addr                     = each.value.secondary_ip_address
  annotation               = each.value.annotation
  ipv6_dad                 = each.value.ipv6_dad
}


#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfExtP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/ospfExtP"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out}: OSPF
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_ospf_external_policy" "l3out_ospf_external_policies" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each      = local.l3out_ospf_external_policies
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  area_cost     = each.value.ospf_area_cost
  area_ctrl     = each.value.ospf_area_control
  area_id       = each.value.ospf_area_id
  area_type     = each.value.ospf_area_type
  # multipod_internal = "no"
}

#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/nodep-{node_profile}/lifp-{interface_profile}/ospfIfP"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > Logical Node Profile {node_profile} > Logical Interface Profile > {interface_profile} > OSPF Interface Profile
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_ospf_interface_profile" "l3out_ospf_interface_profiles" {
  depends_on = [
    aci_logical_interface_profile.interface_profiles,
    aci_ospf_interface_policy.ospf_interface_policies,
    local.ospf_interface_policies
  ]
  for_each                     = local.ospf_interface_profiles
  logical_interface_profile_dn = aci_logical_interface_profile.interface_profiles[each.value.interface_profile].id
  description                  = each.value.description
  auth_key = length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.osfp_key == 5 ? var.ospf_key_5 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.osfp_key == 4 ? var.ospf_key_4 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.osfp_key == 3 ? var.ospf_key_3 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
    ) > 0 && each.value.osfp_key == 2 ? var.ospf_key_2 : length(regexall(
    "(md5|simple)", each.value.authentication_type)
  ) > 0 && each.value.osfp_key == 1 ? var.ospf_key_1 : ""
  auth_key_id = each.value.authentication_type == "md5" ? each.value.osfp_key : ""
  auth_type   = each.value.authentication_type
  relation_ospf_rs_if_pol = length(regexall(
    each.value.tenant, each.value.policy_tenant)
    ) > 0 ? aci_ospf_interface_policy.ospf_interface_policies[each.value.ospf_interface_policy].id : length(regexall(
    "[[:alnum:]]+", each.value.policy_tenant)
  ) > 0 ? local.data_ospf_interface_policy[each.value.ospf_interface_policy].id : ""
}


/*
API Information:
 - Class: "l3extInstP"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{Ext_EPG}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {Ext_EPG}
*/
resource "aci_external_network_instance_profile" "external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each                                    = local.external_epgs
  l3_outside_dn                               = aci_l3_outside.l3outs[each.value.l3out].id
  annotation                                  = each.value.annotation
  description                                 = each.value.description
  exception_tag                               = each.value.contract_exception_tag
  flood_on_encap                              = each.value.flood_on_encapsulation
  match_t                                     = each.value.match_type
  name_alias                                  = each.value.alias
  name                                        = each.value.epg
  pref_gr_memb                                = each.value.preferred_group_member
  prio                                        = each.value.qos_class
  target_dscp                                 = each.value.target_dscp
  relation_l3ext_rs_l3_inst_p_to_dom_p        = each.value.L3_Domain
  relation_fv_rs_sec_inherited                = [each.value.l3out_contract_masters]
  relation_l3ext_rs_inst_p_to_nat_mapping_epg = "aci_bridge_domain.{NAT_fvEPg}.id"
  relation_l3ext_rs_inst_p_to_profile         = [each.value.route_control_profile]
}

resource "aci_rest" "external_epg_intra_epg_contracts" {
  provider   = netascode
  for_each   = { for k, v in local.vzany_contracts : k => v if v.type == "apic" && v.contract_type == "intra_epg" }
  dn         = "uni/tn-${each.value.tenant}/out-${each.value.vrf}/instP-${each.value.epg}/rsintraEpg-${each.value.contract}"
  class_name = "fvRsIntraEpg"
  content = {
    tDn = "uni/tn-${each.value.contract_tenant}/brc-${each.value.contract}"
  }
}

resource "aci_rest" "external_epg_contracts" {
  provider = netascode
  for_each = { for k, v in local.vzany_contracts : k => v if v.type == "apic" && v.contract_type != "intra_epg" }
  dn = length(regexall(
    "consumer", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.vrf}/instP-${each.value.epg}/rscons-${each.value.contract}" : length(regexall(
    "interface", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.vrf}/instP-${each.value.epg}/rsconsIf-${each.value.contract}" : length(regexall(
    "provider", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.vrf}/instP-${each.value.epg}/rsprov-${each.value.contract}" : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.vrf}/instP-${each.value.epg}/rsprotBy-${each.value.contract}" : ""
  class_name = length(regexall(
    "consumer", each.value.contract_type)
    ) > 0 ? "fvRsCons" : length(regexall(
    "interface", each.value.contract_type)
    ) > 0 ? "vzRsAnyToConsIf" : length(regexall(
    "provider", each.value.contract_type)
    ) > 0 ? "fvRsProv" : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? "fvRsProtBy" : ""
  content = {
    tDn  = "uni/tn-${each.value.contract_tenant}/brc-${each.value.contract}"
    prio = each.value.qos_class
  }
}


#------------------------------------------
# Create an Out-of-Band External EPG
#------------------------------------------

/*
API Information:
 - Class: "mgmtInstP"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{Ext_EPG}"
GUI Location:
 - Tenants > mgmt > External Management Network Instance Profiles > {Ext_EPG}
*/
resource "aci_rest" "oob_external_epgs" {
  provider = netascode
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = local.oob_external_epgs
  dn         = "uni/tn-mgmt/extmgmt-default/instp-{Ext_EPG}"
  class_name = "mgmtInstP"
  content = {
    annotation = each.value.annotation
    name       = each.value.external_epg
  }
}

#------------------------------------------------
# Assign a Subnet to an External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extSubnet"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{Ext_EPG}/extsubnet-[{Subnet}]"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {Ext_EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_ext_subnet" "external_epg_subnets" {
  depends_on = [
    aci_external_network_instance_profile.external_epgs
  ]
  for_each                             = { for k, v in local.external_epg_subnets : k => v if epg_type != "oob" }
  external_network_instance_profile_dn = aci_external_network_instance_profile.external_epgs[each.value.external_epg].id
  description                          = each.value.description
  ip                                   = each.value.subnet
  aggregate                            = each.value.aggregate
  scope                                = [each.value.scope]
  dynamic "relation_l3ext_rs_subnet_to_profile" {
    for_each = each.value.route_control_profiles
    content {
      tn_rtctrl_profile_dn = relation_l3ext_rs_subnet_to_profile.value.route_map
      direction            = relation_l3ext_rs_subnet_to_profile.value.direction
    }
  }
  relation_l3ext_rs_subnet_to_rt_summ = each.value.route_summarization_prolicy
}


#------------------------------------------------
# Assign a Subnet to an Out-of-Band External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtSubnet"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{Ext_EPG}/subnet-[{Subnet}]"
GUI Location:
 - Tenants > mgmt > External Management Network Instance Profiles > {Ext_EPG}: Subnets:{Subnet}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "oob_external_epg_subnets" {
  provider = netascode
  depends_on = [
    aci_rest.oob_external_epgs
  ]
  for_each   = { for k, v in local.external_epg_subnets : k => v if epg_type == "oob" }
  dn         = "uni/tn-mgmt/extmgmt-default/instp-${each.value.epg}/subnet-[${each.value.subnet}]"
  class_name = "mgmtSubnet"
  content = {
    ip = each.value.subnet
  }
}
