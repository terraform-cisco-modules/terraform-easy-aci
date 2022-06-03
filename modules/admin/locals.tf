locals {
  #__________________________________________________________
  #
  # Authentication Variables
  #__________________________________________________________

  authentication_properties_flatten = flatten([
    for k, v in var.authentication : [
      for s in v.icmp_reachability : {
        annotation = v.annotation != null ? v.annotation : ""
        key        = k
        retries    = s.retries != null ? s.retries : 1
        timeout    = s.timeout != null ? s.timeout : 5
        remote_user_login_policy = length(compact([v.remote_user_login_policy])
        ) > 0 ? v.remote_user_login_policy : "no-login"
        use_icmp_reachable_providers_only = length(compact([s.use_icmp_reachable_providers_only])
        ) > 0 ? s.use_icmp_reachable_providers_only : true
      }
    ]
  ])
  authentication_properties = { for k, v in local.authentication_properties_flatten : "${v.key}" => v }

  console_authentication_flatten = flatten([
    for k, v in var.authentication : [
      for s in v.console_authentication : {
        annotation   = v.annotation != null ? v.annotation : ""
        key          = k
        annotation   = v.annotation != null ? v.annotation : ""
        login_domain = s.login_domain != null ? s.login_domain : ""
        realm        = s.realm != null ? s.realm : "local"
      }
    ]
  ])
  console_authentication = { for k, v in local.console_authentication_flatten : "${v.key}" => v }

  default_authentication_flatten = flatten([
    for k, v in var.authentication : [
      for s in v.default_authentication : {
        annotation                   = v.annotation != null ? v.annotation : ""
        key                          = k
        annotation                   = v.annotation != null ? v.annotation : ""
        fallback_domain_avialability = s.fallback_domain_avialability != null ? s.fallback_domain_avialability : false
        login_domain                 = s.login_domain != null ? s.login_domain : ""
        realm                        = s.realm != null ? s.realm : "local"
      }
    ]
  ])
  default_authentication = { for k, v in local.default_authentication_flatten : "${v.key}" => v }


  #__________________________________________________________
  #
  # Configuration Backups Variables
  #__________________________________________________________

  trigger_schedulers = {
    for k, v in var.configuration_backups : k => {
      annotation           = v.annotation != null ? v.annotation : ""
      description          = coalesce(v.recurring_window[0].description, "")
      configuration_export = v.configuration_export != null ? v.configuration_export : []
      recurring_window     = v.recurring_window != null ? v.recurring_window : []
    }
  }

  configuration_export_loop_1 = flatten([
    for key, value in local.trigger_schedulers : [
      for k, v in value.configuration_export : {
        annotation            = value.annotation
        authentication_type   = v.authentication_type != null ? v.authentication_type : "usePassword"
        description           = v.description != null ? v.description : ""
        format                = v.format != null ? v.format : "json"
        include_secure_fields = v.include_secure_fields != null ? v.include_secure_fields : true
        key1                  = key
        management_epg        = v.management_epg != null ? v.management_epg : "default"
        management_epg_type   = v.management_epg_type != null ? v.management_epg_type : "oob"
        max_snapshot_count    = v.max_snapshot_count != null ? v.max_snapshot_count : 0
        password              = v.password != null ? v.password : 1
        protocol              = v.protocol != null ? v.protocol : "sftp"
        remote_hosts          = v.remote_hosts != null ? v.remote_hosts : ["fileserver.example.com"]
        remote_path           = v.remote_path != null ? v.remote_path : "/tmp"
        remote_port           = v.remote_port != null ? v.remote_port : 22
        snapshot              = v.snapshot != null ? v.snapshot : false
        ssh_key_contents      = v.ssh_key_contents != null ? v.ssh_key_contents : 0
        ssh_key_passphrase    = v.ssh_key_passphrase != null ? v.ssh_key_passphrase : 0
        start_now             = v.start_now != null ? v.start_now : "untriggered"
        username              = v.username != null ? v.username : "admin"
      }
    ]
  ])

  configuration_export_loop_2 = flatten([
    for k, v in local.configuration_export_loop_1 : [
      for s in v.remote_hosts : {
        annotation            = v.annotation
        authentication_type   = v.authentication_type
        description           = v.description
        format                = v.format
        include_secure_fields = v.include_secure_fields
        key1                  = v.key1
        management_epg        = v.management_epg
        management_epg_type   = v.management_epg_type
        max_snapshot_count    = v.max_snapshot_count
        password              = v.password
        protocol              = v.protocol
        remote_host           = s
        remote_path           = v.remote_path
        remote_port           = v.remote_port
        snapshot              = v.snapshot
        ssh_key_contents      = v.ssh_key_contents
        ssh_key_passphrase    = v.ssh_key_passphrase
        start_now             = v.start_now
        username              = v.username
      }
    ]
  ])

  configuration_export = { for k, v in local.configuration_export_loop_2 : "${v.key1}_${v.remote_host}" => v }

  recurring_window_loop = flatten([
    for key, value in local.trigger_schedulers : [
      for k, v in value.recurring_window : {
        annotation                  = value.annotation
        delay_between_node_upgrades = v.delay_between_node_upgrades != null ? v.delay_between_node_upgrades : 0
        description                 = v.description != null ? v.description : ""
        key1                        = key
        maximum_concurrent_nodes    = v.maximum_concurrent_nodes != null ? v.maximum_concurrent_nodes : "unlimited"
        maximum_running_time        = v.maximum_running_time != null ? v.maximum_running_time : "unlimited"
        processing_break            = v.processing_break != null ? v.processing_break : "none"
        processing_size_capacity    = v.processing_size_capacity != null ? v.processing_size_capacity : "unlimited"
        scheduled_days              = v.scheduled_days != null ? v.scheduled_days : "every-day"
        scheduled_hour              = v.scheduled_hour != null ? v.scheduled_hour : 23
        scheduled_minute            = v.scheduled_minute != null ? v.scheduled_minute : 45
        window_type                 = v.window_type != null ? v.window_type : "recurring"
      }
    ]
  ])

  recurring_window = { for k, v in local.recurring_window_loop : v.key1 => v }


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
      version_check_override = v.version_check_override != null ? v.version_check_override : "untriggered"
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
        maintenance_policy     = value.name
        name                   = value.name
        node_list              = value.node_list != null ? value.node_list : [101, 201]
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
      for s in v.node_list : {
        name    = v.name
        node_id = s
      }
    ]
  ])

  maintenance_group_nodes = { for k, v in local.maintenance_group_nodes_loop : "${v.name}_${v.node_id}" => v }


  #__________________________________________________________
  #
  # RADIUS Variables
  #__________________________________________________________

  radius = {
    for k, v in var.radius : k => {
      annotation             = v.annotation != null ? v.annotation : ""
      authorization_protocol = v.authorization_protocol != null ? v.authorization_protocol : "pap"
      hosts                  = v.hosts
      port                   = v.port != null ? v.port : 49
      retries                = v.retries != null ? v.retries : 1
      server_monitoring      = v.server_monitoring != null ? v.server_monitoring : []
      timeout                = v.timeout != null ? v.timeout : 5
      type                   = v.type != null ? v.type : "radius"
    }
  }

  radius_hosts_loop = flatten([
    for k, v in local.radius : [
      for key, value in v.hosts : {
        annotation             = v.annotation
        authorization_protocol = v.authorization_protocol
        port                   = v.port
        retries                = v.retries
        timeout                = v.timeout
        host                   = value.host
        key                    = value.key
        key1                   = k
        management_epg         = value.management_epg != null ? value.management_epg : "default"
        management_epg_type    = value.management_epg_type != null ? value.management_epg_type : "oob"
        order                  = value.order
        server_monitoring      = coalesce(v.server_monitoring[0]["admin_state"], "disabled")
        password               = coalesce(v.server_monitoring[0]["password"], 0)
        username               = coalesce(v.server_monitoring[0]["username"], "default")
        type                   = v.type
      }
    ]
  ])

  radius_hosts = { for k, v in local.radius_hosts_loop : "${v.key1}_${v.host}" => v }

  #__________________________________________________________
  #
  # Security Variables
  #__________________________________________________________

  security = {
    for k, v in var.security : k => {
      annotation = v.annotation != null ? v.annotation : ""
      lockout_user = v.lockout_user != null ? [
        for s in v.lockout_user : {
          enable_lockout             = s.enable_lockout != null ? s.enable_lockout : "disable"
          lockout_duration           = s.lockout_duration != null ? s.lockout_duration : 60
          max_failed_attempts        = s.max_failed_attempts != null ? s.max_failed_attempts : 5
          max_failed_attempts_window = s.max_failed_attempts_window != null ? s.max_failed_attempts_window : 5
        }
        ] : [
        {
          enable_lockout             = "disable"
          lockout_duration           = 60
          max_failed_attempts        = 5
          max_failed_attempts_window = 5
        }
      ]
      maximum_validity_period          = v.maximum_validity_period != null ? v.maximum_validity_period : 24
      no_change_interval               = v.no_change_interval != null ? v.no_change_interval : 24
      password_change_interval_enforce = v.password_change_interval_enforce != null ? v.password_change_interval_enforce : "enable"
      password_change_interval         = v.password_change_interval != null ? v.password_change_interval : 48
      password_changes_within_interval = v.password_changes_within_interval != null ? v.password_changes_within_interval : 2
      password_expiration_warn_time    = v.password_expiration_warn_time != null ? v.password_expiration_warn_time : 15
      password_strength_check          = v.password_strength_check != null ? v.password_strength_check : true
      user_passwords_to_store_count    = v.user_passwords_to_store_count != null ? v.user_passwords_to_store_count : 5
      web_session_idle_timeout         = v.web_session_idle_timeout != null ? v.web_session_idle_timeout : 1200
      web_token_timeout                = v.web_token_timeout != null ? v.web_token_timeout : 600
    }
  }


  #__________________________________________________________
  #
  # TACACS+ Variables
  #__________________________________________________________

  tacacs = {
    for k, v in var.tacacs : k => {
      accounting_include = v.accounting_include != null ? [
        for s in v.accounting_include : {
          audit_logs   = s.audit_logs != null ? s.audit_logs : true
          events       = s.events != null ? s.events : false
          faults       = s.faults != null ? s.faults : false
          session_logs = s.session_logs != null ? s.session_logs : true
        }
        ] : [
        {
          audit_logs   = true
          events       = false
          faults       = false
          session_logs = true
        }
      ]
      annotation             = v.annotation != null ? v.annotation : ""
      authorization_protocol = v.authorization_protocol != null ? v.authorization_protocol : "pap"
      hosts                  = v.hosts
      port                   = v.port != null ? v.port : 49
      retries                = v.retries != null ? v.retries : 1
      server_monitoring      = v.server_monitoring != null ? v.server_monitoring : []
      timeout                = v.timeout != null ? v.timeout : 5
    }
  }

  tacacs_hosts_loop = flatten([
    for k, v in local.tacacs : [
      for key, value in v.hosts : {
        annotation             = v.annotation
        authorization_protocol = v.authorization_protocol
        port                   = v.port
        retries                = v.retries
        timeout                = v.timeout
        host                   = value.host
        key                    = value.key
        key1                   = k
        management_epg         = value.management_epg != null ? value.management_epg : "default"
        management_epg_type    = value.management_epg_type != null ? value.management_epg_type : "oob"
        order                  = value.order
        server_monitoring      = coalesce(v.server_monitoring[0]["admin_state"], "disabled")
        password               = coalesce(v.server_monitoring[0]["password"], 0)
        username               = coalesce(v.server_monitoring[0]["username"], "default")
      }
    ]
  ])
  tacacs_hosts = { for k, v in local.tacacs_hosts_loop : "${v.key1}_${v.host}" => v }

}