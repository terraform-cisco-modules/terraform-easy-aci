/*_____________________________________________________________________________________________________________________

Global — Error Disabled Recovery Policy — Variables
_______________________________________________________________________________________________________________________
*/
variable "global_error_disabled_recovery_policy" {
  default = {
    "default" = {
      annotation                      = ""
      error_disable_recovery_interval = 300
      events = [
        {
          bpdu_guard                        = true
          debug_1                           = false
          debug_2                           = false
          debug_3                           = false
          debug_4                           = false
          debug_5                           = false
          dhcp_rate_limit                   = false
          ethernet_port_module              = false
          frequent_endpoint_move            = true
          ip_address_conflict               = false
          ipqos_dcbxp_compatability_failure = false
          ipqos_manager_error               = false
          link_flap                         = false
          loopback                          = false
          loop_indication_by_mcp            = true
          port_security_violation           = false
          security_violation                = false
          set_port_state_failed             = false
          storm_control                     = false
          stp_inconsist_vpc_peerlink        = false
          system_error_based                = false
          unidirection_link_detection       = false
          unknown                           = false
        }
      ]
    }
  }
  description = <<-EOT
    Key — This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * error_disable_recovery_interval: (default: 300) — Sets the error disable recovery interval, which specifies the time to recover from an error-disabled state. The interval range is from 30 seconds to 65535 seconds.
    * events: (optional) — Indicates whether an Error Disable Recovery type is enabled (true or false).
      - bpdu_guard: (default: true) — Flag to enable or disable recovery for a BPDU Guard event.
      - debug_1: (default: false) — Flag to enable or disable recovery for a Debug 1 event.
      - debug_2: (default: false) — Flag to enable or disable recovery for a Debug 2 event.
      - debug_3: (default: false) — Flag to enable or disable recovery for a Debug 3 event.
      - debug_4: (default: false) — Flag to enable or disable recovery for a Debug 4 event.
      - debug_5: (default: false) — Flag to enable or disable recovery for a Debug 5 event.
      - dhcp_rate_limit: (default: false) — Flag to enable or disable recovery for a DHCP Rate Limit event.
      - ethernet_port_module: (default: false) — Flag to enable or disable recovery for an Ethernet Port Module event.
      - frequent_endpoint_move: (default: true) — Flag to enable or disable recovery for a Frequent Endpoint Move event.
      - ip_address_conflict: (default: false) — Flag to enable or disable recovery for an IP Address Conflict event.
      - ipqos_dcbxp_compatability_failure: (default: false) — Flag to enable or disable recovery for an IP QoS DCBXP Compatibility Failure event.
      - ipqos_manager_error: (default: false) — Flag to enable or disable recovery for an IP QoS Manager Error event.
      - link_flap: (default: false) — Flag to enable or disable recovery for a Link Flap event.
      - loopback: (default: false) — Flag to enable or disable recovery for a Loopback event.
      - loop_indication_by_mcp: (default: true) — Flag to enable or disable recovery for a Loop Indication by MCP event.
      - port_security_violation: (default: false) — Flag to enable or disable recovery for a Port Security Violation event.
      - security_violation: (default: false) — Flag to enable or disable recovery for a Security Violation event.
      - set_port_state_failed: (default: false) — Flag to enable or disable recovery for a Set Port State Failed event.
      - storm_control: (default: false)— Flag to enable or disable recovery for a Storm Control event.
      - stp_inconsist_vpc_peerlink: (default: false) — Flag to enable or disable recovery for an STP Inconsistent VPC Peerlink event.
      - system_error_based: (default: false) — Flag to enable or disable recovery for a System Error Based event.
      - unidirection_link_detection: (default: false) — Flag to enable or disable recovery for a Unidirectional Link Detection event.
      - unknown: (default: false) — Flag to enable or disable recovery for an Unknown event.
  EOT
  type = map(object(
    {
      annotation                      = optional(string)
      description                     = optional(string)
      error_disable_recovery_interval = optional(number)
      events = optional(list(object(
        {
          bpdu_guard                        = optional(bool)
          debug_1                           = optional(bool)
          debug_2                           = optional(bool)
          debug_3                           = optional(bool)
          debug_4                           = optional(bool)
          debug_5                           = optional(bool)
          dhcp_rate_limit                   = optional(bool)
          ethernet_port_module              = optional(bool)
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
      )))
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
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  edr_event {
    event   = "event-bpduguard"
    recover = each.value.events[0].bpdu_guard == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-1"
    recover = each.value.events[0].debug_1 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-2"
    recover = each.value.events[0].debug_2 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-3"
    recover = each.value.events[0].debug_3 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-4"
    recover = each.value.events[0].debug_4 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-debug-5"
    recover = each.value.events[0].debug_5 == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-dhcp-rate-lim"
    recover = each.value.events[0].dhcp_rate_limit == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ep-move"
    recover = each.value.events[0].frequent_endpoint_move == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ethpm"
    recover = each.value.events[0].ethernet_port_module == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ip-addr-conflict"
    recover = each.value.events[0].ip_address_conflict == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ipqos-dcbxp-compat-failure"
    recover = each.value.events[0].ipqos_dcbxp_compatability_failure == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ipqos-mgr-error"
    recover = each.value.events[0].ipqos_manager_error == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-link-flap"
    recover = each.value.events[0].link_flap == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-loopback"
    recover = each.value.events[0].loopback == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = each.value.events[0].loop_indication_by_mcp == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-psec-violation"
    recover = each.value.events[0].port_security_violation == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-sec-violation"
    recover = each.value.events[0].security_violation == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-set-port-state-failed"
    recover = each.value.events[0].set_port_state_failed == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-storm-ctrl"
    recover = each.value.events[0].storm_control == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-stp-inconsist-vpc-peerlink"
    recover = each.value.events[0].stp_inconsist_vpc_peerlink == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-syserr-based"
    recover = each.value.events[0].system_error_based == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-udld"
    recover = each.value.events[0].unidirection_link_detection == true ? "yes" : "no"
  }
  edr_event {
    event   = "unknown"
    recover = each.value.events[0].unknown == true ? "yes" : "no"
  }
}
