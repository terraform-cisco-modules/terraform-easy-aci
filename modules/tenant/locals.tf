locals {
  # Terraform Cloud Remote Resources - Policies
  rs_contracts               = {}
  rs_filters                 = {}
  rs_l3_domains              = {}
  rs_mso_filter_entries      = {}
  rs_ospf_interface_policies = {}
  rs_schemas                 = {}
  rs_vrfs                    = {}
  # rs_schemas  = lookup(data.terraform_remote_state.policies.outputs, "adapter_configuration_policies", {})

  #__________________________________________________________
  #
  # Application Profile Variables
  #__________________________________________________________

  application_profiles = {
    for k, v in var.application_profiles : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      controller_type   = v.controller_type != null ? v.controller_type : "apic"
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : "default"
      name_alias        = v.name_alias != null ? v.name_alias : ""
      qos_class         = v.qos_class != null ? v.qos_class : "unspecified"
      schema            = v.schema != null ? v.schema : "common"
      sites             = v.sites != null ? v.sites : []
      template          = v.template != null ? v.template : "common"
      tenant            = v.tenant != null ? v.tenant : "common"
    }
  }


  #__________________________________________________________
  #
  # Application EPGs Variables
  #__________________________________________________________

  application_epgs = {
    for k, v in var.application_epgs : k => {
      annotation             = v.annotation != null ? v.annotation : ""
      application_profile    = v.application_profile != null ? v.application_profile : "default"
      bd_schema              = v.bd_schema != null ? v.bd_schema : "common"
      bd_template            = v.bd_template != null ? v.bd_template : "common"
      bd_tenant              = v.bd_tenant != null ? v.bd_tenant : v.tenant
      bridge_domain          = v.bridge_domain != null ? v.bridge_domain : "default"
      contract_exception_tag = v.contract_exception_tag != null ? v.contract_exception_tag : ""
      contracts              = v.contracts != null ? v.contracts : []
      controller_type        = v.controller_type != null ? v.controller_type : "apic"
      description            = v.description != null ? v.description : ""
      domains                = v.domains != null ? v.domains : []
      epg_admin_state        = v.epg_admin_state != null ? v.epg_admin_state : "admin_up"
      epg_type               = v.epg_type != null ? v.epg_type : "standard"
      flood_in_encapsulation = v.flood_in_encapsulation != null ? v.flood_in_encapsulation : "disabled"
      has_multicast_source   = v.has_multicast_source != null ? v.has_multicast_source : false
      label_match_criteria   = v.label_match_criteria != null ? v.label_match_criteria : "AtleastOne"
      name_alias             = v.name_alias != null ? v.name_alias : ""
      intra_epg_isolation    = v.intra_epg_isolation != null ? v.intra_epg_isolation : "unenforced"
      preferred_group_member = v.preferred_group_member != null ? v.preferred_group_member : false
      qos_class              = v.qos_class != null ? v.qos_class : "unspecified"
      schema                 = v.schema != null ? v.schema : "common"
      static_paths           = v.static_paths != null ? v.static_paths : []
      template               = v.template != null ? v.template : "common"
      tenant                 = v.tenant != null ? v.tenant : "common"
      useg_epg               = v.useg_epg != null ? v.useg_epg : false
      vrf                    = v.vrf != null ? v.vrf : "default"
      vrf_schema             = v.vrf_schema != null ? v.vrf_schema : "common"
      vrf_template           = v.vrf_template != null ? v.vrf_template : "common"
    }
  }

  epg_to_domains_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.domains : {
        annotation               = v.annotation != null ? v.annotation : ""
        allow_micro_segmentation = v.allow_micro_segmentation != null ? v.allow_micro_segmentation : false
        application_epg          = key
        delimiter                = v.delimiter != null ? v.delimiter : ""
        domain                   = v.domain
        domain_type              = v.domain_type != null ? v.domain_type : "physical"
        domain_vendor            = v.domain_vendor != null ? v.domain_vendor : "VMware"
        port_binding             = v.port_binding != null ? v.port_binding : "none"
        resolution_immediacy     = v.resolution_immediacy != null ? v.resolution_immediacy : "pre-provision"
        security = v.security != null ? {
          for keys, values in v.security : keys => {
            allow_promiscuous = v.allow_promiscuous != null ? v.allow_promiscuous : "reject"
            forged_transmits  = v.forged_transmits != null ? v.forged_transmits : "reject"
            mac_changes       = v.mac_changes != null ? v.mac_changes : "reject"
          }
        } : []
        vlan_mode = v.vlan_mode != null ? v.vlan_mode : "auto"
        vlans     = v.vlans != null ? v.vlans : []
      }
    ]
  ])

  epg_to_domains = { for k, v in local.epg_to_domains_loop : "${v.application_epg}_${v.domain}" => v }


  contract_to_epgs_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.contracts : {
        application_epg     = key
        application_profile = value.application_profile
        contract            = v.contract
        contract_class = length(regexall("consumer", v.contract_type)) > 0 ? "fvRsCons" : length(regexall(
          "contract_interface", v.contract_type)) > 0 ? "fvRsConsIf" : length(regexall(
          "intra_epg", v.contract_type)) > 0 ? "fvRsIntraEpg" : length(regexall(
          "provider", v.contract_type)) > 0 ? "fvRsProv" : length(regexall(
          "taboo", v.contract_type)
        ) > 0 ? "fvRsProtBy" : ""
        contract_dn = length(regexall("consumer", v.contract_type)) > 0 ? "rscons" : length(regexall(
          "contract_interface", v.contract_type)) > 0 ? "rsconsIf" : length(regexall(
          "intra_epg", v.contract_type)) > 0 ? "rsintraEpg" : length(regexall(
          "provider", v.contract_type)) > 0 ? "rsprov" : length(regexall(
          "taboo", v.contract_type)
        ) > 0 ? "rsprotBy" : ""
        contract_tdn    = length(regexall("taboo", v.contract_type)) > 0 ? "taboo" : "brc"
        contract_tenant = v.contract_tenant != null ? v.contract_tenant : value.tenant
        qos_class       = v.qos_class != null ? v.qos_class : "unspecified"
        tenant          = value.tenant
      }
    ]
  ])
  contract_to_epgs = { for k, v in local.contract_to_epgs_loop : "${v.application_epg}_${v.contract}" => v }

  #__________________________________________________________
  #
  # BGP Policies Variables
  #__________________________________________________________

  bgp_policies = {
    for k, v in var.bgp_policies : k => {
      bgp_address_family_context_policies = v.bgp_address_family_context_policies != null ? v.bgp_address_family_context_policies : []
      bgp_best_path_policies              = v.bgp_best_path_policies != null ? v.bgp_best_path_policies : []
      bgp_peer_prefix_policies            = v.bgp_peer_prefix_policies != null ? v.bgp_peer_prefix_policies : []
      bgp_route_summarization_policies    = v.bgp_route_summarization_policies != null ? v.bgp_route_summarization_policies : []
      bgp_timers_policies                 = v.bgp_timers_policies != null ? v.bgp_timers_policies : []
    }
  }

  bgp_address_family_context_policies_loop = flatten([
    for key, value in local.bgp_policies : [
      for k, v in value.bgp_address_family_context_policies : {
        annotation             = v.annotation != null ? v.annotation : ""
        description            = v.description != null ? v.description : ""
        ebgp_distance          = v.ebgp_distance != null ? v.ebgp_distance : 20
        ebgp_max_ecmp          = v.ebgp_max_ecmp != null ? v.ebgp_max_ecmp : 16
        enable_host_route_leak = v.enable_host_route_leak != null ? v.enable_host_route_leak : false
        ibgp_distance          = v.ibgp_distance != null ? v.ibgp_distance : 200
        ibgp_max_ecmp          = v.ibgp_max_ecmp != null ? v.ibgp_max_ecmp : 16
        local_distance         = v.local_distance != null ? v.local_distance : 220
        name                   = v.name != null ? v.name : "default"
        name_alias             = v.name_alias != null ? v.name_alias : ""
        tenant                 = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  bgp_address_family_context_policies = { for k, v in local.bgp_address_family_context_policies_loop : v.name => v }

  bgp_best_path_policies_loop = flatten([
    for key, value in local.bgp_policies : [
      for k, v in value.bgp_best_path_policies : {
        annotation                = v.annotation != null ? v.annotation : ""
        description               = v.description != null ? v.description : ""
        name                      = v.name != null ? v.name : "default"
        name_alias                = v.name_alias != null ? v.name_alias : ""
        relax_as_path_restriction = v.relax_as_path_restriction != null ? v.relax_as_path_restriction : false
        tenant                    = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  bgp_best_path_policies = { for k, v in local.bgp_best_path_policies_loop : v.name => v }

  bgp_peer_prefix_policies_loop = flatten([
    for key, value in local.bgp_policies : [
      for k, v in value.bgp_peer_prefix_policies : {
        action                     = v.action != null ? v.action : "reject"
        annotation                 = v.annotation != null ? v.annotation : ""
        description                = v.description != null ? v.description : ""
        maximum_number_of_prefixes = v.maximum_number_of_prefixes != null ? v.maximum_number_of_prefixes : 20000
        name                       = v.name != null ? v.name : "default"
        restart_time               = v.restart_time != null ? v.restart_time : "infinite"
        tenant                     = v.tenant != null ? v.tenant : "common"
        threshold                  = v.threshold != null ? v.threshold : 75
      }
    ]
  ])

  bgp_peer_prefix_policies = { for k, v in local.bgp_peer_prefix_policies_loop : v.name => v }

  bgp_route_summarization_policies_loop = flatten([
    for key, value in local.bgp_policies : [
      for k, v in value.bgp_route_summarization_policies : {
        annotation                  = v.annotation != null ? v.annotation : ""
        description                 = v.description != null ? v.description : ""
        generate_as_set_information = v.generate_as_set_information != null ? v.generate_as_set_information : false
        name                        = v.name != null ? v.name : "default"
        name_alias                  = v.name_alias != null ? v.name_alias : ""
        tenant                      = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  bgp_route_summarization_policies = { for k, v in local.bgp_route_summarization_policies_loop : v.name => v }

  bgp_timers_policies_loop = flatten([
    for key, value in local.bgp_policies : [
      for k, v in value.bgp_timers_policies : {
        annotation              = v.annotation != null ? v.annotation : ""
        description             = v.description != null ? v.description : ""
        graceful_restart_helper = v.graceful_restart_helper != null ? v.graceful_restart_helper : true
        hold_interval           = v.hold_interval != null ? v.hold_interval : 180
        keepalive_interval      = v.keepalive_interval != null ? v.keepalive_interval : 60
        maximum_as_limit        = v.maximum_as_limit != null ? v.maximum_as_limit : 0
        name                    = v.name != null ? v.name : "default"
        name_alias              = v.name_alias != null ? v.name_alias : ""
        stale_interval          = v.stale_interval != null ? v.stale_interval : 300
        tenant                  = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  bgp_timers_policies = { for k, v in local.bgp_timers_policies_loop : v.name => v }

  #__________________________________________________________
  #
  # BFD Interface Policies Variables
  #__________________________________________________________

  bfd_interface_policies = {
    for k, v in var.bfd_interface_policies : k => {
      admin_state                       = v.admin_state != null ? v.admin_state : "enabled"
      annotation                        = v.annotation != null ? v.annotation : ""
      description                       = v.description != null ? v.description : ""
      detection_multiplier              = v.detection_multiplier != null ? v.detection_multiplier : 3
      echo_admin_state                  = v.echo_admin_state != null ? v.echo_admin_state : "enabled"
      echo_recieve_interval             = v.echo_recieve_interval != null ? v.echo_recieve_interval : 50
      enable_sub_interface_optimization = v.enable_sub_interface_optimization != null ? v.enable_sub_interface_optimization : false
      minimum_recieve_interval          = v.minimum_recieve_interval != null ? v.minimum_recieve_interval : 50
      minimum_transmit_interval         = v.minimum_transmit_interval != null ? v.minimum_transmit_interval : 50
      name_alias                        = v.name_alias != null ? v.name_alias : ""
      tenant                            = v.tenant != null ? v.tenant : "common"
    }
  }

  #__________________________________________________________
  #
  # Bridge Domain Variables
  #__________________________________________________________

  bridge_domains = {
    for k, v in var.bridge_domains : k => {
      advertise_host_routes                  = lookup(v.general[0], "advertise_host_routes", false)
      alias                                  = lookup(v.general[0], "alias", "")
      annotation                             = lookup(v.general[0], "annotation", "")
      arp_flooding                           = lookup(v.general[0], "arp_flooding", false)
      controller_type                        = v.controller_type != null ? v.controller_type : "apic"
      description                            = lookup(v.general[0], "description", "")
      endpoint_clear                         = lookup(v.general[0], "endpoint_clear", false)
      endpoint_retention_policy              = lookup(v.general[0], "endpoint_retention_policy", "")
      ep_move_detection_mode                 = lookup(v.general[0], "ep_move_detection_mode", "disable")
      igmp_snooping_policy                   = lookup(v.general[0], "igmp_snooping_policy", "")
      ipv6_l3_unknown_multicast              = lookup(v.general[0], "ipv6_l3_unknown_multicast", "flood")
      l2_unknown_unicast                     = lookup(v.general[0], "l2_unknown_unicast", "flood")
      l3_unknown_multicast_flooding          = lookup(v.general[0], "l3_unknown_multicast_flooding", "flood")
      limit_ip_learn_to_subnets              = lookup(v.general[0], "limit_ip_learn_to_subnets", true)
      mld_snoop_policy                       = lookup(v.general[0], "mld_snoop_policy", "")
      multi_destination_flooding             = lookup(v.general[0], "multi_destination_flooding", "bd-flood")
      name_alias                             = lookup(v.general[0], "name_alias", "")
      pim                                    = lookup(v.general[0], "pim", false)
      pimv6                                  = lookup(v.general[0], "pimv6", false)
      tenant                                 = lookup(v.general[0], "tenant", "common")
      type                                   = lookup(v.general[0], "type", "regular")
      vrf                                    = lookup(v.general[0], "vrf", "default")
      vrf_tenant                             = lookup(v.general[0], "vrf_tenant", "common")
      unicast_routing                        = lookup(v.l3_configurations[0], "unicast_routing", true)
      custom_mac_address                     = lookup(v.l3_configurations[0], "custom_mac_address", "")
      link_local_ipv6_address                = lookup(v.l3_configurations[0], "link_local_ipv6_address", "::")
      schema                                 = v.schema != null ? v.schema : "common"
      sites                                  = v.sites != null ? v.sites : []
      subnets                                = lookup(v.l3_configurations[0], "subnets", [])
      virtual_mac_address                    = lookup(v.l3_configurations[0], "virtual_mac_address", ["not-applicable"])
      intersite_bum_traffic_allow            = lookup(v.troubleshooting_advanced[0], "intersite_bum_traffic_allow", false)
      intersite_l2_stretch                   = lookup(v.troubleshooting_advanced[0], "intersite_l2_stretch", false)
      optimize_wan_bandwidth                 = lookup(v.troubleshooting_advanced[0], "optimize_wan_bandwidth", false)
      disable_ip_data_plane_learning_for_pbr = lookup(v.troubleshooting_advanced[0], "disable_ip_data_plane_learning_for_pbr", false)
      first_hop_security_policy              = lookup(v.troubleshooting_advanced[0], "first_hop_security_policy", "")
      monitoring_policy                      = lookup(v.troubleshooting_advanced[0], "monitoring_policy", "")
      netflow_monitor_policies               = lookup(v.troubleshooting_advanced[0], "netflow_monitor_policies", [])
      rogue_coop_exception_list              = lookup(v.troubleshooting_advanced[0], "rogue_coop_exception_list", [])
    }
  }


  subnets_loop_1 = flatten([
    for key, value in local.bridge_domains : [
      for k, v in value.subnets : {
        bridge_domain                = key
        controller_type              = value.controller_type
        description                  = v.description != null ? v.description : ""
        gateway_ip                   = v.gateway_ip != null ? v.gateway_ip : "198.18.5.1/24"
        l3_out_for_route_profile     = v.l3_out_for_route_profile != null ? v.l3_out_for_route_profile : ""
        associated_l3outs            = v.associated_l3outs != null ? v.associated_l3outs : []
        make_this_ip_address_primary = v.make_this_ip_address_primary != null ? v.make_this_ip_address_primary : false
        schema                       = value.schema
        sites                        = value.sites
        scope = [
          {
            advertise_externally = lookup(v.scope[0], "shared_between_vrfs", false)
            shared_between_vrfs  = lookup(v.scope[0], "advertise_externally", false)
          }
        ]
        subnet_control = [
          {
            neighbor_discovery     = lookup(v.subnet_control[0], "neighbor_discovery", false)
            no_default_svi_gateway = lookup(v.subnet_control[0], "no_default_svi_gateway", false)
            querier_ip             = lookup(v.subnet_control[0], "querier_ip", false)
          }
        ]
        treat_as_virtual_ip_address = v.treat_as_virtual_ip_address != null ? v.treat_as_virtual_ip_address : false
      }
    ]
  ])

  subnets = { for k, v in local.subnets_loop_1 : "${v.bridge_domain}_${v.gateway_ip}" => v }

  #__________________________________________________________
  #
  # Contract Variables
  #__________________________________________________________

  contracts = {
    for k, v in var.contracts : k => {
      annotation           = v.annotation != null ? v.annotation : ""
      consumer_match_type  = v.consumer_match_type != null ? v.consumer_match_type : "AtleastOne"
      contract_type        = v.contract_type != null ? v.contract_type : "standard"
      controller_type      = v.controller_type != null ? v.controller_type : "apic"
      description          = v.description != null ? v.description : ""
      filters              = v.filters != null ? v.filters : []
      log_packets          = v.log_packets != null ? v.log_packets : false
      name_alias           = v.name_alias != null ? v.name_alias : ""
      qos_class            = v.qos_class != null ? v.qos_class : "unspecified"
      provider_match_type  = v.provider_match_type != null ? v.provider_match_type : "AtleastOne"
      reverse_filter_ports = v.reverse_filter_ports != null ? v.reverse_filter_ports : true
      schema               = v.schema != null ? v.schema : "common"
      scope                = v.scope != null ? v.scope : "context"
      tags                 = v.tags != null ? v.tags : []
      target_dscp          = v.target_dscp != null ? v.target_dscp : "unspecified"
      template             = v.template != null ? v.template : "common"
      tenant               = v.tenant != null ? v.tenant : "common"
    }
  }


  apic_contract_filters_loop = flatten([
    for key, value in local.contracts : [
      for k, v in value.filters : {
        contract = key
        filter = length(regexall(
          v.tenant, value.tenant)
        ) > 0 ? aci_filter.filters[v.name].id : local.rs_filters[v.name].id
        name = v.name
      }
    ] if value.controller_type == "apic"
  ])

  apic_contract_filters = { for k, v in local.apic_contract_filters_loop : "${v.contract}_${v.name}" => v }

  contract_subjects = {
    for k, v in local.contracts : k => {
      annotation           = v.annotation
      contract_type        = v.contract_type
      consumer_match_type  = v.consumer_match_type
      controller_type      = v.controller_type
      description          = v.description
      filters              = [for key, value in local.apic_contract_filters : value.filter if value.contract == k]
      log_packets          = v.log_packets != null ? v.log_packets : false
      name_alias           = v.name_alias
      qos_class            = v.qos_class
      provider_match_type  = v.provider_match_type
      reverse_filter_ports = v.reverse_filter_ports
      schema               = v.schema
      scope                = v.scope
      tags                 = v.tags
      target_dscp          = v.target_dscp
      template             = v.template
      tenant               = v.tenant
    }
  }

  contract_tags_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.tags : {
        key      = value.key
        value    = v.value
        type     = value.type
        contract = key
      }
    ]
  ])

  contract_tags = { for k, v in local.contract_tags_loop : "${v.contract}_${v.key}" => v }

  #__________________________________________________________
  #
  # Endpoint Retention Policy Variables
  #__________________________________________________________

  # dhcp_relay_policies = {
  #   for k, v in var.dhcp_relay_policies : k => {
  #     annotation  = v.annotation != null ? v.annotation : ""
  #     description = v.description != null ? v.description : ""
  #     dhcp_relay_providers = v.dhcp_relay_providers != null ? { for key, value in v.dhcp_relay_providers : key =>
  #       {
  #         address             = value.address
  #         application_profile = value.application_profile != null ? value.application_profile : "default"
  #         epg                 = value.epg != null ? v.epg : "default"
  #         epg_type            = value.epg_type != null ? v.epg_type : "epg"
  #         l3out               = value.l3out != null ? v.l3out : ""
  #         tenant              = value.tenant != null ? v.tenant : ""
  #       }
  #     } : {}
  #     mode       = v.mode != null ? v.mode : "visible"
  #     name_alias = v.name_alias != null ? v.name_alias : ""
  #     owner      = v.owner != null ? v.owner : "infra"
  #     tenant     = v.tenant != null ? v.tenant : "common"
  #   }
  # }

  #__________________________________________________________
  #
  # Endpoint Retention Policy Variables
  #__________________________________________________________

  endpoint_retention_policies = {
    for k, v in var.endpoint_retention_policies : k => {
      annotation                     = v.annotation != null ? v.annotation : ""
      bounce_entry_aging_interval    = v.bounce_entry_aging_interval != null ? v.bounce_entry_aging_interval : 630
      bounce_trigger                 = v.bounce_trigger != null ? v.bounce_trigger : "protocol"
      description                    = v.description != null ? v.description : ""
      hold_interval                  = v.hold_interval != null ? v.hold_interval : "300"
      local_endpoint_aging_interval  = v.local_endpoint_aging_interval != null ? v.local_endpoint_aging_interval : "900"
      move_frequency                 = v.move_frequency != null ? v.move_frequency : "256"
      name_alias                     = v.name_alias != null ? v.name_alias : ""
      remote_endpoint_aging_interval = v.remote_endpoint_aging_interval != null ? v.remote_endpoint_aging_interval : "300"
      tenant                         = v.tenant != null ? v.tenant : "common"
    }
  }


  #__________________________________________________________
  #
  # Filter Variables
  #__________________________________________________________

  filters = {
    for k, v in var.filters : k => {
      annotation      = v.annotation != null ? v.annotation : ""
      controller_type = v.controller_type != null ? v.controller_type : "apic"
      description     = v.description != null ? v.description : ""
      filter_entries  = v.filter_entries != null ? v.filter_entries : []
      name_alias      = v.name_alias != null ? v.name_alias : ""
      schema          = v.schema != null ? v.schema : "common"
      template        = v.template != null ? v.template : "common"
      tenant          = v.tenant != null ? v.tenant : "common"
    }
  }

  filter_entries_loop = flatten([
    for key, value in local.filters : [
      for k, v in value.filter_entries : {
        annotation            = v.annotation != null ? v.annotation : ""
        arp_flag              = v.arp_flag != null ? v.arp_flag : "unspecified"
        controller_type       = value.controller_type
        description           = v.description != null ? v.description : ""
        destination_port_from = v.destination_port_from != null ? v.destination_port_from : "unspecified"
        destination_port_to   = v.destination_port_to != null ? v.destination_port_to : "unspecified"
        ethertype             = v.ethertype != null ? v.ethertype : "unspecified"
        filter_name           = key
        icmpv4_type           = v.icmpv4_type != null ? v.icmpv4_type : "unspecified"
        icmpv6_type           = v.icmpv6_type != null ? v.icmpv6_type : "unspecified"
        ip_protocol           = v.ip_protocol != null ? v.ip_protocol : "unspecified"
        match_dscp            = v.match_dscp != null ? v.match_dscp : "unspecified"
        match_only_fragments  = v.match_only_fragments != null ? v.match_only_fragments : false
        name                  = v.name != null ? v.name : "default"
        name_alias            = v.name_alias != null ? v.name_alias : ""
        source_port_from      = v.source_port_from != null ? v.source_port_from : "unspecified"
        source_port_to        = v.source_port_to != null ? v.source_port_to : "unspecified"
        schema                = value.schema
        stateful              = v.stateful != null ? v.stateful : false
        tcp_ack               = v.tcp_session_rules != null ? lookup(v.tcp_session_rules[0], "acknowledgement", false) : false
        tcp_est               = v.tcp_session_rules != null ? lookup(v.tcp_session_rules[0], "established", false) : false
        tcp_fin               = v.tcp_session_rules != null ? lookup(v.tcp_session_rules[0], "finish", false) : false
        tcp_rst               = v.tcp_session_rules != null ? lookup(v.tcp_session_rules[0], "reset", false) : false
        tcp_syn               = v.tcp_session_rules != null ? lookup(v.tcp_session_rules[0], "synchronize", false) : false
        template              = value.template
        tenant                = value.tenant
      }
    ]
  ])

  filter_entries = { for k, v in local.filter_entries_loop : "${v.filter_name}_${v.name}" => v }

  #__________________________________________________________
  #
  # OSPF Policies Variables
  #__________________________________________________________

  ospf_policies = {
    for k, v in var.ospf_policies : k => {
      ospf_interface_policies           = v.ospf_interface_policies != null ? v.ospf_interface_policies : []
      ospf_route_summarization_policies = v.ospf_route_summarization_policies != null ? v.ospf_route_summarization_policies : []
      ospf_timers_policies              = v.ospf_timers_policies != null ? v.ospf_timers_policies : []
    }
  }

  ospf_interface_policies_loop = flatten([
    for key, value in local.ospf_policies : [
      for k, v in value.ospf_interface_policies : {
        advertise_subnet      = v.interface_controls != null ? lookup(v.interface_controls[0], "advertise_subnet", false) : false
        annotation            = v.annotation != null ? v.annotation : ""
        bfd                   = v.interface_controls != null ? lookup(v.interface_controls[0], "bfd", false) : false
        mtu_ignore            = v.interface_controls != null ? lookup(v.interface_controls[0], "mtu_ignore", false) : false
        passive               = v.interface_controls != null ? lookup(v.interface_controls[0], "passive_participation", false) : false
        passive_participation = v.annotation != null ? v.annotation : ""
        cost_of_interface     = v.cost_of_interface != null ? v.cost_of_interface : 0
        dead_interval         = v.dead_interval != null ? v.dead_interval : 40
        description           = v.description != null ? v.description : ""
        hello_interval        = v.hello_interval != null ? v.hello_interval : 10
        name                  = v.name != null ? v.name : "default"
        name_alias            = v.name_alias != null ? v.name_alias : ""
        network_type          = v.network_type != null ? v.network_type : "bcast"
        priority              = v.priority != null ? v.priority : 1
        retransmit_interval   = v.retransmit_interval != null ? v.retransmit_interval : 5
        transmit_delay        = v.transmit_delay != null ? v.transmit_delay : 1
        tenant                = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  ospf_interface_policies = { for k, v in local.ospf_interface_policies_loop : v.name => v }

  ospf_route_summarization_policies_loop = flatten([
    for key, value in local.ospf_policies : [
      for k, v in value.ospf_route_summarization_policies : {
        annotation         = v.annotation != null ? v.annotation : ""
        cost               = v.cost != null ? v.cost : 0
        description        = v.description != null ? v.description : ""
        inter_area_enabled = v.inter_area_enabled != null ? v.inter_area_enabled : false
        name               = v.name != null ? v.name : "default"
        name_alias         = v.name_alias != null ? v.name_alias : ""
        tenant             = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  ospf_route_summarization_policies = { for k, v in local.ospf_route_summarization_policies_loop : v.name => v }

  ospf_timers_policies_loop = flatten([
    for key, value in local.ospf_policies : [
      for k, v in value.ospf_timers_policies : {
        annotation                                  = v.annotation != null ? v.annotation : ""
        bandwidth_reference                         = v.bandwidth_reference != null ? v.bandwidth_reference : 400000
        description                                 = v.description != null ? v.description : ""
        admin_distance_preference                   = v.admin_distance_preference != null ? v.admin_distance_preference : 110
        graceful_restart_helper                     = v.graceful_restart_helper != null ? v.graceful_restart_helper : true
        initial_spf_scheduled_delay_interval        = v.initial_spf_scheduled_delay_interval != null ? v.initial_spf_scheduled_delay_interval : 200
        lsa_group_pacing_interval                   = v.lsa_group_pacing_interval != null ? v.lsa_group_pacing_interval : 10
        lsa_generation_throttle_hold_interval       = v.lsa_generation_throttle_hold_interval != null ? v.lsa_generation_throttle_hold_interval : 5000
        lsa_generation_throttle_maximum_interval    = v.lsa_generation_throttle_maximum_interval != null ? v.lsa_generation_throttle_maximum_interval : 5000
        lsa_generation_throttle_start_wait_interval = v.lsa_generation_throttle_start_wait_interval != null ? v.lsa_generation_throttle_start_wait_interval : 0
        lsa_maximum_action                          = v.lsa_maximum_action != null ? v.lsa_maximum_action : "reject"
        lsa_threshold                               = v.lsa_threshold != null ? v.lsa_threshold : 75
        maximum_ecmp                                = v.maximum_ecmp != null ? v.maximum_ecmp : 8
        maximum_lsa_reset_interval                  = v.maximum_lsa_reset_interval != null ? v.maximum_lsa_reset_interval : 10
        maximum_lsa_sleep_count                     = v.maximum_lsa_sleep_count != null ? v.maximum_lsa_sleep_count : 5
        maximum_lsa_sleep_interval                  = v.maximum_lsa_sleep_interval != null ? v.maximum_lsa_sleep_interval : 5
        maximum_number_of_not_self_generated_lsas   = v.maximum_number_of_not_self_generated_lsas != null ? v.maximum_number_of_not_self_generated_lsas : 20000
        minimum_hold_time_between_spf_calculations  = v.minimum_hold_time_between_spf_calculations != null ? v.minimum_hold_time_between_spf_calculations : 1000
        minimum_interval_between_arrival_of_a_lsa   = v.minimum_interval_between_arrival_of_a_lsa != null ? v.minimum_interval_between_arrival_of_a_lsa : 1000
        maximum_wait_time_between_spf_calculations  = v.maximum_wait_time_between_spf_calculations != null ? v.maximum_wait_time_between_spf_calculations : 5000
        name                                        = v.name != null ? v.name : "default"
        name_alias                                  = v.name_alias != null ? v.name_alias : ""
        name_lookup = v.control_knobs != null ? lookup(
          v.control_knobs[0], "enable_name_lookup_for_router_ids", false
        ) : false
        prefix_suppress = v.control_knobs != null ? lookup(
          v.control_knobs[0], "prefix_suppress", false
        ) : false
        tenant = v.tenant != null ? v.tenant : "common"
      }
    ]
  ])

  ospf_timers_policies = { for k, v in local.ospf_timers_policies_loop : v.name => v }


  #__________________________________________________________
  #
  # L3Out Variables
  #__________________________________________________________

  #==================================
  # L3Outs
  #==================================

  l3outs = {
    for k, v in var.l3outs : k => {
      annotation      = v.annotation != null ? v.annotation : ""
      controller_type = v.controller_type != null ? v.controller_type : "apic"
      description     = v.description != null ? v.description : ""
      external_epgs   = v.external_epgs != null ? v.external_epgs : []
      import = v.route_control_enforcement != null ? lookup(
        v.route_control_enforcement[0], "import", false
      ) : false
      l3_domain               = v.l3_domain != null ? v.l3_domain : ""
      level                   = v.level != null ? v.level : "template"
      name_alias              = v.name_alias != null ? v.name_alias : ""
      node_profiles           = v.node_profiles != null ? v.node_profiles : []
      ospf_external_policies  = v.ospf_external_policies != null ? v.ospf_external_policies : []
      ospf_interface_profiles = v.ospf_interface_profiles != null ? v.ospf_interface_profiles : []
      route_control_for_dampening = v.route_control_for_dampening != null ? [
        for key, value in v.route_control_for_dampening : {
          address_family = value.address_family != null ? value.address_family : "ipv4"
          route_map      = value.route_map
          tenant         = value.tenant != null ? value.tenant : v.tenant
        }
      ] : []
      target_dscp       = v.target_dscp != null ? v.target_dscp : "unspecified"
      sites             = v.sites != null ? v.sites : []
      tags              = v.tags != null ? v.tags : []
      template          = v.template != null ? v.template : "common"
      tenant            = v.tenant != null ? v.tenant : "common"
      controller_vendor = v.controller_vendor != null ? v.controller_vendor : "cisco"
      vrf               = v.vrf != null ? v.vrf : "default"
      vrf_tenant        = v.vrf_tenant != null ? v.vrf_tenant : "common"
    }
  }

  #==================================
  # L3Outs - External EPGs
  #==================================

  external_epgs_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.external_epgs : {
        annotation             = value.annotation
        contract_exception_tag = v.contract_exception_tag != null ? v.contract_exception_tag : 0
        contracts              = v.contracts != null ? v.contracts : []
        controller_type        = value.controller_type
        description            = v.description != null ? v.description : ""
        flood_on_encapsulation = v.flood_on_encapsulation != null ? v.flood_on_encapsulation : "disabled"
        l3out                  = key
        match_type             = v.match_type != null ? v.match_type : "AtleastOne"
        name                   = v.name != null ? v.name : "default"
        name_alias             = v.name_alias != null ? v.name_alias : ""
        preferred_group_member = v.preferred_group_member != null ? v.preferred_group_member : "exclude"
        qos_class              = v.qos_class != null ? v.qos_class : "unspecified"
        subnets                = v.subnets != null ? v.subnets : []
        target_dscp            = v.target_dscp != null ? v.target_dscp : "unspecified"
        epg_type               = v.epg_type != null ? v.epg_type : "default"
        route_control_profiles = v.route_control_profiles != null ? {
          for a, b in v.route_control_profiles : a => {
            direction = b.direction
            route_map = b.route_map
            tenant    = b.tenant != null ? b.tenant : value.tenant
          }
        } : {}
        tenant = value.tenant
      }
    ]
  ])
  l3out_external_epgs = { for k, v in local.external_epgs_loop : "${v.l3out}_${v.epg_type}_${v.name}" => v }

  ext_epg_contracts_loop = flatten([
    for key, value in local.l3out_external_epgs : [
      for k, v in value.contracts : {
        annotation      = value.annotation
        contract        = v.contract_name
        contract_tenant = v.contract_tenant != null ? v.contract_tenant : "common"
        contract_type   = v.contract_type != null ? v.contract_type : "consumer"
        controller_type = value.controller_type
        epg             = value.name
        l3out           = value.l3out
        qos_class       = v.qos_class
        tenant          = value.tenant
      }
    ]
  ])
  l3out_ext_epg_contracts = { for k, v in local.ext_epg_contracts_loop : "${v.l3out}_${v.epg}_${v.contract_type}_${v.contract}" => v }

  external_epg_subnets_loop = flatten([
    for key, value in local.l3out_external_epgs : [
      for k, v in value.subnets : {
        agg_export      = v.aggregate != null ? lookup(v.aggregate[0], "aggregate_export", false) : false
        agg_shared      = v.aggregate != null ? lookup(v.aggregate[0], "aggregate_shared_routes", false) : false
        annotation      = value.annotation
        controller_type = value.controller_type
        description     = v.description != null ? v.description : ""
        epg_type        = value.epg_type
        ext_epg         = key
        route_control_profiles = v.route_control_profiles != null ? {
          for a, b in v.route_control_profiles : a => {
            direction = b.direction
            route_map = b.route_map
            tenant    = b.tenant != null ? b.tenant : value.tenant
          }
        } : {}
        route_summarization_policy = v.route_summarization_policy != null ? v.route_summarization_policy : ""
        scope_isec = v.external_epg_classification != null ? lookup(
          v.external_epg_classification[0], "external_subnets_for_external_epg", true
        ) : true
        scope_ishared = v.external_epg_classification != null ? lookup(
          v.external_epg_classification[0], "shared_security_import_subnet", false
        ) : false
        scope_export = v.route_control != null ? lookup(v.route_control[0], "export_route_control_subnet", false) : false
        scope_shared = v.route_control != null ? lookup(v.route_control[0], "shared_route_control_subnet", false) : false
        subnet       = v.subnet != null ? v.subnet : "0.0.0.0/1"
      }
    ]
  ])
  l3out_external_epg_subnets = { for k, v in local.external_epg_subnets_loop : "${v.ext_epg}_${v.subnet}" => v }


  #==================================
  # L3Outs - Node Profiles
  #==================================

  node_profiles_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.node_profiles : {
        annotation              = value.annotation
        color_tag               = v.color_tag != null ? v.color_tag : "yellow-green"
        controller_type         = value.controller_type
        description             = v.description != null ? v.description : ""
        interface_profiles      = v.interface_profiles != null ? v.interface_profiles : []
        l3out                   = key
        name                    = v.name
        nodes                   = v.nodes != null ? v.nodes : []
        ospf_interface_profiles = value.ospf_interface_profiles
        pod_id                  = v.pod_id != null ? v.pod_id : 1
        target_dscp             = value.target_dscp
        tenant                  = value.tenant
      }
    ]
  ])
  l3out_node_profiles = { for k, v in local.node_profiles_loop : "${v.l3out}_${v.name}" => v }

  nodes_loop = flatten([
    for key, value in local.l3out_node_profiles : [
      for k, v in value.nodes : {
        annotation                = value.annotation
        controller_type           = value.controller_type
        node_id                   = v.node_id != null ? v.node_id : 201
        node_profile              = key
        pod_id                    = value.pod_id
        router_id                 = v.router_id != null ? v.router_id : "198.18.0.1"
        use_router_id_as_loopback = v.use_router_id_as_loopback != null ? v.use_router_id_as_loopback : true
      }
    ]
  ])
  l3out_node_profiles_nodes = { for k, v in local.nodes_loop : "${v.node_profile}_${v.node_id}" => v }

  #==================================
  # L3Outs - Node Interface Profiles
  #==================================

  interface_profiles_loop = flatten([
    for key, value in local.l3out_node_profiles : [
      for k, v in value.interface_profiles : {
        annotation                  = value.annotation
        arp_policy                  = v.arp_policy != null ? v.arp_policy : ""
        auto_state                  = v.auto_state != null ? v.auto_state : "disabled"
        color_tag                   = value.color_tag
        controller_type             = value.controller_type
        custom_qos_policy           = v.custom_qos_policy != null ? v.custom_qos_policy : ""
        description                 = v.description != null ? v.description : ""
        egress_data_plane_policing  = v.egress_data_plane_policing != null ? v.egress_data_plane_policing : ""
        encapsulation_scope         = v.encapsulation_scope != null ? v.encapsulation_scope : "local"
        encapsulation_vlan          = v.encapsulation_vlan != null ? v.encapsulation_vlan : 1
        ingress_data_plane_policing = v.ingress_data_plane_policing != null ? v.ingress_data_plane_policing : ""
        interface                   = v.interface != null ? v.interface : "eth1/1"
        interface_type              = v.interface_type != null ? v.interface_type : "l3-port"
        ipv6_dad                    = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        link_local_address          = v.link_local_address != null ? v.link_local_address : "::"
        mac_address                 = v.mac_address != null ? v.mac_address : "00:22:BD:F8:19:FF"
        mode                        = v.mode != null ? v.mode : "regular"
        mtu                         = v.mtu != null ? v.mtu : "inherit" # 576 to 9216
        name                        = v.name != null ? v.name : "default"
        nd_policy                   = v.nd_policy != null ? v.nd_policy : ""
        netflow_policies            = v.netflow_policies != null ? v.netflow_policies : []
        node_profile                = key
        nodes                       = v.nodes != null ? v.nodes : [201]
        ospf_interface_profile      = v.ospf_interface_profile != null ? v.ospf_interface_profile : ""
        pod_id                      = value.pod_id
        preferred_address           = v.preferred_address != null ? v.preferred_address : "198.18.1.1/24"
        qos_class                   = v.qos_class != null ? v.qos_class : "unspecified"
        secondary_addresses         = v.secondary_addresses != null ? v.secondary_addresses : []
        secondaries_keys            = v.secondary_addresses != null ? range(length(v.secondary_addresses)) : []
        svi_addresses               = v.svi_addresses != null ? v.svi_addresses : []
        target_dscp                 = value.target_dscp
        tenant                      = value.tenant
      }
    ]
  ])
  l3out_interface_profiles = { for k, v in local.interface_profiles_loop : "${v.node_profile}_${v.name}" => v }


  svi_addressing_loop = flatten([
    for key, value in local.l3out_interface_profiles : [
      for k, v in value.interface_profiles : {
        annotation          = value.annotation
        ipv6_dad            = value.ipv6_dad
        link_local_address  = v.link_local_address != null ? v.link_local_address : "::"
        path                = key
        preferred_address   = v.preferred_address != null ? v.preferred_address : "198.18.1.1/24"
        secondary_addresses = v.secondary_addresses != null ? v.secondary_addresses : []
        secondaries_keys    = v.secondary_addresses != null ? range(length(v.secondary_addresses)) : []
        side                = v.side != null ? v.side : "A"
        type                = value.type
      }
    ] if value.interface_type == "ext-svi"
  ])
  l3out_paths_svi_addressing = { for k, v in local.svi_addressing_loop : "${v.path}_${v.side}" => v }

  secondaries_loop_1 = flatten([
    for k, v in local.l3out_interface_profiles : [
      for s in v.secondaries_keys : {
        annotation           = v.annotation
        controller_type      = v.controller_type
        ipv6_dad             = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        key1                 = "${k}-${s}"
        l3out_path           = k
        secondary_ip_address = element(v.secondary_addresses, s)
      }
    ]
  ])
  interface_secondaries = { for k, v in local.secondaries_loop_1 : "${v.key1}" => v }
  secondaries_loop_2 = flatten([
    for k, v in local.l3out_paths_svi_addressing : [
      for s in v.secondaries_keys : {
        annotation           = v.annotation
        controller_type      = v.controller_type
        ipv6_dad             = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        key1                 = "${k}-${s}"
        l3out_path           = k
        secondary_ip_address = element(v.secondary_addresses, s)
      }
    ]
  ])
  svi_secondaries           = { for k, v in local.secondaries_loop_2 : "${v.key1}" => v }
  l3out_paths_secondary_ips = merge(local.interface_secondaries, local.svi_secondaries)


  #==================================
  # L3Outs - OSPF External Policies
  #==================================

  ospf_process_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.ospf_external_policies : {
        annotation     = value.annotation
        l3out          = key
        ospf_area_cost = v.ospf_area_cost != null ? v.ospf_area_cost : 1
        ospf_area_id   = v.ospf_area_id != null ? v.ospf_area_id : "0.0.0.0"
        ospf_area_type = v.ospf_area_type != null ? v.ospf_area_type : "regular"
        redistribute = v.ospf_area_control != null ? lookup(
          v.ospf_area_control[0], "send_redistribution_lsas_into_nssa_area", true
        ) : true
        summary = v.ospf_area_control != null ? lookup(
          v.ospf_area_control[0], "originate_summary_lsa", true
        ) : true
        suppress_fa = v.ospf_area_control != null ? lookup(
          v.ospf_area_control[0], "suppress_forwarding_address", false
        ) : false
        type = value.type
      }
    ]
  ])
  l3out_ospf_external_policies = { for k, v in local.ospf_process_loop : "${v.l3out}_ospf_external" => v }

  #==================================
  # L3Outs - OSPF Interface Profiles
  #==================================

  ospf_profiles_loop_1 = flatten([
    for key, value in local.l3outs : [
      for k, v in value.ospf_interface_profiles : {
        annotation            = value.annotation
        authentication_type   = v.authentication_type != null ? v.authentication_type : "none"
        description           = v.description != null ? v.description : ""
        l3out                 = key
        name                  = v.name != null ? v.name : "default"
        ospf_key              = v.ospf_key != null ? v.ospf_key : 0
        ospf_interface_policy = v.ospf_interface_policy != null ? v.ospf_interface_policy : "default"
        policy_tenant         = v.policy_tenant != null ? v.policy_tenant : "common"
        tenant                = value.tenant
        type                  = value.type
      }
    ]
  ])
  ospf_interface_profiles = { for k, v in local.ospf_profiles_loop_1 : "${v.l3out}_${v.name}" => v }

  ospf_profiles_loop_2 = flatten([
    for key, value in local.ospf_interface_profiles : [
      for k, v in local.l3out_interface_profiles : {
        annotation            = value.annotation
        authentication_type   = value.authentication_type
        description           = value.description
        interface_profile     = k
        name                  = value.name
        ospf_key              = value.ospf_key
        ospf_interface_policy = value.ospf_interface_policy
        policy_tenant         = value.policy_tenant
        tenant                = v.tenant
        type                  = value.type
      } if value.name == v.ospf_interface_profile
    ]
  ])
  l3out_ospf_interface_profiles = { for k, v in local.ospf_profiles_loop_2 : "${v.interface_profile}_${v.name}" => v }

  #__________________________________________________________
  #
  # Route Map Match Rule Variables
  #__________________________________________________________

  route_map_match_rules = {
    for k, v in var.route_map_match_rules : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
      rules       = v.rules != null ? v.rules : {}
      tenant      = v.tenant != null ? v.tenant : "common"
    }
  }

  match_rule_rules_loop = flatten([
    for key, value in local.route_map_match_rules : [
      for k, v in value.rules : {
        community      = v.community != null ? v.community : ""
        community_type = v.community_type != null ? v.community_type : "regular"
        description    = v.description != null ? v.description : ""
        greater_than   = v.greater_than != null ? v.greater_than : 0
        less_than      = v.less_than != null ? v.less_than : 0
        network        = v.network != null ? v.network : "198.18.0.0/24"
        regex          = v.regex != null ? v.regex : ""
        match_rule     = key
        type           = v.type
        tenant         = value.tenant
      }
    ]
  ])

  match_rule_rules = { for k, v in local.match_rule_rules_loop : "${v.match_rule}_${v.type}" => v }


  #__________________________________________________________
  #
  # Route Map Set Rule Variables
  #__________________________________________________________

  route_map_set_rules = {
    for k, v in var.route_map_set_rules : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      name_alias  = v.name_alias != null ? v.name_alias : ""
      rules       = v.rules != null ? v.rules : []
      tenant      = v.tenant != null ? v.tenant : "common"
    }
  }

  set_rule_rules_loop = flatten([
    for key, value in local.route_map_set_rules : [
      for k, v in value.rules : {
        address           = v.address != null ? v.address : "198.18.0.1"
        asns              = v.asns != null ? v.asns : []
        asns_keys         = v.asns != null ? range(length(v.asns)) : []
        communities       = v.communities != null ? v.communities : {}
        criteria          = v.criteria != null ? v.criteria : "prepend"
        half_life         = v.half_life != null ? v.half_life : 15
        last_as_count     = v.last_as_count != null ? v.last_as_count : 0
        max_suprress_time = v.max_suprress_time != null ? v.max_suprress_time : 60
        metric            = v.metric != null ? v.metric : 100
        metric_type       = v.metric_type != null ? v.metric_type : "ospf-type1"
        preference        = v.preference != null ? v.preference : 100
        reuse_limit       = v.reuse_limit != null ? v.reuse_limit : 750
        set_rule          = key
        suppress_limit    = v.suppress_limit != null ? v.suppress_limit : 2000
        route_tag         = v.route_tag != null ? v.route_tag : 1
        type              = v.type
        weight            = v.weight != null ? v.weight : 0
        tenant            = value.tenant
      }
    ]
  ])

  set_rule_rules = { for k, v in local.set_rule_rules_loop : "${v.set_rule}_${v.type}" => v }

  set_rule_asn_rules = {
    for k, v in local.set_rule_rules : k => {
      autonomous_systems = {
        for s in v.asns_keys : s => {
          asn   = element(v.asns, s)
          order = s
        } if v.criteria == "prepend"
      }
      criteria      = v.criteria
      last_as_count = v.criteria == "prepend-last-as" ? v.last_as_count : 0
      set_rule      = v.set_rule
      tenant        = v.tenant
      type          = v.type
    } if v.type == "set_as_path"
  }

  set_rule_communities_loop = flatten([
    for key, value in local.set_rule_rules : [
      for k, v in value.communities : {
        community    = v.community
        description  = v.description != null ? v.description : ""
        index        = k
        set_criteria = v.set_criteria != null ? v.set_criteria : "append"
        set_rule     = value.set_rule
        type         = value.type
        tenant       = value.tenant
      }
    ]
  ])

  set_rule_communities = { for k, v in local.set_rule_communities_loop : "${v.set_rule}_${v.type}_${v.index}" => v }


  #__________________________________________________________
  #
  # Route Maps Rule Variables
  #__________________________________________________________

  route_maps_for_route_control = {
    for k, v in var.route_maps_for_route_control : k => {
      annotation         = v.annotation != null ? v.annotation : ""
      description        = v.description != null ? v.description : ""
      match_rules        = v.match_rules != null ? v.match_rules : {}
      name_alias         = v.name_alias != null ? v.name_alias : ""
      route_map_continue = v.route_map_continue != null ? v.route_map_continue : false
      tenant             = v.tenant != null ? v.tenant : "common"
    }
  }

  route_maps_context_rules_loop = flatten([
    for key, value in local.route_maps_for_route_control : [
      for k, v in value.match_rules : {
        action      = v.action
        annotation  = value.annotation
        ctx_name    = k
        description = v.description != null ? v.description : ""
        name        = v.name
        order       = v.order
        route_map   = key
        set_rule    = v.set_rule != null ? v.set_rule : ""
        tenant      = value.tenant
      }
    ]
  ])

  route_maps_context_rules = { for k, v in local.route_maps_context_rules_loop : "${v.route_map}_${v.ctx_name}" => v }


  #__________________________________________________________
  #
  # Schema Variables
  #__________________________________________________________

  schemas = {
    for k, v in var.schemas : k => {
      primary_template = v.primary_template
      tenant           = v.tenant
      templates        = v.templates
    }
  }

  schema_templates_loop = flatten([
    for key, value in local.schemas : [
      for k, v in value.templates : {
        name             = v.name
        key1             = key
        primary_template = value.primary_template
        schema           = key
        sites            = v.sites
        tenant           = value.tenant
      }
    ]
  ])

  schema_templates = { for k, v in local.schema_templates_loop : "${v.key1}_${v.name}" => v }


  templates_sites_loop = flatten([
    for k, v in local.schema_templates : [
      for s in v.sites : {
        name   = v.name
        key1   = v.key1
        schema = v.schema
        site   = s
      }
    ]
  ])

  template_sites = { for k, v in local.templates_sites_loop : "${v.key1}_${v.site}" => v }

  #__________________________________________________________
  #
  # Tenant Variables
  #__________________________________________________________

  tenants = {
    for k, v in var.tenants : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      controller_type   = v.controller_type != null ? v.controller_type : "apic"
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : ""
      name_alias        = v.name_alias != null ? v.name_alias : ""
      sites = v.sites != null ? [
        for key, value in v.sites : {
          aws_access_key_id         = value.aws_access_key_id != null ? value.aws_access_key_id : ""
          aws_account_id            = value.aws_account_id != null ? value.aws_account_id : ""
          azure_access_type         = value.azure_access_type != null ? value.azure_access_type : "managed"
          azure_active_directory_id = value.azure_active_directory_id != null ? value.azure_active_directory_id : ""
          azure_application_id      = value.azure_application_id != null ? value.azure_application_id : ""
          azure_shared_account_id   = value.azure_shared_account_id != null ? value.azure_shared_account_id : ""
          azure_subscription_id     = value.azure_subscription_id != null ? value.azure_subscription_id : ""
          is_aws_account_trusted    = value.is_aws_account_trusted != null ? value.is_aws_account_trusted : false
          site                      = value.site
          vendor                    = value.vendor != null ? value.vendor : "cisco"
        }
      ] : []
      users = v.users != null ? v.users : []
    }
  }

  #__________________________________________________________
  #
  # VRF Variables
  #__________________________________________________________

  vrfs = {
    for k, v in var.vrfs : k => {
      annotation                      = v.annotation != null ? v.annotation : ""
      bd_enforcement_status           = v.bd_enforcement_status != null ? v.bd_enforcement_status : false
      bgp_timers_per_address_family   = v.bgp_timers_per_address_family != null ? v.bgp_timers_per_address_family : []
      bgp_timers                      = v.bgp_timers != null ? v.bgp_timers : "default"
      communities                     = v.communities != null ? v.communities : []
      contracts                       = v.contracts != null ? v.contracts : []
      controller_type                 = v.controller_type != null ? v.controller_type : "apic"
      controller_vendor               = v.controller_vendor != null ? v.controller_vendor : "cisco"
      description                     = v.description != null ? v.description : ""
      endpoint_retention_policy       = v.endpoint_retention_policy != null ? v.endpoint_retention_policy : "default"
      eigrp_timers_per_address_family = v.eigrp_timers_per_address_family != null ? v.eigrp_timers_per_address_family : []
      ip_data_plane_learning          = v.ip_data_plane_learning != null ? v.ip_data_plane_learning : "enabled"
      layer3_multicast                = v.layer3_multicast != null ? v.layer3_multicast : true
      level                           = v.level != null ? v.level : "template"
      monitoring_policy               = v.monitoring_policy != null ? v.monitoring_policy : ""
      name_alias                      = v.name_alias != null ? v.name_alias : ""
      ospf_timers_per_address_family  = v.ospf_timers_per_address_family != null ? v.ospf_timers_per_address_family : []
      ospf_timers                     = v.ospf_timers != null ? v.ospf_timers : "default"
      policy_enforcement_direction    = v.policy_enforcement_direction != null ? v.policy_enforcement_direction : "ingress"
      policy_enforcement_preference   = v.policy_enforcement_preference != null ? v.policy_enforcement_preference : "enforced"
      preferred_group                 = v.preferred_group != null ? v.preferred_group : "disabled"
      sites                           = v.sites != null ? v.sites : []
      schema                          = v.schema != null ? v.schema : "common"
      tags                            = v.tags != null ? v.tags : []
      template                        = v.template != null ? v.template : ""
      tenant                          = v.tenant != null ? v.tenant : "common"
      transit_route_tag_policy        = v.transit_route_tag_policy != null ? v.transit_route_tag_policy : ""
    }
  }

  vrf_communities_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.communities : {
        annotation = value.annotation
        community  = v.community
        vrf        = key
      }
    ]
  ])

  vrf_communities = { for k, v in local.vrf_communities_loop : "${v.vrf}_${v.community}" => v }

  vrf_tags_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.tags : {
        key   = value.key
        value = v.value
        type  = value.type
        vrf   = key
      }
    ]
  ])

  vrf_tags = { for k, v in local.vrf_tags_loop : "${v.vrf}_${v.key}" => v }

  vzany_contracts_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.contracts : {
        annotation        = value.annotation
        contract          = v.name != null ? v.name : ""
        contract_type     = v.type != null ? v.type : "consumer" # interface|provider
        contract_schema   = v.schema != null ? v.schema : value.schema
        contract_tenant   = v.tenant != null ? v.tenant : value.tenant
        contract_template = v.template != null ? v.template : value.template
        match_type        = v.match_type != null ? v.match_type : "AtleastOne"
        qos_class         = v.qos_class != null ? v.qos_class : "unspecified"
        schema            = value.schema
        template          = value.template
        tenant            = value.tenant
        type              = value.type
        vrf               = key
      }
    ]
  ])

  vzany_contracts = { for k, v in local.vzany_contracts_loop : "${v.vrf}_${v.contract_type}" => v }

}