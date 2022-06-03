/*_____________________________________________________________________________________________________________________

DNS Profile — Variables
_______________________________________________________________________________________________________________________
*/
variable "dns_profiles" {
  default = {
    default = {
      annotation            = ""
      description           = ""
      dns_domains           = []
      dns_providers         = []
      ip_version_preference = "IPv4"
      management_epg        = "default"
      management_epg_type   = "oob"
    }
  }
  description = <<-EOT
    Key - Name for the DNS Profile
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      dns_domains           = []
          domain         = string
          default_domain = optional(bool)
          description    = optional(string)
      dns_providers         = []
          description  = optional(string)
          dns_provider = string
          preferred    = optional(string)
      ip_version_preference = "IPv4"
      management_epg        = "default"
      management_epg_type   = "oob"
  EOT
  type = map(object(
    {
      annotation  = optional(string)
      description = optional(string)
      dns_domains = optional(list(object(
        {
          domain         = string
          default_domain = optional(bool)
          description    = optional(string)
        }
      )))
      dns_providers = optional(list(object(
        {
          description  = optional(string)
          dns_provider = string
          preferred    = optional(string)
        }
      )))
      ip_version_preference = optional(string)
      management_epg        = optional(string)
      management_epg_type   = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsProfile"
 - Distinguished Name: "uni/fabric/dnsp-{name}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > default: Management EPG
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_profiles" {
  for_each   = local.dns_profiles
  class_name = "dnsProfile"
  dn         = "uni/fabric/dnsp-${each.key}"
  content = {
    # annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr           = each.value.description
    IPVerPreference = each.value.ip_version_preference
    name            = each.key
  }
  child {
    class_name = "dnsRsProfileToEpg"
    rn         = "rsProfileToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsProv"
 - Distinguished Name: "uni/fabric/dnsp-{name}/prov-[{dns_provider}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > {name}: DNS Providers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_providers" {
  depends_on = [
    aci_rest_managed.dns_profiles
  ]
  for_each   = local.dns_providers
  class_name = "dnsProv"
  dn         = "uni/fabric/dnsp-${each.value.key1}/prov-[${each.value.dns_provider}]"
  content = {
    addr = each.value.dns_provider
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    preferred = each.value.preferred == true ? "yes" : "no"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dnsDomain"
 - Distinguished Name: "uni/fabric/dnsp-{name}/dom-[{domain}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Global > DNS Profiles > {name}: DNS Domains
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "dns_domains" {
  depends_on = [
    aci_rest_managed.dns_profiles
  ]
  for_each   = local.dns_domains
  class_name = "dnsDomain"
  dn         = "uni/fabric/dnsp-${each.value.key1}/dom-[${each.value.domain}]"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr     = each.value.description
    isDefault = each.value.default_domain == true ? "yes" : "no"
    name      = each.value.domain
  }
}
