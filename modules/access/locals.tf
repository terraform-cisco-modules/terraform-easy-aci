locals {
  #__________________________________________________________
  #
  # Global Policies Variables
  #__________________________________________________________

  aaep_policies = {
    for k, v in var.aaep_policies : k => {
      alias            = v.alias != null ? v.alias : ""
      description      = v.description != null ? v.description : ""
      layer3_domains   = v.layer3_domains != null ? v.layer3_domains : []
      physical_domains = v.physical_domains != null ? v.physical_domains : []
      virtual_domains  = v.virtual_domains != null ? v.virtual_domains : []
    }
  }


  error_disabled_recovery_policy = {
    for k, v in var.error_disabled_recovery_policy : k => {
      alias                             = v.alias != null ? v.alias : ""
      description                       = v.description != null ? v.description : ""
      arp_inspection                    = "yes"
      bpdu_guard                        = "yes"
      debug_1                           = "yes"
      debug_2                           = "yes"
      debug_3                           = "yes"
      debug_4                           = "yes"
      debug_5                           = "yes"
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
      tags                              = v.tags != null ? v.tags : ""
      unidirection_link_detection       = "yes"
      unknown                           = "yes"
    }
  }


  mcp_instance_policy = {
    for k, v in var.mcp_instance_policy : k => {
      admin_state                       = v.admin_state != null ? v.admin_state : "enabled"
      alias                             = v.alias != null ? v.alias : ""
      description                       = v.description != null ? v.description : ""
      tags                              = v.tags != null ? v.tags : ""
      controls                          = v.enable_mcp_pdu_per_vlan == true ? ["pdu-per-vlan", "stateful-ha"] : ["stateful-ha"]
      initial_delay                     = "180"
      loop_detect_multiplication_factor = "3"
      loop_protect_action               = "yes"
      transmission_frequency_seconds    = "2"
      transmission_frequency_msec       = "0"
    }
  }


  global_qos_class = {
    for k, v in var.global_qos_class : k => {
      alias                             = v.alias != null ? v.alias : ""
      control                           = v.preserve_cos == false ? ["none"] : ["dot1p-preserve"]
      description                       = v.description != null ? v.description : ""
      elephant_trap_age_period          = "0"
      elephant_trap_bandwidth_threshold = "0"
      elephant_trap_byte_count          = "0"
      elephant_trap_state               = "no"
      fabric_flush_interval             = "500"
      fabric_flush_state                = "no"
      micro_burst_spine_queues          = "0"
      micro_burst_leaf_queues           = "0"
      tags                              = v.tags != null ? v.tags : ""
    }
  }


  #__________________________________________________________
  #
  # Interface Policies Variables
  #__________________________________________________________

  cdp_interface_policies = {
    for k, v in var.cdp_interface_policies : k => {
      admin_state = v.admin_state != null ? v.admin_state : "enabled"
      alias       = v.alias != null ? v.alias : ""
      description = v.description != null ? v.description : ""
    }
  }


  fc_interface_policies = {
    for k, v in var.fc_interface_policies : k => {
      auto_max_speed        = v.auto_max_speed != null ? v.auto_max_speed : "32G"
      alias                 = v.alias != null ? v.alias : ""
      description           = v.description != null ? v.description : ""
      fill_pattern          = v.fill_pattern != null ? v.fill_pattern : "ARBFF"
      port_mode             = v.port_mode != null ? v.port_mode : "f"
      receive_buffer_credit = v.receive_buffer_credit != null ? v.receive_buffer_credit : "64"
      speed                 = v.speed != null ? v.speed : "auto"
      trunk_mode            = v.trunk_mode != null ? v.trunk_mode : "trunk-off"
    }
  }


  l2_interface_policies = {
    for k, v in var.l2_interface_policies : k => {
      alias            = v.alias != null ? v.alias : ""
      description      = v.description != null ? v.description : ""
      qinq             = v.qinq != null ? v.qinq : "disabled"
      reflective_relay = v.reflective_relay != null ? v.reflective_relay : "disabled"
      vlan_scope       = v.vlan_scope != null ? v.vlan_scope : "global"
    }
  }


  lacp_interface_policies = {
    for k, v in var.lacp_interface_policies : k => {
      alias                     = v.alias != null ? v.alias : ""
      description               = v.description != null ? v.description : ""
      fast_select_standby_ports = v.fast_select_standby_ports != null ? v.fast_select_standby_ports : true
      graceful_convergence      = v.graceful_convergence != null ? v.graceful_convergence : true
      load_defer_member_ports   = v.load_defer_member_ports != null ? v.load_defer_member_ports : false
      maximum_number_of_links   = v.maximum_number_of_links != null ? v.maximum_number_of_links : "16"
      minimum_number_of_links   = v.minimum_number_of_links != null ? v.minimum_number_of_links : "1"
      mode                      = v.mode != null ? v.mode : "off"
      suspend_individual_port   = v.suspend_individual_port != null ? v.suspend_individual_port : true
      symmetric_hashing         = v.symmetric_hashing != null ? v.symmetric_hashing : false
    }
  }


  link_level_policies = {
    for k, v in var.link_level_policies : k => {
      alias                       = v.alias != null ? v.alias : ""
      auto_negotiation            = v.auto_negotiation != null ? v.auto_negotiation : "on"
      description                 = v.description != null ? v.description : ""
      forwarding_error_correction = v.forwarding_error_correction != null ? v.forwarding_error_correction : "inherit"
      link_debounce_interval      = v.link_debounce_interval != null ? v.link_debounce_interval : "100"
      speed                       = v.speed != null ? v.speed : "inherit"
    }
  }


  lldp_interface_policies = {
    for k, v in var.lldp_interface_policies : k => {
      alias          = v.alias != null ? v.alias : ""
      description    = v.description != null ? v.description : ""
      receive_state  = v.receive_state != null ? v.receive_state : "enabled"
      tags           = v.tags != null ? v.tags : ""
      transmit_state = v.transmit_state != null ? v.transmit_state : "enabled"
    }
  }


  mcp_interface_policies = {
    for k, v in var.mcp_interface_policies : k => {
      admin_state = v.admin_state != null ? v.admin_state : "enabled"
      alias       = v.alias != null ? v.alias : ""
      description = v.description != null ? v.description : ""
      tags        = v.tags != null ? v.tags : ""
    }
  }


  port_security_policies = {
    for k, v in var.port_security_policies : k => {
      alias                 = v.alias != null ? v.alias : ""
      description           = v.description != null ? v.description : ""
      maximum_endpoints     = v.maximum_endpoints != null ? v.maximum_endpoints : "0"
      port_security_timeout = v.port_security_timeout != null ? v.port_security_timeout : "60"
      tags                  = v.tags != null ? v.tags : ""
    }
  }


  spanning_tree_interface_policies = {
    for k, v in var.spanning_tree_interface_policies : k => {
      alias = v.alias != null ? v.alias : ""
      control = length(
        regexall("^yes$", v.bpdu_filter_enabled)) > 0 && length(regexall("^yes$", v.bpdu_filter_enabled)
        ) > 0 ? ["bpdu-filter", "bpdu-guard"] : length(
        regexall("^yes$", v.bpdu_filter_enabled)) > 0 && length(regexall("^no$", v.bpdu_filter_enabled)
        ) > 0 ? ["bpdu-filter"] : length(
        regexall("^no$", v.bpdu_filter_enabled)) > 0 && length(regexall("^yes$", v.bpdu_filter_enabled)
      ) > 0 ? ["bpdu-filter", "bpdu-guard"] : ["unspecified"]
      description = v.description != null ? v.description : ""
      tags        = v.tags != null ? v.tags : ""
    }
  }


  #__________________________________________________________
  #
  # Leaf Policy Group Variables
  #__________________________________________________________

  leaf_policy_groups = {
    for k, v in var.leaf_policy_groups : k => {
      alias                          = v.alias != null ? v.alias : ""
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
      netflow_node_policy            = v.netflow_node_policy != null ? v.netflow_node_policy : "default"
      ptp_node_policy                = v.ptp_node_policy != null ? v.ptp_node_policy : "default"
      poe_node_policy                = v.poe_node_policy != null ? v.poe_node_policy : "default"
      spanning_tree_interface_policy = v.spanning_tree_interface_policy != null ? v.spanning_tree_interface_policy : "default"
      synce_node_policy              = v.synce_node_policy != null ? v.synce_node_policy : "default"
      tags                           = v.tags != null ? v.tags : ""
      usb_configuration_policy       = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
    }
  }


  #__________________________________________________________
  #
  # Leaf Profiles Variables
  #__________________________________________________________

  leaf_profiles = {
    for k, v in var.leaf_profiles : k => {
      alias             = v.alias != null ? v.alias : ""
      description       = v.description != null ? v.description : ""
      external_pool_id  = v.external_pool_id != null ? v.external_pool_id : "0"
      interfaces        = v.interfaces != null ? v.interfaces : {}
      name              = v.name
      leaf_policy_group = v.leaf_policy_group
      node_type         = v.node_type != null ? v.node_type : "unspecified"
      pod_id            = v.pod_id != null ? v.pod_id : "1"
      role              = v.role != null ? v.role : "unspecified"
      serial            = v.serial
      tags              = v.tags != null ? v.tags : ""
    }
  }

  leaf_interface_selectors_loop_1 = flatten([
    for key, value in local.leaf_profiles : [
      for k, v in value.interfaces : {
        interface_description  = v.interface_description != null ? v.interface_description : ""
        interface_policy_group = v.interface_policy_group != null ? v.interface_policy_group : ""
        key1                   = key
        key2                   = k
        interface_name = v.sub_port == true && var.two_slot_leafs == true && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-00${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && var.two_slot_leafs == true && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && var.two_slot_leafs == true && length(
          regexall("^\\d{3}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == false && var.two_slot_leafs == true && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-00${element(split("/", k), 1
          )}" : v.sub_port == false && var.two_slot_leafs == true && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1
          )}" : v.sub_port == false && var.two_slot_leafs == true && length(
          regexall("^\\d{3}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1
          )}" : v.sub_port == true && var.two_slot_leafs == false && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == true && var.two_slot_leafs == false && length(
          regexall("^\\d{2}$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-${element(split("/", k), 1)}-${element(split("/", k), 2
          )}" : v.sub_port == false && var.two_slot_leafs == false && length(
          regexall("^\\d$", element(split("/", k), 1))) > 0 ? "Eth${element(split("/", k), 0
            )}-0${element(split("/", k), 1
          )}" : v.sub_port == false && var.two_slot_leafs == false && length(
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
      alias             = v.alias != null ? v.alias : ""
      cdp_policy        = v.cdp_policy != null ? v.cdp_policy : "default"
      description       = v.description != null ? v.description : ""
      link_level_policy = v.link_level_policy != null ? v.link_level_policy : "default"
      macsec_policy     = v.macsec_policy != null ? v.macsec_policy : "default"
    }
  }


  #__________________________________________________________
  #
  # Spine Policy Group Variables
  #__________________________________________________________

  spine_policy_groups = {
    for k, v in var.spine_policy_groups : k => {
      alias                    = v.alias != null ? v.alias : ""
      bfd_ipv4_policy          = v.bfd_ipv4_policy != null ? v.bfd_ipv4_policy : "default"
      bfd_ipv6_policy          = v.bfd_ipv6_policy != null ? v.bfd_ipv6_policy : "default"
      cdp_policy               = v.cdp_policy != null ? v.cdp_policy : "default"
      copp_pre_filter          = v.copp_pre_filter != null ? v.copp_pre_filter : "default"
      copp_spine_policy        = v.copp_spine_policy != null ? v.copp_spine_policy : "default"
      description              = v.description != null ? v.description : ""
      lldp_policy              = v.lldp_policy != null ? v.lldp_policy : "default"
      tags                     = v.tags != null ? v.tags : ""
      usb_configuration_policy = v.usb_configuration_policy != null ? v.usb_configuration_policy : "default"
    }
  }


  #__________________________________________________________
  #
  # Spine Profiles Variables
  #__________________________________________________________

  spine_profiles = {
    for k, v in var.spine_profiles : k => {
      alias              = v.alias != null ? v.alias : ""
      description        = v.description != null ? v.description : ""
      external_pool_id   = ""
      interfaces         = v.interfaces != null ? v.interfaces : {}
      name               = v.name
      node_type          = "unspecified"
      pod_id             = v.pod_id != null ? v.pod_id : "1"
      role               = "spine"
      serial             = v.serial
      spine_policy_group = v.spine_policy_group
      tags               = v.tags != null ? v.tags : ""
    }
  }

  spine_interface_selectors_loop_1 = flatten([
    for key, value in local.spine_profiles : [
      for k, v in value.interfaces : {
        interface_description  = v.interface_description != null ? v.interface_description : ""
        interface_policy_group = v.interface_policy_group != null ? v.interface_policy_group : "default"
        key1                   = key
        key2                   = k
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

  fabric_node_members = merge(local.leaf_profiles, local.spine_profiles)


  #__________________________________________________________
  #
  # VLAN Pools Variables
  #__________________________________________________________

  vlan_pools = {
    for k, v in var.vlan_pools : k => {
      alias           = v.alias != null ? v.alias : ""
      allocation_mode = v.allocation_mode != null ? v.allocation_mode : "dynamic"
      description     = v.description != null ? v.description : ""
      encap_blocks    = v.encap_blocks != null ? v.encap_blocks : {}
    }
  }


  vlan_ranges = {
    for k, v in local.vlan_pools : k => {
      alias           = v.alias != null ? v.alias : ""
      allocation_mode = v.allocation_mode != null ? v.allocation_mode : "dynamic"
      description     = v.description != null ? v.description : ""
      encap_blocks    = v.encap_blocks != null ? v.encap_blocks : {}
    }
  }

  # End of Local Loops
}
