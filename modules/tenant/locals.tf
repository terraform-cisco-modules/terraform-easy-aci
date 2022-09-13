locals {
  #__________________________________________________________
  #
  # Use the First defined tenant as the default Tenant+
  #__________________________________________________________

  first_tenant = keys(local.tenants)[0]

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
      alias             = v.alias != null ? v.alias : ""
      qos_class         = v.qos_class != null ? v.qos_class : "unspecified"
      schema            = v.schema != null ? v.schema : local.first_tenant
      sites             = v.sites != null ? v.sites : []
      template          = v.template != null ? v.template : local.first_tenant
      tenant            = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  application_sites = flatten([
    for k, v in local.application_profiles : [
      for s in v.sites : {
        application_profile = k
        controller_type     = v.controller_type
        schema              = v.schema
        site                = s
        template            = v.template
      }
    ] if v.controller_type == "ndo"
  ])

  application_profile_sites = {
    for k, v in local.application_sites : "${v.application_profile}_${v.site}" => v
  }


  #__________________________________________________________
  #
  # Application EPGs Variables
  #__________________________________________________________

  application_epgs = {
    for k, v in var.application_epgs : k => {
      alias                  = v.alias != null ? v.alias : ""
      annotation             = v.annotation != null ? v.annotation : ""
      application_profile    = v.application_profile != null ? v.application_profile : "default"
      bd_schema              = v.bd_schema != null ? v.bd_schema : local.first_tenant
      bd_template            = v.bd_template != null ? v.bd_template : local.first_tenant
      bd_tenant              = v.bd_tenant != null ? v.bd_tenant : v.tenant
      bridge_domain          = v.bridge_domain != null ? v.bridge_domain : "default"
      contract_exception_tag = v.contract_exception_tag != null ? v.contract_exception_tag : ""
      contracts              = v.contracts != null ? v.contracts : []
      controller_type        = v.controller_type != null ? v.controller_type : "apic"
      custom_qos_policy      = v.custom_qos_policy != null ? v.custom_qos_policy : ""
      data_plane_policer     = v.data_plane_policer != null ? v.data_plane_policer : ""
      description            = v.description != null ? v.description : ""
      domains                = v.domains != null ? v.domains : []
      epg_admin_state        = v.epg_admin_state != null ? v.epg_admin_state : "admin_up"
      epg_contract_masters = v.epg_contract_masters != null ? [
        for s in v.epg_contract_masters : {
          application_profile = s.application_profile != null ? s.application_profile : v.application_profile
          application_epg     = s.application_epg
        }
      ] : []
      epg_to_aaeps = v.epg_to_aaeps != null ? [
        for s in v.epg_to_aaeps : {
          aaep                      = s.aaep
          instrumentation_immediacy = s.instrumentation_immediacy != null ? s.instrumentation_immediacy : "on-demand"
          mode                      = s.mode != null ? s.mode : "regular"
          vlans                     = s.vlans != null ? s.vlans : []
        }
      ] : []
      epg_type                 = v.epg_type != null ? v.epg_type : "standard"
      fhs_trust_control_policy = v.fhs_trust_control_policy != null ? v.fhs_trust_control_policy : ""
      flood_in_encapsulation   = v.flood_in_encapsulation != null ? v.flood_in_encapsulation : "disabled"
      global_alias             = v.global_alias != null ? v.global_alias : ""
      has_multicast_source     = v.has_multicast_source != null ? v.has_multicast_source : false
      intra_epg_isolation      = v.intra_epg_isolation != null ? v.intra_epg_isolation : "unenforced"
      label_match_criteria     = v.label_match_criteria != null ? v.label_match_criteria : "AtleastOne"
      monitoring_policy        = v.monitoring_policy != null ? v.monitoring_policy : "default"
      policy_source_tenant     = v.policy_source_tenant != null ? v.policy_source_tenant : local.first_tenant
      preferred_group_member   = v.preferred_group_member != null ? v.preferred_group_member : false
      qos_class                = v.qos_class != null ? v.qos_class : "unspecified"
      schema                   = v.schema != null ? v.schema : local.first_tenant
      # static_paths = v.static_paths != null ? compact(flatten([
      #   for s in v.static_paths : [
      #     length(regexall("vpc", s.path_type)
      #       ) > 0 ? "topology/pod-${s.pod}/protpaths-${element(s.nodes, 0)}-${element(s.nodes, 1)}/pathep-[${s.name}]" : length(
      #       regexall("pc", s.path_type)
      #       ) > 0 ? "topology/pod-${s.pod}/paths-${element(s.nodes, 0)}/pathep-[${s.name}]" : length(
      #       regexall("port", s.path_type)
      #     ) > 0 ? "topology/pod-${s.pod}/paths-${element(s.nodes, 0)}/pathep-[eth${s.name}]" : ""
      #   ]
      # ])) : []
      static_paths_for_loop = v.static_paths != null ? v.static_paths : []
      template              = v.template != null ? v.template : local.first_tenant
      tenant                = v.tenant != null ? v.tenant : local.first_tenant
      useg_epg              = v.useg_epg != null ? v.useg_epg : false
      vlan                  = v.vlan != null ? v.vlan : null
      vrf                   = v.vrf != null ? v.vrf : "default"
      vrf_schema            = v.vrf_schema != null ? v.vrf_schema : local.first_tenant
      vrf_template          = v.vrf_template != null ? v.vrf_template : local.first_tenant
      vzGraphCont           = v.vzGraphCont != null ? v.vzGraphCont : ""
    }
  }

  epg_to_domains_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.domains : {
        annotation               = v.annotation != null ? v.annotation : ""
        allow_micro_segmentation = v.allow_micro_segmentation != null ? v.allow_micro_segmentation : false
        application_epg          = key
        controller_type          = value.controller_type
        delimiter                = v.delimiter != null ? v.delimiter : ""
        deploy_immediacy         = v.deploy_immediacy != null ? v.deploy_immediacy : "on-demand"
        domain                   = v.domain
        domain_type              = v.domain_type != null ? v.domain_type : "physical"
        enhanced_lag_policy      = v.enhanced_lag_policy != null ? v.enhanced_lag_policy : ""
        epg_type                 = value.epg_type
        number_of_ports          = v.number_of_ports != null ? v.number_of_ports : 0
        port_allocation          = v.port_allocation != null ? v.port_allocation : "none"
        port_binding             = v.port_binding != null ? v.port_binding : "none"
        resolution_immediacy     = v.resolution_immediacy != null ? v.resolution_immediacy : "on-demand"
        security = v.security != null ? [
          for s in v.security : {
            allow_promiscuous = s.allow_promiscuous != null ? s.allow_promiscuous : "reject"
            forged_transmits  = s.forged_transmits != null ? s.forged_transmits : "reject"
            mac_changes       = s.mac_changes != null ? s.mac_changes : "reject"
          }
          ] : [
          {
            allow_promiscuous = "reject"
            forged_transmits  = "reject"
            mac_changes       = "reject"
          }
        ]
        switch_provider = v.switch_provider != null ? v.switch_provider : "VMware"
        vlan_mode       = v.vlan_mode != null ? v.vlan_mode : "dynamic"
        vlans           = v.vlans != null ? v.vlans : []
      }
    ]
  ])
  epg_to_domains = { for k, v in local.epg_to_domains_loop : "${v.application_epg}_${v.domain}" => v }


  epg_to_static_paths_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.static_paths_for_loop : {
        annotation         = value.annotation
        epg                = key
        key1               = k
        encapsulation_type = v.encapsulation_type != null ? v.encapsulation_type : "vlan"
        mode               = v.mode != null ? v.mode : "trunk"
        name               = v.name
        nodes              = v.nodes
        path_type          = v.path_type != null ? v.path_type : "port"
        pod                = v.pod != null ? v.pod : 1
        vlans              = v.vlans
      }
    ]
  ])
  epg_to_static_paths = { for k, v in local.epg_to_static_paths_loop : "${v.epg}_${k}" => v }


  epg_to_aaeps_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.epg_to_aaeps : {
        epg                       = key
        aaep                      = v.aaep
        instrumentation_immediacy = v.instrumentation_immediacy != null ? v.instrumentation_immediacy : "on-demand"
        mode                      = v.mode != null ? v.mode : "regular"
        vlans                     = v.vlans
      }
    ]
  ])
  epg_to_aaeps = { for k, v in local.epg_to_aaeps_loop : "${v.epg}_${v.aaep}" => v }


  contract_to_epgs_loop = flatten([
    for key, value in local.application_epgs : [
      for k, v in value.contracts : {
        annotation          = value.annotation
        application_epg     = key
        application_profile = value.application_profile
        contract            = v.name
        contract_class = length(regexall(
          "consumed", v.contract_type)) > 0 ? "fvRsCons" : length(regexall(
          "contract_interface", v.contract_type)) > 0 ? "fvRsConsIf" : length(regexall(
          "intra_epg", v.contract_type)) > 0 ? "fvRsIntraEpg" : length(regexall(
          "provided", v.contract_type)) > 0 && length(regexall(
          "oob", value.epg_type)) > 0 ? "mgmtRsOoBProv" : length(regexall(
          "provided", v.contract_type)) > 0 ? "fvRsProv" : length(regexall(
          "taboo", v.contract_type)
        ) > 0 ? "fvRsProtBy" : ""
        contract_dn = length(regexall(
          "consumed", v.contract_type)) > 0 ? "rscons" : length(regexall(
          "contract_interface", v.contract_type)) > 0 ? "rsconsIf" : length(regexall(
          "intra_epg", v.contract_type)) > 0 ? "rsintraEpg" : length(regexall(
          "provided", v.contract_type)) > 0 && length(regexall(
          "oob", value.epg_type)) > 0 ? "rsooBProv" : length(regexall(
          "provided", v.contract_type)) > 0 ? "rsprov" : length(regexall(
          "taboo", v.contract_type)
        ) > 0 ? "rsprotBy" : ""
        contract_tdn    = length(regexall("taboo", v.contract_type)) > 0 ? "taboo" : "brc"
        contract_tenant = v.tenant != null ? v.tenant : value.tenant
        contract_type   = v.contract_type
        epg_type        = value.epg_type
        qos_class       = v.qos_class != null ? v.qos_class : "unspecified"
        tenant          = value.tenant
      }
    ]
  ])
  contract_to_epgs = { for k, v in local.contract_to_epgs_loop : "${v.application_epg}_${k}_${v.contract}" => v }


  #__________________________________________________________
  #
  # Bridge Domain Variables
  #__________________________________________________________

  bridge_domains = {
    for key, value in var.bridge_domains : key => {
      advanced_troubleshooting = value.advanced_troubleshooting != null ? [
        for k, v in value.advanced_troubleshooting : {
          endpoint_clear                         = v.endpoint_clear != null ? v.endpoint_clear : false
          intersite_bum_traffic_allow            = v.intersite_bum_traffic_allow != null ? v.intersite_bum_traffic_allow : false
          intersite_l2_stretch                   = v.intersite_l2_stretch != null ? v.intersite_l2_stretch : false
          optimize_wan_bandwidth                 = v.optimize_wan_bandwidth != null ? v.optimize_wan_bandwidth : false
          disable_ip_data_plane_learning_for_pbr = v.disable_ip_data_plane_learning_for_pbr != null ? v.disable_ip_data_plane_learning_for_pbr : false
          first_hop_security_policy              = v.first_hop_security_policy != null ? v.first_hop_security_policy : ""
          monitoring_policy                      = v.monitoring_policy != null ? v.monitoring_policy : "default"
          netflow_monitor_policies = v.netflow_monitor_policies != null ? [
            for s in v.netflow_monitor_policies : {
              filter_type    = s.filter_type != null ? s.filter_type : "ipv4"
              netflow_policy = s.netflow_policy
            }
          ] : []
          rogue_coop_exception_list = v.rogue_coop_exception_list != null ? v.rogue_coop_exception_list : []
        }
        ] : [
        {
          endpoint_clear                         = false
          intersite_bum_traffic_allow            = false
          intersite_l2_stretch                   = false
          optimize_wan_bandwidth                 = false
          disable_ip_data_plane_learning_for_pbr = false
          first_hop_security_policy              = ""
          monitoring_policy                      = "default"
          netflow_monitor_policies               = []
          rogue_coop_exception_list              = []
        }
      ]
      controller_type = value.controller_type != null ? value.controller_type : "apic"
      dhcp_relay_labels = value.dhcp_relay_labels != null ? [
        for k, v in value.dhcp_relay_labels : {
          dhcp_option_policy = v.dhcp_option_policy != null ? v.dhcp_option_policy : ""
          scope              = v.scope != null ? v.scope : "infra"
          names              = v.names
        }
      ] : []
      general = value.general != null ? [
        for k, v in value.general : {
          advertise_host_routes         = v.advertise_host_routes != null ? v.advertise_host_routes : false
          alias                         = v.alias != null ? v.alias : ""
          annotation                    = v.annotation != null ? v.annotation : ""
          arp_flooding                  = v.arp_flooding != null ? v.arp_flooding : false
          description                   = v.description != null ? v.description : ""
          endpoint_retention_policy     = v.endpoint_retention_policy != null ? v.endpoint_retention_policy : ""
          global_alias                  = v.global_alias != null ? v.global_alias : ""
          igmp_snooping_policy          = v.igmp_snooping_policy != null ? v.igmp_snooping_policy : ""
          ipv6_l3_unknown_multicast     = v.ipv6_l3_unknown_multicast != null ? v.ipv6_l3_unknown_multicast : "flood"
          l2_unknown_unicast            = v.l2_unknown_unicast != null ? v.l2_unknown_unicast : "proxy"
          l3_unknown_multicast_flooding = v.l3_unknown_multicast_flooding != null ? v.l3_unknown_multicast_flooding : "flood"
          limit_ip_learn_to_subnets     = v.limit_ip_learn_to_subnets != null ? v.limit_ip_learn_to_subnets : true
          mld_snoop_policy              = v.mld_snoop_policy != null ? v.mld_snoop_policy : ""
          multi_destination_flooding    = v.multi_destination_flooding != null ? v.multi_destination_flooding : "bd-flood"
          pim                           = v.pim != null ? v.pim : false
          pimv6                         = v.pimv6 != null ? v.pimv6 : false
          tenant                        = value.tenant
          type                          = v.type != null ? v.type : "regular"
          vrf                           = v.vrf != null ? v.vrf : "default"
          vrf_schema                    = v.vrf_schema != null ? v.vrf_schema : null
          vrf_template                  = v.vrf_template != null ? v.vrf_template : null
          vrf_tenant                    = v.vrf_tenant != null ? v.vrf_tenant : value.tenant != null ? value.tenant : local.first_tenant
        }
        ] : [
        {
          advertise_host_routes         = false
          alias                         = ""
          annotation                    = ""
          arp_flooding                  = false
          description                   = ""
          endpoint_retention_policy     = ""
          global_alias                  = ""
          igmp_snooping_policy          = ""
          ipv6_l3_unknown_multicast     = "flood"
          l2_unknown_unicast            = "flood"
          l3_unknown_multicast_flooding = "flood"
          limit_ip_learn_to_subnets     = true
          mld_snoop_policy              = ""
          multi_destination_flooding    = "bd-flood"
          pim                           = false
          pimv6                         = false
          tenant                        = value.tenant != null ? value.tenant : local.first_tenant
          type                          = "regular"
          vrf                           = "default"
          vrf_schema                    = value.tenant != null ? value.tenant : local.first_tenant
          vrf_template                  = value.tenant != null ? value.tenant : local.first_tenant
          vrf_tenant                    = value.tenant != null ? value.tenant : local.first_tenant
        }
      ]
      l3_configurations = value.l3_configurations != null ? [
        for k, v in value.l3_configurations : {
          associated_l3outs = v.associated_l3outs != null ? [
            for s in v.associated_l3outs : {
              l3out         = s.l3out
              route_profile = s.route_profile != null ? s.route_profile : ""
              tenant        = s.tenant != null ? s.tenant : value.tenant
            }
          ] : []
          ep_move_detection_mode  = v.ep_move_detection_mode != null ? v.ep_move_detection_mode : false
          unicast_routing         = v.unicast_routing != null ? v.unicast_routing : true
          custom_mac_address      = v.custom_mac_address != null ? v.custom_mac_address : ""
          link_local_ipv6_address = v.link_local_ipv6_address != null ? v.link_local_ipv6_address : "::"
          subnets                 = v.subnets != null ? v.subnets : {}
          virtual_mac_address     = v.virtual_mac_address != null ? v.virtual_mac_address : ""
        }
        ] : [
        {
          associated_l3outs       = []
          custom_mac_address      = ""
          ep_move_detection_mode  = false
          link_local_ipv6_address = "::"
          subnets                 = {}
          unicast_routing         = true
          virtual_mac_address     = "not-applicable"
        }
      ]
      policy_source_tenant = value.policy_source_tenant != null ? value.policy_source_tenant : local.first_tenant
      schema               = value.schema != null ? value.schema : local.first_tenant
      sites                = value.sites != null ? value.sites : []
      site_length          = value.sites != null ? range(length(value.sites)) : null
      template             = value.template != null ? value.template : local.first_tenant
      tenant               = value.tenant != null ? value.tenant : local.first_tenant
    }
  }

  bridge_domain_loop = flatten([
    for k, v in local.bridge_domains : [
      for s in v.site_length : {
        advertise_host_routes = s == 1 ? false : v.general[0].advertise_host_routes
        bridge_domain         = k
        controller_type       = v.controller_type
        l3out                 = element(v.l3_configurations[0].associated_l3outs[0].l3out, s)
        schema                = v.schema
        site                  = element(v.sites, s)
        template              = v.template
      }
    ] if v.controller_type == "ndo"
  ])
  bridge_domain_sites = { for k, v in local.bridge_domain_loop : "${v.bridge_domain}_${v.site}" => v }

  bd_dhcp_relay_labels_loop = flatten([
    for key, value in local.bridge_domains : [
      for k, v in value.dhcp_relay_labels : {
        annotation         = value.general[0].annotation
        bridge_domain      = key
        controller_type    = value.controller_type
        dhcp_option_policy = v.dhcp_option_policy
        names              = v.names
        scope              = v.scope
        tenant             = value.tenant
      }
    ]
  ])
  bridge_domain_labels = { for k, v in local.bd_dhcp_relay_labels_loop : "${v.bridge_domain}_dhcp_labels" => v }

  dhcp_relay_labels_loop = flatten([
    for k, v in local.bridge_domain_labels : [
      for s in v.names : {
        annotation         = v.annotation
        bridge_domain      = v.bridge_domain
        controller_type    = v.controller_type
        dhcp_option_policy = v.dhcp_option_policy
        name               = s
        scope              = v.scope
        tenant             = v.tenant
      }
    ]
  ])
  bridge_domain_dhcp_relay_labels = { for k, v in local.dhcp_relay_labels_loop : "${v.bridge_domain}_${v.name}" => v }

  bridge_domain_subnets_loop = flatten([
    for key, value in local.bridge_domains : [
      for k, v in value.l3_configurations[0].subnets : {
        bridge_domain                = key
        controller_type              = value.controller_type
        description                  = v.description != null ? v.description : ""
        gateway_ip                   = k
        ip_data_plane_learning       = v.ip_data_plane_learning != null ? v.ip_data_plane_learning : "enabled"
        make_this_ip_address_primary = v.make_this_ip_address_primary != null ? v.make_this_ip_address_primary : false
        schema                       = value.schema
        sites                        = value.sites
        scope = v.scope != null ? [
          for b, a in v.scope : {
            advertise_externally = a.advertise_externally != null ? a.advertise_externally : false
            shared_between_vrfs  = a.shared_between_vrfs != null ? a.shared_between_vrfs : false
          }
          ] : [
          {
            advertise_externally = false
            shared_between_vrfs  = false
          }
        ]
        subnet_control = v.subnet_control != null ? [
          for b, a in v.subnet_control : {
            neighbor_discovery     = a.neighbor_discovery != null ? a.neighbor_discovery : false
            no_default_svi_gateway = a.no_default_svi_gateway != null ? a.no_default_svi_gateway : false
            querier_ip             = a.querier_ip != null ? a.querier_ip : false
          }
          ] : [
          {
            neighbor_discovery     = false
            no_default_svi_gateway = false
            querier_ip             = false
          }
        ]
        template                    = value.template
        treat_as_virtual_ip_address = v.treat_as_virtual_ip_address != null ? v.treat_as_virtual_ip_address : false
      }
    ]
  ])
  bridge_domain_subnets = { for k, v in local.bridge_domain_subnets_loop : "${v.bridge_domain}_${v.gateway_ip}" => v }

  rogue_coop_exception_list_loop = flatten([
    for k, v in local.bridge_domains : [
      for s in v.advanced_troubleshooting[0].rogue_coop_exception_list : {
        bridge_domain = k
        mac_address   = s
        tenant        = v.general[0].tenant
      }
    ] if v.controller_type == "apic"
  ])
  rogue_coop_exception_list = { for k, v in local.rogue_coop_exception_list_loop : "${v.bridge_domain}_${v.mac_address}" => v }


  #__________________________________________________________
  #
  # Contract Variables
  #__________________________________________________________

  contracts = {
    for k, v in var.contracts : k => {
      alias                 = v.alias != null ? v.alias : ""
      annotation            = v.annotation != null ? v.annotation : ""
      annotations           = v.annotations != null ? v.annotations : []
      apply_both_directions = coalesce(v.subjects[0]["apply_both_directions"], false)
      contract_type         = v.contract_type != null ? v.contract_type : "standard"
      controller_type       = v.controller_type != null ? v.controller_type : "apic"
      description           = v.description != null ? v.description : ""
      filters = v.subjects != null ? flatten([
        for s in v.subjects : [
          s.filters
        ]
      ]) : []
      global_alias = v.global_alias != null ? v.global_alias : ""
      log          = v.log != null ? v.log : false
      qos_class    = v.qos_class != null ? v.qos_class : "unspecified"
      schema       = v.schema != null ? v.schema : local.first_tenant
      subjects     = v.subjects != null ? v.subjects : []
      scope        = v.scope != null ? v.scope : "context"
      target_dscp  = v.target_dscp != null ? v.target_dscp : "unspecified"
      template     = v.template != null ? v.template : local.first_tenant
      tenant       = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  contract_subjects_loop = flatten([
    for key, value in local.contracts : [
      for k, v in value.subjects : {
        action                = v.action != null ? v.action : "permit"
        apply_both_directions = v.apply_both_directions != null ? v.apply_both_directions : true
        contract              = key
        contract_type         = value.contract_type
        description           = v.description != null ? v.description : ""
        directives            = v.directives != null ? v.directives : []
        filters               = v.filters
        label_match_criteria  = v.label_match_criteria != null ? v.label_match_criteria : "AtleastOne"
        name                  = v.name
        qos_class             = v.qos_class != null ? v.qos_class : value.qos_class
        target_dscp           = v.target_dscp != null ? v.target_dscp : value.qos_class
        tenant                = value.tenant
      }
    ] if value.controller_type == "apic"
  ])
  contract_subjects = { for k, v in local.contract_subjects_loop : "${v.contract}_${v.name}" => v }

  subject_filters_loop = flatten([
    for k, v in local.contract_subjects : [
      for s in v.filters : {
        action        = v.action
        contract      = v.contract
        contract_type = v.contract_type
        directives = length(v.directives) > 0 ? [
          for i in v.directives : {
            enable_policy_compression = i.enable_policy_compression != null ? i.enable_policy_compression : false
            log                       = i.log != null ? i.log : false
          }
          ] : [
          {
            enable_policy_compression = false
            log                       = false
          }
        ]
        directives = v.directives
        filter     = s
        subject    = v.name
        tenant     = v.tenant
      }
    ]
  ])
  subject_filters = { for k, v in local.subject_filters_loop : "${v.contract}_${v.subject}_${v.filter}" => v }

  contract_annotations_loop = flatten([
    for key, value in local.contracts : [
      for k, v in value.annotations : {
        key      = value.key
        value    = v.value
        type     = value.type
        contract = key
      }
    ]
  ])
  contract_annotations = { for k, v in local.contract_annotations_loop : "${v.contract}_${v.key}" => v }


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
      alias           = v.alias != null ? v.alias : ""
      schema          = v.schema != null ? v.schema : local.first_tenant
      template        = v.template != null ? v.template : local.first_tenant
      tenant          = v.tenant != null ? v.tenant : local.first_tenant
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
        alias                 = v.alias != null ? v.alias : ""
        source_port_from      = v.source_port_from != null ? v.source_port_from : "unspecified"
        source_port_to        = v.source_port_to != null ? v.source_port_to : "unspecified"
        schema                = value.schema
        stateful              = v.stateful != null ? v.stateful : false
        tcp_session_rules = v.tcp_session_rules != null ? [
          for s in v.tcp_session_rules : {
            acknowledgement = s.acknowledgement != null ? s.acknowledgement : false
            established     = s.established != null ? s.established : false
            finish          = s.finish != null ? s.finish : false
            reset           = s.reset != null ? s.reset : false
            synchronize     = s.synchronize != null ? s.synchronize : false
          }
          ] : [
          {
            acknowledgement = false
            established     = false
            finish          = false
            reset           = false
            synchronize     = false
          }
        ]
        template = value.template
        tenant   = value.tenant
      }
    ]
  ])
  filter_entries = { for k, v in local.filter_entries_loop : "${v.filter_name}_${v.name}" => v }


  #__________________________________________________________
  #
  # L3Out Variables
  #__________________________________________________________

  #==================================
  # L3Outs
  #==================================

  l3outs = {
    for k, v in var.l3outs : k => {
      alias                 = v.alias != null ? v.alias : ""
      annotation            = v.annotation != null ? v.annotation : ""
      annotations           = v.annotations != null ? v.annotations : []
      consumer_label        = v.consumer_label != null ? v.consumer_label : ""
      controller_type       = v.controller_type != null ? v.controller_type : "apic"
      description           = v.description != null ? v.description : ""
      enable_bgp            = v.enable_bgp != null ? v.enable_bgp : false
      external_epgs         = v.external_epgs != null ? v.external_epgs : []
      import                = coalesce(v.route_control_enforcement[0].import, false)
      global_alias          = v.global_alias != null ? v.global_alias : ""
      l3_domain             = v.l3_domain != null ? v.l3_domain : ""
      pim                   = v.pim != null ? v.pim : false
      pimv6                 = v.pimv6 != null ? v.pimv6 : false
      ospf_external_profile = v.ospf_external_profile != null ? v.ospf_external_profile : []
      policy_source_tenant  = v.policy_source_tenant != null ? v.policy_source_tenant : local.first_tenant
      provider_label        = v.provider_label != null ? v.provider_label : ""
      route_control_for_dampening = v.route_control_for_dampening != null ? [
        for s in v.route_control_for_dampening : {
          address_family = s.address_family != null ? s.address_family : "ipv4"
          route_map      = s.route_map
        }
      ] : []
      route_profile_for_interleak       = v.route_profile_for_interleak != null ? v.route_profile_for_interleak : ""
      route_profiles_for_redistribution = v.route_profiles_for_redistribution != null ? v.route_profiles_for_redistribution : []
      target_dscp                       = v.target_dscp != null ? v.target_dscp : "unspecified"
      schema                            = v.schema != null ? v.schema : local.first_tenant
      sites                             = v.sites != null ? v.sites : []
      template                          = v.template != null ? v.template : local.first_tenant
      tenant                            = v.tenant != null ? v.tenant : local.first_tenant
      vrf                               = v.vrf != null ? v.vrf : "default"
    }
  }

  l3out_route_profiles_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.route_profiles_for_redistribution : {
        annotation = value.annotation
        l3out      = key
        tenant     = value.tenant
        rm_l3out   = v.l3out != null ? v.l3out : ""
        route_map  = v.route_map
        source     = v.source != null ? v.source : "static"
      }
    ]
  ])
  l3out_route_profiles_for_redistribution = {
    for k, v in local.l3out_route_profiles_loop : "${v.l3out}_${v.route_map}_${v.source}" => v
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
        controller_type        = value.controller_type
        description            = v.description != null ? v.description : ""
        epg_type               = v.epg_type != null ? v.epg_type : "standard"
        flood_on_encapsulation = v.flood_on_encapsulation != null ? v.flood_on_encapsulation : "disabled"
        l3out                  = key
        l3out_contract_masters = v.l3out_contract_masters != null ? [
          for s in v.l3out_contract_masters : {
            external_epg = s.external_epg
            l3out        = s.l3out
          }
        ] : []
        label_match_criteria   = v.label_match_criteria != null ? v.label_match_criteria : "AtleastOne"
        name                   = v.name != null ? v.name : "default"
        preferred_group_member = v.preferred_group_member != null ? v.preferred_group_member : false
        qos_class              = v.qos_class != null ? v.qos_class : "unspecified"
        subnets                = v.subnets != null ? v.subnets : []
        target_dscp            = v.target_dscp != null ? v.target_dscp : "unspecified"
        tenant                 = value.tenant
        route_control_profiles = v.route_control_profiles != null ? [
          for s in v.route_control_profiles : {
            direction = s.direction
            route_map = s.route_map
          }
        ] : []
        tenant = value.tenant
      }
    ]
  ])
  l3out_external_epgs = { for k, v in local.external_epgs_loop : "${v.l3out}_${v.epg_type}_${v.name}" => v }

  ext_epg_contracts_loop = flatten([
    for key, value in local.l3out_external_epgs : [
      for k, v in value.contracts : {
        annotation      = value.annotation
        contract        = v.name
        contract_tenant = v.tenant != null ? v.tenant : value.tenant
        contract_type   = v.contract_type != null ? v.contract_type : "consumer"
        controller_type = value.controller_type
        epg             = value.name
        l3out           = value.l3out
        qos_class       = v.qos_class
        tenant          = v.tenant != null ? v.tenant : value.tenant
      }
    ]
  ])
  l3out_ext_epg_contracts = { for k, v in local.ext_epg_contracts_loop : "${v.l3out}_${v.epg}_${v.contract_type}_${v.contract}" => v }

  external_epg_subnets_loop_1 = flatten([
    for key, value in local.l3out_external_epgs : [
      for k, v in value.subnets : {
        aggregate_export        = coalesce(v.aggregate[0].aggregate_export, false)
        aggregate_import        = coalesce(v.aggregate[0].aggregate_import, false)
        aggregate_shared_routes = coalesce(v.aggregate[0].aggregate_shared_routes, false)
        annotation              = value.annotation
        controller_type         = value.controller_type
        description             = v.description != null ? v.description : ""
        epg_type                = value.epg_type
        ext_epg                 = key
        key2                    = k
        route_control_profiles = v.route_control_profiles != null ? [
          for s in v.route_control_profiles : {
            direction = s.direction
            route_map = s.route_map
          }
        ] : []
        route_summarization_policy        = v.route_summarization_policy != null ? v.route_summarization_policy : ""
        external_subnets_for_external_epg = coalesce(v.external_epg_classification[0].external_subnets_for_external_epg, true)
        shared_security_import_subnet     = coalesce(v.external_epg_classification[0].shared_security_import_subnet, false)
        export_route_control_subnet       = coalesce(v.route_control[0].export_route_control_subnet, false)
        import_route_control_subnet       = coalesce(v.route_control[0].import_route_control_subnet, false)
        shared_route_control_subnet       = coalesce(v.route_control[0].shared_route_control_subnet, false)
        subnets                           = v.subnets != null ? v.subnets : ["0.0.0.0/1", "128.0.0.0/1"]
      }
    ]
  ])
  external_epg_subnets_loop_2 = { for k, v in local.external_epg_subnets_loop_1 : "${v.ext_epg}_${v.key2}" => v }
  external_epg_subnets_loop_3 = flatten([
    for k, v in local.external_epg_subnets_loop_2 : [
      for s in v.subnets : {
        aggregate_export                  = v.aggregate_export
        aggregate_import                  = v.aggregate_import
        aggregate_shared_routes           = v.aggregate_shared_routes
        annotation                        = v.annotation
        controller_type                   = v.controller_type
        description                       = v.description
        epg_type                          = v.epg_type
        ext_epg                           = v.ext_epg
        route_control_profiles            = v.route_control_profiles
        route_summarization_policy        = v.route_summarization_policy
        export_route_control_subnet       = v.export_route_control_subnet
        external_subnets_for_external_epg = v.external_subnets_for_external_epg
        import_route_control_subnet       = v.import_route_control_subnet
        shared_security_import_subnet     = v.shared_security_import_subnet
        shared_route_control_subnet       = v.shared_route_control_subnet
        subnet                            = s
      }
    ]
  ])
  l3out_external_epg_subnets = { for k, v in local.external_epg_subnets_loop_3 : "${v.ext_epg}_${v.subnet}" => v }

  #=======================================================================================
  # L3Outs - OSPF External Policies
  #=======================================================================================

  ospf_process_loop = flatten([
    for key, value in local.l3outs : [
      for k, v in value.ospf_external_profile : {
        annotation                              = value.annotation
        l3out                                   = key
        ospf_area_cost                          = v.ospf_area_cost != null ? v.ospf_area_cost : 1
        ospf_area_id                            = v.ospf_area_id != null ? v.ospf_area_id : "0.0.0.0"
        ospf_area_type                          = v.ospf_area_type != null ? v.ospf_area_type : "regular"
        originate_summary_lsa                   = coalesce(v.ospf_area_control[0].originate_summary_lsa, true)
        send_redistribution_lsas_into_nssa_area = coalesce(v.ospf_area_control[0].send_redistribution_lsas_into_nssa_area, true)
        suppress_forwarding_address             = coalesce(v.ospf_area_control[0].suppress_forwarding_address, true)
        type                                    = value.type
      }
    ]
  ])
  l3out_ospf_external_policies = { for k, v in local.ospf_process_loop : v.l3out => v }

  #=======================================================================================
  # L3Outs - Logical Node Profiles
  #=======================================================================================

  l3out_node_profiles = {
    for k, v in var.l3out_logical_node_profiles : k => {
      alias              = v.alias != null ? v.alias : ""
      annotation         = v.annotation != null ? v.annotation : ""
      color_tag          = v.color_tag != null ? v.color_tag : "yellow-green"
      description        = v.description != null ? v.description : ""
      interface_profiles = v.interface_profiles != null ? v.interface_profiles : []
      l3out              = v.l3out
      name               = v.name
      nodes              = v.nodes != null ? v.nodes : []
      pod_id             = v.pod_id != null ? v.pod_id : 1
      target_dscp        = v.target_dscp != null ? v.target_dscp : "unspecified"
      tenant             = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  nodes_loop = flatten([
    for key, value in local.l3out_node_profiles : [
      for k, v in value.nodes : {
        annotation                = value.annotation
        node_id                   = v.node_id != null ? v.node_id : 201
        node_profile              = key
        pod_id                    = value.pod_id
        router_id                 = v.router_id != null ? v.router_id : "198.18.0.1"
        use_router_id_as_loopback = v.use_router_id_as_loopback != null ? v.use_router_id_as_loopback : true
      }
    ]
  ])
  l3out_node_profiles_nodes = { for k, v in local.nodes_loop : "${v.node_profile}_${v.node_id}" => v }

  l3out_node_profile_static_routes = {}

  #=======================================================================================
  # L3Outs - Logical Node Profiles - Logical Interface Profiles
  #=======================================================================================

  interface_profiles_loop = flatten([
    for key, value in local.l3out_node_profiles : [
      for k, v in value.interface_profiles : {
        annotation                  = value.annotation
        arp_policy                  = v.arp_policy != null ? v.arp_policy : ""
        auto_state                  = v.auto_state != null ? v.auto_state : "disabled"
        bgp_peers                   = v.bgp_peers != null ? v.bgp_peers : []
        color_tag                   = value.color_tag
        custom_qos_policy           = v.custom_qos_policy != null ? v.custom_qos_policy : ""
        description                 = v.description != null ? v.description : ""
        data_plane_policing_egress  = v.data_plane_policing_egress != null ? v.data_plane_policing_egress : ""
        data_plane_policing_ingress = v.data_plane_policing_ingress != null ? v.data_plane_policing_ingress : ""
        encap_scope                 = v.encap_scope != null ? v.encap_scope : "local"
        encap_vlan                  = v.encap_vlan != null ? v.encap_vlan : 1
        hsrp_interface_profile = v.hsrp_interface_profile != null ? [
          for s in v.hsrp_interface_profile : {
            alias       = s.alias != null ? s.alias : ""
            annotation  = s.annotation != null ? s.annotation : ""
            description = s.description != null ? s.description : ""
            groups = s.groups != null ? [
              for a in s.groups : {
                alias                 = a.alias != null ? a.alias : ""
                annotation            = a.annotation != null ? a.annotation : ""
                description           = a.description != null ? a.description : ""
                group_id              = a.group_id != null ? a.group_id : 0
                group_name            = a.group_name != null ? a.group_name : ""
                group_type            = a.group_type != null ? a.group_type : "ipv4"
                hsrp_group_policy     = a.hsrp_group_policy != null ? a.hsrp_group_policy : ""
                ip_address            = a.ip_address != null ? a.ip_address : ""
                ip_obtain_mode        = a.ip_obtain_mode != null ? a.ip_obtain_mode : "admin"
                mac_address           = a.mac_address != null ? a.mac_address : ""
                name                  = a.name != null ? a.name : "default"
                secondary_virtual_ips = a.secondary_virtual_ips != null ? a.secondary_virtual_ips : []
              }
            ] : []
            hsrp_interface_policy = s.hsrp_interface_policy != null ? s.hsrp_interface_policy : "default"
            policy_source_tenant  = s.policy_source_tenant != null ? s.policy_source_tenant : local.first_tenant
            version               = s.version != null ? s.version : "v1"
          }
        ] : []
        interface_or_policy_group = v.interface_or_policy_group != null ? v.interface_or_policy_group : "eth1/1"
        interface_type            = v.interface_type != null ? v.interface_type : "l3-port"
        ipv6_dad                  = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        l3out                     = value.l3out
        link_local_address        = v.link_local_address != null ? v.link_local_address : "::"
        mac_address               = v.mac_address != null ? v.mac_address : "00:22:BD:F8:19:FF"
        mode                      = v.mode != null ? v.mode : "regular"
        mtu                       = v.mtu != null ? v.mtu : "inherit" # 576 to 9216
        name                      = v.name != null ? v.name : "default"
        nd_policy                 = v.nd_policy != null ? v.nd_policy : ""
        netflow_monitor_policies = v.netflow_monitor_policies != null ? [
          for s in v.netflow_monitor_policies : {
            filter_type    = s.filter_type != null ? s.filter_type : "ipv4"
            netflow_policy = s.netflow_policy
          }
        ] : []
        node_profile = key
        nodes        = [for keys, values in value.nodes : value.nodes[keys]["node_id"]]
        ospf_interface_profile = v.ospf_interface_profile != null ? [
          for s in v.ospf_interface_profile : {
            description           = s.description != null ? s.description : ""
            authentication_type   = s.authentication_type != null ? s.authentication_type : "none"
            name                  = s.name != null ? s.name : "default"
            ospf_key              = s.ospf_key != null ? s.ospf_key : 0
            ospf_interface_policy = s.ospf_interface_policy != null ? s.ospf_interface_policy : "default"
            policy_source_tenant  = s.policy_source_tenant != null ? s.policy_source_tenant : value.tenant
          }
        ] : []
        pod_id                    = value.pod_id
        primary_preferred_address = v.primary_preferred_address != null ? v.primary_preferred_address : "198.18.1.1/24"
        qos_class                 = v.qos_class != null ? v.qos_class : "unspecified"
        secondary_addresses       = v.secondary_addresses != null ? v.secondary_addresses : []
        secondaries_keys          = v.secondary_addresses != null ? range(length(v.secondary_addresses)) : []
        svi_addresses = v.svi_addresses != null ? [
          for s in v.svi_addresses : {
            link_local_address        = s.link_local_address != null ? s.link_local_address : "::"
            primary_preferred_address = s.primary_preferred_address
            secondary_addresses       = s.secondary_addresses != null ? s.secondary_addresses : []
            side                      = s.side
          }
        ] : []
        target_dscp = value.target_dscp
        tenant      = value.tenant
      }
    ]
  ])
  l3out_interface_profiles = { for k, v in local.interface_profiles_loop : "${v.node_profile}_${v.name}" => v }

  svi_addressing_loop = flatten([
    for key, value in local.l3out_interface_profiles : [
      for s in value.svi_addresses : {
        annotation                = value.annotation
        ipv6_dad                  = value.ipv6_dad
        link_local_address        = s.link_local_address
        path                      = key
        primary_preferred_address = s.primary_preferred_address
        secondary_addresses       = s.secondary_addresses
        secondaries_keys          = s.secondary_addresses != null ? range(length(s.secondary_addresses)) : []
        side                      = s.side
        interface_type            = value.interface_type
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
        ipv6_dad             = v.ipv6_dad != null ? v.ipv6_dad : "enabled"
        key1                 = "${k}-${s}"
        l3out_path           = k
        secondary_ip_address = element(v.secondary_addresses, s)
      }
    ]
  ])
  svi_secondaries           = { for k, v in local.secondaries_loop_2 : "${v.key1}" => v }
  l3out_paths_secondary_ips = merge(local.interface_secondaries, local.svi_secondaries)

  #=======================================================================================
  # L3Outs - Logical Node Profiles - Logical Interface Profiles - BGP Peers
  #=======================================================================================

  bgp_peer_connectivity_profiles_loop = flatten([
    for key, value in local.l3out_interface_profiles : [
      for k, v in value.bgp_peers : {
        address_type_controls = v.address_type_controls != null ? [
          for s in v.address_type_controls : {
            af_mcast = s.af_mcast != null ? s.af_mcast : false
            af_ucast = s.af_ucast != null ? s.af_ucast : true
          }
          ] : [
          {
            af_mcast = false
            af_ucast = true
          }
        ]
        admin_state           = v.admin_state != null ? v.admin_state : "enabled"
        allowed_self_as_count = v.allowed_self_as_count != null ? v.allowed_self_as_count : 3
        annotation            = value.annotation
        bgp_controls = v.bgp_controls != null ? [
          for s in v.bgp_controls : {
            allow_self_as           = s.allow_self_as != null ? s.allow_self_as : false
            as_override             = s.as_override != null ? s.as_override : false
            disable_peer_as_check   = s.disable_peer_as_check != null ? s.disable_peer_as_check : false
            next_hop_self           = s.next_hop_self != null ? s.next_hop_self : false
            send_community          = s.send_community != null ? s.send_community : false
            send_domain_path        = s.send_domain_path != null ? s.send_domain_path : false
            send_extended_community = s.send_extended_community != null ? s.send_extended_community : false
          }
          ] : [
          {
            allow_self_as           = false
            as_override             = false
            disable_peer_as_check   = false
            next_hop_self           = false
            send_community          = false
            send_domain_path        = false
            send_extended_community = false
          }
        ]
        bgp_peer_prefix_policy = v.bgp_peer_prefix_policy != null ? v.bgp_peer_prefix_policy : ""
        description            = v.description != null ? v.description : ""
        ebgp_multihop_ttl      = v.ebgp_multihop_ttl != null ? v.ebgp_multihop_ttl : 1
        local_as_number        = v.local_as_number != null ? v.local_as_number : null
        local_as_number_config = v.local_as_number_config != null ? v.local_as_number_config : "none"
        password               = v.password != null ? v.password : 0
        path_profile           = "${key}"
        peer_address           = v.peer_address != null ? v.peer_address : "**REQUIRED**"
        peer_asn               = v.peer_asn
        peer_controls = v.peer_controls != null ? [
          for s in v.peer_controls : {
            bidirectional_forwarding_detection = s.bidirectional_forwarding_detection != null ? s.bidirectional_forwarding_detection : false
            disable_connected_check            = s.disable_connected_check != null ? s.disable_connected_check : false
          }
          ] : [
          {
            bidirectional_forwarding_detection = false
            disable_connected_check            = true
          }
        ]
        peer_level           = v.peer_level != null ? v.peer_level : "interface"
        policy_source_tenant = v.policy_source_tenant != null ? v.policy_source_tenant : "common"
        private_as_control = v.private_as_control != null ? [
          for s in v.private_as_control : {
            remove_all_private_as            = s.remove_all_private_as != null ? s.remove_all_private_as : false
            remove_private_as                = s.remove_private_as != null ? s.remove_private_as : false
            replace_private_as_with_local_as = s.replace_private_as_with_local_as != null ? s.replace_private_as_with_local_as : false
          }
          ] : [
          {
            remove_all_private_as            = false
            remove_private_as                = false
            replace_private_as_with_local_as = false
          }
        ]
        route_control_profiles = v.route_control_profiles != null ? [
          for s in v.route_control_profiles : {
            direction = s.direction
            route_map = s.route_map
          }
        ] : []
        weight_for_routes_from_neighbor = v.weight_for_routes_from_neighbor != null ? v.weight_for_routes_from_neighbor : 0
      }
    ]
  ])
  bgp_peer_connectivity_profiles = {
    for k, v in local.bgp_peer_connectivity_profiles_loop : "${v.path_profile}_${v.peer_address}" => v
  }


  #=======================================================================================
  # L3Outs - Logical Node Profiles - Logical Interface Profiles - HSRP Interface Profiles
  #=======================================================================================

  hsrp_interface_profile_loop = flatten([
    for key, value in local.l3out_interface_profiles : [
      for k, v in value.hsrp_interface_profile : {
        alias                 = v.alias
        annotation            = v.annotation
        description           = v.description
        groups                = v.groups
        hsrp_interface_policy = v.hsrp_interface_policy
        interface_profile     = key
        policy_source_tenant  = v.policy_source_tenant
        version               = v.version
      }
    ]
  ])
  hsrp_interface_profile = {
    for k, v in local.hsrp_interface_profile_loop : "${v.interface_profile}" => v
  }

  hsrp_interface_profile_groups_loop = flatten([
    for key, value in local.hsrp_interface_profile : [
      for k, v in value.groups : {
        alias                 = v.alias != null ? v.alias : ""
        annotation            = v.annotation != null ? v.annotation : ""
        description           = v.description != null ? v.description : ""
        group_id              = v.group_id != null ? v.group_id : 0
        group_name            = v.group_name != null ? v.group_name : ""
        group_type            = v.group_type != null ? v.group_type : "ipv4"
        hsrp_group_policy     = v.hsrp_group_policy != null ? v.hsrp_group_policy : ""
        ip_address            = v.ip_address != null ? v.ip_address : ""
        ip_obtain_mode        = v.ip_obtain_mode != null ? v.ip_obtain_mode : "admin"
        key1                  = key
        mac_address           = v.mac_address != null ? v.mac_address : ""
        name                  = v.name != null ? v.name : "default"
        policy_source_tenant  = value.policy_source_tenant
        secondary_virtual_ips = v.secondary_virtual_ips != null ? v.secondary_virtual_ips : []
      }
    ]
  ])
  hsrp_interface_profile_groups = {
    for k, v in local.hsrp_interface_profile_groups_loop : "${v.key1}_${v.name}" => v
  }

  hsrp_interface_profile_group_secondaries_loop = flatten([
    for key, value in local.hsrp_interface_profile_groups : [
      for s in value.secondary_virtual_ips : {
        key1         = "${value.key1}_${value.name}"
        secondary_ip = s
      }
    ]
  ])
  hsrp_interface_profile_group_secondaries = {
    for k, v in local.hsrp_interface_profile_group_secondaries_loop : "${v.key1}_${v.name}" => v
  }

  #=======================================================================================
  # L3Outs - Logical Node Profiles - Logical Interface Profiles - OSPF Interface Policies
  #=======================================================================================

  ospf_profiles_loop = flatten([
    for key, value in local.l3out_interface_profiles : [
      for k, v in value.ospf_interface_profile : {
        annotation            = value.annotation
        authentication_type   = v.authentication_type != null ? v.authentication_type : "none"
        description           = v.description != null ? v.description : ""
        interface_profile     = key
        l3out                 = value.l3out
        name                  = v.name != null ? v.name : "default"
        ospf_key              = v.ospf_key != null ? v.ospf_key : 0
        ospf_interface_policy = v.ospf_interface_policy != null ? v.ospf_interface_policy : "default"
        policy_source_tenant  = v.policy_source_tenant != null ? v.policy_source_tenant : local.first_tenant
        tenant                = value.tenant
      }
    ]
  ])
  l3out_ospf_interface_profiles = { for k, v in local.ospf_profiles_loop : "${v.interface_profile}_${v.name}" => v }


  #__________________________________________________________
  #
  # Policies - BFD Interface
  #__________________________________________________________

  policies_bfd_interface = {
    for k, v in var.policies_bfd_interface : k => {
      admin_state                       = v.admin_state != null ? v.admin_state : "enabled"
      annotation                        = v.annotation != null ? v.annotation : ""
      description                       = v.description != null ? v.description : ""
      detection_multiplier              = v.detection_multiplier != null ? v.detection_multiplier : 3
      echo_admin_state                  = v.echo_admin_state != null ? v.echo_admin_state : "enabled"
      echo_recieve_interval             = v.echo_recieve_interval != null ? v.echo_recieve_interval : 50
      enable_sub_interface_optimization = v.enable_sub_interface_optimization != null ? v.enable_sub_interface_optimization : false
      minimum_recieve_interval          = v.minimum_recieve_interval != null ? v.minimum_recieve_interval : 50
      minimum_transmit_interval         = v.minimum_transmit_interval != null ? v.minimum_transmit_interval : 50
      tenant                            = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  #__________________________________________________________
  #
  # Policies - BGP
  #__________________________________________________________

  policies_bgp_address_family_context = {
    for k, v in var.policies_bgp_address_family_context : k => {
      annotation             = v.annotation != null ? v.annotation : ""
      description            = v.description != null ? v.description : ""
      ebgp_distance          = v.ebgp_distance != null ? v.ebgp_distance : 20
      ebgp_max_ecmp          = v.ebgp_max_ecmp != null ? v.ebgp_max_ecmp : 16
      enable_host_route_leak = v.enable_host_route_leak != null ? v.enable_host_route_leak : false
      ibgp_distance          = v.ibgp_distance != null ? v.ibgp_distance : 200
      ibgp_max_ecmp          = v.ibgp_max_ecmp != null ? v.ibgp_max_ecmp : 16
      local_distance         = v.local_distance != null ? v.local_distance : 220
      tenant                 = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_bgp_best_path = {
    for k, v in var.policies_bgp_best_path : k => {
      annotation                = v.annotation != null ? v.annotation : ""
      description               = v.description != null ? v.description : ""
      relax_as_path_restriction = v.relax_as_path_restriction != null ? v.relax_as_path_restriction : false
      tenant                    = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_bgp_peer_prefix = {
    for k, v in var.policies_bgp_peer_prefix : k => {
      action                     = v.action != null ? v.action : "reject"
      annotation                 = v.annotation != null ? v.annotation : ""
      description                = v.description != null ? v.description : ""
      maximum_number_of_prefixes = v.maximum_number_of_prefixes != null ? v.maximum_number_of_prefixes : 20000
      name                       = v.name != null ? v.name : "default"
      restart_time               = v.restart_time != null ? v.restart_time : 65535
      tenant                     = v.tenant != null ? v.tenant : local.first_tenant
      threshold                  = v.threshold != null ? v.threshold : 75
    }
  }

  policies_bgp_route_summarization = {
    for k, v in var.policies_bgp_route_summarization : k => {
      annotation                  = v.annotation != null ? v.annotation : ""
      description                 = v.description != null ? v.description : ""
      generate_as_set_information = v.generate_as_set_information != null ? v.generate_as_set_information : false
      name                        = v.name != null ? v.name : "default"
      tenant                      = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_bgp_timers = {
    for k, v in var.policies_bgp_timers : k => {
      annotation              = v.annotation != null ? v.annotation : ""
      description             = v.description != null ? v.description : ""
      graceful_restart_helper = v.graceful_restart_helper != null ? v.graceful_restart_helper : true
      hold_interval           = v.hold_interval != null ? v.hold_interval : 180
      keepalive_interval      = v.keepalive_interval != null ? v.keepalive_interval : 60
      maximum_as_limit        = v.maximum_as_limit != null ? v.maximum_as_limit : 0
      name                    = v.name != null ? v.name : "default"
      stale_interval          = v.stale_interval != null ? v.stale_interval : 300
      tenant                  = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  #__________________________________________________________
  #
  # Policies - DHCP Variables
  #__________________________________________________________

  policies_dhcp_option = {
    for k, v in var.policies_dhcp_option : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      options = v.options != null ? { for key, value in v.options : v.name =>
        {
          alias          = value.alias != null ? value.alias : ""
          annotation     = value.annotation != null ? value.annotation : ""
          data           = value.data
          dhcp_option_id = value.dhcp_option_id
          name           = value.name
        }
      } : {}
      tenant = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_dhcp_relay = {
    for k, v in var.policies_dhcp_relay : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      dhcp_relay_providers = v.dhcp_relay_providers != null ? { for key, value in v.dhcp_relay_providers : key =>
        {
          address             = value.address
          application_profile = value.application_profile != null ? value.application_profile : "default"
          epg                 = value.epg != null ? value.epg : "default"
          epg_type            = value.epg_type != null ? value.epg_type : "epg"
          l3out               = value.l3out != null ? value.l3out : ""
          tenant              = value.tenant != null ? value.tenant : local.first_tenant
        }
      } : {}
      mode   = v.mode != null ? v.mode : "visible"
      tenant = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  #__________________________________________________________
  #
  # Policies - Endpoint Retention Variables
  #__________________________________________________________

  policies_endpoint_retention = {
    for k, v in var.policies_endpoint_retention : k => {
      annotation                     = v.annotation != null ? v.annotation : ""
      bounce_entry_aging_interval    = v.bounce_entry_aging_interval != null ? v.bounce_entry_aging_interval : 630
      bounce_trigger                 = v.bounce_trigger != null ? v.bounce_trigger : "protocol"
      description                    = v.description != null ? v.description : ""
      hold_interval                  = v.hold_interval != null ? v.hold_interval : 300
      local_endpoint_aging_interval  = v.local_endpoint_aging_interval != null ? v.local_endpoint_aging_interval : 900
      move_frequency                 = v.move_frequency != null ? v.move_frequency : 256
      remote_endpoint_aging_interval = v.remote_endpoint_aging_interval != null ? v.remote_endpoint_aging_interval : 300
      tenant                         = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  #__________________________________________________________
  #
  # Policies - HSRP
  #__________________________________________________________

  policies_hsrp_group = {
    for k, v in var.policies_hsrp_group : k => {
      annotation                        = v.annotation != null ? v.annotation : ""
      description                       = v.description != null ? v.description : ""
      enable_preemption_for_the_group   = v.enable_preemption_for_the_group != null ? v.enable_preemption_for_the_group : false
      hello_interval                    = v.hello_interval != null ? v.hello_interval : 3000
      hold_interval                     = v.hold_interval != null ? v.hold_interval : 10000
      key                               = v.key != null ? v.key : "cisco"
      max_seconds_to_prevent_preemption = v.max_seconds_to_prevent_preemption != null ? v.max_seconds_to_prevent_preemption : 0
      min_preemption_delay              = v.min_preemption_delay != null ? v.min_preemption_delay : 0
      preemption_delay_after_reboot     = v.preemption_delay_after_reboot != null ? v.preemption_delay_after_reboot : 0
      priority                          = v.priority != null ? v.priority : 100
      tenant                            = v.tenant != null ? v.tenant : local.first_tenant
      timeout                           = v.timeout != null ? v.timeout : 0
      type                              = v.alias != null ? v.type : "simple_authentication"
    }
  }

  policies_hsrp_interface = {
    for k, v in var.policies_hsrp_interface : k => {
      annotation                                = v.annotation != null ? v.annotation : ""
      delay                                     = v.delay != null ? v.delay : 0
      description                               = v.description != null ? v.description : ""
      enable_bidirectional_forwarding_detection = coalesce(v.control[0].enable_bidirectional_forwarding_detection, false)
      reload_delay                              = v.reload_delay != null ? v.reload_delay : 0
      tenant                                    = v.tenant != null ? v.tenant : local.first_tenant
      use_burnt_in_mac_address_of_the_interface = coalesce(v.control[0].use_burnt_in_mac_address_of_the_interface, false)
    }
  }


  #__________________________________________________________
  #
  # Policies - OSPF Variables
  #__________________________________________________________

  policies_ospf_interface = {
    for k, v in var.policies_ospf_interface : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      cost_of_interface = v.cost_of_interface != null ? v.cost_of_interface : 0
      dead_interval     = v.dead_interval != null ? v.dead_interval : 40
      description       = v.description != null ? v.description : ""
      hello_interval    = v.hello_interval != null ? v.hello_interval : 10
      interface_controls = v.interface_controls != null ? [
        for s in v.interface_controls : {
          advertise_subnet      = s.advertise_subnet != null ? s.advertise_subnet : false
          bfd                   = s.bfd != null ? s.bfd : false
          mtu_ignore            = s.mtu_ignore != null ? s.mtu_ignore : false
          passive_participation = s.passive_participation != null ? s.passive_participation : false
        }
        ] : [
        {
          advertise_subnet      = false
          bfd                   = false
          mtu_ignore            = false
          passive_participation = false
        }
      ]
      network_type        = v.network_type != null ? v.network_type : "bcast"
      priority            = v.priority != null ? v.priority : 1
      retransmit_interval = v.retransmit_interval != null ? v.retransmit_interval : 5
      transmit_delay      = v.transmit_delay != null ? v.transmit_delay : 1
      tenant              = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_ospf_route_summarization = {
    for k, v in var.policies_ospf_route_summarization : k => {
      annotation         = v.annotation != null ? v.annotation : ""
      cost               = v.cost != null ? v.cost : 0
      description        = v.description != null ? v.description : ""
      inter_area_enabled = v.inter_area_enabled != null ? v.inter_area_enabled : false
      tenant             = v.tenant != null ? v.tenant : local.first_tenant
    }
  }

  policies_ospf_timers = {
    for k, v in var.policies_ospf_timers : k => {
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
      control_knobs = v.control_knobs != null ? [
        for s in v.control_knobs : {
          enable_name_lookup_for_router_ids = length(compact([s.enable_name_lookup_for_router_ids])
          ) > 0 ? s.enable_name_lookup_for_router_ids : false
          prefix_suppress = s.prefix_suppress != null ? s.prefix_suppress : false
        }
        ] : [
        {
          enable_name_lookup_for_router_ids = false
          prefix_suppress                   = false
        }
      ]
      tenant = v.tenant != null ? v.tenant : local.first_tenant
    }
  }


  #__________________________________________________________
  #
  # Route Map Match Rule Variables
  #__________________________________________________________

  route_map_match_rules = {
    for k, v in var.route_map_match_rules : k => {
      annotation  = v.annotation != null ? v.annotation : ""
      description = v.description != null ? v.description : ""
      rules       = v.rules != null ? v.rules : {}
      tenant      = v.tenant != null ? v.tenant : local.first_tenant
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
      rules       = v.rules != null ? v.rules : []
      tenant      = v.tenant != null ? v.tenant : local.first_tenant
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
      route_map_continue = v.route_map_continue != null ? v.route_map_continue : false
      tenant             = v.tenant != null ? v.tenant : local.first_tenant
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
      templates = v.templates != null ? [
        for key, value in v.templates : {
          name   = value.name != null ? value.name : local.first_tenant
          schema = k
          sites  = value.sites
          tenant = value.tenant != null ? value.tenant : local.first_tenant
        }
      ] : []
    }
  }

  schema_templates_loop = flatten([
    for key, value in local.schemas : [
      for k, v in value.templates : {
        name   = v.name
        schema = key
        sites  = v.sites
        tenant = v.tenant
      }
    ]
  ])
  schema_templates = { for k, v in local.schema_templates_loop : "${v.schema}_${v.name}" => v }


  templates_sites_loop = flatten([
    for k, v in local.schema_templates : [
      for s in v.sites : {
        name   = v.name
        schema = v.schema
        site   = s
      }
    ] if v.tenant == local.first_tenant
  ])
  template_sites = { for k, v in local.templates_sites_loop : "${v.schema}_${v.name}_${v.site}" => v }


  #__________________________________________________________
  #
  # Tenant Variables
  #__________________________________________________________

  tenants = {
    for k, v in var.tenants : k => {
      alias             = v.alias != null ? v.alias : ""
      annotation        = v.annotation != null ? v.annotation : ""
      annotations       = v.annotations != null ? v.annotations : []
      controller_type   = v.controller_type != null ? v.controller_type : "apic"
      description       = v.description != null ? v.description : ""
      global_alias      = v.global_alias != null ? v.global_alias : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : "default"
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

  ndo_sites = flatten([
    for s in local.tenants : [
      for k, v in s.sites : [v.site]
    ]
  ])

  ndo_users = flatten([
    for s in local.tenants : [
      s.users
    ]
  ])

  tenants_annotations_loop = flatten([
    for key, value in local.tenants : [
      for k, v in value.annotations : {
        key    = value.key
        value  = v.value
        tenant = value.tenant
      }
    ] if value.controller_type == "apic" && value.annotations != []
  ])
  tenants_annotations = { for k, v in local.tenants_annotations_loop : "${v.tenant}_${v.key}" => v }

  tenants_global_alias = {
    for k, v in local.tenants : k => {
      global_alias = v.global_alias
    } if v.global_alias != ""
  }


  #__________________________________________________________
  #
  # VRF Variables
  #__________________________________________________________

  vrfs = {
    for k, v in var.vrfs : k => {
      annotation                      = v.annotation != null ? v.annotation : ""
      annotations                     = v.annotations != null ? v.annotations : []
      bd_enforcement_status           = v.bd_enforcement_status != null ? v.bd_enforcement_status : false
      bgp_timers_per_address_family   = v.bgp_timers_per_address_family != null ? v.bgp_timers_per_address_family : []
      bgp_timers                      = v.bgp_timers != null ? v.bgp_timers : "default"
      communities                     = v.communities != null ? v.communities : []
      controller_type                 = v.controller_type != null ? v.controller_type : "apic"
      description                     = v.description != null ? v.description : ""
      eigrp_timers_per_address_family = v.eigrp_timers_per_address_family != null ? v.eigrp_timers_per_address_family : []
      endpoint_retention_policy       = v.endpoint_retention_policy != null ? v.endpoint_retention_policy : "default"
      epg_esg_collection_for_vrfs = v.epg_esg_collection_for_vrfs != null ? [
        for s in v.epg_esg_collection_for_vrfs : {
          contracts            = s.contracts != null ? s.contracts : []
          label_match_criteria = s.label_match_criteria != null ? s.label_match_criteria : "AtleastOne"
        }
        ] : [
        {
          contracts            = []
          label_match_criteria = "AtleastOne"
        }
      ]
      global_alias                          = v.global_alias != null ? v.global_alias : ""
      ip_data_plane_learning                = v.ip_data_plane_learning != null ? v.ip_data_plane_learning : "enabled"
      layer3_multicast                      = v.layer3_multicast != null ? v.layer3_multicast : false
      monitoring_policy                     = v.monitoring_policy != null ? v.monitoring_policy : ""
      alias                                 = v.alias != null ? v.alias : ""
      ospf_timers_per_address_family        = v.ospf_timers_per_address_family != null ? v.ospf_timers_per_address_family : []
      ospf_timers                           = v.ospf_timers != null ? v.ospf_timers : "default"
      policy_source_tenant                  = v.policy_source_tenant != null ? v.policy_source_tenant : local.first_tenant
      policy_control_enforcement_direction  = v.policy_control_enforcement_direction != null ? v.policy_control_enforcement_direction : "ingress"
      policy_control_enforcement_preference = v.policy_control_enforcement_preference != null ? v.policy_control_enforcement_preference : "enforced"
      preferred_group                       = v.preferred_group != null ? v.preferred_group : false
      sites                                 = v.sites != null ? v.sites : []
      schema                                = v.schema != null ? v.schema : local.first_tenant
      template                              = v.template != null ? v.template : ""
      tenant                                = v.tenant != null ? v.tenant : local.first_tenant
      transit_route_tag_policy              = v.transit_route_tag_policy != null ? v.transit_route_tag_policy : ""
    }
  }

  vrfs_annotations_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.annotations : {
        key    = value.key
        value  = v.value
        tenant = value.tenant
        vrf    = key
      }
    ] if value.controller_type == "apic" && value.annotations != []
  ])
  vrfs_annotations = { for k, v in local.vrfs_annotations_loop : "${v.vrf}_${v.key}" => v }

  vrf_communities_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.communities : {
        annotation         = value.annotation
        community_variable = v.community_variable
        description        = v.description != null ? v.description : ""
        vrf                = key
      }
    ]
  ])
  vrf_communities = { for k, v in local.vrf_communities_loop : "${v.vrf}_${v.community_variable}" => v }

  vzany_contracts_loop = flatten([
    for key, value in local.vrfs : [
      for k, v in value.epg_esg_collection_for_vrfs[0].contracts : {
        annotation           = value.annotation
        contract             = v.name
        contract_type        = v.contract_type
        contract_schema      = v.schema != null ? v.schema : value.schema
        contract_tenant      = v.tenant != null ? v.tenant : value.tenant
        contract_template    = v.template != null ? v.template : value.template
        controller_type      = value.controller_type
        label_match_criteria = value.epg_esg_collection_for_vrfs[0].label_match_criteria
        qos_class            = v.qos_class != null ? v.qos_class : "unspecified"
        schema               = value.schema
        template             = value.template
        tenant               = value.tenant
        vrf                  = key
      }
    ]
  ])
  vzany_contracts = { for k, v in local.vzany_contracts_loop : "${v.vrf}_${v.contract}_${v.contract_type}" => v }

  vrfs_global_alias = {
    for k, v in local.vrfs : k => {
      global_alias = v.global_alias
    } if v.global_alias != ""
  }

  vrf_sites_loop = flatten([
    for k, v in local.vrfs : [
      for s in v.sites : {
        controller_type = v.controller_type
        schema          = v.schema
        site            = s
        template        = v.template
        vrf             = k
      }
    ] if v.controller_type == "ndo"
  ])
  vrf_sites = { for k, v in local.vrf_sites_loop : "${v.vrf}_${v.site}" => v }

}
