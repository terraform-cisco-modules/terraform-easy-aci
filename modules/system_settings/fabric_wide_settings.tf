variable "fabric_wide_settings" {
  default = {
    "default" = {
      disable_remote_ep_learning        = "yes"
      enforce_domain_validation         = "yes"
      enforce_epg_vlan_validation       = "no"
      enforce_subnet_check              = "yes"
      leaf_opflex_client_authentication = "yes"
      leaf_ssl_opflex                   = "yes"
      reallocate_gipo                   = "no"
      restrict_infra_vlan_traffic       = "no"
      ssl_opflex_versions = [{
        TLSv1   = false
        TLSv1_1 = false
        TLSv1_2 = true
      }]
      spine_opflex_client_authentication = "yes"
      spine_ssl_opflex                   = "yes"
      tags                               = ""
    }
  }
  type = map(object(
    {
      disable_remote_ep_learning        = optional(string)
      enforce_domain_validation         = optional(string)
      enforce_epg_vlan_validation       = optional(string)
      enforce_subnet_check              = optional(string)
      leaf_opflex_client_authentication = optional(string)
      leaf_ssl_opflex                   = optional(string)
      reallocate_gipo                   = optional(string)
      restrict_infra_vlan_traffic       = optional(string)
      ssl_opflex_versions = list(object(
        {
          TLSv1   = bool
          TLSv1_1 = bool
          TLSv1_2 = bool
        }
      ))
      spine_opflex_client_authentication = optional(string)
      spine_ssl_opflex                   = optional(string)
      tags                               = optional(string)
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
resource "aci_rest" "fabric_wide_settings" {
  provider   = netascode
  for_each   = { for k, v in local.fabric_wide_settings : k => v if length(regexall("(^[3-4]\\..*|^5.[0-1].*|^5.2\\([0-2].*\\))", var.apic_version)) > 0 }
  dn         = "uni/infra/settings"
  class_name = "infraSetPol"
  content = {
    annotation                 = each.value.tags != "" ? each.value.tags : var.tags
    domainValidation           = each.value.enforce_domain_validation
    enforceSubnetCheck         = each.value.enforce_subnet_check
    opflexpAuthenticateClients = each.value.spine_opflex_client_authentication
    opflexpUseSsl              = each.value.spine_ssl_opflex
    reallocateGipo             = each.value.reallocate_gipo
    restrictInfraVLANTraffic   = each.value.restrict_infra_vlan_traffic
    unicastXrEpLearnDisable    = each.value.disable_remote_ep_learning
    validateOverlappingVlans   = each.value.enforce_epg_vlan_validation
  }
}

resource "aci_rest" "fabric_wide_settings_5_2_3" {
  provider   = netascode
  for_each   = { for k, v in local.fabric_wide_settings : k => v if length(regexall("5.2(3[a-z])", var.apic_version)) > 0 }
  dn         = "uni/infra/settings"
  class_name = "infraSetPol"
  content = {
    # disableEpDampening     = 	each.value. # disable_ep_dampening
    # enableMoStreaming      = 	each.value.
    # enableRemoteLeafDirect = 	each.value.
    # policySyncNodeBringup  = 	each.value.
    domainValidation               = each.value.enforce_domain_validation
    enforceSubnetCheck             = each.value.enforce_subnet_check
    leafOpflexpAuthenticateClients = each.value.leaf_opflex_client_authentication
    leafOpflexpUseSsl              = each.value.leaf_ssl_opflex
    opflexpAuthenticateClients     = each.value.spine_opflex_client_authentication
    opflexpSslProtocols = alltrue(
      [each.value.ssl_opflex_version1_0, each.value.ssl_opflex_version1_1, each.value.ssl_opflex_version1_2]
      ) ? "TLSv1,TLSv1.1,TLSv1.2" : anytrue(
      [each.value.ssl_opflex_version1_0, each.value.ssl_opflex_version1_1, each.value.ssl_opflex_version1_2]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.ssl_opflex_version1_0)) > 0 ? "TLSv1" : ""], [
        length(regexall(true, each.value.ssl_opflex_version1_1)) > 0 ? "TLSv1.1" : ""], [
        length(regexall(true, each.value.ssl_opflex_version1_2)) > 0 ? "TLSv1.2" : ""]
    )), ","), ",,", ",") : "TLSv1.1,TLSv1.2"
    opflexpUseSsl            = each.value.spine_ssl_opflex
    reallocateGipo           = each.value.reallocate_gipo
    restrictInfraVLANTraffic = each.value.restrict_infra_vlan_traffic
    unicastXrEpLearnDisable  = each.value.disable_remote_ep_learning
    validateOverlappingVlans = each.value.enforce_epg_vlan_validation
  }
}
