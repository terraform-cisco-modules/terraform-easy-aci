locals {
  #__________________________________________________________
  #
  # RADIUS Variables
  #__________________________________________________________

  radius = {
    for k, v in var.radius : k => {
      authorization_protocol = v.authorization_protocol != null ? v.authorization_protocol : "pap"
      hosts                  = v.hosts
      port                   = v.port != null ? v.port : 49
      retries                = v.retries != null ? v.retries : 1
      server_monitoring      = v.server_monitoring != null ? v.server_monitoring : []
      timeout                = v.timeout != null ? v.timeout : 5
      tags                   = v.tags != null ? v.tags : ""
      type                   = v.type != null ? v.type : "radius"
    }
  }

  radius_hosts_loop = flatten([
    for keys, values in local.radius : [
      for k, v in values.hosts : {
        authorization_protocol = values.authorization_protocol
        port                   = values.port
        retries                = values.retries
        timeout                = values.timeout
        host                   = v.host
        key                    = v.key
        key1                   = keys
        management_epg         = v.management_epg != null ? v.management_epg : "default"
        management_epg_type    = v.management_epg_type != null ? v.management_epg_type : "oob"
        order = v.order
        server_monitoring      = values.server_monitoring[0]["admin_state"] != null ? values.server_monitoring[0]["admin_state"] : "disabled"
        password               = values.server_monitoring[0]["password"] != null ? values.server_monitoring[0]["password"] : ""
        tags                   = values.tags
        type                   = values.type
        username               = values.server_monitoring[0]["username"] != null ? values.server_monitoring[0]["username"] : "default"
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
      enable_lockout                   = v.lockout_user[0]["enable_lockout"] != null ? v.lockout_user[0]["enable_lockout"] : "disable"
      lockout_duration                 = v.lockout_user[0]["lockout_duration"] != null ? v.lockout_user[0]["lockout_duration"] : 60
      max_failed_attempts              = v.lockout_user[0]["max_failed_attempts"] != null ? v.lockout_user[0]["max_failed_attempts"] : 5
      max_failed_attempts_window       = v.lockout_user[0]["max_failed_attempts_window"] != null ? v.lockout_user[0]["max_failed_attempts_window"] : 5
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
      tags                             = v.tags != null ? v.tags : ""
    }
  }

  #__________________________________________________________
  #
  # TACACS+ Variables
  #__________________________________________________________

  tacacs = {
    for k, v in var.tacacs : k => {
      accounting_a           = v.accounting_include[0]["audit_logs"] != null ? v.accounting_include[0]["audit_logs"] : true
      accounting_e           = v.accounting_include[0]["events"] != null ? v.accounting_include[0]["events"] : false
      accounting_f           = v.accounting_include[0]["faults"] != null ? v.accounting_include[0]["faults"] : false
      accounting_s           = v.accounting_include[0]["session_logs"] != null ? v.accounting_include[0]["session_logs"] : true
      authorization_protocol = v.authorization_protocol != null ? v.authorization_protocol : "pap"
      hosts                  = v.hosts
      port                   = v.port != null ? v.port : 49
      retries                = v.retries != null ? v.retries : 1
      server_monitoring      = v.server_monitoring != null ? v.server_monitoring : []
      timeout                = v.timeout != null ? v.timeout : 5
      tags                   = v.tags != null ? v.tags : ""
    }
  }

  tacacs_hosts_loop = flatten([
    for keys, values in local.tacacs : [
      for k, v in values.hosts : {
        authorization_protocol = values.authorization_protocol
        port                   = values.port
        retries                = values.retries
        timeout                = values.timeout
        host                   = v.host
        key                    = v.key
        key1                   = keys
        management_epg         = v.management_epg != null ? v.management_epg : "default"
        management_epg_type    = v.management_epg_type != null ? v.management_epg_type : "oob"
        order = v.order
        server_monitoring      = values.server_monitoring[0]["admin_state"] != null ? values.server_monitoring[0]["admin_state"] : "disabled"
        password               = values.server_monitoring[0]["password"] != null ? values.server_monitoring[0]["password"] : ""
        tags                   = values.tags
        username               = values.server_monitoring[0]["username"] != null ? values.server_monitoring[0]["username"] : "default"
      }
    ]
  ])

  tacacs_hosts = { for k, v in local.tacacs_hosts_loop : "${v.key1}_${v.host}" => v }

}