resource "aci_bgp_best_path_policy" "foobgp_best_path_policy" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation  = each.value.annotation
  ctrl        = each.value.ctrl
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent tenant object.
# name - (Required) Name of Object BGP Best Path Policy.
# annotation - (Optional) Annotation for object BGP Best Path Policy.
# description - (Optional) Description for object BGP Best Path Policy.
# ctrl - (Optional) The control state.
# Allowed values: "asPathMultipathRelax", "0". Default Value: "0".
# name_alias - (Optional) Name alias for object BGP Best Path Policy.