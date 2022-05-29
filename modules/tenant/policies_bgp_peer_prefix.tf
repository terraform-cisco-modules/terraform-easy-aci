#------------------------------------------------
# Create a BGP Peer Connectivity Profile
#------------------------------------------------

/*
API Information:
 - Class: "bgpPeerPfxPol"
 - Distinguished Name: "uni/tn-{tenant}/bgpPfxP-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > BGP >  BGP Peer Prefix > {name}
*/
variable "bgp_peer_prefix_policies" {
  default = {
    "default" = {
      action                     = "reject"
      annotation                 = ""
      description                = ""
      maximum_number_of_prefixes = 20000
      restart_time               = "infinite"
      tenant                     = "common"
      threshold                  = 75
    }
  }
  description = <<-EOT
  Key - Name of the BGP Peer Prefix Policies
  * alias - (Optional) Name alias for BGP peer prefix object.
  * action - (Optional) Action when the maximum prefix limit is reached for BGP peer prefix object. Allowed values are "log", "reject", "restart" and "shut". Default value is "reject".
  * annotation - (Optional) Annotation for BGP peer prefix object.
  * description - (Optional) Description for BGP peer prefix object.
  * maximum_number_of_prefixes - (Optional) Maximum number of prefixes allowed from the peer for BGP peer prefix object. Default value is "20000".
  * restart_time - (Optional) The period of time in minutes before restarting the peer when the prefix limit is reached for BGP peer prefix object. Default value is "infinite".
  * tenant - (Required) Name of parent Tenant object.
  * threshold - (Optional) Threshold percentage of the maximum number of prefixes before a warning is issued for BGP peer prefix object. Default value is "75".
  EOT
  type = map(object(
    {
      action                     = optional(string)
      annotation                 = optional(string)
      description                = optional(string)
      maximum_number_of_prefixes = optional(number)
      name                       = optional(string)
      restart_time               = optional(string)
      tenant                     = optional(string)
      threshold                  = optional(number)
    }
  ))
}

resource "aci_bgp_peer_prefix" "bgp_peer_prefix_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.bgp_peer_prefix_policies
  action   = each.value.action # log|reject|restart|shut default is log
  # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  name         = each.key
  max_pfx      = each.value.maximum_number_of_prefixes # default is 20000
  restart_time = each.value.restart_time               # default is inifinite
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
  thresh       = each.value.threshold # default is 75
}


