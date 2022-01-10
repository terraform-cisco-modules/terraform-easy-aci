locals {
  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  bgp_route_reflectors = {
    for k, v in var.bgp_route_reflectors : k => {
      node_id = v.node_id != null ? v.node_id : 101
      pod_id  = v.pod_id != null ? v.pod_id : 1
    }
  }

  #__________________________________________________________
  #
  # Endpoint Control Variables
  #__________________________________________________________

  ep_loop_protection_loop = flatten([
    for key, value in var.endpoint_controls : [
      for k, v in value.ep_loop_protection : {
        action = alltrue(
          [v.action[0]["bd_learn_disable"], v.action[0]["port_disable"]]
          ) ? "bd-learn-disable,port-disable" : anytrue(
          [v.action[0]["bd_learn_disable"], v.action[0]["port_disable"]]
          ) ? trim(join(",", compact(concat(
            [length(regexall(true, v.action[0]["bd_learn_disable"])) > 0 ? "bd-learn-disable" : ""
            ], [length(regexall(true, v.action[0]["port_disable"])) > 0 ? "port-disable" : ""]
          ))), ","
        ) : ""
        administrative_state      = v.administrative_state != null ? v.administrative_state : "enabled"
        key1                      = key
        loop_detection_interval   = v.loop_detection_interval != null ? v.loop_detection_interval : 60
        loop_detection_multiplier = v.loop_detection_multiplier != null ? v.loop_detection_multiplier : 4
      }
    ]
  ])

  ep_loop_protection = { for k, v in local.ep_loop_protection_loop : v.key1 => v }

  ip_aging_loop = flatten([
    for key, value in var.endpoint_controls : [
      for k, v in value.ip_aging : {
        administrative_state = v.administrative_state != null ? v.administrative_state : "enabled"
        key1                 = key
      }
    ]
  ])

  ip_aging = { for k, v in local.ip_aging_loop : v.key1 => v }

  rouge_ep_control_loop = flatten([
    for key, value in var.endpoint_controls : [
      for k, v in value.rouge_ep_control : {
        administrative_state = v.administrative_state != null ? v.administrative_state : "enabled"
        key1                 = key
        hold_interval        = v.hold_interval != null ? v.hold_interval : 1800
        rouge_interval       = v.rouge_interval != null ? v.rouge_interval : 30
        rouge_multiplier     = v.rouge_multiplier != null ? v.rouge_multiplier : 6
      }
    ]
  ])

  rouge_ep_control = { for k, v in local.rouge_ep_control_loop : v.key1 => v }


  #__________________________________________________________
  #
  # Fabric Wide Settings Variables
  #__________________________________________________________

  fabric_wide_settings = {
    for k, v in var.fabric_wide_settings : k => {
      disable_remote_ep_learning         = v.disable_remote_ep_learning != null ? v.disable_remote_ep_learning : "yes"
      enforce_domain_validation          = v.enforce_domain_validation != null ? v.enforce_domain_validation : "yes"
      enforce_epg_vlan_validation        = v.enforce_epg_vlan_validation != null ? v.enforce_epg_vlan_validation : "no"
      enforce_subnet_check               = v.enforce_subnet_check != null ? v.enforce_subnet_check : "yes"
      leaf_opflex_client_authentication  = v.leaf_opflex_client_authentication != null ? v.leaf_opflex_client_authentication : "yes"
      leaf_ssl_opflex                    = v.leaf_ssl_opflex != null ? v.leaf_ssl_opflex : "yes"
      reallocate_gipo                    = v.reallocate_gipo != null ? v.reallocate_gipo : "no"
      restrict_infra_vlan_traffic        = v.restrict_infra_vlan_traffic != null ? v.restrict_infra_vlan_traffic : "no"
      ssl_opflex_version1_0              = v.ssl_opflex_versions[0].TLSv1
      ssl_opflex_version1_1              = v.ssl_opflex_versions[0].TLSv1_1
      ssl_opflex_version1_2              = v.ssl_opflex_versions[0].TLSv1_2
      spine_opflex_client_authentication = v.spine_opflex_client_authentication != null ? v.spine_opflex_client_authentication : "yes"
      spine_ssl_opflex                   = v.spine_ssl_opflex != null ? v.spine_ssl_opflex : "yes"
    }
  }

  #__________________________________________________________
  #
  # Global AES Passphrase Variables
  #__________________________________________________________

  aes_encryption_settings = {
    for k, v in var.aes_encryption_settings : k => {
      clear_passphrase                  = v.clear_passphrase != null ? v.clear_passphrase : "no"
      enable_encryption                 = v.enable_encryption != null ? v.enable_encryption : "yes"
      passphrase_key_derivation_version = v.passphrase_key_derivation_version != null ? v.passphrase_key_derivation_version : "v1"
    }
  }

  #__________________________________________________________
  #
  # ISIS Policy Variables
  #__________________________________________________________

  isis_policy = {
    for k, v in var.isis_policy : k => {
      isis_mtu                                        = v.isis_mtu != null ? v.isis_mtu : 1492
      isis_metric_for_redistributed_routes            = v.isis_metric_for_redistributed_routes != null ? v.isis_metric_for_redistributed_routes : 63
      lsp_fast_flood_mode                             = v.lsp_fast_flood_mode != null ? v.lsp_fast_flood_mode : "enabled"
      lsp_generation_initial_wait_interval            = v.lsp_generation_initial_wait_interval != null ? v.lsp_generation_initial_wait_interval : 50
      lsp_generation_maximum_wait_interval            = v.lsp_generation_maximum_wait_interval != null ? v.lsp_generation_maximum_wait_interval : 8000
      lsp_generation_second_wait_interval             = v.lsp_generation_second_wait_interval != null ? v.lsp_generation_second_wait_interval : 50
      sfp_computation_frequency_initial_wait_interval = v.sfp_computation_frequency_initial_wait_interval != null ? v.sfp_computation_frequency_initial_wait_interval : 50
      sfp_computation_frequency_maximum_wait_interval = v.sfp_computation_frequency_maximum_wait_interval != null ? v.sfp_computation_frequency_maximum_wait_interval : 50
      sfp_computation_frequency_second_wait_interval  = v.sfp_computation_frequency_second_wait_interval != null ? v.sfp_computation_frequency_second_wait_interval : 50
    }
  }

  #__________________________________________________________
  #
  # Port Tracking Variables
  #__________________________________________________________

  port_tracking = {
    for k, v in var.port_tracking : k => {
      delay_restore_timer    = v.delay_restore_timer != null ? v.delay_restore_timer : 120
      include_apic_ports     = v.include_apic_ports != null ? v.include_apic_ports : "no"
      number_of_active_ports = v.number_of_active_ports != null ? v.number_of_active_ports : 0
      port_tracking_state    = v.port_tracking_state != null ? v.port_tracking_state : "on"
      tags                   = v.tags != null ? v.tags : ""
    }
  }

}