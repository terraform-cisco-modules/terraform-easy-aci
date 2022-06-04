/*_____________________________________________________________________________________________________________________

Fabric Wide Settings — Variables
_______________________________________________________________________________________________________________________
*/
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
  description = <<-EOT
    Key - This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * disable_remote_ep_learning: (optional) — You should enable this policy in fabrics which include the Cisco Nexus 9000 series switches, 93128 TX, 9396 PX, or 9396 TX switches with the N9K-M12PQ uplink module, after all the nodes have been successfully upgraded to APIC Release 2.2(2x).
      - Note: After any of the following configuration changes, you may need to manually flush previously learned IP endpoints:
        * Remote IP endpoint learning is disabled.
        * The VRF is configured for ingress policy enforcement.
        * At least one Layer 3 interface exists in the VRF.
      - To manually flush previously learned IP endpoints, enter the following command on both VPC peers: vsh -c "clear system internal epm endpoint vrf <vrf-name> remote"
      - false
      - true: (default)
    * enforce_domain_validation: (optional) — Enable a validation check when static paths are added, to ensure that a domain is attached to the EPG on the path.
      - false
      - true: (default)
    * enforce_epg_vlan_validation: (optional) — When checked, the system globally prevents overlapping VLAN pools from being assigned to EPGs.
      - Note:  If overlapping VLAN pools already exist and this parameter is checked, the system returns an error. You must assign VLAN pools that are not overlapping to the EPGs before choosing this feature.
      - If this parameter is checked and an attempt is made to add an overlapping VLAN pool to an EPG, the system returns an error.
      - false: (default)
      - true
    * enforce_subnet_check: (optional) — When checked, IP address learning on outside of subnets configured in a VRF, for all VRFs are disabled.
      - false
      - true: (default)
    * leaf_opflex_client_authentication: (optional) — To enforce Opflex client certificate authentication on leaf switches for GOLF and Linux.
      - false
      - true: (default)
    * leaf_ssl_opflex: (optional) — To enable SSL Opflex transport for leaf switches.
      - false
      - true: (default)
    * reallocate_gipo: (optional) — Enable reallocating group IP outer addresses (Gipos) on non-stretched BDs to make room for stretched BDs.
      - false: (default)
      - true
    * restrict_infra_vlan_traffic: (optional) — This feature restricts Infra VLAN traffic to only network paths specified by Infra security entry policies. When this feature is enabled, each leaf switch limits Infra VLAN traffic between compute nodes to allow only iVXLAN traffic. The switch also limits traffic to fabric nodes to allow only OpFlex and iVXLAN/VXLAN traffic. APIC management traffic is allowed on front panel ports on the Infra VLAN.
      - false: (default)
      - true
    * ssl_opflex_versions: (optional) — This is only applicable to APIC version 5.2 and greater.
      - TLSv1: (default: false)
      - TLSv1_1: (default: false)
      - TLSv1_2: (default: true)
    * spine_opflex_client_authentication: (optional) — To enforce Opflex client certificate authentication on spine switches for GOLF and Linux.
      - false
      - true: (default)
    * spine_ssl_opflex: (optional) — To enable SSL Opflex transport for spine switches.
      - false
      - true: (default)
  EOT
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
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
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
  class_name = "infraSetPol"
  dn         = "uni/infra/settings"
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
