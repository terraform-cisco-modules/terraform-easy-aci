/*_____________________________________________________________________________________________________________________

Tenant — Policies — BGP Peer Prefix — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bgp_peer_prefix" {
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
  * alias: (optional) — Name alias for BGP peer prefix object.
  * action: (optional) — Action when the maximum prefix limit is reached for BGP peer prefix object. Allowed values are "log", "reject", "restart" and "shut". Default value is "reject".
  * annotation: (optional) — Annotation for BGP peer prefix object.
  * description: (optional) — Description for BGP peer prefix object.
  * maximum_number_of_prefixes: (optional) — Maximum number of prefixes allowed from the peer for BGP peer prefix object. Default value is "20000".
  * restart_time: (optional) — The period of time in minutes before restarting the peer when the prefix limit is reached for BGP peer prefix object. Default value is "infinite".
  * tenant: (required) — Name of parent Tenant object.
  * threshold: (optional) — Threshold percentage of the maximum number of prefixes before a warning is issued for BGP peer prefix object. Default value is "75".
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

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpPeerPfxPol"
 - Distinguished Name: "uni/tn-{tenant}/bgpPfxP-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > BGP >  BGP Peer Prefix > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bgp_peer_prefix" "policies_bgp_peer_prefix" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.policies_bgp_peer_prefix
  action   = each.value.action # log|reject|restart|shut default is log
  # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  name         = each.key
  max_pfx      = each.value.maximum_number_of_prefixes # default is 20000
  restart_time = each.value.restart_time               # default is inifinite
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
  thresh       = each.value.threshold # default is 75
}


