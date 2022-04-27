variable "l3outs" {
  default = {
    "default" = {
      annotation      = ""
      controller_type = "apic"
      description     = ""
      external_epgs = [
        {
          contract_exception_tag = 0
          contracts = [
            {
              contract_name   = "default"
              contract_tenant = "common"
              contract_type   = "consumer" # consumer|interface|intra_epg|provider|taboo
              qos_class       = "unspecified"
            }
          ]
          description            = ""
          epg_type               = "default" # default or oob
          flood_on_encapsulation = "disabled"
          match_type             = "AtleastOne"
          name                   = "default"
          name_alias             = ""
          preferred_group_member = false
          qos_class              = "unspecified"
          subnets = [
            {
              aggregate = [{
                aggregate_export        = false
                aggregate_shared_routes = false
              }]
              description = ""
              external_epg_classification = [{
                external_subnets_for_external_epg = true
                shared_security_import_subnet     = false
              }]
              route_control = [{
                export_route_control_subnet = false
                shared_route_control_subnet = false
              }]
              route_summarization_policy = ""
              route_control_profiles     = []
              # Example
              # route_control_profiles = [{
              #   direction = "export" # export/import
              #   route_map = "default"
              #   tenant = "**l3out_tenant**"
              # }]
              subnet = "0.0.0.0/1"
            },
            {
              aggregate = [{
                aggregate_export        = false
                aggregate_shared_routes = false
              }]
              description = ""
              external_epg_classification = [{
                external_subnets_for_external_epg = true
                shared_security_import_subnet     = false
              }]
              route_control = [{
                export_route_control_subnet = false
                shared_route_control_subnet = false
              }]
              subnet = "128.0.0.0/1"
            }
          ]
          route_control_profiles = []
          # Example
          # route_control_profiles = [{
          #   direction = "export" # export/import
          #   route_map = "default"
          #   tenant = "**l3out_tenant**"
          # }]
          target_dscp = "unspecified"
        }
      ]
      floating_svi = []
      l3_domain    = ""
      level        = "template"
      name_alias   = ""
      node_profiles = [
        {
          color_tag   = "yellow-green"
          description = ""
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
              interface                   = "eth1/1"
              interface_type              = "l3-port" # ext-svi|l3-port|sub-interface
              ipv6_dad                    = "enabled"
              link_local_address          = "::"
              mac_address                 = "00:22:BD:F8:19:FF"
              mode                        = "regular"
              mtu                         = "inherit" # 576 to 9216
              name                        = "default"
              nd_policy                   = ""
              netflow_policies            = []
              nodes                       = [201]
              ospf_interface_profile      = "default"
              preferred_address           = "198.18.1.1/24"
              qos_class                   = "unspecified"
              secondary_addresses         = [] # "198.18.3.1/24"
              svi_addresses               = []
              # Example
              # svi_addresses               = [
              #   {
              #     link_local_address  = "::"
              #     preferred_address   = "198.18.1.1/24"
              #     secondary_addresses = []
              #     side                = "A"
              #   },
              #   {
              #     link_local_address  = "::"
              #     preferred_address   = "198.18.1.2/24"
              #     secondary_addresses = []
              #     side                = "B"
              #   }
              # ]
            }
          ]
          name = "default"
          nodes = [
            {
              node_id                   = 201
              router_id                 = "198.18.0.1"
              use_router_id_as_loopback = true
            }
          ]
          pod_id = 1
        }
      ]
      ospf_external_policies = []
      # Example
      # ospf_external_policies = [
      #   {
      #     ospf_area_cost = 1
      #     ospf_area_control = [{
      #       send_redistribution_lsas_into_nssa_area = true
      #       originate_summary_lsa                   = true
      #       suppress_forwarding_address             = false
      #     }]
      #     ospf_area_id   = "0.0.0.0"
      #     ospf_area_type = "regular" # nssa, regular, stub
      #   }
      # ]
      ospf_interface_profiles = []
      # Example
      # ospf_interface_profiles = [
      #   {
      #     description           = ""
      #     authentication_type   = "none" # md5,none,simple
      #     name                  = "default"
      #     ospf_key              = 0
      #     ospf_interface_policy = "default"
      #     policy_tenant    = "**l3out_tenant**"
      #   }
      # ]
      route_control_enforcement = [
        {
          import = false
        }
      ]
      route_control_for_dampening = []
      # Example
      # route_control_for_dampening = [
      #   {
      #     address_family = "ipv4"
      #     route_map      = "**REQUIRED**"
      #     tenant         = "**l3out_tenant**"
      #   }
      # ]
      target_dscp = "unspecified"
      sites       = []
      tags        = []
      template    = "common"
      tenant      = "common"
      vrf         = "default"
      vrf_tenant  = "common"
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
# Argument Reference
# addr - (Optional) Peer address for L3out floating SVI object. Default value: "0.0.0.0".
# annotation - (Optional) Annotation for L3out floating SVI object.
# autostate - (Optional) Autostate for L3out floating SVI object. Allowed values are "disabled" and "enabled". Default value is "disabled".
# description - (Optional) Description for L3out floating SVI object.
# encap - (Required) Port encapsulation for L3out floating SVI object.
# encap_scope - (Optional) Encap scope for L3out floating SVI object. Allowed values are "ctx" and "local". Default value is "local".
# if_inst_t - (Optional) Interface type for L3out floating SVI object. Allowed values are "ext-svi", "l3-port", "sub-interface" and "unspecified". Default value is "unspecified".
# ipv6_dad - (Optional) IPv6 dad for L3out floating SVI object. Allowed values are "disabled" and "enabled". Default value is "enabled".
# ll_addr - (Optional) Link local address for L3out floating SVI object. Default value: "::".
# logical_interface_profile_dn - (Required) Distinguished name of parent logical interface profile object.
# mac - (Optional) MAC address for L3out floating SVI object.
# mode - (Optional) BGP domain mode for L3out floating SVI object. Allowed values are "native", "regular" and "untagged". Default value is "regular".
# mtu - (Optional) Administrative MTU port on the aggregated interface for L3out floating SVI object. Range of allowed values is "576" to "9216". Default value is "inherit".
# node_dn - (Required) Distinguished name of the node for L3out floating SVI object.
# relation_l3ext_rs_dyn_path_att - (Optional) Relation to class infraDomP. Cardinality - N_TO_M. Type - Set of String.
# target_dscp - (Optional) Target DSCP for L3out floating SVI object. Allowed values are "AF11", "AF12", "AF13", "AF21", "AF22", "AF23", "AF31", "AF32", "AF33", "AF41", "AF42", "AF43", "CS0", "CS1", "CS2", "CS3", "CS4", "CS5", "CS6", "CS7", "EF", "VA" and "unspecified". Default value is "unspecified".
  EOT
  type = map(object(
    {
      annotation      = optional(string)
      controller_type = optional(string)
      description     = optional(string)
      external_epgs = optional(list(object(
        {
          contract_exception_tag = optional(number)
          contracts = optional(list(object(
            {
              contract_name   = string
              contract_tenant = optional(string)
              contract_type   = optional(string)
              qos_class       = optional(string)
            }
          )))
          description            = optional(string)
          epg_type               = optional(string)
          flood_on_encapsulation = optional(string)
          match_type             = optional(string)
          name                   = string
          name_alias             = optional(string)
          preferred_group_member = optional(bool)
          qos_class              = optional(string)
          subnets = list(object(
            {
              aggregate = optional(list(object(
                {
                  aggregate_export        = optional(bool)
                  aggregate_shared_routes = optional(bool)
                }
              )))
              description = optional(string)
              external_epg_classification = optional(list(object(
                {
                  external_subnets_for_external_epg = optional(bool)
                  shared_security_import_subnet     = optional(bool)
                }
              )))
              route_control = optional(list(object(
                {
                  export_route_control_subnet = optional(bool)
                  shared_route_control_subnet = optional(bool)
                }
              )))
              route_control_profiles = optional(list(object(
                {
                  direction = string
                  route_map = string
                }
              )))
              route_summarization_policy = optional(string)
              subnet                     = string
            }
          ))
          route_control_profiles = optional(list(object(
            {
              direction = string
              route_map = string
            }
          )))
          target_dscp = optional(string)
        }
      )))
      floating_svi = optional(list(object(
        {
          abc = optional(string)
        }
      )))
      l3_domain  = optional(string)
      level      = optional(string)
      name_alias = optional(string)
      node_profiles = optional(list(object(
        {
          color_tag   = optional(string)
          description = optional(string)
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
              interface                   = string
              interface_type              = optional(string)
              ipv6_dad                    = optional(string)
              link_local_address          = optional(string)
              mac_address                 = optional(string)
              mode                        = optional(string)
              mtu                         = optional(string)
              name                        = string
              nd_policy                   = optional(string)
              netflow_policies            = optional(list(string))
              nodes                       = optional(list(string))
              ospf_interface_profile      = optional(string)
              preferred_address           = optional(string)
              qos_class                   = optional(string)
              secondary_addresses         = optional(list(string))
              svi_addresses = optional(list(object(
                {
                  link_local_address  = optional(string)
                  preferred_address   = optional(string)
                  secondary_addresses = optional(list(string))
                  side                = string
                },
              )))
            }
          )))
          name = string
          nodes = list(object(
            {
              node_id                   = optional(number)
              router_id                 = optional(string)
              use_router_id_as_loopback = optional(bool)
            }
          ))
          pod_id = optional(string)
        }
      )))
      ospf_external_policies = optional(list(object(
        {
          ospf_area_cost = optional(number)
          ospf_area_control = optional(list(object(
            {
              send_redistribution_lsas_into_nssa_area = optional(bool)
              originate_summary_lsa                   = optional(bool)
              suppress_forwarding_address             = optional(bool)
            }
          )))
          ospf_area_id   = optional(string)
          ospf_area_type = optional(string)
        }
      )))
      ospf_interface_profiles = optional(list(object(
        {
          description           = optional(string)
          authentication_type   = optional(string)
          name                  = string
          ospf_key              = optional(number)
          ospf_interface_policy = optional(string)
          policy_tenant         = optional(string)
        }
      )))
      route_control_enforcement = optional(list(object(
        {
          import = optional(bool)
        }
      )))
      route_control_for_dampening = optional(list(object(
        {
          address_family = optional(string)
          route_map      = string
          tenant         = optional(string)
        }
      )))
      target_dscp = optional(string)
      sites       = optional(list(string))
      tags = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      template   = optional(string)
      tenant     = optional(string)
      vrf        = optional(string)
      vrf_tenant = optional(string)
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
    local.rs_l3_domains,
    aci_tenant.tenants,
    aci_vrf.vrfs
  ]
  for_each = { for k, v in local.l3outs : k => v if v.controller_type == "apic" }
  # annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description    = each.value.description
  enforce_rtctrl = each.value.import == true ? ["export", "import"] : ["export"]
  name           = each.key
  name_alias     = each.value.name_alias
  target_dscp    = each.value.target_dscp
  tenant_dn      = aci_tenant.tenants[each.value.tenant].id
  relation_l3ext_rs_ectx = length(regexall(
    each.value.tenant, each.value.vrf_tenant)
    ) > 0 ? aci_vrf.vrfs[each.value.vrf].id : length(regexall(
    "[[:alnum:]]+", each.value.vrf_tenant)
  ) > 0 ? local.rs_vrfs[each.value.vrf].id : ""
  relation_l3ext_rs_l3_dom_att = length(regexall(
    "[[:alnum:]]+", each.value.l3_domain)
  ) > 0 ? "uni/l3dom-${each.value.l3_domain}" : ""
  dynamic "relation_l3ext_rs_dampening_pol" {
    for_each = each.value.route_control_for_dampening
    content {
      af                     = "${relation_l3ext_rs_dampening_pol.value.address_family}-ucast"
      tn_rtctrl_profile_name = "uni/tn-${relation_l3ext_rs_dampening_pol.value.tenant}/prof-${relation_l3ext_rs_dampening_pol.value.route_map}"
    }
  }
  # relation_l3ext_rs_interleak_pol = "{route_profile_for_interleak}"
  # relation_l3ext_rs_out_to_bd_public_subnet_holder = ["{fvBDPublicSubnetHolder}"]
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extInstP"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{Ext_EPG}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {Ext_EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_external_network_instance_profile" "l3out_external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each       = { for k, v in local.l3out_external_epgs : k => v if v.epg_type != "oob" }
  l3_outside_dn  = aci_l3_outside.l3outs[each.value.l3out].id
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description    = each.value.description
  exception_tag  = each.value.contract_exception_tag
  flood_on_encap = each.value.flood_on_encapsulation
  match_t        = each.value.match_type
  name_alias     = each.value.name_alias
  name           = each.value.name
  pref_gr_memb   = each.value.preferred_group_member == true ? "include" : "exclude"
  prio           = each.value.qos_class
  target_dscp    = each.value.target_dscp
  dynamic "relation_l3ext_rs_inst_p_to_profile" {
    for_each = each.value.route_control_profiles
    content {
      direction              = each.value.direction
      tn_rtctrl_profile_name = "uni/tn-${relation_l3ext_rs_inst_p_to_profile.value.tenant}/prof-${relation_l3ext_rs_inst_p_to_profile.value.route_map}"
    }
  }
  # relation_l3ext_rs_l3_inst_p_to_dom_p        = each.value.L3_Domain
  # relation_fv_rs_cust_qos_pol = each.value.custom_qos_policy
  # relation_fv_rs_sec_inherited                = [each.value.l3out_contract_masters]
  # relation_l3ext_rs_inst_p_to_nat_mapping_epg = "aci_bridge_domain.{NAT_fvEPg}.id"
}

#------------------------------------------
# Create an Out-of-Band External EPG
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtInstP"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{name}"
GUI Location:
 - Tenants > mgmt > External Management Network Instance Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = { for k, v in local.l3out_external_epgs : k => v if v.epg_type == "oob" }
  dn         = "uni/tn-mgmt/extmgmt-default/instp-{name}"
  class_name = "mgmtInstP"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name       = each.value.name
  }
}

#------------------------------------------------
# Assign Contracts to an External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsIntraEpg"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsintraEpg-{contract}"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}: Contracts
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "external_epg_intra_epg_contracts" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs,
    aci_rest_managed.oob_external_epgs
  ]
  for_each   = { for k, v in local.l3out_ext_epg_contracts : k => v if v.controller_type == "apic" && v.contract_type == "intra_epg" }
  dn         = "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsintraEpg-${each.value.contract}"
  class_name = "fvRsIntraEpg"
  content = {
    tnVzBrCPName = each.value.contract
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Consumer Class: "fvRsCons"
 - Interface Class: "vzRsAnyToConsIf"
 - Provider Class: "fvRsProv"
 - Taboo Class: "fvRsProtBy"
 - Consumer Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsintraEpg-{contract}"
 - Interface Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsconsIf-{contract}"
 - Provider Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsprov-{contract}"
 - Taboo Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsprotBy-{contract}"
GUI Location:
 - All Contracts: Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}: Contracts
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "external_epg_contracts" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs,
    aci_rest_managed.oob_external_epgs
  ]
  for_each = { for k, v in local.l3out_ext_epg_contracts : k => v if v.controller_type == "apic" && v.contract_type != "intra_epg" }
  dn = length(regexall(
    "consumer", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rscons-${each.value.contract}" : length(regexall(
    "interface", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsconsIf-${each.value.contract}" : length(regexall(
    "provider", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsprov-${each.value.contract}" : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsprotBy-${each.value.contract}" : ""
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
    tnVzBrCPName = each.value.contract
    prio         = each.value.qos_class
  }
}


#------------------------------------------------
# Assign a Subnet to an External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extSubnet"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/extsubnet-[{subnet}]"
GUI Location:
 - Tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_ext_subnet" "external_epg_subnets" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs
  ]
  for_each = { for k, v in local.l3out_external_epg_subnets : k => v if v.epg_type != "oob" }
  aggregate = anytrue(
    [each.value.agg_export, each.value.agg_shared]
    ) ? replace(trim(join(",", concat([
      length(regexall(true, each.value.agg_export)) > 0 ? "export-rtctrl" : ""], [
      length(regexall(true, each.value.agg_shared)) > 0 ? "shared-rtctrl" : ""]
  )), ","), ",,", ",") : "none"
  annotation                           = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                          = each.value.description
  external_network_instance_profile_dn = aci_external_network_instance_profile.l3out_external_epgs[each.value.ext_epg].id
  ip                                   = each.value.subnet
  scope = anytrue(
    [each.value.scope_export, each.value.scope_isec, each.value.scope_ishared, each.value.scope_shared]
    ) ? compact(concat([
      length(regexall(true, each.value.scope_export)) > 0 ? "export-rtctrl" : ""], [
      length(regexall(true, each.value.scope_isec)) > 0 ? "import-security" : ""], [
      length(regexall(true, each.value.scope_ishared)) > 0 ? "shared-security" : ""], [
      length(regexall(true, each.value.scope_shared)) > 0 ? "shared-rtctrl" : ""]
  )) : ["import-security"]
  dynamic "relation_l3ext_rs_subnet_to_profile" {
    for_each = each.value.route_control_profiles
    content {
      direction            = relation_l3ext_rs_subnet_to_profile.value.direction
      tn_rtctrl_profile_dn = "uni/tn-${relation_l3ext_rs_subnet_to_profile.value.tenant}/prof-${relation_l3ext_rs_subnet_to_profile.value.route_map}"
    }
  }
  relation_l3ext_rs_subnet_to_rt_summ = length(
    regexall("[:alnum:]", each.value.route_summarization_policy)
  ) > 0 ? "uni/tn-common/bgprtsum-${each.value.route_summarization_policy}" : ""
}


#------------------------------------------------
# Assign a Subnet to an Out-of-Band External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtSubnet"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{ext_epg}/subnet-[{subnet}]"
GUI Location:
 - Tenants > mgmt > External Management Network Instance Profiles > {ext_epg}: Subnets:{subnet}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_external_epg_subnets" {
  depends_on = [
    aci_rest_managed.oob_external_epgs
  ]
  for_each   = { for k, v in local.l3out_external_epg_subnets : k => v if v.epg_type == "oob" }
  dn         = "uni/tn-mgmt/extmgmt-default/instp-${each.value.epg}/subnet-[${each.value.subnet}]"
  class_name = "mgmtSubnet"
  content = {
    ip = each.value.subnet
  }
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
resource "aci_logical_node_profile" "l3out_node_profiles" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each      = local.l3out_node_profiles
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = each.value.description
  name          = each.value.name
  name_alias    = ""
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
  ) > 0 ? "uni/tn-common/arpifpol-${each.value.arp_policy}" : ""
  relation_l3ext_rs_egress_qos_dpp_pol = length(regexall(
    "[[:alnum:]]+", each.value.egress_data_plane_policing)
  ) > 0 ? "uni/tn-common/qosdpppol-${each.value.egress_data_plane_policing}" : ""
  relation_l3ext_rs_ingress_qos_dpp_pol = length(regexall(
    "[[:alnum:]]+", each.value.ingress_data_plane_policing)
  ) > 0 ? "uni/tn-common/qosdpppol-${each.value.ingress_data_plane_policing}" : ""
  relation_l3ext_rs_l_if_p_cust_qos_pol = length(regexall(
    "[[:alnum:]]+", each.value.custom_qos_policy)
  ) > 0 ? "uni/tn-common/qoscustom-${each.value.custom_qos_policy}" : ""
  relation_l3ext_rs_nd_if_pol = each.value.nd_policy
  dynamic "relation_l3ext_rs_l_if_p_to_netflow_monitor_pol" {
    for_each = each.value.netflow_policies
    content {
      tn_netflow_monitor_pol_name = relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.netflow_policy
      flt_type                    = relation_l3ext_rs_l_if_p_to_netflow_monitor_pol.value.filter_type # ipv4|ipv6|ce
    }
  }
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
    aci_logical_interface_profile.l3out_interface_profiles
  ]
  for_each                     = local.l3out_interface_profiles
  logical_interface_profile_dn = aci_logical_interface_profile.l3out_interface_profiles[each.key].id
  target_dn = length(regexall(
    "ext-svi", each.value.interface_type)
    ) > 0 ? "topology/pod-${each.value.pod_id}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.interface}]" : length(regexall(
    "[[:alnum:]]+", each.value.interface_type)
  ) > 0 ? "topology/pod-${each.value.pod_id}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.interface}]" : ""
  if_inst_t   = each.value.interface_type
  addr        = each.value.interface_type != "ext-svi" ? each.value.preferred_address : ""
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  autostate   = each.value.interface_type != "ext-svi" ? each.value.auto_state : ""
  encap       = each.value.interface_type != "l3-port" ? "vlan-${each.value.encapsulation_vlan}" : "unknown"
  mode        = each.value.interface_type != "l3-port" ? each.value.mode : "regular"
  encap_scope = each.value.interface_type != "l3-port" ? each.value.encapsulation_scope : "local"
  ipv6_dad    = each.value.ipv6_dad
  ll_addr     = each.value.interface_type != "ext-svi" ? each.value.link_local_address : "::"
  mac         = each.value.mac_address
  mtu         = each.value.mtu
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
  for_each     = local.l3out_paths_svi_addressing
  addr         = each.value.preferred_address
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = ""
  ipv6_dad     = each.value.ipv6_dad
  leaf_port_dn = aci_l3out_path_attachment.l3out_path_attachments[each.value.path].id
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


# resource "aci_l3out_floating_svi" "l3out_floating_svis" {
#   depends_on = [
#     aci_logical_interface_profile.l3out_interface_profiles
#   ]
#   for_each                     = local.l3out_floating_svis
#   addr                         = each.value.address
#   annotation                   = each.value.annotation
#   autostate                    = each.value.autostate
#   description                  = each.value.description
#   encap_scope                  = each.value.encapsulation_scope
#   if_inst_t                    = "ext-svi"
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

#------------------------------------------------
# Create a BGP Peer Connectivity Profile
#------------------------------------------------

/*
API Information:
 - Class: "bgpPeerP"
 - Distinguished Name: "uni/tn-{Tenant}/out-{L3Out}/lnodep-{Node_Profile}/lifp-{Interface_Profile}/rspathL3OutAtt-[topology/pod-{Pod_ID}/{PATH}/pathep-[{Interface_or_PG}]]/peerP-[{Peer_IP}]"
GUI Location:
 - Tenants > {Tenant} > Networking > L3Outs > {L3Out} > Logical Node Profile {Node_Profile} > Logical Interface Profile > {Interface_Profile} > OSPF Interface Profile
*/
# resource "aci_bgp_peer_connectivity_profile" "bgp_peer_connectivity_profiles" {
#   depends_on = [
#     aci_logical_node_profile.l3out_node_profiles,
#     aci_logical_interface_profile.l3out_interface_profiles,
#     aci_bgp_peer_prefix.bgp_peer_prefix_policies
#   ]
#   logical_node_profile_dn = length(
#     regexall("interface", each.value.peer_level)
#     ) > 0 ? aci_logical_interface_profile.l3out_interface_profiles[each.value.interface_profile].id : length(
#     regexall("loopback", each.value.peer_level)
#   ) > 0 ? aci_logical_node_profile.l3out_node_profiles[each.value.node_profile].id : ""
#   addr                = each.value.bgp_peer
#   addr_t_ctrl         = each.value.address_type_controls
#   allowed_self_as_cnt = each.value.allowed_self_as_count
#   as_number           = each.value.remote_as
#   ctrl                = each.value.bgp_controlls
#   description         = each.value.description
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
#     ) > 0 ? aci_bgp_peer_prefix.bgp_peer_prefix_policies[each.value.bgp_peer_prefix_policy].id : length(
#     regexall("[:alnum:]", each.value.prefix_tenant)
#   ) > 0 ? rs_bgp_peer_prefix_policy.bgp_peer_prefix_policies[each.value.bgp_peer_prefix_policy].id : ""
#   dynamic "relation_bgp_rs_peer_pfx_pol" {
#     for_each = each.value.route_control_profiles
#     content {
#       direction = relation_bgp_rs_peer_to_profile.value.direction
#       target_dn = "uni/tn-${relation_bgp_rs_peer_pfx_pol.value.tenant}/prof-${relation_bgp_rs_peer_pfx_pol.value.route_map}"
#     }
#   }
# }


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
  for_each   = local.l3out_ospf_external_policies
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  area_cost  = each.value.ospf_area_cost
  area_ctrl = anytrue(
    [each.value.redistribute, each.value.summary, each.value.suppress_fa]
    ) ? replace(trim(join(",", concat([
      length(regexall(true, each.value.redistribute)) > 0 ? "redistribute" : ""], [
      length(regexall(true, each.value.summary)) > 0 ? "summary" : ""], [
      length(regexall(true, each.value.suppress_fa)) > 0 ? "suppress-fa" : ""]
  )), ","), ",,", ",") : ["redistribute", "summary"]
  area_id       = each.value.ospf_area_id
  area_type     = each.value.ospf_area_type
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
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
    aci_logical_interface_profile.l3out_interface_profiles,
    aci_ospf_interface_policy.ospf_interface_policies,
    local.rs_ospf_interface_policies
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
  relation_ospf_rs_if_pol = length(regexall(
    each.value.tenant, each.value.policy_tenant)
    ) > 0 ? aci_ospf_interface_policy.ospf_interface_policies[each.value.ospf_interface_policy].id : length(regexall(
    "[[:alnum:]]+", each.value.policy_tenant)
  ) > 0 ? local.rs_ospf_interface_policies[each.value.ospf_interface_policy].id : ""
}
