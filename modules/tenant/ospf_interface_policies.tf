#------------------------------------------------
# Create a OSPF Interface Policy
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfPol"
 - Distinguished Name: "/uni/tn-{tenant}/ospfIfPol-{policy_name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > OSPF >  OSPF Interface > {policy_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_ospf_interface_policy" "ospf_interface_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.ospf_interface_policies
  tenant_dn   = aci_tenant.aci_tenant.tenants[each.value.tenant].id
  description = each.value.description
  name        = each.key
  cost        = each.value.cost_of_interface
  ctrl        = each.value.interface_controls
  dead_intvl  = each.value.dead_interval
  hello_intvl = each.value.hello_interval
  nw_t        = each.value.network_type
  # pfx_suppress  = each.value.pfx_suppress
  prio         = each.value.priority
  rexmit_intvl = each.value.retransmit_interval
  xmit_delay   = each.value.transmit_delay
}
