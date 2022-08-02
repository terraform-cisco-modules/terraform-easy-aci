/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvTenant"
 - Distinguished Name: "uni/tn-{tenant}""
GUI Location:
 - Tenants > Create Tenant > {tenant}
_______________________________________________________________________________________________________________________
*/
resource "aci_tenant" "test123" {
  annotation                    = "orchestrator:terraform:easy-aci-v1.2"
  description                   = "test123 tenant"
  name                          = "test123"
  relation_fv_rs_tenant_mon_pol = "uni/tn-common/monepg-default"
}

resource "aci_ospf_route_summarization" "policies_ospf_route_summarization" {
  depends_on = [
    aci_tenant.test123
  ]
  annotation         = "orchestrator:terraform:easy-aci-v1.2"
  cost               = "unspecified"
  description        = "test123 tenant"
  inter_area_enabled = "yes"
  name               = "test123"
  tag                = 0
  tenant_dn          = "uni/tn-test123"
}
