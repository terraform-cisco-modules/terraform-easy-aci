variable "policies_dhcp_relay" {
  default = {
    "default" = {
      alias       = ""
      annotation  = ""
      description = ""
      dhcp_relay_providers = [
        {
          address             = "198.18.10.1"
          application_profile = "default"
          epg                 = "default"
          epg_type            = "epg"
          l3out               = ""
          tenant              = ""
        }
      ]
      mode   = "visible"
      owner  = "infra"
      tenant = "common"
    }
  }
  description = <<-EOT
  Key - Name of the DHCP Relay Policy
  annotation - (Optional) Annotation for object DHCP Relay Policy.
  description - (Optional) Description for object DHCP Relay Policy.
  mode - (Optional) DHCP relay policy mode. Allowed Values are "visible" and "not-visible". Default Value is "visible".
  alias - (Optional) Name name_alias for object DHCP Relay Policy.
  owner - (Optional) Owner of the target relay servers. Allowed values are "infra" and "tenant". Default value is "infra".
  relation_dhcp_rs_prov - (Optional) List of relation to class fvEPg. Cardinality - N_TO_M. Type - Set of String.
  relation_dhcp_rs_prov.tdn - (Required) target Dn of the class fvEPg.
  relation_dhcp_rs_prov.addr - (Required) IP address for relation dhcpRsProv.
  tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias       = optional(string)
      annotation  = optional(string)
      description = optional(string)
      dhcp_relay_providers = optional(list(object(
        {
          address             = string
          application_profile = optional(string)
          epg                 = string
          epg_type            = optional(string)
          l3out               = optional(string)
          tenant              = string
        }
      )))
      mode   = optional(string)
      owner  = optional(string)
      tenant = optional(string)
    }
  ))
}

resource "aci_dhcp_relay_policy" "policies_dhcp_relay" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.policies_dhcp_relay
  annotation  = each.value.annotation
  description = each.value.description
  mode        = each.value.mode
  name        = each.key
  name_alias  = each.value.alias
  owner       = each.value.owner
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "relation_dhcp_rs_prov" {
    for_each = each.value.dhcp_relay_providers
    content {
      addr = relation_dhcp_rs_prov.value.address
      tdn = length(
        regexall("ext_epg", relation_dhcp_rs_prov.value.epg_type)
        ) > 0 ? "uni/tn-${relation_dhcp_rs_prov.value.tenant}/out-${relation_dhcp_rs_prov.value.l3out}/instP-${relation_dhcp_rs_prov.value.epg}" : length(
        regexall("epg", relation_dhcp_rs_prov.value.epg_type)
      ) > 0 ? "uni/tn-${relation_dhcp_rs_prov.value.tenant}/ap-${relation_dhcp_rs_prov.value.appication_profile}/epg-${relation_dhcp_rs_prov.value.epg}" : ""
    }
  }
}
