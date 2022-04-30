locals {
  #__________________________________________________________
  #
  # Authentication Variables
  #__________________________________________________________

  authentication_properties = {
    for k, v in var.authentication : k => {
      annotation                    = v.annotation != null ? v.annotation : ""
      icmp_reachable_providers_only = v.icmp_reachability != null ? lookup(v.icmp_reachability[0], "icmp_reachable_providers_only", true) : true
      retries                       = v.icmp_reachability != null ? lookup(v.icmp_reachability[0], "retries", 1) : 1
      timeout                       = v.icmp_reachability != null ? lookup(v.icmp_reachability[0], "timeout", 5) : 5
      remote_user_login_policy      = v.remote_user_login_policy != null ? v.remote_user_login_policy : "no-login"
    }
  }

  console_authentication = {
    for k, v in var.authentication : k => {
      annotation     = v.annotation != null ? v.annotation : ""
      provider_group = v.console_authentication != null ? lookup(v.console_authentication[0], "provider_group", "") : ""
      realm          = v.console_authentication != null ? lookup(v.console_authentication[0], "realm", "local") : "local"
      realm_sub_type = v.console_authentication != null ? lookup(v.console_authentication[0], "realm_sub_type", "default") : "default"
    }
  }

  default_authentication = {
    for k, v in var.authentication : k => {
      annotation                   = v.annotation != null ? v.annotation : ""
      fallback_domain_avialability = v.default_authentication != null ? lookup(v.default_authentication[0], "fallback_domain_avialability", false) : false
      provider_group               = v.default_authentication != null ? lookup(v.default_authentication[0], "provider_group", "") : ""
      realm                        = v.default_authentication != null ? lookup(v.default_authentication[0], "realm", "local") : "local"
      realm_sub_type               = v.default_authentication != null ? lookup(v.default_authentication[0], "realm_sub_type", "default") : "default"
    }
  }


  #__________________________________________________________
  #
  # Configuration Backups Variables
  #__________________________________________________________

  trigger_schedulers = {
    for k, v in var.configuration_backups : k => {
      annotation           = v.annotation != null ? v.annotation : ""
      description          = v.recurring_window != null ? lookup(v.recurring_window[0], "description", "") : ""
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
  # Global Security Variables
  #__________________________________________________________

  global_security = {
    for k, v in var.global_security : k => {
      annotation                       = v.annotation != null ? v.annotation : ""
      enable_lockout                   = v.lockout_user != null ? lookup(v.lockout_user[0], "enable_lockout", "disable") : "disable"
      lockout_duration                 = v.lockout_user != null ? lookup(v.lockout_user[0], "lockout_duration", 60) : 60
      max_failed_attempts              = v.lockout_user != null ? lookup(v.lockout_user[0], "max_failed_attempts", 5) : 5
      max_failed_attempts_window       = v.lockout_user != null ? lookup(v.lockout_user[0], "max_failed_attempts_window", 5) : 5
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
        key1                   = key
        management_epg         = value.management_epg != null ? value.management_epg : "default"
        management_epg_type    = value.management_epg_type != null ? value.management_epg_type : "oob"
        order                  = value.order
        server_monitoring      = v.server_monitoring != null ? lookup(v.server_monitoring[0], "admin_state", "disabled") : "disabled"
        password               = v.server_monitoring != null ? lookup(v.server_monitoring[0], "password", "") : ""
        username               = v.server_monitoring != null ? lookup(v.server_monitoring[0], "username", "admin") : "admin"
        type                   = v.type
      }
    ]
  ])

  radius_hosts = { for k, v in local.radius_hosts_loop : "${v.key1}_${v.host}" => v }

  #__________________________________________________________
  #
  # TACACS+ Variables
  #__________________________________________________________

  tacacs = {
    for k, v in var.tacacs : k => {
      accounting_a           = v.accounting_include != null ? lookup(v.accounting_include[0], "audit_logs", true) : true
      accounting_e           = v.accounting_include != null ? lookup(v.accounting_include[0], "events", false) : false
      accounting_f           = v.accounting_include != null ? lookup(v.accounting_include[0], "faults", false) : false
      accounting_s           = v.accounting_include != null ? lookup(v.accounting_include[0], "session_logs", true) : true
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
        server_monitoring      = v.server_monitoring != null ? lookup(v.server_monitoring[0], "admin_state", "disabled") : "disabled"
        password               = v.server_monitoring != null ? lookup(v.server_monitoring[0], "password", "") : ""
        username               = v.server_monitoring != null ? lookup(v.server_monitoring[0], "username", "admin") : "admin"
      }
    ]
  ])

  tacacs_hosts = { for k, v in local.tacacs_hosts_loop : "${v.key1}_${v.host}" => v }

}