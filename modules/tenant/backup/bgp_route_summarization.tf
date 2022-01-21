resource "aci_bgp_route_summarization" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation  = each.value.annotation
  attrmap     = each.value.attrmap
  ctrl        = each.value.ctrl
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent tenant object.
# name - (Required) Name of Object BGP route summarization.
# annotation - (Optional) Annotation for object BGP route summarization.
# description - (Optional) Description for object BGP route summarization.
# attrmap - (Optional) Summary attribute map.
# ctrl - (Optional) The control state. Allowed values: "as-set", "none". Default value: "none".
# name_alias - (Optional) Name alias for object BGP route summarization.