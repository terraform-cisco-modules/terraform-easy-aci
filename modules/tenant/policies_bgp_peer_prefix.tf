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
      restart_time               = 65535
      threshold                  = 75
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                     = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BGP Peer Prefix Policies
    * action: (optional) — Action when the maximum prefix limit is reached for BGP peer prefix object. Allowed values are:
      - log
      - reject
      - restart: (default)
      - shut
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * maximum_number_of_prefixes: (default: 20000) — Maximum number of prefixes allowed from the peer for BGP peer prefix object.  Range is 1-300000.
    * restart_time: (default: 65535) — The period of time in minutes before restarting the peer when the prefix limit is reached for BGP peer prefix object. Range is 1-65535.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
    * threshold: (default: 75) — Threshold percentage of the maximum number of prefixes before a warning is issued for BGP peer prefix object. Range is 1-100.
  EOT
  type = map(object(
    {
      action                     = optional(string)
      annotation                 = optional(string)
      description                = optional(string)
      maximum_number_of_prefixes = optional(number)
      name                       = optional(string)
      restart_time               = optional(number)
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
  for_each     = local.policies_bgp_peer_prefix
  action       = each.value.action
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  name         = each.key
  max_pfx      = each.value.maximum_number_of_prefixes
  restart_time = each.value.restart_time == 65535 ? "infinite" : each.value.restart_time
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
  thresh       = each.value.threshold
}


