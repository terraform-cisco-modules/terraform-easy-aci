locals {
  #__________________________________________________________
  #
  # Authentication Variables
  #__________________________________________________________

  authentication_properties = {
    for k, v in var.authentication : k => {
      annotation                    = v.annotation != null ? v.annotation : ""
      icmp_reachable_providers_only = v.icmp_reachability != null ? lookup(v.icmp_reachability[0], "reachable_providers_only", true) : true
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
      annotation     = v.annotation != null ? v.annotation : ""
      fallback_check = v.default_authentication != null ? lookup(v.default_authentication[0], "fallback_check", false) : false
      provider_group = v.default_authentication != null ? lookup(v.default_authentication[0], "provider_group", "") : ""
      realm          = v.default_authentication != null ? lookup(v.default_authentication[0], "realm", "local") : "local"
      realm_sub_type = v.default_authentication != null ? lookup(v.default_authentication[0], "realm_sub_type", "default") : "default"
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
  # Security Variables
  #__________________________________________________________

  security = {
    for k, v in var.security : k => {
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
      password_strength_check          = v.password_strength_check != null ? v.password_strength_check : "yes"
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