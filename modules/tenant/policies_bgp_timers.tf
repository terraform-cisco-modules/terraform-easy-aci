variable "policies_bgp_timers" {
  default = {
    "default" = {
      alias                   = ""
      annotation              = ""
      description             = ""
      graceful_restart_helper = true
      hold_interval           = 180
      keepalive_interval      = 60
      maximum_as_limit        = 0
      name                    = "default"
      stale_interval          = 300
      tenant                  = "common"
    }
  }
  description = <<-EOT
  Key - Name of the BGP Timers Policies
  * alias - (Optional) Name alias for bgp timers object. Default value is "default".
  * annotation - (Optional) Annotation for bgp timers object.
  * description - (Optional) Description for bgp timers object.
  * graceful_restart_helper - (Boolean) Graceful restart enabled or helper only for bgp timers object.  Default is true
  * hold_interval - (Optional) Time period before declaring neighbor down for bgp timers object. Default value is 180.
  * keepalive_interval - (Optional) Interval time between keepalive messages for bgp timers object. Default value is 60.
  * maximum_as_limit - (Optional) Maximum AS limit for bgp timers object. Range of allowed values is 0 to 2000. Default value is 0.
  * name - (Required) Name of bgp timers object.
  * stale_interval - (Optional) Stale interval for routes advertised by peer for bgp timers object. Range of allowed values is 1 to 3600. Default value is 300.
  * tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias                   = optional(string)
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

resource "aci_bgp_timers" "policies_bgp_timers" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.policies_bgp_timers
  # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  gr_ctrl      = each.value.graceful_restart_helper == true ? "helper" : "none"
  hold_intvl   = each.value.hold_interval
  ka_intvl     = each.value.keepalive_interval
  max_as_limit = each.value.maximum_as_limit
  name         = each.key
  name_alias   = each.value.alias
  stale_intvl  = each.value.stale_interval == 300 ? "default" : each.value.stale_interval
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
