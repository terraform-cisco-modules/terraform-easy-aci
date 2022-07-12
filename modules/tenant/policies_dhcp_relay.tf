/*_____________________________________________________________________________________________________________________

Tenant — Policies — DHCP Relay — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_dhcp_relay" {
  default = {
    "default" = {
      annotation  = ""
      description = ""
      dhcp_relay_providers = [
        {
          address             = "198.18.10.1"
          application_profile = "default"
          epg                 = "default"
          epg_type            = "application_epg"
          l3out               = ""
          tenant              = ""
        }
      ]
      mode  = "visible"
      owner = "infra"
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the DHCP Relay Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * dhcp_relay_providers: (optional) — List of DHCP Relay Provider attributes.
      - address: (required) — The server IP address.
      - application_profile: (required if epg_type is epg) — Name of parent Application Profile object.
      - epg: (default: default) — Name of the EPG/External-EPG Object.
      - epg_type: (optional) — The Type of EPG to assign to the DHCP relay Provider.
        * application_epg: (default)
        * external_epg
      - l3out: (required if epg_type is external_epg) — Name of parent L3Out object.
      - tenant: (required) — Name of parent Tenant object.
    * mode: (optional) — DHCP relay policy mode. Allowed Values are:
      - visible: (default)
      - not-visible
    * owner: (optional) — Owner of the target relay servers. Allowed values are:
      - infra: (default)
      - tenant
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dhcpRelayPol"
 - Distinguised Name: "uni/tn-{name}/relayp-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > DHCP > Relay Policies > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_dhcp_relay_policy" "policies_dhcp_relay" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.policies_dhcp_relay
  annotation  = each.value.annotation
  description = each.value.description
  mode        = each.value.mode
  name        = each.key
  owner       = each.value.owner
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "relation_dhcp_rs_prov" {
    for_each = each.value.dhcp_relay_providers
    content {
      addr = relation_dhcp_rs_prov.value.address
      tdn = length(
        regexall("external_epg", relation_dhcp_rs_prov.value.epg_type)
        ) > 0 ? "uni/tn-${relation_dhcp_rs_prov.value.tenant}/out-${relation_dhcp_rs_prov.value.l3out}/instP-${relation_dhcp_rs_prov.value.epg}" : length(
        regexall("application_epg", relation_dhcp_rs_prov.value.epg_type)
      ) > 0 ? "uni/tn-${relation_dhcp_rs_prov.value.tenant}/ap-${relation_dhcp_rs_prov.value.appication_profile}/epg-${relation_dhcp_rs_prov.value.epg}" : ""
    }
  }
}
