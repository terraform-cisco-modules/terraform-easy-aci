/*_____________________________________________________________________________________________________________________

Tenant — Policies — BGP Timers — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bgp_timers" {
  default = {
    "default" = {
      annotation              = ""
      description             = ""
      graceful_restart_helper = true
      hold_interval           = 180
      keepalive_interval      = 60
      maximum_as_limit        = 0
      name                    = "default"
      stale_interval          = 300
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                  = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BGP Timers Policies
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * graceful_restart_helper — (optional) Graceful restart enabled or helper only for bgp timers object.  Options are:
      - false
      - true: (default)
    * hold_interval: (default: 180) — Time period before declaring neighbor down for bgp timers object. Default value is 180.
    * keepalive_interval: (default: 60) — Interval time between keepalive messages for bgp timers object. Default value is 60.
    * maximum_as_limit: (default: 0) — Maximum AS limit for bgp timers object. Range of allowed values is 0 to 2000. Default value is 0.
    * name: (required) — Name of bgp timers object.
    * stale_interval: (default: 300) — Stale interval for routes advertised by peer for bgp timers object. Range of allowed values is 1 to 3600. Default value is 300.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation              = optional(string)
      description             = optional(string)
      graceful_restart_helper = optional(bool)
      hold_interval           = optional(number)
      keepalive_interval      = optional(number)
      maximum_as_limit        = optional(number)
      name                    = optional(string)
      stale_interval          = optional(number)
      tenant                  = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpCtxPol"
 - Distinguised Name: "uni/tn-{name}/bgpCtxP-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > BGP > BGP Timers > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bgp_timers" "policies_bgp_timers" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each     = local.policies_bgp_timers
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  gr_ctrl      = each.value.graceful_restart_helper == true ? "helper" : "none"
  hold_intvl   = each.value.hold_interval
  ka_intvl     = each.value.keepalive_interval
  max_as_limit = each.value.maximum_as_limit
  name         = each.key
  stale_intvl  = each.value.stale_interval == 300 ? "default" : each.value.stale_interval
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
