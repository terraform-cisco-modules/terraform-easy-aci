# Global Variables
annotation   = "easy-aci:0.9.5"
apicHostname = "64.100.14.15"
apicUser     = "admin"
ndoHostname  = "64.100.14.14"
ndoUser      = "admin"

# Nexus Dashboard Sites/Users
sites = ["Asgard", "Wakanda"]
users = ["admin", "tyscott"]

# Filters
filters = {
  "mgmt" = {
    description = "Management Protocols"
    filter_entries = [
      {
        name = "ip"
      }
    ]
    tenant = "common"
    type   = "apic"
  }
  "terraform" = {
    description = "NDO Terraform Filter."
    filter_entries = [
      {
        name = "ip"
      }
    ]
    schema   = "terraform"
    template = "terraform"
    tenant   = "terraform"
    type     = "ndo"
  }
}

# Contracts
# contracts = {}
contracts = {
  "mgmt" = {
    alias               = ""
    annotation          = ""
    consumer_match_type = "AtleastOne"
    contract_type       = "standard"
    description         = ""
    filters = [
      {
        name = "mgmt"
        # template = "value"
        tenant = "common"
      }
    ]
    log_packets          = false
    provider_match_type  = "AtleastOne"
    qos_class            = "unspecified"
    reverse_filter_ports = true
    schema               = ""
    scope                = "global"
    tags                 = []
    target_dscp          = "unspecified"
    template             = ""
    tenant               = "common"
    type                 = "apic"
  }
  "terraform" = {
    filters = [
      {
        name     = "terraform_ip"
        template = "terraform"
        tenant   = "terraform"
      }
    ]
    log_packets          = false
    reverse_filter_ports = true
    schema               = "terraform"
    scope                = "global"
    tags                 = []
    template             = "terraform"
    tenant               = "terraform"
    type                 = "ndo"
} }

# Schemas
schemas = {
  "terraform" = {
    primary_template = "terraform"
    templates = [{
      name  = "terraform"
      sites = ["Asgard", "Wakanda"]
    }]
    tenant = "terraform"
  }
}

# Tenants
tenants = {
  "common" = {
    description = "APIC common Tenant"
    type        = "apic"
  }
  "terraform" = {
    description = "NDO terraform Tenant"
    sites       = ["Asgard", "Wakanda"]
    type        = "ndo"
    users       = ["admin", "tyscott"]
    vendor      = "cisco"
  }
}

# VRF