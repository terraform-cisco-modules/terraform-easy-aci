# Global Variables
annotation = "easy-aci:0.9.5"
apicUrl    = "https://64.100.14.15"
apicUser   = "admin"

# TACACS Variables
radius = {}
security = {
  "security" = {
    annotation = ""
    lockout_user = [{
      enable_lockout             = "disable"
      lockout_duration           = 60
      max_failed_attempts        = 5
      max_failed_attempts_window = 5
    }]
    maximum_validity_period          = 24
    no_change_interval               = 2
    password_change_interval         = 48
    password_change_interval_enforce = "enable"
    password_changes_within_interval = 2
    password_expiration_warn_time    = 15
    password_strength_check          = true
    user_passwords_to_store_count    = 5
    web_session_idle_timeout         = 65525
    web_token_timeout                = 900
  }
}
tacacs = {
  "RICH" = {
    accounting_include = [{
      audit_logs   = true
      events       = false
      faults       = false
      session_logs = true
    }]
    annotation             = ""
    authorization_protocol = "pap"
    hosts = [
      {
        host                = "10.101.128.71"
        key                 = 1
        management_epg      = "default"
        management_epg_type = "oob"
        order               = 0
      },
      {
        host                = "10.101.128.72"
        key                 = 1
        management_epg      = "default"
        management_epg_type = "oob"
        order               = 1
      }
    ]
    port    = 49
    retries = 1
    server_monitoring = [{
      admin_state = "disabled"
      password    = 0
      username    = "default"
    }]
    timeout = 5
  }
}