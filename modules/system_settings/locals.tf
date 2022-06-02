locals {
  #__________________________________________________________
  #
  # BGP Variables
  #__________________________________________________________

  bgp_route_reflectors_loop = flatten([
    for k, v in var.bgp_route_reflectors : [
      for s in v.node_list : {
        annotation = v.annotation != null ? v.annotation : ""
        node_id    = s
        pod_id     = k
      }
    ]
  ])

  bgp_route_reflectors = { for k, v in local.bgp_route_reflectors_loop : "${v.pod_id}_${v.node_id}" => v }

  #__________________________________________________________
  #
  # Endpoint Control Variables
  #__________________________________________________________

  ep_loop_protection_loop = flatten([
    for key, value in var.endpoint_controls : [
      for k, v in value.ep_loop_protection : {
        action = v.action != null ? [
          for s in v.action : {
            bd_learn_disable = s.bd_learn_disable != null ? s.bd_learn_disable : false
            port_disable     = s.port_disable != null ? s.port_disable : false
          }
          ] : [
          {
            bd_learn_disable = false
            port_disable     = false
          }
        ]
        administrative_state      = v.administrative_state != null ? v.administrative_state : "enabled"
        annotation                = value.annotation != null ? value.annotation : ""
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
        annotation           = value.annotation != null ? value.annotation : ""
        key1                 = key
      }
    ]
  ])

  ip_aging = { for k, v in local.ip_aging_loop : v.key1 => v }

  rouge_ep_control_loop = flatten([
    for key, value in var.endpoint_controls : [
      for k, v in value.rouge_ep_control : {
        administrative_state = v.administrative_state != null ? v.administrative_state : "enabled"
        annotation           = value.annotation != null ? value.annotation : ""
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
      annotation                        = v.annotation != null ? v.annotation : ""
      disable_remote_ep_learning        = v.disable_remote_ep_learning != null ? v.disable_remote_ep_learning : true
      enforce_domain_validation         = v.enforce_domain_validation != null ? v.enforce_domain_validation : true
      enforce_epg_vlan_validation       = v.enforce_epg_vlan_validation != null ? v.enforce_epg_vlan_validation : false
      enforce_subnet_check              = v.enforce_subnet_check != null ? v.enforce_subnet_check : true
      leaf_opflex_client_authentication = v.leaf_opflex_client_authentication != null ? v.leaf_opflex_client_authentication : true
      leaf_ssl_opflex                   = v.leaf_ssl_opflex != null ? v.leaf_ssl_opflex : true
      reallocate_gipo                   = v.reallocate_gipo != null ? v.reallocate_gipo : false
      restrict_infra_vlan_traffic       = v.restrict_infra_vlan_traffic != null ? v.restrict_infra_vlan_traffic : false
      ssl_opflex_versions = v.ssl_opflex_versions != null ? [
        for s in v.ssl_opflex_versions : {
          TLSv1   = s.TLSv1 != null ? s.TLSv1 : false
          TLSv1_1 = s.TLSv1_1 != null ? s.TLSv1_1 : false
          TLSv1_2 = s.TLSv1_2 != null ? s.TLSv1_2 : true
        }
        ] : [
        {
          TLSv1   = false
          TLSv1_1 = false
          TLSv1_2 = true
        }
      ]
      spine_opflex_client_authentication = v.spine_opflex_client_authentication != null ? v.spine_opflex_client_authentication : true
      spine_ssl_opflex                   = v.spine_ssl_opflex != null ? v.spine_ssl_opflex : true
    }
  }

  #__________________________________________________________
  #
  # Global AES Passphrase Variables
  #__________________________________________________________

  global_aes_encryption_settings = {
    for k, v in var.global_aes_encryption_settings : k => {
      clear_passphrase                  = v.clear_passphrase != null ? v.clear_passphrase : false
      enable_encryption                 = v.enable_encryption != null ? v.enable_encryption : true
      passphrase_key_derivation_version = v.passphrase_key_derivation_version != null ? v.passphrase_key_derivation_version : "v1"
    }
  }

  #__________________________________________________________
  #
  # ISIS Policy Variables
  #__________________________________________________________

  isis_policy = {
    for k, v in var.isis_policy : k => {
      annotation                                      = v.annotation != null ? v.annotation : ""
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
      annotation             = v.annotation != null ? v.annotation : ""
      delay_restore_timer    = v.delay_restore_timer != null ? v.delay_restore_timer : 120
      include_apic_ports     = v.include_apic_ports != null ? v.include_apic_ports : false
      number_of_active_ports = v.number_of_active_ports != null ? v.number_of_active_ports : 0
      port_tracking_state    = v.port_tracking_state != null ? v.port_tracking_state : "on"
    }
  }

}