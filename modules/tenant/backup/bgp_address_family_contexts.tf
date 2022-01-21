resource "aci_bgp_address_family_context" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation    = each.value.annotation
  ctrl          = each.value.ctrl
  description   = each.value.description
  e_dist        = each.value.e_dist
  i_dist        = each.value.i_dist
  local_dist    = each.value.local_dist
  max_ecmp      = each.value.max_ecmp
  max_ecmp_ibgp = each.value.max_ecmp_ibgp
  name          = each.value.name
  name_alias    = each.value.name_alias
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent tenant object.
# name - (Required) Name of BGP address family context object.
# description - (Optional) Description for BGP address family context object.
# annotation - (Optional) Annotation for BGP address family context object.
# ctrl - (Optional) Control state for BGP address family context object. Allowed value is "host-rt-leak".
# e_dist - (Optional) Administrative distance of EBGP routes for BGP address family context object. Range of allowed values is "1" to "255". Default value is "20".
# i_dist - (Optional) Administrative distance of IBGP routes for BGP address family context object. Range of allowed values is "1" to "255". Default value is "200".
# local_dist - (Optional) Administrative distance of local routes for BGP address family context object. Range of allowed values is "1" to "255". Default value is "220".
# max_ecmp - (Optional) Maximum number of equal-cost paths for BGP address family context object.Range of allowed values is "1" to "64". Default value is "16".
# max_ecmp_ibgp - (Optional) Maximum ECMP IBGP for BGP address family context object. Range of allowed values is "1" to "64". Default value is "16".
# name_alias - (Optional) Name alias for BGP address family context object.