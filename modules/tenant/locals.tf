locals {
  #__________________________________________________________
  #
  # Tenant Variables
  #__________________________________________________________

  tenants = {
    for k, v in var.tenants : k => {
      alias             = v.alias != null ? v.alias : ""
      description       = v.description != null ? v.description : ""
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : ""
      name              = v.name != null ? v.name : "common"
      sites             = v.sites != null ? v.sites : []
      tags              = v.tags != null ? v.tags : ""
      type              = v.type != null ? v.type : "apic"
      users             = v.users != null ? v.users : []
      vendor            = v.vendor != null ? v.vendor : "cisco"
    }
  }
}