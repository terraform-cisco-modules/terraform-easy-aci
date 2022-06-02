variable "fabric_wide_settings" {
  default = {
    "default" = {
      annotation                        = ""
      disable_remote_ep_learning        = true
      enforce_domain_validation         = true
      enforce_epg_vlan_validation       = false
      enforce_subnet_check              = true
      leaf_opflex_client_authentication = true
      leaf_ssl_opflex                   = true
      reallocate_gipo                   = false
      restrict_infra_vlan_traffic       = false
      ssl_opflex_versions = [{
        TLSv1   = false
        TLSv1_1 = false
        TLSv1_2 = true
      }]
      spine_opflex_client_authentication = true
      spine_ssl_opflex                   = true
    }
  }
  type = map(object(
    {
      annotation                        = optional(string)
      disable_remote_ep_learning        = optional(bool)
      enforce_domain_validation         = optional(bool)
      enforce_epg_vlan_validation       = optional(bool)
      enforce_subnet_check              = optional(bool)
      leaf_opflex_client_authentication = optional(bool)
      leaf_ssl_opflex                   = optional(bool)
      reallocate_gipo                   = optional(bool)
      restrict_infra_vlan_traffic       = optional(bool)
      ssl_opflex_versions = optional(list(object(
        {
          TLSv1   = optional(bool)
          TLSv1_1 = optional(bool)
          TLSv1_2 = optional(bool)
        }
      )))
      spine_opflex_client_authentication = optional(bool)
      spine_ssl_opflex                   = optional(bool)
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraSetPol"
 - Distinguished Name: "uni/infra/settings"
GUI Location:
 - System > System Settings > Fabric Wide Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "fabric_wide_settings" {
  for_each   = { for k, v in local.fabric_wide_settings : k => v if length(regexall("(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", var.apic_version)) > 0 }
  dn         = "uni/infra/settings"
  class_name = "infraSetPol"
  content = {
    # annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
    domainValidation           = each.value.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck         = each.value.enforce_subnet_check == true ? "yes" : "no"
    opflexpAuthenticateClients = each.value.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpUseSsl              = each.value.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo             = each.value.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic   = each.value.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable    = each.value.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans   = each.value.enforce_epg_vlan_validation == true ? "yes" : "no"
  }
}

resource "aci_rest_managed" "fabric_wide_settings_5_2_3" {
  for_each   = { for k, v in local.fabric_wide_settings : k => v if length(regexall("5.2(3[a-z])", var.apic_version)) > 0 }
  dn         = "uni/infra/settings"
  class_name = "infraSetPol"
  content = {
    # disableEpDampening     = 	each.value. # disable_ep_dampening
    # enableMoStreaming      = 	each.value.
    # enableRemoteLeafDirect = 	each.value.
    # policySyncNodeBringup  = 	each.value.
    domainValidation               = each.value.enforce_domain_validation == true ? "yes" : "no"
    enforceSubnetCheck             = each.value.enforce_subnet_check == true ? "yes" : "no"
    leafOpflexpAuthenticateClients = each.value.leaf_opflex_client_authentication == true ? "yes" : "no"
    leafOpflexpUseSsl              = each.value.leaf_ssl_opflex == true ? "yes" : "no"
    opflexpAuthenticateClients     = each.value.spine_opflex_client_authentication == true ? "yes" : "no"
    opflexpSslProtocols = anytrue(
      [
        each.value.ssl_opflex_versions[0].TLSv1,
        each.value.ssl_opflex_versions[0].TLSv1_1,
        each.value.ssl_opflex_versions[0].TLSv1_2
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.ssl_opflex_versions[0].TLSv1)) > 0 ? "TLSv1" : ""], [
        length(regexall(true, each.value.ssl_opflex_versions[0].TLSv1_1)) > 0 ? "TLSv1.1" : ""], [
        length(regexall(true, each.value.ssl_opflex_versions[0].TLSv1_2)) > 0 ? "TLSv1.2" : ""]
    )), ","), ",,", ",") : "TLSv1.1,TLSv1.2"
    opflexpUseSsl            = each.value.spine_ssl_opflex == true ? "yes" : "no"
    reallocateGipo           = each.value.reallocate_gipo == true ? "yes" : "no"
    restrictInfraVLANTraffic = each.value.restrict_infra_vlan_traffic == true ? "yes" : "no"
    unicastXrEpLearnDisable  = each.value.disable_remote_ep_learning == true ? "yes" : "no"
    validateOverlappingVlans = each.value.enforce_epg_vlan_validation == true ? "yes" : "no"
  }
}
