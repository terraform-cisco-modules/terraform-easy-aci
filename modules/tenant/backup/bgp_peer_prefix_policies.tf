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
resource "aci_bgp_peer_prefix" "bgp_peer_prefix_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation   = each.value.annotation
  action       = each.value.action # log|reject|restart|shut default is log
  description  = each.value.description
  name         = each.value.name
  max_pfx      = each.value.maximum_number_of_prefixes # default is 20000
  restart_time = each.value.restart_time               # default is inifinite
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
  thresh       = each.value.threshold # default is 75
}
