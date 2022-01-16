#------------------------------------------------
# Create L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extOut"
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_outside" "l3outs" {
  depends_on = [
    local.l3_domains,
    aci_tenant.tenants,
    aci_vrf.vrfs
  ]
  tenant_dn      = aci_tenant.tenants[each.value.tenant].id
  description    = each.value.description
  name           = each.key
  annotation     = each.value.annotation
  enforce_rtctrl = "{enforce_rtctrl}"
  name_alias     = each.value.alias
  target_dscp    = "{target_dscp}"
  relation_l3ext_rs_ectx = length(regexall(
    each.value.tenant, each.value.vrf_tenant)
    ) > 0 ? aci_vrf.vrfs[each.value.vrf].id : length(regexall(
    "[[:alnum:]]+", each.value.vrf_tenant)
  ) > 0 ? local.common_vrfs[each.value.vrf].id : ""
  relation_l3ext_rs_l3_dom_att                     = local.l3_domains[each.value.l3_domain].id
  relation_l3ext_rs_dampening_pol                  = ["{damp_rtctrlProfile}"]
  relation_l3ext_rs_interleak_pol                  = "{leak_rtctrlProfile}"
  relation_l3ext_rs_out_to_bd_public_subnet_holder = ["{fvBDPublicSubnetHolder}"]
}

#------------------------------------------------
# Create a Logical Node Profile
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extLNodeP"
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}"
GUI Location:
Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_node_profile" "logical_node_profiles" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  description   = each.value.description
  name          = "{Node_Profile}"
  name_alias    = each.value.alias
  tag           = "{Color_Tag}"
  target_dscp   = "{Target_DSCP}"
}


#------------------------------------------------
# Assign a Node to a Logical Node Profile
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsNodeL3OutAtt"
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}/rsnodeL3OutAtt-[topology/pod-{Pod_ID}/node-{Node_ID}]"
GUI Location:
Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile}: Nodes > {Node_ID}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_node_to_fabric_node" "logical_node_to_fabric_nodes" {
  depends_on = [
    aci_logical_node_profile.logical_node_profiles
  ]
  logical_node_profile_dn = aci_logical_node_profile.logical_node_profiles[each.value.logical_node_profile].id
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
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}/lnodep-{Name}"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {Interface_Profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_logical_interface_profile" "logical_interface_profiles" {
  depends_on = [
    aci_logical_node_profile.logical_node_profiles
  ]
  logical_node_profile_dn                         = aci_logical_node_profile.logical_node_profiles[each.value.logical_node_profile].id
  description                                     = each.value.description
  name                                            = "{Interface_Profile}"
  name_alias                                      = each.value.alias
  prio                                            = "{prio}"
  tag                                             = "{tag}"
  relation_l3ext_rs_path_l3_out_att               = ["{fabricPathEp}"]
  relation_l3ext_rs_arp_if_pol                    = "{arpIfPol}"
  relation_l3ext_rs_egress_qos_dpp_pol            = "{egress_qosDppPol}"
  relation_l3ext_rs_ingress_qos_dpp_pol           = "{ingress_qosDppPol}"
  relation_l3ext_rs_l_if_p_cust_qos_pol           = "{qosCustomPol}"
  relation_l3ext_rs_nd_if_pol                     = "{ndIfPol}"
  relation_l3ext_rs_l_if_p_to_netflow_monitor_pol = ["{netflowMonitorPol}"]
}


#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: "uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}/lifp-{interface_profile}/rspathL3OutAtt-[topology/pod-{Pod_ID}/{PATH}/pathep-[{Interface_or_PG}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {interface_profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {interface_profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {interface_profile}: Routed Sub-Interfaces

 - Assign all the default Policies to this Policy Group
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_path_attachment" "l3out_path_attachments" {
  depends_on = [
    aci_logical_interface_profile.logical_interface_profiles
  ]
  logical_interface_profile_dn = aci_logical_interface_profile.logical_interface_profiles[each.value.interface_profile].id
  target_dn                    = "topology/pod-{Pod_ID}/{PATH}/pathep-[{Interface_or_PG}]"
  if_inst_t                    = each.value.interface_type
  addr                         = each.value.address
  annotation                   = each.value.annotation
  autostate                    = each.value.interface_type != "ext-svi" ? each.value.auto_state : ""
  encap                        = each.value.vlan != "" ? "vlan-${vlan}" : ""
  mode                         = each.value.vlan != "" ? each.value.mode : ""
  encap_scope                  = each.value.vlan != "" ? each.value.encap_scope : ""
  ipv6_dad                     = "{IPv6_DAD}"
  ll_addr                      = "{Link_Local}"
  mac                          = "{MAC_Address}"
  mtu                          = "{MTU}"
  target_dscp                  = "{Target_DSCP}"
}


#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}/lifp-{Interface_Profile}/rspathL3OutAtt-[topology/pod-{Pod_ID}/protpaths-{Node1_ID}-{Node2_ID}//pathep-[{Interface_or_PG}]]/mem-{Side}"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {Interface_Profile}: SVI
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_vpc_member" "l3out_vpc_member" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  addr         = "{Address}"
  description  = each.value.description
  ipv6_dad     = "{IPv6_DAD}"
  leaf_port_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.l3out_path].id
  ll_addr      = "{Link_Local}"
  side         = "{Side}"
}

#-------------------------------------------------------------
# Attach a Node Interface Path to a Logical Interface Profile
#-------------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsPathL3OutAtt"
 - Distinguished Name: " uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}/lifp-{Interface_Profile}/rspathL3OutAtt-[topology/pod-{Pod_ID}/{PATH}/pathep-[{Interface_or_PG}]]"
GUI Location:
{%- if Interface_Type == 'ext-svi' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {Interface_Profile}: SVI
{%- elif Interface_Type == 'l3-port' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {Interface_Profile}: Routed Interfaces
{%- elif Interface_Type == 'sub-interface' %}
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile > {Node_Profile} > Logical Interface Profiles {Interface_Profile}: Routed Sub-Interfaces

_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_path_attachment_secondary_ip" "aci_l3out_path_attachment_secondary_ips" {
  depends_on = [
    aci_l3out_path_attachment.l3out_path_attachments
  ]
  l3out_path_attachment_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.l3out_path].id
  addr                     = "{Secondary}"
  annotation               = each.value.annotation
  ipv6_dad                 = "{IPv6_DAD}"
}


#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfExtP"
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}/ospfExtP"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out}: OSPF
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_ospf_external_policy" "l3out_ospf_external_policies" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  area_cost     = "{Cost}"
  area_ctrl     = "{Ctrl}"
  area_id       = "{Area_ID}"
  area_type     = "{Area_Type}"
  # multipod_internal = "no"
}

#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfP"
 - Distinguished Name: "/uni/tn-{Tenant}/out-{L3Out}/nodep-{Node_Profile}/lifp-{Interface_Profile}/ospfIfP"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile {Node_Profile} > Logical Interface Profile > {Interface_Profile} > OSPF Interface Profile
_______________________________________________________________________________________________________________________
*/
resource "aci_l3out_ospf_interface_profile" "l3out_ospf_interface_profiles" {
  depends_on = [
    aci_logical_interface_profile.logical_interface_profiles,
    aci_ospf_interface_policy.ospf_interface_policies,
    local.ospf_interface_policies
  ]
  logical_interface_profile_dn = aci_logical_interface_profile.logical_interface_profiles[each.value.interface_profile].id
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
 - Distinguised Name: "/uni/tn-{Tenant}/out-{L3Out}/instP-{Ext_EPG}"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > External EPGs > {Ext_EPG}
*/
resource "aci_external_network_instance_profile" "external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  l3_outside_dn                               = aci_l3_outside.l3outs[each.value.l3out].id
  description                                 = "{Description}"
  annotation                                  = "{Tags}"
  exception_tag                               = "{exception_tag}"
  flood_on_encap                              = "{flood}"
  match_t                                     = "{match_t}"
  name_alias                                  = "{Alias}"
  name                                        = "{Ext_EPG}"
  pref_gr_memb                                = "{pref_gr_memb}"
  prio                                        = "{prio}"
  target_dscp                                 = "{target_dscp}"
  relation_l3ext_rs_l3_inst_p_to_dom_p        = "{L3_Domain}"
  relation_fv_rs_cons                         = ["{cons_vzBrCP}"]
  relation_fv_rs_cons_if                      = ["{vzCPIf}"]
  relation_fv_rs_sec_inherited                = ["{Master_fvEPg}"]
  relation_fv_rs_prov                         = ["{prov_vzBrCP}"]
  relation_fv_rs_prot_by                      = ["{vzTaboo}"]
  relation_l3ext_rs_inst_p_to_nat_mapping_epg = "aci_bridge_domain.{NAT_fvEPg}.id"
  relation_l3ext_rs_inst_p_to_profile         = ["{rtctrlProfile}"]
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
 - Distinguised Name: "/uni/tn-{Tenant}/out-{L3Out}/instP-{Ext_EPG}/extsubnet-[{Subnet}]"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > External EPGs > {Ext_EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_ext_subnet" "external_epg_subnets" {
  depends_on = [
    aci_external_network_instance_profile.external_epgs
  ]
  external_network_instance_profile_dn = aci_external_network_instance_profile.external_epgs[each.value.external_epg].id
  description                          = each.value.description
  ip                                   = "{Subnet}"
  aggregate                            = "{aggregate}"
  scope                                = "{scope}"
  relation_l3ext_rs_subnet_to_profile  = ["{sub_rtctrlProfile}"]
  relation_l3ext_rs_subnet_to_rt_summ  = "{rtsumARtSummPol}"
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
  for_each   = local.oob_external_epg_subnets
  dn         = "uni/tn-mgmt/extmgmt-default/instp-{Ext_EPG}/subnet-[{Subnet}]"
  class_name = "mgmtSubnet"
  content = {
    ip = each.value.subnet
  }
}
