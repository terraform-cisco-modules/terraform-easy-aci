
/*_____________________________________________________________________________________________________________________

Leaf Policy Group Variables
_______________________________________________________________________________________________________________________
*/
variable "virtual_networking" {
  default = {
    "default" = {
      vmm_domain = "**REQUIRED**"
      vmm_credentials = {
        "default" = {
          description = ""
          password    = 1
          username    = "**REQUIRED**"
        }
      }
      vmm_controller = {
        "default" = {
          annotation             = ""
          datacenter             = "**REQUIRED**"
          dvs_version            = "unmanaged"
          hostname               = "**REQUIRED**"
          management_epg         = ""
          monitoring_policy      = "default"
          policy_scope           = "vm"
          port                   = "0"
          sequence_number        = "0"
          stats_collection       = "disabled"
          trigger_inventory_sync = "untriggered"
          virtual_switch_type    = "default"
        }
      }
      vswitch_policy = {
        "default" = {
          active_flow_timeout   = "60"
          alias                 = ""
          annotation            = ""
          idle_flow_timeout     = "15"
          sample_rate           = "0"
          netflow_export_policy = ""
        }
      }
    }
  }
  description = <<-EOT
  key - Name of the Leaf Policy Group.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * bfd_ipv4_policy: The BFD IPv4 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
  * bfd_ipv6_policy: The BFD IPv6 policy name.  Bidirectional Forwarding Detection (BFD) is used to provide sub-second failure detection times in the forwarding path between Cisco ACI fabric border leaf switches configured to support peering router connections.
  * bfd_multihop_ipv4_policy: The BFD multihop IPv4 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv4 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
  * bfd_multihop_ipv6_policy: The BFD multihop IPv6 policy name.  Bidirectional Forwarding Detection (BFD) multihop for IPv6 provides subsecond forwarding failure detection for a destination with more than one hop and up to 255 hops.
  * cdp_policy: The CDP policy name.  CDP is used to obtain protocol addresses of neighboring devices and discover those devices. CDP is also be used to display information about the interfaces connecting to the neighboring devices. CDP is media- and protocol-independent, and runs on all Cisco-manufactured equipments including routers, bridges, access servers, and switches.
  * copp_leaf_policy: The leaf CoPP policy name.  Control Plane Policing (CoPP) protects the control plane, which ensures network stability, reachability, and packet delivery.
  * copp_pre_filter: The CoPP Pre-Filter name.  A CoPP prefilter profile is used on spine and leaf switches to filter access to authentication services based on specified sources and TCP ports to protect against DDoS attacks. When deployed on a switch, control plane traffic is denied by default. Only the traffic specified in the CoPP prefilter profile is permitted.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * dot1x_authentication_policy: The 802.1x node authentication policy name.  An 802.1x node authorization policy is a client and server-based access control and authentication protocol that restricts unauthorized clients from connecting to a LAN through publicly accessible ports.
  * equipment_flash_config: Flash Configuration Policy.
  * fast_link_failover_policy: The fast link failover policy name.  A fast link failover policy provides better convergence of the network.  Fast link failover policies are not supported on the same port as port profiles or remote leaf switch connections.
  * fibre_channel_node_policy: The default Fibre Channel node policy name.  Fibre channel node policies specify FCoE-related settings, such as the load balance options and FIP keep alive intervals. 
  * fibre_channel_san_policy: The Fibre Channel SAN policy name.  Fibre Channel SAN policies specify FCoE-related settings: Error detect timeout values (EDTOV), resource allocation timeout values (RATOV), and the MAC address prefix (also called FC map) used by the leaf switch. Typically the default value 0E:FC:00 is used. 
  * forward_scale_profile_policy: The forwarding scale profile policy name.  The forwarding scale profile policy provides different scalability options. The scaling types are:
    - Dual Stack: Provides scalability of up to 12,000 endpoints for IPv6 configurations and up to 24,000 endpoints for IPv4 configurations.
    - High LPM: Provides scalability similar to the dual-stack policy, except that the longest prefix match (LPM) scale is 128,000 and the policy scale is 8,000.
    - IPv4 Scale: Enables systems with no IPv6 configurations to increase scalability to 48,000 IPv4 endpoints.
    - High Dual Stack: Provides scalability of up to 64,000 MAC endpoints, 64,000 IPv4 endpoints, and 24,000 IPv6 endpoints.
    For more information about this feature, see the Cisco APIC Forwarding Scale Profiles document.
  * lldp_policy: The LLDP policy name.  LLDP uses the logical link control (LLC) services to transmit and receive information to and from other LLDP agents.
  * monitoring_policy: The monitoring policy name.  Monitoring policies can include policies such as event/fault severity or the fault lifecycle. 
  * netflow_node_policy: The NetFlow node policy name.  The node-level policy deploys two different NetFlow timers that specify the rate at which flow records are sent to the external collector.
  * ptp_node_policy: The PTP node policy name.  The Precision Time Protocol (PTP) synchronizes distributed clocks in a system using Ethernet networks.
  * poe_node_policy: The PoE node policy name.  PoE node policies control the overall power setting for the switch.
  * spanning_tree_interface_policy: The spanning tree policy name.  A spanning tree protocol (STP) policy prevents loops caused by redundant paths in your network.
  * synce_node_policy: The SyncE Node policy name.  Synchronous Ethernet (SyncE) provides high-quality clock synchronization over Ethernet ports by using known common precision frequency references.
  * usb_configuration_policy: The USB configuration policy name.  The USB configuration policy can disable the USB port on a Cisco ACI-mode switch to prevent someone booting the switch from a USB image that contains malicious code.
  EOT
  type = map(object(
    {
      vmm_domain = string
      vmm_credentials = map(object(
        {
          description = optional(string)
          password    = number
          username    = string
        }
      ))
      vmm_controller = map(object(
        {
          annotation             = optional(string)
          datacenter             = string
          dvs_version            = optional(string)
          hostname               = string
          management_epg         = optional(string)
          monitoring_policy      = optional(string)
          policy_scope           = optional(string)
          port                   = optional(string)
          sequence_number        = optional(string)
          stats_collection       = optional(string)
          trigger_inventory_sync = optional(string)
          virtual_switch_type    = optional(string)
        }
      ))
      vswitch_policy = map(object(
        {
          annotation            = optional(string)
          active_flow_timeout   = optional(string)
          alias                 = optional(string)
          idle_flow_timeout     = optional(string)
          sample_rate           = optional(string)
          netflow_export_policy = optional(string)
        }
      ))
    }
  ))
}

variable "vmm_password_1" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_2" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_3" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_4" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}

variable "vmm_password_5" {
  default     = ""
  description = "Password for VMM Credentials Policy."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmUsrAccP"
 - Distinguished Name: "uni/vmmp-{vendor}/dom-{name}/usracc-{name}"
GUI Location:
 - Virtual Networking -> {vendor} -> {domain_name} -> vCenter Credentials
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_credential" "vmm_credentials" {
  depends_on = [
    aci_vmm_domain.vmm_domains
  ]
  for_each      = local.vmm_credentials
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = each.value.description
  name          = "${each.key}-creds"
  vmm_domain_dn = aci_vmm_domain.vmm_domains[each.value.vmm_domain].id
  pwd = length(
    regexall(5, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_5 : length(
    regexall(4, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_4 : length(
    regexall(3, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_3 : length(
    regexall(2, coalesce(each.value.password, 10))
  ) > 0 ? var.vmm_password_2 : var.vmm_password_1
  usr = each.value.username
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmCtrlrP"
 - Distinguished Name: "uni/vmmp-{vendor}/dom-{name}/ctrlr-{name}"
GUI Location:
 - Virtual Networking -> {vendor} -> {domain_name} -> {controller_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_controller" "vmm_controllers" {
  depends_on = [
    aci_vmm_credential.vmm_credentials,
    aci_vmm_domain.vmm_domains
  ]
  for_each                        = local.vmm_controllers
  vmm_domain_dn                   = aci_vmm_domain.vmm_domains[each.value.vmm_domain].id
  name                            = "${each.key}-controller"
  annotation                      = each.value.annotation != "" ? each.value.annotation : var.annotation
  dvs_version                     = each.value.dvs_version
  host_or_ip                      = each.value.hostname
  inventory_trig_st               = each.value.trigger_inventory_sync
  mode                            = each.value.virtual_switch_type
  port                            = each.value.port
  root_cont_name                  = each.value.datacenter
  scope                           = each.value.policy_scope
  seq_num                         = each.value.sequence_number
  stats_mode                      = each.value.stats_collection
  relation_vmm_rs_acc             = aci_vmm_credential.vmm_credentials[each.key].id
  relation_vmm_rs_ctrlr_p_mon_pol = each.value.monitoring_policy
  relation_vmm_rs_mgmt_e_pg       = each.value.management_epg
  # relation_vmm_rs_to_ext_dev_mgr  = [each.value.external_device_manager]
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmVSwitchPolicyCont"
 - Distinguished Name: "uni/vmmp-{vendor}/dom-{name}/vswitchpolcont"
GUI Location:
 - Virtual Networking -> {vendor} -> {domain_name} -> VSwitch Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_vswitch_policy" "vswitch_policies" {
  depends_on = [
    aci_vmm_credential.vmm_credentials,
    aci_vmm_domain.vmm_domains
  ]
  for_each      = local.vswitch_policies
  vmm_domain_dn = aci_vmm_domain.vmm_domains[each.value.vmm_domain].id
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = each.value.description
  name_alias    = each.value.alias
  relation_vmm_rs_vswitch_exporter_pol {
    active_flow_time_out = each.value.active_flow_timeout
    idle_flow_time_out   = each.value.idle_flow_timeout
    sampling_rate        = each.value.sampling_rate
    target_dn = length(
      regexall("[a-zA-Z\\d]", each.value.netfow_export_policy)
    ) > 0 ? "uni/infra/vmmexporterpol-${each.value.netflow_export_policy}" : ""
  }
}