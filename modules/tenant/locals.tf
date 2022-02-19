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
      alias             = v.alias != null ? v.alias : ""
      annotation        = v.annotation != null ? v.annotation : ""
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : "default"
      qos_class         = v.qos_class != null ? v.qos_class : "unspecified"
      schema            = v.schema != null ? v.schema : "common"
      template          = v.template != null ? v.template : "common"
      tenant            = v.tenant != null ? v.tenant : "common"
      type              = v.type != null ? v.type : "apic"
    }
  }


  #__________________________________________________________
  #
  # Contract Variables
  #__________________________________________________________

  contracts = {
    for k, v in var.contracts : k => {
      alias                = v.alias != null ? v.alias : ""
      annotation           = v.annotation != null ? v.annotation : ""
      contract_type        = v.contract_type != null ? v.contract_type : "standard"
      consumer_match_type  = v.consumer_match_type != null ? v.consumer_match_type : "AtleastOne"
      description          = v.description != null ? v.description : ""
      filters              = v.filters != null ? v.filters : []
      log_packets          = v.log_packets != null ? v.log_packets : false
      qos_class            = v.qos_class != null ? v.qos_class : "unspecified"
      provider_match_type  = v.provider_match_type != null ? v.provider_match_type : "AtleastOne"
      reverse_filter_ports = v.reverse_filter_ports != null ? v.reverse_filter_ports : true
      schema               = v.schema != null ? v.schema : "common"
      scope                = v.scope != null ? v.scope : "context"
      tags                 = v.tags != null ? v.tags : []
      target_dscp          = v.target_dscp != null ? v.target_dscp : "unspecified"
      template             = v.template != null ? v.template : "common"
      tenant               = v.tenant != null ? v.tenant : "common"
      type                 = v.type != null ? v.type : "apic"
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
    ] if value.type == "apic"
  ])

  apic_contract_filters = { for k, v in local.apic_contract_filters_loop : "${v.contract}_${v.name}" => v }

  contract_subjects = {
    for k, v in local.contracts : k => {
      alias                = v.alias
      annotation           = v.annotation
      contract_type        = v.contract_type
      consumer_match_type  = v.consumer_match_type
      description          = v.description
      filters              = [for key, value in local.apic_contract_filters : value.filter if value.contract == k]
      log_packets          = v.log_packets != null ? v.log_packets : false
      qos_class            = v.qos_class
      provider_match_type  = v.provider_match_type
      reverse_filter_ports = v.reverse_filter_ports
      schema               = v.schema
      scope                = v.scope
      tags                 = v.tags
      target_dscp          = v.target_dscp
      template             = v.template
      tenant               = v.tenant
      type                 = v.type
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

  endpoint_retention_policies = {
    for k, v in var.endpoint_retention_policies : k => {
      alias                          = v.alias != null ? v.alias : ""
      annotation                     = v.annotation != null ? v.annotation : ""
      bounce_entry_aging_interval    = v.bounce_entry_aging_interval != null ? v.bounce_entry_aging_interval : 630
      bounce_trigger                 = v.bounce_trigger != null ? v.bounce_trigger : "protocol"
      description                    = v.description != null ? v.description : ""
      hold_interval                  = v.hold_interval != null ? v.hold_interval : "300"
      local_endpoint_aging_interval  = v.local_endpoint_aging_interval != null ? v.local_endpoint_aging_interval : "900"
      move_frequency                 = v.move_frequency != null ? v.move_frequency : "256"
      remote_endpoint_aging_interval = v.remote_endpoint_aging_interval != null ? v.remote_endpoint_aging_interval : "900"
      tenant                         = v.tenant != null ? v.tenant : "common"
    }
  }


  #__________________________________________________________
  #
  # Filter Variables
  #__________________________________________________________

  filters = {
    for k, v in var.filters : k => {
      alias          = v.alias != null ? v.alias : ""
      annotation     = v.annotation != null ? v.annotation : ""
      description    = v.description != null ? v.description : ""
      filter_entries = v.filter_entries != null ? v.filter_entries : []
      schema         = v.schema != null ? v.schema : "common"
      template       = v.template != null ? v.template : "common"
      tenant         = v.tenant != null ? v.tenant : "common"
      type           = v.type != null ? v.type : "apic"
    }
  }

  filter_entries_loop = flatten([
    for key, value in local.filters : [
      for k, v in value.filter_entries : {
        alias                 = v.alias != null ? v.alias : ""
        annotation            = v.annotation != null ? v.annotation : ""
        arp_flag              = v.arp_flag != null ? v.arp_flag : "unspecified"
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
        type                  = value.type
      }
    ]
  ])

  filter_entries = { for k, v in local.filter_entries_loop : "${v.filter_name}_${v.name}" => v }

  #__________________________________________________________
  #
  # Endpoint Retention Policy Variables
  #__________________________________________________________

  ospf_interface_policies = {
    for k, v in var.ospf_interface_policies : k => {
      adv_subnet          = v.interface_controls != null ? lookup(v.interface_controls[0], "advertise_subnet", false) : false
      bfd                 = v.interface_controls != null ? lookup(v.interface_controls[0], "bfd", false) : false
      mtu_ignore          = v.interface_controls != null ? lookup(v.interface_controls[0], "mtu_ignore", false) : false
      passive             = v.interface_controls != null ? lookup(v.interface_controls[0], "passive_participation", false) : false
      alias               = v.alias != null ? v.alias : ""
      annotation          = v.annotation != null ? v.annotation : ""
      cost_of_interface   = v.cost_of_interface != null ? v.cost_of_interface : 0
      dead_interval       = v.dead_interval != null ? v.dead_interval : 40
      description         = v.description != null ? v.description : ""
      hello_interval      = v.hello_interval != null ? v.hello_interval : 10
      network_type        = v.network_type != null ? v.network_type : "bcast"
      priority            = v.priority != null ? v.priority : 1
      retransmit_interval = v.retransmit_interval != null ? v.retransmit_interval : 5
      transmit_delay      = v.transmit_delay != null ? v.transmit_delay : 1
      tenant              = v.tenant != null ? v.tenant : "common"
    }
  }


  #__________________________________________________________
  #
  # L3Out Variables
  #__________________________________________________________

  #==================================
  # L3Outs
  #==================================

  l3outs = {
    for k, v in var.l3outs : k => {
      alias         = v.alias != null ? v.alias : ""
      annotation    = v.annotation != null ? v.annotation : ""
      description   = v.description != null ? v.description : ""
      external_epgs = v.external_epgs != null ? v.external_epgs : []
      import = v.route_control_enforcement != null ? lookup(
        v.route_control_enforcement[0], "import", false
      ) : false
      l3_domain               = v.l3_domain != null ? v.l3_domain : ""
      level                   = v.level != null ? v.level : "template"
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
      target_dscp = v.target_dscp != null ? v.target_dscp : "unspecified"
      sites       = v.sites != null ? v.sites : []
      tags        = v.tags != null ? v.tags : []
      template    = v.template != null ? v.template : "common"
      tenant      = v.tenant != null ? v.tenant : "common"
      type        = v.type != null ? v.type : "apic"
      vendor      = v.vendor != null ? v.vendor : "cisco"
      vrf         = v.vrf != null ? v.vrf : "default"
      vrf_tenant  = v.vrf_tenant != null ? v.vrf_tenant : "common"
    }
  }

  #==================================
  # L3Outs - External EPGs
  #==================================

  external_epgs_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.external_epgs : {
        alias                  = v.alias != null ? v.alias : ""
        annotation             = value.annotation
        contract_exception_tag = v.contract_exception_tag != null ? v.contract_exception_tag : 0
        contracts              = v.contracts != null ? v.contracts : []
        description            = v.description != null ? v.description : ""
        flood_on_encapsulation = v.flood_on_encapsulation != null ? v.flood_on_encapsulation : "disabled"
        l3out                  = key
        match_type             = v.match_type != null ? v.match_type : "AtleastOne"
        name                   = v.name != null ? v.name : "default"
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
        type   = value.type
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
        epg             = value.name
        l3out           = value.l3out
        qos_class       = v.qos_class
        tenant          = value.tenant
        type            = value.type
      }
    ]
  ])
  l3out_ext_epg_contracts = { for k, v in local.ext_epg_contracts_loop : "${v.l3out}_${v.epg}_${v.contract_type}_${v.contract}" => v }

  external_epg_subnets_loop = flatten([
    for key, value in local.l3out_external_epgs : [
      for k, v in value.subnets : {
        agg_export  = v.aggregate != null ? lookup(v.aggregate[0], "aggregate_export", false) : false
        agg_shared  = v.aggregate != null ? lookup(v.aggregate[0], "aggregate_shared_routes", false) : false
        annotation  = value.annotation
        description = v.description != null ? v.description : ""
        epg_type    = value.epg_type
        ext_epg     = key
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
        type         = value.type
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
        description             = v.description != null ? v.description : ""
        interface_profiles      = v.interface_profiles != null ? v.interface_profiles : []
        l3out                   = key
        name                    = v.name
        nodes                   = v.nodes != null ? v.nodes : []
        ospf_interface_profiles = value.ospf_interface_profiles
        pod_id                  = v.pod_id != null ? v.pod_id : 1
        target_dscp             = value.target_dscp
        tenant                  = value.tenant
        type                    = value.type
      }
    ]
  ])
  l3out_node_profiles = { for k, v in local.node_profiles_loop : "${v.l3out}_${v.name}" => v }

  nodes_loop = flatten([
    for key, value in local.l3out_node_profiles : [
      for k, v in value.nodes : {
        annotation                = value.annotation
        node_id                   = v.node_id != null ? v.node_id : 201
        node_profile              = key
        pod_id                    = value.pod_id
        router_id                 = v.router_id != null ? v.router_id : "198.18.0.1"
        use_router_id_as_loopback = v.use_router_id_as_loopback != null ? v.use_router_id_as_loopback : true
        type                      = value.type
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
        type                        = value.type
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
        ipv6_dad             = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        key1                 = "${k}-${s}"
        l3out_path           = k
        secondary_ip_address = element(v.secondary_addresses, s)
        type                 = v.type
      }
    ]
  ])
  interface_secondaries = { for k, v in local.secondaries_loop_1 : "${v.key1}" => v }
  secondaries_loop_2 = flatten([
    for k, v in local.l3out_paths_svi_addressing : [
      for s in v.secondaries_keys : {
        annotation           = v.annotation
        ipv6_dad             = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        key1                 = "${k}-${s}"
        l3out_path           = k
        secondary_ip_address = element(v.secondary_addresses, s)
        type                 = v.type
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
      alias       = v.alias != null ? v.alias : ""
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
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
        type           = v.type != null ? v.type : v.type
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
      alias       = v.alias != null ? v.alias : ""
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
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
      alias              = v.alias != null ? v.alias : ""
      annotation         = v.annotation != null ? v.annotation : ""
      description        = v.description != null ? v.description : ""
      match_rules        = v.match_rules != null ? v.match_rules : {}
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
      alias             = v.alias != null ? v.alias : ""
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : ""
      sites             = v.sites != null ? v.sites : []
      annotation        = v.annotation != null ? v.annotation : ""
      type              = v.type != null ? v.type : "apic"
      users             = v.users != null ? v.users : []
      vendor            = v.vendor != null ? v.vendor : "cisco"
    }
  }

  #__________________________________________________________
  #
  # VRF Variables
  #__________________________________________________________

  vrfs = {
    for k, v in var.vrfs : k => {
      alias                           = v.alias != null ? v.alias : ""
      annotation                      = v.annotation != null ? v.annotation : ""
      bd_enforcement_status           = v.bd_enforcement_status != null ? v.bd_enforcement_status : false
      bgp_timers_per_address_family   = v.bgp_timers_per_address_family != null ? v.bgp_timers_per_address_family : []
      bgp_timers                      = v.bgp_timers != null ? v.bgp_timers : "default"
      communities                     = v.communities != null ? v.communities : []
      contracts                       = v.contracts != null ? v.contracts : []
      description                     = v.description != null ? v.description : ""
      endpoint_retention_policy       = v.endpoint_retention_policy != null ? v.endpoint_retention_policy : "default"
      eigrp_timers_per_address_family = v.eigrp_timers_per_address_family != null ? v.eigrp_timers_per_address_family : []
      ip_data_plane_learning          = v.ip_data_plane_learning != null ? v.ip_data_plane_learning : "enabled"
      layer3_multicast                = v.layer3_multicast != null ? v.layer3_multicast : true
      level                           = v.level != null ? v.level : "template"
      monitoring_policy               = v.monitoring_policy != null ? v.monitoring_policy : ""
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
      type                            = v.type != null ? v.type : "apic"
      vendor                          = v.vendor != null ? v.vendor : "cisco"
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