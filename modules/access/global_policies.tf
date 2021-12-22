#------------------------------------------
# Create Attachable Access Entity Profiles
#------------------------------------------

/*
API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}
*/
resource "aci_attachable_access_entity_profile" "aaep_policies" {
  depends_on = [
    aci_l3_domain_profile.layer3_domains,
    aci_physical_domain.physical_domains,
    aci_vmm_domain.vmm_domains
  ]
  for_each    = local.aaep_policies
  description = each.value.description
  name        = each.key
  relation_infra_rs_dom_p = [each.value.domains]
}

/*
API Information:
 - Class: "edrErrDisRecoverPol"
 - Distinguished Named "uni/infra/edrErrDisRecoverPol-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Error Disabled Recovery Policy
*/
resource "aci_error_disable_recovery" "error_disabled_recovery_policy" {
  for_each = local.error_disable_recovery_policy
  annotation          = each.value.tags
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  name_alias          = each.value.alias
  description         = each.value.description
  edr_event {
    event             = "event-arp-inspection"
    recover           = each.value.arp_inspection
  }
  edr_event {
    event             = "event-bpduguard"
    recover           = each.value.bpdu_guard
  }
  edr_event {
    event             = "event-debug-1"
    recover           = each.value.debug_1
  }
  edr_event {
    event             = "event-debug-2"
    recover           = each.value.debug_2
  }
  edr_event {
    event             = "event-debug-3"
    recover           = each.value.debug_3
  }
  edr_event {
    event             = "event-debug-4"
    recover           = each.value.debug_4
  }
  edr_event {
    event             = "event-debug-5"
    recover           = each.value.debug_5
  }
  edr_event {
    event             = "event-dhcp-rate-lim"
    recover           = each.value.dhcp_rate_limit
  }
  edr_event {
    event             = "event-ep-move"
    recover           = each.value.frequent_endpoint_move
  }
  edr_event {
    event             = "event-ethpm"
    recover           = each.value.ethpm
  }
  edr_event {
    event             = "event-ip-addr-conflict"
    recover           = each.value.ip_address_conflict
  }
  edr_event {
    event             = "event-ipqos-dcbxp-compat-failure"
    recover           = each.value.ipqos_dcbxp_compatability_failure
  }
  edr_event {
    event             = "event-ipqos-mgr-error"
    recover           = each.value.ipqos_manager_error
  }
  edr_event {
    event             = "event-link-flap"
    recover           = each.value.link_flap
  }
  edr_event {
    event             = "event-loopback"
    recover           = each.value.loopback
  }
  edr_event {
    event             = "event-mcp-loop"
    recover           = each.value.loop_indication_by_mcp
  }
  edr_event {
    event             = "event-psec-violation"
    recover           = each.value.port_security_violation
  }
  edr_event {
    event             = "event-sec-violation"
    recover           = each.value.security_violation
  }
  edr_event {
    event             = "event-set-port-state-failed"
    recover           = each.value.set_port_state_failed
  }
  edr_event {
    event             = "event-storm-ctrl"
    recover           = each.value.storm_control
  }
  edr_event {
    event             = "event-stp-inconsist-vpc-peerlink"
    recover           = each.value.stp_inconsist_vpc_peerlink
  }
  edr_event {
    event             = "event-syserr-based"
    recover           = each.value.system_error_based
  }
  edr_event {
    event             = "event-udld"
    recover           = each.value.unidirection_link_detection
  }
  edr_event {
    event             = "unknown"
    recover           = each.value.unknown
  }
}

/*
- This Resource File will create Recommended Default Policies Based on the Best Practice Wizard and additional Best Practices
*/

/*
API Information:
 - Class: "mcpInstPol"
 - Distinguished Named "uni/infra/mcpInstP-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy Default
*/
resource "aci_mcp_instance_policy" "mcp_instance_policy" {
  for_each = local.mcp_instance_policy
  admin_st         = each.value.admin_state
  annotation       = each.value.tags
  name_alias       = each.value.alias
  description      = each.value.description
  ctrl             = [each.value.controls]
  init_delay_time  = each.value.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = each.value.loop_detect_multiplication_factor
  loop_protect_act = each.value.loop_protect_action
  tx_freq          = each.value.transmission_frequency_seconds
  tx_freq_msec     = each.value.transmission_frequency_msec
}


/*
API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

*/
resource "aci_qos_instance_policy" "global_qos_class" {
  for_each = local.global_qos_class
  annotation            = each.value.tags
  name_alias            = each.value.alias
  description           = each.value.description
  etrap_age_timer       = each.value.elephant_trap_age_period
  etrap_bw_thresh       = each.value.elephant_trap_bandwidth_threshold
  etrap_byte_ct         = each.value.elephant_trap_byte_count
  etrap_st              = each.value.elephant_trap_state
  fabric_flush_interval = each.value.fabric_flush_interval
  fabric_flush_st       = each.value.fabric_flush_state
  ctrl                  = [each.value.preserve_cos]
  uburst_spine_queues   = each.value.micro_burst_spine_queues
  uburst_tor_queues     = each.value.micro_burst_leaf_queues
}