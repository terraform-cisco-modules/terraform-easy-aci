/*_____________________________________________________________________________________________________________________

Error Disabled Recovery Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "global_error_disabled_recovery_policy" {
  default = {
    "default" = {
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
      error_disable_recovery_interval   = 300
      ethernet_port_module              = true
      frequent_endpoint_move            = true
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
  annotation - (Optional) Annotation of object Error Disable Recovery. Type String.
  name_alias - (Optional) Name Alias of object Error Disable Recovery. Type: String.
  description - (Optional) Description of object Error Disable Recovery. Type: String.
  err_dis_recov_intvl - (Optional) Error Disable Recovery Interval.Sets the error disable recovery interval, which specifies the time to recover from an error-disabled state. Allowed range is "30" - "65535". Type: String.
  edr_event - (Optional) To manage Error Disable Recovery Event from the Error Disable Recovery Policy resource.
  edr_event.event - (Required) Event of object Error Disabled Recovery. The error disable recovery event type. Allowed values are "event-arp-inspection", "event-bpduguard", "event-debug-1", "event-debug-2", "event-debug-3", "event-debug-4", "event-debug-5", "event-dhcp-rate-lim", "event-ep-move", "event-ethpm", "event-ip-addr-conflict", "event-ipqos-dcbxp-compat-failure", "event-ipqos-mgr-error", "event-link-flap", "event-loopback", "event-mcp-loop", "event-psec-violation", "event-sec-violation", "event-set-port-state-failed", "event-storm-ctrl", "event-stp-inconsist-vpc-peerlink", "event-syserr-based", "event-udld", "unknown". Type: String.
  edr_event.recover - (Optional) Enables or disables Error Disable Recovery. Allowed values are "no", "yes". Type: String.
  edr_event.name - (Optional) Name of object Error Disable Recovery Event. Type: String.
  edr_event.name_alias - (Optional) Name Alias of object Error Disable Recovery Event. Type: String.
  edr_event.description - (Optional) Description of object Error Disable Recovery Event. Type: String.
  edr_event.annotation - (Optional) Annotation of object Error Disable Recovery Event. Type String.
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
      error_disable_recovery_interval   = optional(number)
      frequent_endpoint_move            = optional(bool)
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
resource "aci_error_disable_recovery" "global_error_disabled_recovery_policy" {
  for_each            = local.global_error_disabled_recovery_policy
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  description         = each.value.description
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
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
