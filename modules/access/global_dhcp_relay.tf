/*_____________________________________________________________________________________________________________________

Fabric — Access Policies — Global - DHCP Relay — Variables
_______________________________________________________________________________________________________________________
*/
variable "global_dhcp_relay" {
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
          tenant              = "common"
        }
      ]
      mode = "visible"
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
      mode = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dhcpRelayPol"
 - Distinguised Name: "uni/infra-{name}/relayp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > DHCP Relay > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "global_dhcp_relay" {
  for_each   = local.global_dhcp_relay
  class_name = "dhcpRelayP"
  dn         = "uni/infra/relayp-${each.key}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr = each.value.description
    mode  = each.value.mode
    name  = each.key
    owner = "infra"
  }
  child {
    rn = length(
      regexall("external_epg", each.value.dhcp_relay_providers[0]["epg_type"])
      ) > 0 ? "rsprov-[uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/out-${each.value.dhcp_relay_providers[0]["l3out"]}/instP-${each.value.dhcp_relay_providers[0]["epg"]}]" : length(
      regexall("application_epg", each.value.dhcp_relay_providers[0]["epg_type"])
    ) > 0 ? "rsprov-[uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/ap-${each.value.dhcp_relay_providers[0]["application_profile"]}/epg-${each.value.dhcp_relay_providers[0]["epg"]}]" : ""
    class_name = "dhcpRsProv"
    content = {
      addr = each.value.dhcp_relay_providers[0]["address"]
      tDn = length(
        regexall("external_epg", each.value.dhcp_relay_providers[0]["epg_type"])
        ) > 0 ? "uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/out-${each.value.dhcp_relay_providers[0]["l3out"]}/instP-${each.value.dhcp_relay_providers[0]["epg"]}" : length(
        regexall("application_epg", each.value.dhcp_relay_providers[0]["epg_type"])
      ) > 0 ? "uni/tn-${each.value.dhcp_relay_providers[0]["tenant"]}/ap-${each.value.dhcp_relay_providers[0]["application_profile"]}/epg-${each.value.dhcp_relay_providers[0]["epg"]}" : ""
    }
  }
}
