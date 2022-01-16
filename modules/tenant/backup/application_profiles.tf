/*_____________________________________________________________________________________________________________________

API Location:
 - Class: "fvAp"
 - Distinguished Name: "uni/tn-[Tenant]/ap-{App_Profile}"
GUI Location:
 - Tenants > {Tenant} > Application Profiles > {App_Profile}
_______________________________________________________________________________________________________________________
*/
resource "aci_application_profile" "application_profiles" {
  depends_on = [
    aci_tenant.tenants
  ]
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  prio        = each.value.priority
  # relation_fv_rs_ctx_mon_pol  = "{monEPGPol}"
}
