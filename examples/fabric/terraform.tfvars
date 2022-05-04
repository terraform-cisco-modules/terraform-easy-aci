# Global Variables
annotation   = "easy-aci:0.9.5"
apicHostname = "64.100.14.15"
apicUser     = "admin"

date_and_time = {
  "default" = {
    administrative_state = "enabled"
    authentication_keys  = []
    description          = "NTP Policy"
    display_format       = "local"
    master_mode          = "disabled"
    ntp_servers = [
      {
        authentication_key       = 0
        description              = "AD1"
        management_epg           = "default"
        management_epg_type      = "oob"
        maximum_polling_interval = 6
        minimum_polling_interval = 4
        hostname                 = "10.101.128.15"
        preferred                = "yes"
      }
    ]
    offset_state  = "enabled"
    server_state  = "disabled"
    stratum_value = 8
    time_zone     = "UTC"
  }
}

dns_profiles = {
  "default" = {
    annotation  = ""
    description = ""
    dns_domains = [{
      default_domain = true
      domain         = "rich.ciscolabs.com"
    }]
    dns_providers = [
      {
        description  = ""
        dns_provider = "10.101.128.15"
        preferred    = true
      },
      {
        dns_provider = "10.101.128.16"
      }
    ]
    ip_version_preference = "IPv4"
    management_epg        = "default"
    management_epg_type   = "oob"
  }
}