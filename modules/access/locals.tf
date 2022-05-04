locals {
  #__________________________________________________________
  #
  # Domain Variables
  #__________________________________________________________

  layer3_domains = {
    for k, v in var.layer3_domains : k => {
      annotation = v.annotation != null ? v.annotation : ""
      name_alias = v.name_alias != null ? v.name_alias : ""
      vlan_pool  = v.vlan_pool
    }
  }

  physical_domains = {
    for k, v in var.physical_domains : k => {
      annotation = v.annotation != null ? v.annotation : ""
      name_alias = v.name_alias != null ? v.name_alias : ""
      vlan_pool  = v.vlan_pool
    }
  }

  #__________________________________________________________
  #
  # Firmware Management Variables
  #__________________________________________________________

  firmware = {
    for k, v in var.firmware : k => {
      annotation             = v.annotation != null ? v.annotation : ""
      compatibility_check    = v.compatibility_check != null ? v.compatibility_check : false
      description            = v.description != null ? v.description : ""
      policy_type            = v.policy_type != null ? v.policy_type : "switch"
      graceful_upgrade       = v.graceful_upgrade != null ? v.graceful_upgrade : false
      maintenance_groups     = v.maintenance_groups
      notify_conditions      = v.notify_conditions != null ? v.notify_conditions : "notifyOnlyOnFailures"
      run_mode               = v.run_mode != null ? v.run_mode : "pauseOnlyOnFailures"
      simulator              = v.simulator != null ? v.simulator : false
      version                = v.version != null ? v.version : "5.2(3g)"
      version_check_override = v.version_check_override != null ? v.version_check_override : false
    }
  }

  maintenance_groups_loop = flatten([
    for k, v in local.firmware : [
      for key, value in v.maintenance_groups : {
        annotation             = v.annotation
        compatibility_check    = v.compatibility_check
        description            = v.description
        policy_type            = v.policy_type
        graceful_upgrade       = v.graceful_upgrade
        name                   = value.name
        nodes                  = value.nodes != null ? value.nodes : [101, 201]
        notify_conditions      = v.notify_conditions
        simulator              = v.simulator
        start_now              = value.start_now != null ? value.start_now : false
        run_mode               = v.run_mode
        version                = v.version
        version_check_override = v.version_check_override
      }
    ]
  ])

  maintenance_groups = { for k, v in local.maintenance_groups_loop : v.name => v }

  maintenance_group_nodes_loop = flatten([
    for k, v in local.maintenance_groups : [
      for s in v.nodes : {
        name    = v.name
        node_id = s
      }
    ]
  ])

  maintenance_group_nodes = { for k, v in local.maintenance_group_nodes_loop : "${v.name}_${v.node_id}" => v }

  #__________________________________________________________
  #
  # Global Policies Variables
  #__________________________________________________________

  aaep_policies_loop_1 = {
    for k, v in var.aaep_policies : k => {
      annotation       = v.annotation != null ? v.annotation : ""
      description      = v.description != null ? v.description : ""
      layer3_domains   = v.layer3_domains != null ? v.layer3_domains : []
      name_alias       = v.name_alias != null ? v.name_alias : ""
      physical_domains = v.physical_domains != null ? v.physical_domains : []
      vmm_domains      = v.vmm_domains != null ? v.vmm_domains : []
    }
  }

  aaep_policies_loop_2 = {
    for k, v in local.aaep_policies_loop_1 : k => {
      name_alias  = v.name_alias != null ? v.name_alias : ""
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      layer3_domains = length(v.layer3_domains
      ) > 0 ? [for s in v.layer3_domains : aci_l3_domain_profile.layer3_domains["${s}"].id] : []
      physical_domains = length(v.physical_domains
      ) > 0 ? [for s in v.physical_domains : aci_physical_domain.physical_domains["${s}"].id] : []
      vmm_domains = length(v.vmm_domains
      ) > 0 ? [for s in v.vmm_domains : aci_vmm_domain.vmm_domains["${s}"].id] : []
    }
  }

  aaep_policies = {
    for k, v in local.aaep_policies_loop_2 : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      domains     = compact(concat(v.layer3_domains, v.physical_domains, v.vmm_domains))
      name_alias  = v.name_alias != null ? v.name_alias : ""
    }
  }


  error_disabled_recovery_policy = {
    for k, v in var.error_disabled_recovery_policy : k => {
      annotation                        = v.annotation != null ? v.annotation : ""
      description                       = v.description != null ? v.description : ""
      arp_inspection                    = v.arp_inspection != null ? v.arp_inspection : true
      bpdu_guard                        = v.bpdu_guard != null ? v.bpdu_guard : true
      debug_1                           = v.debug_1 != null ? v.debug_1 : true
      debug_2                           = v.debug_2 != null ? v.debug_2 : true
      debug_3                           = v.debug_3 != null ? v.debug_3 : true
      debug_4                           = v.debug_4 != null ? v.debug_4 : true
      debug_5                           = v.debug_5 != null ? v.debug_5 : true
      dhcp_rate_limit                   = v.dhcp_rate_limit != null ? v.dhcp_rate_limit : true
      ethernet_port_module              = v.ethernet_port_module != null ? v.ethernet_port_module : true
      ip_address_conflict               = v.ip_address_conflict != null ? v.ip_address_conflict : true
      ipqos_dcbxp_compatability_failure = v.ipqos_dcbxp_compatability_failure != null ? v.ipqos_dcbxp_compatability_failure : true
      ipqos_manager_error               = v.ipqos_manager_error != null ? v.ipqos_manager_error : true
      link_flap                         = v.link_flap != null ? v.link_flap : true
      loopback                          = v.loopback != null ? v.loopback : true
      loop_indication_by_mcp            = v.loop_indication_by_mcp != null ? v.loop_indication_by_mcp : true
      name_alias                        = v.name_alias != null ? v.name_alias : ""
      port_security_violation           = v.port_security_violation != null ? v.port_security_violation : true
      security_violation                = v.security_violation != null ? v.security_violation : true
      set_port_state_failed             = v.set_port_state_failed != null ? v.set_port_state_failed : true
      storm_control                     = v.storm_control != null ? v.storm_control : true
      stp_inconsist_vpc_peerlink        = v.stp_inconsist_vpc_peerlink != null ? v.stp_inconsist_vpc_peerlink : true
      system_error_based                = v.system_error_based != null ? v.system_error_based : true
      unidirection_link_detection       = v.unidirection_link_detection != null ? v.unidirection_link_detection : true
      unknown                           = v.unknown != null ? v.unknown : true
    }
  }


  mcp_instance_policy = {
    for k, v in var.mcp_instance_policy : k => {
      admin_state                       = v.admin_state != null ? v.admin_state : "enabled"
      annotation                        = v.annotation != null ? v.annotation : ""
      description                       = v.description != null ? v.description : ""
      annotation                        = v.annotation != null ? v.annotation : ""
      controls                          = v.enable_mcp_pdu_per_vlan == true ? ["pdu-per-vlan", "stateful-ha"] : ["stateful-ha"]
      initial_delay                     = v.initial_delay != null ? v.initial_delay : 180
      loop_detect_multiplication_factor = v.loop_detect_multiplication_factor != null ? v.loop_detect_multiplication_factor : 3
      loop_protection_disable_port      = v.loop_protection_disable_port != null ? v.loop_protection_disable_port : true
      name_alias                        = v.name_alias != null ? v.name_alias : ""
      transmission_frequency_seconds    = v.transmission_frequency_seconds != null ? v.transmission_frequency_seconds : 2
      transmission_frequency_msec       = v.transmission_frequency_msec != null ? v.transmission_frequency_msec : 0
    }
  }


  global_qos_class = {
    for k, v in var.global_qos_class : k => {
      annotation                        = v.annotation != null ? v.annotation : ""
      control                           = v.preserve_cos == false ? ["none"] : ["dot1p-preserve"]
      description                       = v.description != null ? v.description : ""
      elephant_trap_age_period          = v.elephant_trap_age_period != null ? v.elephant_trap_age_period : 0
      elephant_trap_bandwidth_threshold = v.elephant_trap_bandwidth_threshold != null ? v.elephant_trap_bandwidth_threshold : 0
      elephant_trap_byte_count          = v.elephant_trap_byte_count != null ? v.elephant_trap_byte_count : 0
      elephant_trap_state               = v.elephant_trap_state != null ? v.elephant_trap_state : false
      fabric_flush_interval             = v.fabric_flush_interval != null ? v.fabric_flush_interval : 500
      fabric_flush_state                = v.fabric_flush_state != null ? v.fabric_flush_state : false
      micro_burst_spine_queues          = v.micro_burst_spine_queues != null ? v.micro_burst_spine_queues : 0
      micro_burst_leaf_queues           = v.micro_burst_leaf_queues != null ? v.micro_burst_leaf_queues : 0
      name_alias                        = v.name_alias != null ? v.name_alias : ""
    }
  }


  #__________________________________________________________
  #
  # Interface Policies Variables
  #__________________________________________________________

  cdp_interface_policies = {
    for k, v in var.cdp_interface_policies : k => {
      admin_state = v.admin_state != null ? v.admin_state : "enabled"
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
    }
  }


  fc_interface_policies = {
    for k, v in var.fc_interface_policies : k => {
      auto_max_speed        = v.auto_max_speed != null ? v.auto_max_speed : "32G"
      annotation            = v.annotation != null ? v.annotation : ""
      description           = v.description != null ? v.description : ""
      fill_pattern          = v.fill_pattern != null ? v.fill_pattern : "ARBFF"
      name_alias            = v.name_alias != null ? v.name_alias : ""
      port_mode             = v.port_mode != null ? v.port_mode : "f"
      receive_buffer_credit = v.receive_buffer_credit != null ? v.receive_buffer_credit : 64
      speed                 = v.speed != null ? v.speed : "auto"
      trunk_mode            = v.trunk_mode != null ? v.trunk_mode : "trunk-off"
    }
  }


  l2_interface_policies = {
    for k, v in var.l2_interface_policies : k => {
      annotation       = v.annotation != null ? v.annotation : ""
      description      = v.description != null ? v.description : ""
      name_alias       = v.name_alias != null ? v.name_alias : ""
      qinq             = v.qinq != null ? v.qinq : "disabled"
      reflective_relay = v.reflective_relay != null ? v.reflective_relay : "disabled"
      vlan_scope       = v.vlan_scope != null ? v.vlan_scope : "global"
    }
  }


  lacp_interface_policies = {
    for k, v in var.lacp_interface_policies : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      control = v.control != null ? [
        for a in v.control : {
          fast_select_hot_standby_ports = a.fast_select_hot_standby_ports != null ? a.fast_select_hot_standby_ports : true
          graceful_convergence          = a.graceful_convergence != null ? a.graceful_convergence : true
          load_defer_member_ports       = a.load_defer_member_ports != null ? a.load_defer_member_ports : false
          suspend_individual_port       = a.suspend_individual_port != null ? a.suspend_individual_port : true
          symmetric_hashing             = a.symmetric_hashing != null ? a.symmetric_hashing : false
        }
        ] : [
        {
          fast_select_hot_standby_ports = true
          graceful_convergence          = true
          load_defer_member_ports       = false
          suspend_individual_port       = true
          symmetric_hashing             = false
        }
      ]
      maximum_number_of_links = v.maximum_number_of_links != null ? v.maximum_number_of_links : 16
      minimum_number_of_links = v.minimum_number_of_links != null ? v.minimum_number_of_links : 1
      mode                    = v.mode != null ? v.mode : "off"
      name_alias              = v.name_alias != null ? v.name_alias : ""
    }
  }


  link_level_policies = {
    for k, v in var.link_level_policies : k => {
      annotation                  = v.annotation != null ? v.annotation : ""
      auto_negotiation            = v.auto_negotiation != null ? v.auto_negotiation : "on"
      description                 = v.description != null ? v.description : ""
      forwarding_error_correction = v.forwarding_error_correction != null ? v.forwarding_error_correction : "inherit"
      link_debounce_interval      = v.link_debounce_interval != null ? v.link_debounce_interval : 100
      name_alias                  = v.name_alias != null ? v.name_alias : ""
      speed                       = v.speed != null ? v.speed : "inherit"
    }
  }


  lldp_interface_policies = {
    for k, v in var.lldp_interface_policies : k => {
      annotation     = v.annotation != null ? v.annotation : ""
      description    = v.description != null ? v.description : ""
      name_alias     = v.name_alias != null ? v.name_alias : ""
      receive_state  = v.receive_state != null ? v.receive_state : "enabled"
      transmit_state = v.transmit_state != null ? v.transmit_state : "enabled"
    }
  }


  mcp_interface_policies = {
    for k, v in var.mcp_interface_policies : k => {
      admin_state = v.admin_state != null ? v.admin_state : "enabled"
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
    }
  }


  port_security_policies = {
    for k, v in var.port_security_policies : k => {
      annotation            = v.annotation != null ? v.annotation : ""
      description           = v.description != null ? v.description : ""
      maximum_endpoints     = v.maximum_endpoints != null ? v.maximum_endpoints : 0
      name_alias            = v.name_alias != null ? v.name_alias : ""
      port_security_timeout = v.port_security_timeout != null ? v.port_security_timeout : 60
    }
  }


  spanning_tree_interface_policies_loop1 = {
    for k, v in var.spanning_tree_interface_policies : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      bpdu_filter = v.bpdu_filter != null ? v.bpdu_filter : "disabled"
      bpdu_guard  = v.bpdu_guard != null ? v.bpdu_guard : "disabled"
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
    }
  }

  spanning_tree_interface_policies = {
    for k, v in local.spanning_tree_interface_policies_loop1 : k => {
      annotation = v.annotation != null ? v.annotation : ""
      control = length(
        regexall("enabled", v.bpdu_filter)) > 0 && length(regexall("enabled", v.bpdu_guard)
        ) > 0 ? ["bpdu-filter", "bpdu-guard"] : length(
        regexall("enabled", v.bpdu_filter)) > 0 && length(regexall("disabled", v.bpdu_guard)
        ) > 0 ? ["bpdu-filter"] : length(
        regexall("disabled", v.bpdu_filter)) > 0 && length(regexall("enabled", v.bpdu_guard)
      ) > 0 ? ["bpdu-filter", "bpdu-guard"] : ["unspecified"]
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
    }
  }


  #__________________________________________________________
  #
  # Leaf Interface Policy Group Variables
  #__________________________________________________________

  leaf_port_group_access = {
    for k, v in var.leaf_port_group_access : k => {
      aaep_policy                        = v.aaep_policy != null ? v.aaep_policy : ""
      annotation                         = v.annotation != null ? v.annotation : ""
      cdp_interface_policy               = v.cdp_interface_policy != null ? v.cdp_interface_policy : ""
      copp_interface_policy              = v.copp_interface_policy != null ? v.copp_interface_policy : ""
      data_plane_policing_policy         = v.data_plane_policing_policy != null ? v.data_plane_policing_policy : ""
      data_plane_policing_policy_egress  = v.data_plane_policing_policy_egress != null ? v.data_plane_policing_policy_egress : ""
      data_plane_policing_policy_ingress = v.data_plane_policing_policy_ingress != null ? v.data_plane_policing_policy_ingress : ""
      description                        = v.description != null ? v.description : ""
      dot1x_port_policy                  = v.dot1x_port_policy != null ? v.dot1x_port_policy : ""
      dwdm_policy                        = v.dwdm_policy != null ? v.dwdm_policy : ""
      fc_interface_policy                = v.fc_interface_policy != null ? v.fc_interface_policy : ""
      l2_interface_policy                = v.l2_interface_policy != null ? v.l2_interface_policy : ""
      link_level_policy                  = v.link_level_policy != null ? v.link_level_policy : ""
      lldp_interface_policy              = v.lldp_interface_policy != null ? v.lldp_interface_policy : ""
      macsec_policy                      = v.macsec_policy != null ? v.macsec_policy : ""
      mcp_interface_policy               = v.mcp_interface_policy != null ? v.mcp_interface_policy : ""
      monitoring_policy                  = v.monitoring_policy != null ? v.monitoring_policy : ""
      name_alias                         = v.name_alias != null ? v.name_alias : ""
      netflow_policy                     = v.netflow_policy != null ? v.netflow_policy : []
      port_security_policy               = v.port_security_policy != null ? v.port_security_policy : ""
      priority_flow_control_policy       = v.priority_flow_control_policy != null ? v.priority_flow_control_policy : ""
      slow_drain_policy                  = v.slow_drain_policy != null ? v.slow_drain_policy : ""
      span_destination_groups            = v.span_destination_groups != null ? v.span_destination_groups : ""
      span_source_groups                 = v.span_source_groups != null ? v.span_source_groups : ""
      spanning_tree_interface_policy     = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : ""
      storm_control_policy               = v.storm_control_policy != null ? v.storm_control_policy : ""
    }
  }


  leaf_port_group_breakout = {
    for k, v in var.leaf_port_group_breakout : k => {
      annotation   = v.annotation != null ? v.annotation : ""
      breakout_map = v.breakout_map != null ? v.breakout_map : "10g-4x"
      description  = v.description != null ? v.description : ""
      name_alias   = v.name_alias != null ? v.name_alias : ""
    }
  }


  leaf_port_group_bundle = {
    for k, v in var.leaf_port_group_bundle : k => {
      aaep_policy                        = v.aaep_policy != null ? v.aaep_policy : ""
      annotation                         = v.annotation != null ? v.annotation : ""
      cdp_interface_policy               = v.cdp_interface_policy != null ? v.cdp_interface_policy : ""
      copp_interface_policy              = v.copp_interface_policy != null ? v.copp_interface_policy : ""
      data_plane_policing_policy         = v.data_plane_policing_policy != null ? v.data_plane_policing_policy : ""
      data_plane_policing_policy_egress  = v.data_plane_policing_policy_egress != null ? v.data_plane_policing_policy_egress : ""
      data_plane_policing_policy_ingress = v.data_plane_policing_policy_ingress != null ? v.data_plane_policing_policy_ingress : ""
      description                        = v.description != null ? v.description : ""
      fc_interface_policy                = v.fc_interface_policy != null ? v.fc_interface_policy : ""
      l2_interface_policy                = v.l2_interface_policy != null ? v.l2_interface_policy : ""
      lacp_interface_policy              = v.lacp_interface_policy != null ? v.lacp_interface_policy : ""
      link_aggregation_type              = v.link_aggregation_type != null ? v.link_aggregation_type : "node"
      lldp_interface_policy              = v.lldp_interface_policy != null ? v.lldp_interface_policy : ""
      macsec_policy                      = v.macsec_policy != null ? v.macsec_policy : ""
      mcp_interface_policy               = v.mcp_interface_policy != null ? v.mcp_interface_policy : ""
      monitoring_policy                  = v.monitoring_policy != null ? v.monitoring_policy : ""
      name_alias                         = v.name_alias != null ? v.name_alias : ""
      port_security_policy               = v.port_security_policy != null ? v.port_security_policy : ""
      priority_flow_control_policy       = v.priority_flow_control_policy != null ? v.priority_flow_control_policy : ""
      slow_drain_policy                  = v.slow_drain_policy != null ? v.slow_drain_policy : ""
      span_destination_groups            = v.span_destination_groups != null ? v.span_destination_groups : ""
      span_source_groups                 = v.span_source_groups != null ? v.span_source_groups : ""
      spanning_tree_interface_policy     = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : ""
      storm_control_policy               = v.storm_control_policy != null ? v.storm_control_policy : ""
    }
  }


  #__________________________________________________________
  #
  # Leaf Policy Group Variables
  #__________________________________________________________

  leaf_policy_groups = {
    for k, v in var.leaf_policy_groups : k => {
      annotation                     = v.annotation != null ? v.annotation : ""
      bfd_ipv4_policy                = v.bfd_ipv4_policy != null ? v.bfd_ipv4_policy : "default"
      bfd_ipv6_policy                = v.bfd_ipv6_policy != null ? v.bfd_ipv6_policy : "default"
      bfd_multihop_ipv4_policy       = v.bfd_multihop_ipv4_policy != null ? v.bfd_multihop_ipv4_policy : "default"
      bfd_multihop_ipv6_policy       = v.bfd_multihop_ipv6_policy != null ? v.bfd_multihop_ipv6_policy : "default"
      cdp_policy                     = v.cdp_policy != null ? v.cdp_policy : "default"
      copp_leaf_policy               = v.copp_leaf_policy != null ? v.copp_leaf_policy : "default"
      copp_pre_filter                = v.copp_pre_filter != null ? v.copp_pre_filter : "default"
      description                    = v.description != null ? v.description : ""
      dot1x_authentication_policy    = v.dot1x_authentication_policy != null ? v.dot1x_authentication_policy : "default"
      equipment_flash_config         = v.equipment_flash_config != null ? v.equipment_flash_config : "default"
      fast_link_failover_policy      = v.fast_link_failover_policy != null ? v.fast_link_failover_policy : "default"
      fibre_channel_node_policy      = v.fibre_channel_node_policy != null ? v.fibre_channel_node_policy : "default"
      fibre_channel_san_policy       = v.fibre_channel_san_policy != null ? v.fibre_channel_san_policy : "default"
      forward_scale_profile_policy   = v.forward_scale_profile_policy != null ? v.forward_scale_profile_policy : "default"
      lldp_policy                    = v.lldp_policy != null ? v.lldp_policy : "default"
      monitoring_policy              = v.monitoring_policy != null ? v.monitoring_policy : "default"
      name_alias                     = v.name_alias != null ? v.name_alias : ""
      netflow_node_policy            = v.netflow_node_policy != null ? v.netflow_node_policy : "default"
      ptp_node_policy                = v.ptp_node_policy != null ? v.ptp_node_policy : "default"
      poe_node_policy                = v.poe_node_policy != null ? v.poe_node_policy : "default"
      spanning_tree_interface_policy = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : "default"
      synce_node_policy              = v.synce_node_policy != null ? v.synce_node_policy : "default"
      usb_configuration_policy       = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
    }
  }


  #__________________________________________________________
  #
  # Leaf Profiles Variables
  #__________________________________________________________

  leaf_profiles = {
    for k, v in var.leaf_profiles : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      external_pool_id = length(regexall(
        "^[[:alnum:]]", coalesce(v.external_pool_id, "_EMPTY"))
      ) > 0 ? v.external_pool_id : 0
      interfaces        = v.interfaces != null ? v.interfaces : {}
      leaf_policy_group = v.leaf_policy_group
      monitoring_policy = v.monitoring_policy != null ? "uni/fabric/monfab-${v.monitoring_policy}" : "uni/fabric/monfab-default"
      name              = v.name
      name_alias        = v.name_alias != null ? v.name_alias : ""
      node_type         = v.node_type != null ? v.node_type : "unspecified"
      pod_id            = v.pod_id != null ? v.pod_id : 1
      role              = v.role != null ? v.role : "unspecified"
      serial            = v.serial
      two_slot_leaf     = v.two_slot_leaf != null ? v.two_slot_leaf : false
    }
  }

  leaf_interface_selectors_loop_1 = flatten([
    for key, value in local.leaf_profiles : [
      for k, v in value.interfaces : {
        annotation             = value.annotation != null ? value.annotation : ""
        interface_description  = v.interface_description != null ? v.interface_description : ""
        interface_policy_group = v.interface_policy_group != null ? v.interface_policy_group : ""
        key1                   = key
        key2                   = k
        interface_name = v.sub_port == true && value.two_slot_leaf == true && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-00${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && value.two_slot_leaf == true && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && value.two_slot_leaf == true && length(
          regexall("^\\d{3}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == false && value.two_slot_leaf == true && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-00${element(split("/", k), 1
          )}" : v.sub_port == false && value.two_slot_leaf == true && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1
          )}" : v.sub_port == false && value.two_slot_leaf == true && length(
          regexall("^\\d{3}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1
          )}" : v.sub_port == true && value.two_slot_leaf == false && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && value.two_slot_leaf == false && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == false && value.two_slot_leaf == false && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1
          )}" : v.sub_port == false && value.two_slot_leaf == false && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1
        )}" : ""

        module               = element(split("/", k), 0)
        port                 = element(split("/", k), 1)
        port_type            = v.port_type != null ? v.port_type : "access"
        selector_description = v.selector_description != null ? v.selector_description : ""
        sub_port             = v.sub_port != false ? element(split("/", k), 2) : ""
      }
    ]
  ])


  leaf_interface_selectors = {
    for k, v in local.leaf_interface_selectors_loop_1 : "${v.key1}_${v.key2}" => v
  }


  #__________________________________________________________
  #
  # Spine Interface Policy Group Variables
  #__________________________________________________________

  spine_interface_policy_groups = {
    for k, v in var.spine_interface_policy_groups : k => {
      aaep_policy       = v.aaep_policy
      annotation        = v.annotation != null ? v.annotation : ""
      cdp_policy        = v.cdp_policy != null ? v.cdp_policy : "default"
      description       = v.description != null ? v.description : ""
      link_level_policy = v.link_level_policy != null ? v.link_level_policy : "default"
      macsec_policy     = v.macsec_policy != null ? v.macsec_policy : "default"
      name_alias        = v.name_alias != null ? v.name_alias : ""
    }
  }


  #__________________________________________________________
  #
  # Spine Policy Group Variables
  #__________________________________________________________

  spine_policy_groups = {
    for k, v in var.spine_policy_groups : k => {
      annotation               = v.annotation != null ? v.annotation : ""
      bfd_ipv4_policy          = v.bfd_ipv4_policy != null ? v.bfd_ipv4_policy : "default"
      bfd_ipv6_policy          = v.bfd_ipv6_policy != null ? v.bfd_ipv6_policy : "default"
      cdp_policy               = v.cdp_policy != null ? v.cdp_policy : "default"
      copp_pre_filter          = v.copp_pre_filter != null ? v.copp_pre_filter : "default"
      copp_spine_policy        = v.copp_spine_policy != null ? v.copp_spine_policy : "default"
      description              = v.description != null ? v.description : ""
      lldp_policy              = v.lldp_policy != null ? v.lldp_policy : "default"
      name_alias               = v.name_alias != null ? v.name_alias : ""
      usb_configuration_policy = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
    }
  }


  #__________________________________________________________
  #
  # Spine Profiles Variables
  #__________________________________________________________

  spine_profiles = {
    for k, v in var.spine_profiles : k => {
      annotation         = v.annotation != null ? v.annotation : ""
      description        = v.description != null ? v.description : ""
      external_pool_id   = 0
      interfaces         = v.interfaces != null ? v.interfaces : {}
      monitoring_policy  = v.monitoring_policy != null ? "uni/fabric/monfab-${v.monitoring_policy}" : "uni/fabric/monfab-default"
      name               = v.name
      name_alias         = v.name_alias != null ? v.name_alias : ""
      node_type          = "unspecified"
      pod_id             = v.pod_id != null ? v.pod_id : 1
      role               = "spine"
      serial             = v.serial
      spine_policy_group = v.spine_policy_group
    }
  }

  spine_interface_selectors_loop_1 = flatten([
    for key, value in local.spine_profiles : [
      for k, v in value.interfaces : {
        annotation            = value.annotation != null ? value.annotation : ""
        interface_description = v.interface_description != null ? v.interface_description : ""
        interface_policy_group = coalesce(
          v.interface_policy_group, "EMPTY"
        ) != "EMPTY" ? v.interface_policy_group : "default"
        key1 = key
        key2 = k
        interface_name = length(
          regexall("^\\d{1}$", element(split("/", k), 1))
          ) > 0 ? "Eth${element(split("/", k), 0)}-0${element(split("/", k), 1)}" : length(
          regexall("^\\d{2}$", element(split("/", k), 1))
        ) > 0 ? "Eth${element(split("/", k), 0)}-${element(split("/", k), 1)}" : ""
        module               = element(split("/", k), 0)
        name                 = value.name
        port                 = element(split("/", k), 1)
        port_type            = v.port_type != null ? v.port_type : "access"
        selector_description = v.selector_description != null ? v.selector_description : ""
      }
    ]
  ])

  spine_interface_selectors = {
    for k, v in local.spine_interface_selectors_loop_1 : "${v.key1}_${v.key2}" => v
  }

  fabric_membership = merge(local.leaf_profiles, local.spine_profiles)


  #__________________________________________________________
  #
  # VLAN Pools Variables
  #__________________________________________________________

  # This first loop is to handle optional attributes and return 
  # default values if the user doesn't enter a value.
  vlan_pools = {
    for k, v in var.vlan_pools : k => {
      allocation_mode = v.allocation_mode != null ? v.allocation_mode : "dynamic"
      annotation      = v.annotation != null ? v.annotation : ""
      description     = v.description != null ? v.description : ""
      encap_blocks    = v.encap_blocks != null ? v.encap_blocks : {}
      name_alias      = v.name_alias != null ? v.name_alias : ""
    }
  }

  /*
  Loop 1 is to determine if the vlan_range is:
  * A Single number 1
  * A Range of numbers 1-5
  * A List of numbers 1-5,10-15
  And then to return these values as a list
  */
  vlan_ranges_loop_1 = flatten([
    for key, value in local.vlan_pools : [
      for k, v in value.encap_blocks : {
        allocation_mode = v.allocation_mode != null ? v.allocation_mode : "inherit"
        annotation      = value.annotation
        description     = v.description != null ? v.description : ""
        key1            = key
        key2            = k
        role            = v.role != null ? v.role : "external"
        vlan_split = length(regexall("-", v.vlan_range)) > 0 ? tolist(split(",", v.vlan_range)) : length(
          regexall(",", v.vlan_range)) > 0 ? tolist(split(",", v.vlan_range)
        ) : [v.vlan_range]
        vlan_range = v.vlan_range
      }
    ]
  ])

  # Loop 2 takes a list that contains a "-" or a "," and expands those values
  # into a full list.  So [1-5] becomes [1, 2, 3, 4, 5]
  vlan_ranges_loop_2 = {
    for k, v in local.vlan_ranges_loop_1 : "${v.key1}_${v.key2}" => {
      allocation_mode = v.allocation_mode
      annotation      = v.annotation
      description     = v.description
      key1            = v.key1
      key2            = v.key2
      role            = v.role
      vlan_list = length(regexall("(,|-)", jsonencode(v.vlan_range))) > 0 ? flatten([
        for s in v.vlan_split : length(regexall("-", s)) > 0 ? [for v in range(tonumber(
          element(split("-", s), 0)), (tonumber(element(split("-", s), 1)) + 1)
        ) : tonumber(v)] : [s]
      ]) : v.vlan_split
    }
  }

  # Loop 3 will take the vlan_list created in Loop 2 and expand this
  # out to a map of objects per vlan.
  vlan_ranges_loop_3 = flatten([
    for k, v in local.vlan_ranges_loop_2 : [
      for s in v.vlan_list : {
        allocation_mode = v.allocation_mode
        annotation      = v.annotation
        description     = v.description
        key1            = v.key1
        role            = v.role
        vlan            = s
      }
    ]
  ])

  # And lastly loop3's list is converted back to a map of objects
  vlan_ranges = { for k, v in local.vlan_ranges_loop_3 : "${v.key1}_${v.vlan}" => v }

  #__________________________________________________________
  #
  # Virtual Networking Variables
  #__________________________________________________________

  vmm_domains_loop = flatten([
    for key, value in var.virtual_networking : [
      for k, v in value.domain : {
        access_mode                     = v.access_mode != null ? v.access_mode : "read-write"
        annotation                      = v.annotation != null ? v.annotation : ""
        control_knob                    = v.control_knob != null ? v.control_knob : "epDpVerify"
        delimiter                       = v.delimiter != null ? v.delimiter : "|"
        domain                          = key
        enable_tag_collection           = v.enable_tag_collection != null ? v.enable_tag_collection : false
        enable_vm_folder_data_retrieval = v.enable_vm_folder_data_retrieval != null ? v.enable_vm_folder_data_retrieval : false
        encapsulation                   = v.encapsulation != null ? v.encapsulation : "vlan"
        endpoint_inventory_type         = v.endpoint_inventory_type != null ? v.endpoint_inventory_type : "on-link"
        endpoint_retention_time         = v.endpoint_retention_time != null ? v.endpoint_retention_time : 0
        enforcement                     = v.enforcement != null ? v.enforcement : "hw"
        name_alias                      = v.name_alias != null ? v.name_alias : ""
        preferred_encapsulation         = v.preferred_encapsulation != null ? v.preferred_encapsulation : "unspecified"
        switch_vendor                   = v.switch_vendor != null ? v.switch_vendor : "VMware"
        switch_type                     = v.switch_type != null ? v.switch_type : "default"
        uplink_names                    = length(compact(v.uplink_names)) > 0 ? v.uplink_names : ["uplink1", "uplink2"]
        vlan_pool                       = v.vlan_pool
      }
    ]
  ])
  vmm_domains = { for k, v in local.vmm_domains_loop : "${v.domain}" => v }



  vmm_credentials_loop = flatten([
    for key, value in var.virtual_networking : [
      for k, v in value.credentials : {
        annotation  = local.vmm_domains["${key}"].annotation
        domain      = key
        description = v.description != null ? v.description : ""
        password    = v.password != null ? v.password : 1
        username    = v.username
      }
    ]
  ])

  vmm_credentials = { for k, v in local.vmm_credentials_loop : "${v.domain}" => v }

  vmm_controller_loop = flatten([
    for key, value in var.virtual_networking : [
      for k, v in value.controllers : {
        annotation             = v.annotation != null ? v.annotation : ""
        datacenter             = v.datacenter
        domain                 = key
        dvs_version            = v.dvs_version != null ? v.dvs_version : "unmanaged"
        hostname               = v.hostname
        management_epg         = v.management_epg != null ? v.management_epg : "default"
        management_epg_type    = v.management_epg_type != null ? v.management_epg_type : "oob"
        monitoring_policy      = v.monitoring_policy != null ? v.monitoring_policy : "default"
        port                   = v.port != null ? v.port : 0
        sequence_number        = v.sequence_number != null ? v.sequence_number : 0
        stats_collection       = v.stats_collection != null ? v.stats_collection : "disabled"
        switch_mode            = v.switch_mode != null ? v.switch_mode : "vm"
        switch_type            = local.vmm_domains["${key}"].switch_type
        trigger_inventory_sync = v.trigger_inventory_sync != null ? v.trigger_inventory_sync : "untriggered"
        vxlan_pool             = v.vxlan_pool != null ? v.vxlan_pool : ""
      }
    ]
  ])
  vmm_controllers = { for k, v in local.vmm_controller_loop : "${v.domain}_${v.hostname}" => v }


  vswitch_policies_loop = flatten([
    for key, value in var.virtual_networking : [
      for k, v in value.vswitch_policy : {
        annotation           = v.annotation != null ? v.annotation : ""
        cdp_interface_policy = v.cdp_interface_policy != null ? v.cdp_interface_policy : ""
        enhanced_lag_policy = length(v.enhanced_lag_policy) > 0 ? [
          for s in v.enhanced_lag_policy : {
            load_balancing_mode = s.load_balancing_mode != null ? s.load_balancing_mode : "src-dst-ip"
            mode                = s.mode != null ? s.mode : "active"
            name                = s.name != null ? s.name : key
            number_of_links     = s.number_of_links != null ? s.number_of_links : 2
          }
        ] : []
        firewall_policy       = v.firewall_policy != null ? v.firewall_policy : "default"
        domain                = key
        lacp_interface_policy = v.lacp_interface_policy != null ? v.lacp_interface_policy : ""
        lldp_interface_policy = v.lldp_interface_policy != null ? v.lldp_interface_policy : ""
        mtu_policy            = v.mtu_policy != null ? v.mtu_policy : "default"
        name_alias            = v.name_alias != null ? v.name_alias : ""
        netflow_export_policy = v.vmm_netflow_export_policy != null ? [
          for s in v.netflow_export_policy : {
            active_flow_timeout = s.active_flow_timeout != null ? s.active_flow_timeout : 60
            idle_flow_timeout   = s.idle_flow_timeout != null ? s.idle_flow_timeout : 15
            netflow_policy      = s.netflow_policy
            sample_rate         = s.sample_rate != null ? s.sample_rate : 0
          }
        ] : []
      }
    ]
  ])
  vswitch_policies = { for k, v in local.vswitch_policies_loop : "${v.domain}" => v }


  vmm_uplinks = {
    for k, v in local.vmm_domains : k => {
      domain        = k
      numOfUplinks  = length(v.uplink_names) > 0 ? length(v.uplink_names) : 2
      switch_vendor = v.switch_vendor
    } if v.access_mode == "read-write"
  }


  vmm_uplink_names_loop = flatten([
    for k, v in local.vmm_domains : [
      for s in v.uplink_names : {
        domain        = k
        switch_vendor = v.switch_vendor
        uplinkId      = index(v.uplink_names, s) + 1
        uplinkName    = s
      }
    ] if v.access_mode == "read-write"
  ])
  vmm_uplink_names = { for k, v in local.vmm_uplink_names_loop : "${v.domain}_${v.uplinkName}" => v }


  #__________________________________________________________
  #
  # VPC Domains Variables
  #__________________________________________________________

  vpc_domain_policies = {
    for k, v in var.vpc_domain_policies : k => {
      annotation    = v.annotation != null ? v.annotation : ""
      dead_interval = v.dead_interval != null ? v.dead_interval : 200
      description   = v.description != null ? v.description : ""
      name_alias    = v.name_alias != null ? v.name_alias : ""
    }
  }
  vpc_domains = {
    for k, v in var.vpc_domains : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      domain_id         = v.domain_id
      switch_1          = v.switch_1
      switch_2          = v.switch_2
      vpc_domain_policy = v.vpc_domain_policy != null ? v.vpc_domain_policy : "default"
    }
  }

  # End of Local Loops
}
