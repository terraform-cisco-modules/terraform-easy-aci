/*
- This Resource File will create Recommended Default Policies Based on the Best Practice Wizard and additional Best Practices
*/


/*_____________________________________________________________________________________________________________________

AAEP Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "aaep_policies" {
  default = {
    "default" = {
      alias            = ""
      description      = ""
      layer3_domains   = []
      physical_domains = []
      vmm_domains      = []
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * layer3_domains: A List of Layer3 Domains to Attach to this AAEP Policy.
  * physical_domains: A List of Physical Domains to Attach to this AAEP Policy.
  * vmm_domains: A List of Virtual Domains to Attach to this AAEP Policy.
  EOT
  type = map(object(
    {
      alias            = optional(string)
      description      = optional(string)
      layer3_domains   = optional(list(string))
      physical_domains = optional(list(string))
      vmm_domains      = optional(list(string))
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_attachable_access_entity_profile" "aaep_policies" {
  depends_on = [
    # aci_l3_domain_profile.layer3_domains,
    # aci_physical_domain.physical_domains,
    # aci_vmm_domain.vmm_domains
  ]
  for_each                = local.aaep_policies
  annotation              = each.value.tags != "" ? each.value.tags : var.tags
  description             = each.value.description
  name                    = each.key
  relation_infra_rs_dom_p = each.value.domains
}


/*_____________________________________________________________________________________________________________________

Error Disabled Recovery Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "error_disabled_recovery_policy" {
  default = {
    "default" = {
      alias                             = ""
      arp_inspection                    = "yes"
      bpdu_guard                        = "yes"
      debug_1                           = "yes"
      debug_2                           = "yes"
      debug_3                           = "yes"
      debug_4                           = "yes"
      debug_5                           = "yes"
      description                       = ""
      dhcp_rate_limit                   = "yes"
      ethernet_port_module              = "yes"
      ip_address_conflict               = "yes"
      ipqos_dcbxp_compatability_failure = "yes"
      ipqos_manager_error               = "yes"
      link_flap                         = "yes"
      loopback                          = "yes"
      loop_indication_by_mcp            = "yes"
      port_security_violation           = "yes"
      security_violation                = "yes"
      set_port_state_failed             = "yes"
      storm_control                     = "yes"
      stp_inconsist_vpc_peerlink        = "yes"
      system_error_based                = "yes"
      tags                              = ""
      unidirection_link_detection       = "yes"
      unknown                           = "yes"
    }
  }
  description = <<-EOT
  Key: Unique Identifier for the Map of Objects.  Not used in assignment.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * arp_inspection                    = "yes"
  * bpdu_guard                        = "yes"
  * debug_1                           = "yes"
  * debug_2                           = "yes"
  * debug_3                           = "yes"
  * debug_4                           = "yes"
  * debug_5                           = "yes"
  * description                       = ""
  * dhcp_rate_limit                   = "yes"
  * ethernet_port_module              = "yes"
  * ip_address_conflict               = "yes"
  * ipqos_dcbxp_compatability_failure = "yes"
  * ipqos_manager_error               = "yes"
  * link_flap                         = "yes"
  * loopback                          = "yes"
  * loop_indication_by_mcp            = "yes"
  * port_security_violation           = "yes"
  * security_violation                = "yes"
  * set_port_state_failed             = "yes"
  * storm_control                     = "yes"
  * stp_inconsist_vpc_peerlink        = "yes"
  * system_error_based                = "yes"
  * tags                              = ""
  * unidirection_link_detection       = "yes"
  * unknown                           = "yes"
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      arp_inspection                    = optional(string)
      bpdu_guard                        = optional(string)
      debug_1                           = optional(string)
      debug_2                           = optional(string)
      debug_3                           = optional(string)
      debug_4                           = optional(string)
      debug_5                           = optional(string)
      description                       = optional(string)
      dhcp_rate_limit                   = optional(string)
      ethernet_port_module              = optional(string)
      ip_address_conflict               = optional(string)
      ipqos_dcbxp_compatability_failure = optional(string)
      ipqos_manager_error               = optional(string)
      link_flap                         = optional(string)
      loopback                          = optional(string)
      loop_indication_by_mcp            = optional(string)
      port_security_violation           = optional(string)
      security_violation                = optional(string)
      set_port_state_failed             = optional(string)
      storm_control                     = optional(string)
      stp_inconsist_vpc_peerlink        = optional(string)
      system_error_based                = optional(string)
      tags                              = optional(string)
      unidirection_link_detection       = optional(string)
      unknown                           = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "edrErrDisRecoverPol"
 - Distinguished Named "uni/infra/edrErrDisRecoverPol-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Error Disabled Recovery Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_error_disable_recovery" "error_disabled_recovery_policy" {
  for_each            = local.error_disabled_recovery_policy
  annotation          = each.value.tags != "" ? each.value.tags : var.tags
  description         = each.value.description
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  name_alias          = each.value.alias
  edr_event {
    event   = "event-arp-inspection"
    recover = each.value.arp_inspection
  }
  edr_event {
    event   = "event-bpduguard"
    recover = each.value.bpdu_guard
  }
  edr_event {
    event   = "event-debug-1"
    recover = each.value.debug_1
  }
  edr_event {
    event   = "event-debug-2"
    recover = each.value.debug_2
  }
  edr_event {
    event   = "event-debug-3"
    recover = each.value.debug_3
  }
  edr_event {
    event   = "event-debug-4"
    recover = each.value.debug_4
  }
  edr_event {
    event   = "event-debug-5"
    recover = each.value.debug_5
  }
  edr_event {
    event   = "event-dhcp-rate-lim"
    recover = each.value.dhcp_rate_limit
  }
  edr_event {
    event   = "event-ep-move"
    recover = each.value.frequent_endpoint_move
  }
  edr_event {
    event   = "event-ethpm"
    recover = each.value.ethernet_port_module
  }
  edr_event {
    event   = "event-ip-addr-conflict"
    recover = each.value.ip_address_conflict
  }
  edr_event {
    event   = "event-ipqos-dcbxp-compat-failure"
    recover = each.value.ipqos_dcbxp_compatability_failure
  }
  edr_event {
    event   = "event-ipqos-mgr-error"
    recover = each.value.ipqos_manager_error
  }
  edr_event {
    event   = "event-link-flap"
    recover = each.value.link_flap
  }
  edr_event {
    event   = "event-loopback"
    recover = each.value.loopback
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = each.value.loop_indication_by_mcp
  }
  edr_event {
    event   = "event-psec-violation"
    recover = each.value.port_security_violation
  }
  edr_event {
    event   = "event-sec-violation"
    recover = each.value.security_violation
  }
  edr_event {
    event   = "event-set-port-state-failed"
    recover = each.value.set_port_state_failed
  }
  edr_event {
    event   = "event-storm-ctrl"
    recover = each.value.storm_control
  }
  edr_event {
    event   = "event-stp-inconsist-vpc-peerlink"
    recover = each.value.stp_inconsist_vpc_peerlink
  }
  edr_event {
    event   = "event-syserr-based"
    recover = each.value.system_error_based
  }
  edr_event {
    event   = "event-udld"
    recover = each.value.unidirection_link_detection
  }
  edr_event {
    event   = "unknown"
    recover = each.value.unknown
  }
}


/*_____________________________________________________________________________________________________________________

MCP Instance Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "mcp_instance_policy" {
  default = {
    "default" = {
      admin_state                       = "enabled"
      alias                             = ""
      description                       = ""
      tags                              = ""
      enable_mcp_pdu_per_vlan           = true
      initial_delay                     = "180"
      loop_detect_multiplication_factor = "3"
      loop_protect_action               = "yes"
      transmission_frequency_seconds    = "2"
      transmission_frequency_msec       = "0"
    }
  }
  description = <<-EOT
  Key: Name of the Layer2 Interface Policy.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * admin_state                       = "enabled"
  * tags                              = ""
  * enable_mcp_pdu_per_vlan           = true
  * initial_delay                     = "180"
  * loop_detect_multiplication_factor = "3"
  * loop_protect_action               = "yes"
  * transmission_frequency_seconds    = "2"
  * transmission_frequency_msec       = "0"
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      description                       = optional(string)
      admin_state                       = optional(string)
      tags                              = optional(string)
      enable_mcp_pdu_per_vlan           = bool
      initial_delay                     = optional(string)
      loop_detect_multiplication_factor = optional(string)
      loop_protect_action               = optional(string)
      transmission_frequency_seconds    = optional(string)
      transmission_frequency_msec       = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mcpInstPol"
 - Distinguished Named "uni/infra/mcpInstP-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy Default
_______________________________________________________________________________________________________________________
*/
resource "aci_mcp_instance_policy" "mcp_instance_policy" {
  for_each         = local.mcp_instance_policy
  admin_st         = each.value.admin_state
  annotation       = each.value.tags != "" ? each.value.tags : var.tags
  ctrl             = [each.value.controls]
  description      = each.value.description
  init_delay_time  = each.value.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = each.value.loop_detect_multiplication_factor
  loop_protect_act = each.value.loop_protect_action
  name_alias       = each.value.alias
  tx_freq          = each.value.transmission_frequency_seconds
  tx_freq_msec     = each.value.transmission_frequency_msec
}


/*_____________________________________________________________________________________________________________________

Global QoS Class Variables
_______________________________________________________________________________________________________________________
*/
variable "global_qos_class" {
  default = {
    "default" = {
      alias                             = ""
      description                       = ""
      elephant_trap_age_period          = "0"
      elephant_trap_bandwidth_threshold = "0"
      elephant_trap_byte_count          = "0"
      elephant_trap_state               = "no"
      fabric_flush_interval             = "500"
      fabric_flush_state                = "no"
      micro_burst_spine_queues          = "0"
      micro_burst_leaf_queues           = "0"
      preserve_cos                      = true
      tags                              = ""
    }
  }
  description = <<-EOT
  Key: Name of the Layer2 Interface Policy.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * qinq: (Default value is "disabled").  To enable or disable an interface for Dot1q Tunnel or Q-in-Q encapsulation modes, select one of the following:
    - corePort: Configure this core-switch interface to be included in a Dot1q Tunnel.  You can configure multiple corePorts, for multiple customers, to be used in a Dot1q Tunnel.
    - disabled: Disable this interface to be used in a Dot1q Tunnel.
    - doubleQtagPort: Configure this interface to be used for Q-in-Q encapsulated traffic.
    - edgePort: Configure this edge-switch interface (for a single customer) to be included in a Dot1q Tunnel.
  * reflective_relay: (Default value is "disabled").  Enable or disable reflective relay for ports that consume the policy.
  * vlan_scope: (Default value is "global").  The layer 2 interface VLAN scope. The scope can be:
    - global: Sets the VLAN encapsulation value to map only to a single EPG per leaf.
    - portlocal: Allows allocation of separate (Port, Vlan) translation entries in both ingress and egress directions. This configuration is not valid when the EPGs belong to a single bridge domain.
    VLAN Scope is not supported if edgePort is selected in the QinQ field.
    Note:  Changing the VLAN scope from Global to Port Local or Port Local to Global will cause the ports where this policy is applied to flap and traffic will be disrupted.
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      description                       = optional(string)
      elephant_trap_age_period          = optional(string)
      elephant_trap_bandwidth_threshold = optional(string)
      elephant_trap_byte_count          = optional(string)
      elephant_trap_state               = optional(string)
      fabric_flush_interval             = optional(string)
      fabric_flush_state                = optional(string)
      micro_burst_spine_queues          = optional(string)
      micro_burst_leaf_queues           = optional(string)
      preserve_cos                      = optional(bool)
      tags                              = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

*/
resource "aci_qos_instance_policy" "global_qos_class" {
  for_each              = local.global_qos_class
  annotation            = each.value.tags != "" ? each.value.tags : var.tags
  ctrl                  = each.value.control
  description           = each.value.description
  etrap_age_timer       = each.value.elephant_trap_age_period
  etrap_bw_thresh       = each.value.elephant_trap_bandwidth_threshold
  etrap_byte_ct         = each.value.elephant_trap_byte_count
  etrap_st              = each.value.elephant_trap_state
  fabric_flush_interval = each.value.fabric_flush_interval
  fabric_flush_st       = each.value.fabric_flush_state
  name_alias            = each.value.alias
  uburst_spine_queues   = each.value.micro_burst_spine_queues
  uburst_tor_queues     = each.value.micro_burst_leaf_queues
}