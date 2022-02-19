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
  annotation              = each.value.annotation != "" ? each.value.annotation : var.annotation
  description             = each.value.description
  name                    = each.key
  relation_infra_rs_dom_p = each.value.domains
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{AAEP}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {AAEP}
_______________________________________________________________________________________________________________________
*/
resource "aci_access_generic" "access_generic" {
  depends_on = [
    aci_attachable_access_entity_profile.aaep_policies
  ]
  for_each                            = local.aaep_policies
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.aaep_policies[each.key].id
  name                                = "default"
}


/*_____________________________________________________________________________________________________________________

Error Disabled Recovery Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "error_disabled_recovery_policy" {
  default = {
    "default" = {
      alias                             = ""
      annotation                        = ""
      arp_inspection                    = true
      bpdu_guard                        = true
      debug_1                           = true
      debug_2                           = true
      debug_3                           = true
      debug_4                           = true
      debug_5                           = true
      description                       = ""
      dhcp_rate_limit                   = true
      ethernet_port_module              = true
      ip_address_conflict               = true
      ipqos_dcbxp_compatability_failure = true
      ipqos_manager_error               = true
      link_flap                         = true
      loopback                          = true
      loop_indication_by_mcp            = true
      port_security_violation           = true
      security_violation                = true
      set_port_state_failed             = true
      storm_control                     = true
      stp_inconsist_vpc_peerlink        = true
      system_error_based                = true
      unidirection_link_detection       = true
      unknown                           = true
    }
  }
  description = <<-EOT
  Key: Unique Identifier for the Map of Objects.  Not used in assignment.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation                              = ""
  * arp_inspection                    = true
  * bpdu_guard                        = true
  * debug_1                           = true
  * debug_2                           = true
  * debug_3                           = true
  * debug_4                           = true
  * debug_5                           = true
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * dhcp_rate_limit                   = true
  * ethernet_port_module              = true
  * ip_address_conflict               = true
  * ipqos_dcbxp_compatability_failure = true
  * ipqos_manager_error               = true
  * link_flap                         = true
  * loopback                          = true
  * loop_indication_by_mcp            = true
  * port_security_violation           = true
  * security_violation                = true
  * set_port_state_failed             = true
  * storm_control                     = true
  * stp_inconsist_vpc_peerlink        = true
  * system_error_based                = true
  * unidirection_link_detection       = true
  * unknown                           = true
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      annotation                        = optional(string)
      arp_inspection                    = optional(bool)
      bpdu_guard                        = optional(bool)
      debug_1                           = optional(bool)
      debug_2                           = optional(bool)
      debug_3                           = optional(bool)
      debug_4                           = optional(bool)
      debug_5                           = optional(bool)
      description                       = optional(string)
      dhcp_rate_limit                   = optional(bool)
      ethernet_port_module              = optional(bool)
      ip_address_conflict               = optional(bool)
      ipqos_dcbxp_compatability_failure = optional(bool)
      ipqos_manager_error               = optional(bool)
      link_flap                         = optional(bool)
      loopback                          = optional(bool)
      loop_indication_by_mcp            = optional(bool)
      port_security_violation           = optional(bool)
      security_violation                = optional(bool)
      set_port_state_failed             = optional(bool)
      storm_control                     = optional(bool)
      stp_inconsist_vpc_peerlink        = optional(bool)
      system_error_based                = optional(bool)
      unidirection_link_detection       = optional(bool)
      unknown                           = optional(bool)
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
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  description         = each.value.description
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  name_alias          = each.value.alias
  edr_event {
    event   = "event-arp-inspection"
    recover = each.value.arp_inspection == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-bpduguard"
    recover = each.value.bpdu_guard == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-1"
    recover = each.value.debug_1 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-2"
    recover = each.value.debug_2 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-3"
    recover = each.value.debug_3 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-4"
    recover = each.value.debug_4 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-5"
    recover = each.value.debug_5 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-dhcp-rate-lim"
    recover = each.value.dhcp_rate_limit == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ep-move"
    recover = each.value.frequent_endpoint_move == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ethpm"
    recover = each.value.ethernet_port_module == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ip-addr-conflict"
    recover = each.value.ip_address_conflict == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ipqos-dcbxp-compat-failure"
    recover = each.value.ipqos_dcbxp_compatability_failure == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ipqos-mgr-error"
    recover = each.value.ipqos_manager_error == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-link-flap"
    recover = each.value.link_flap == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-loopback"
    recover = each.value.loopback == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = each.value.loop_indication_by_mcp == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-psec-violation"
    recover = each.value.port_security_violation == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-sec-violation"
    recover = each.value.security_violation == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-set-port-state-failed"
    recover = each.value.set_port_state_failed == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-storm-ctrl"
    recover = each.value.storm_control == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-stp-inconsist-vpc-peerlink"
    recover = each.value.stp_inconsist_vpc_peerlink == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-syserr-based"
    recover = each.value.system_error_based == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-udld"
    recover = each.value.unidirection_link_detection == true ? "yes" : "no"
  }
  edr_event {
    event   = "unknown"
    recover = each.value.unknown == true ? "yes" : "no"
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
      annotation                        = ""
      enable_mcp_pdu_per_vlan           = true
      initial_delay                     = 180
      loop_detect_multiplication_factor = 3
      loop_protect_action               = true
      transmission_frequency_seconds    = 2
      transmission_frequency_msec       = 0
    }
  }
  description = <<-EOT
  Key: Name of the Layer2 Interface Policy.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * admin_state                       = "enabled"
  * annotation                              = ""
  * enable_mcp_pdu_per_vlan           = true
  * initial_delay                     = 180
  * loop_detect_multiplication_factor = 3
  * loop_protection_disable_port               = true
  * transmission_frequency_seconds    = 2
  * transmission_frequency_msec       = 0
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      description                       = optional(string)
      admin_state                       = optional(string)
      annotation                        = optional(string)
      enable_mcp_pdu_per_vlan           = bool
      initial_delay                     = optional(number)
      loop_detect_multiplication_factor = optional(number)
      loop_protection_disable_port      = optional(bool)
      transmission_frequency_seconds    = optional(number)
      transmission_frequency_msec       = optional(number)
    }
  ))
}

variable "mcp_instance_key" {
  description = "The key or password to uniquely identify the MCP packets within this fabric."
  sensitive   = true
  type        = string
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
  annotation       = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl             = [each.value.controls]
  description      = each.value.description
  init_delay_time  = each.value.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = each.value.loop_detect_multiplication_factor
  loop_protect_act = each.value.loop_protection_disable_port == true ? "yes" : "no"
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
      elephant_trap_age_period          = 0
      elephant_trap_bandwidth_threshold = 0
      elephant_trap_byte_count          = 0
      elephant_trap_state               = false
      fabric_flush_interval             = 500
      fabric_flush_state                = false
      micro_burst_spine_queues          = 0
      micro_burst_leaf_queues           = 0
      preserve_cos                      = true
      annotation                        = ""
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
      elephant_trap_age_period          = optional(number)
      elephant_trap_bandwidth_threshold = optional(number)
      elephant_trap_byte_count          = optional(number)
      elephant_trap_state               = optional(bool)
      fabric_flush_interval             = optional(number)
      fabric_flush_state                = optional(bool)
      micro_burst_spine_queues          = optional(string)
      micro_burst_leaf_queues           = optional(string)
      preserve_cos                      = optional(bool)
      annotation                        = optional(string)
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
  annotation            = each.value.annotation != "" ? each.value.annotation : var.annotation
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