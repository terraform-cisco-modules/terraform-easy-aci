locals {
  # Terraform Cloud Remote Resources - Policies
  rs_contracts          = {}
  rs_filters            = {}
  rs_mso_filter_entries = {}
  rs_schemas            = {}
  # rs_schemas  = lookup(data.terraform_remote_state.policies.outputs, "adapter_configuration_policies", {})

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
      hold_interval                  = v.hold_interval != null ? v.hold_interval : 300
      local_endpoint_aging_interval  = v.local_endpoint_aging_interval != null ? v.local_endpoint_aging_interval : 900
      move_frequency                 = v.move_frequency != null ? v.move_frequency : 256
      remote_endpoint_aging_interval = v.remote_endpoint_aging_interval != null ? v.remote_endpoint_aging_interval : 900
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
      route_map_continue = v.route_map_continue != null ? v.route_map_continue : "no"
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
      bd_enforcement_status           = v.bd_enforcement_status != null ? v.bd_enforcement_status : "no"
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