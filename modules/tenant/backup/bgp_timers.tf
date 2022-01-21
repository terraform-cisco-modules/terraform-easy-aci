resource "aci_bgp_timers" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation   = "example"
  description  = "from terraform"
  gr_ctrl      = "helper"
  hold_intvl   = "189"
  ka_intvl     = "65"
  max_as_limit = "70"
  name         = "one"
  name_alias   = "aliasing"
  stale_intvl  = "15"
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent tenant object.
# name - (Required) Name of bgp timers object.
# annotation - (Optional) Annotation for bgp timers object.
# description - (Optional) Description for bgp timers object.
# gr_ctrl - (Optional) Graceful restart enabled or helper only for bgp timers object. Default value is "helper".
# hold_intvl - (Optional) Time period before declaring neighbor down for bgp timers object. Default value is "180".
# ka_intvl - (Optional) Interval time between keepalive messages for bgp timers object. Default value is "60".
# max_as_limit - (Optional) Maximum AS limit for bgp timers object. Range of allowed values is "0" to "2000". Default value is "0".
# name_alias - (Optional) Name alias for bgp timers object. Default value is "default".
# stale_intvl - (Optional) Stale interval for routes advertised by peer for bgp timers object. Range of allowed values is "1" to "3600". Default value is "300".