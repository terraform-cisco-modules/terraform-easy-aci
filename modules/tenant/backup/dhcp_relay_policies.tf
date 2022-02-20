resource "aci_dhcp_relay_policy" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  annotation  = "annotation_example"
  description = "from terraform"
  mode        = "visible"
  name        = "name_example"
  name_alias  = "name_alias_example"
  owner       = "infra"
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "relation_dhcp_rs_prov" {
    for_each = each.value.dhcp_relay_providers
    addr     = "10.20.30.40"
    tdn = length(
      regexall("ext_epg", relation_dhcp_rs_prov.value.epg_type)
      ) > 0 ? aci_application_epg.application_epgs[each.value.epg].id : length(
      regexall("epg", relation_dhcp_rs_prov.value.epg_type)
    ) > 0 ? aci_application_epg.application_epgs[each.value.epg].id : ""
  }
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent Tenant object.
# name - (Required) Name of Object DHCP Relay Policy.
# annotation - (Optional) Annotation for object DHCP Relay Policy.
# description - (Optional) Description for object DHCP Relay Policy.
# mode - (Optional) DHCP relay policy mode. Allowed Values are "visible" and "not-visible". Default Value is "visible".
# name_alias - (Optional) Name name_alias for object DHCP Relay Policy.
# owner - (Optional) Owner of the target relay servers. Allowed values are "infra" and "tenant". Default value is "infra".
# relation_dhcp_rs_prov - (Optional) List of relation to class fvEPg. Cardinality - N_TO_M. Type - Set of String.
# relation_dhcp_rs_prov.tdn - (Required) target Dn of the class fvEPg.
# relation_dhcp_rs_prov.addr - (Required) IP address for relation dhcpRsProv.