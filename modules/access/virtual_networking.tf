
/*_____________________________________________________________________________________________________________________

Virtual Networking Variables
_______________________________________________________________________________________________________________________
*/
variable "virtual_networking" {
  default = {
    "default" = {
      controllers = [
        {
          annotation             = ""
          datacenter             = "**REQUIRED**"
          dvs_version            = "unmanaged"
          hostname               = "**REQUIRED**"
          management_epg         = "default"
          management_epg_type    = "oob"
          monitoring_policy      = "default"
          port                   = 0
          sequence_number        = 0
          stats_collection       = "disabled"
          switch_scope           = "vm"
          trigger_inventory_sync = "untriggered"
          vxlan_pool             = ""
        }
      ]
      credentials = [
        {
          description = ""
          password    = 1
          username    = "**REQUIRED**"
        }
      ]
      domain = [
        {
          access_mode                     = "read-write"
          annotation                      = ""
          control_knob                    = "epDpVerify"
          delimiter                       = ""
          enable_tag_collection           = false
          enable_vm_folder_data_retrieval = false
          encapsulation                   = "vlan"
          endpoint_inventory_type         = "on-link"
          endpoint_retention_time         = 0
          enforcement                     = "hw"
          preferred_encapsulation         = "unspecified"
          switch_mode                     = "default"
          switch_provider                 = "VMware"
          uplink_names                    = []
          vlan_pool                       = ""
        }
      ]
      vswitch_policy = [
        {
          annotation           = ""
          cdp_interface_policy = ""
          enhanced_lag_policy  = []
          /* **Example
          enhanced_lag_policy = [
            {
              load_balancing_mode = "src-dst-ip"
              mode                = "active"
              number_of_links     = 2
            }
          ] */
          firewall_policy           = "default"
          lldp_interface_policy     = ""
          mtu_policy                = "default"
          port_channel_policy       = ""
          vmm_netflow_export_policy = []
          /* **Example
          vmm_netflow_export_policy = [
            {
              active_flow_timeout = 60
              idle_flow_timeout   = 15
              netflow_policy      = "**REQUIRED**"
              sample_rate         = 0
            }
          ] */
        }
      ]
    }
  }
  description = <<-EOT
  Key - Name of the Virtual Networking Policy
  * controllers: List of Controllers to add to the Virtual Networking Policy
    - annotation: (Optional) - Annotation of object VMM Controller.
    - datacenter: (Required) - Top level container name.
    - dvs_version: (Optional) -  Dvs Version. Allowed values are:
      * 7.0
      * 6.6
      * 6.5
      * 6.0
      * 5.5
      * 5.1
      * unmanaged
    - hostname: (Required) - Hostname or IP Address. [Create Only]
    - management_epg: (Required) - Name of the Management EPG.
    - management_epg_type: (Required) - Type of Management EPG.  Options are:
      * inb: This is an Inband EPG.
      * oob: This is an Out-of-Band EPG.
    - monitoring_policy: (class monInfraPol) (Optional) - Name of the Monitoring Policy.
    - sequence_number: (Optional) - An ISIS link-state packet sequence number. Default value is "0".
    - stats_collection: (Optional) - The statistics mode. Allowed values are:
      * disabled
      * enabled
    - switch_scope: (Optional) - The VMM control policy scope. Allowed values are:
      * MicrosoftSCVMM: SCVMM
      * cloudfoundry: Cloud Foundry
      * iaas: vShield
      * kubernetes: Kubernetes
      * network: vCD
      * nsx: VMware NSX
      * openshift: Openshift
      * openstack: Openstack
      * rhev: Redhat Enterprise Virtualization
      * unmanaged: Unmanaged
      * vm: vCenter DVS
    - trigger_inventory_sync: (Optional) - Triggered Inventory Sync Status. It will sync the status of inventory if value is set to triggered. Once sync is done, value is reset back to untriggered. Allowed values are "autoTriggered", "triggered", "untriggered", and default value is "untriggered". Type: String.
    - vxlan_pool: (class fvnsVxlanInstP) (Optional) - Name of the VxLAN Pool.
  * credentials: List of credential policies to add to the Virtual Networking Policy
    * annotation: (Optional) - Annotation of object VMM Credential.
    * description: (Optional) - Description of object VMM Credential.
    * password: (Required) - Password Identifier in the range of 1 to 5 to identify the vmm_password_{number} variable.
    * username: (Required) - Username to use for login to the controller.
  * domain: List of Arguments for the virtual networking domain.
    - name - (Required) Name of Object vmm domain.
    - access_mode: (Optional) - Access mode for object vmm domain. Allowed values are:
      * read-only
      * read-write
    - annotation: (Optional) - Annotation for object vmm domain.
    - control_knob: (Optional) - Type pf control knob to use. Allowed values are:
      * none
      * epDpVerify
    - delimiter: (Optional) - Delimiter for object vmm domain.
    - enable_tag_collection: (Optional) - Flag enable tagging for object vmm domain.
    - encapsulation: (Optional) - The layer 2 encapsulation protocol to use with the virtual switch. Allowed values are "unknown", "vlan" and "vxlan". Default is "unknown".
    - enforcement: (Optional) - The switching enforcement preference. This determines whether switches can be done within the virtual switch (Local Switching) or whether all switched traffic must go through the fabric (No Local Switching). Allowed values are "hw", "sw" and "unknown". Default is "hw".
    - endpoint_inventory_type: (Optional) - Determines which end point inventory type to use for object VMM domain. Allowed values are "none" and "on-link". Default is "on-link".
    - endpoint_retention_time: (Optional) - End point retention time for object vmm domain. Allowed value range is "0" - "600". Default value is "0".
    - switch_mode: (Optional) - The switch mode for the vmm domain profile. Allowed values are:
      * cf
      * default
      * k8s
      * nsx
      * ovs
      * rancher
      * rhev
      * openshift
      * unknown
    - switch_provider: (Optional) - The switch to be used for the vmm domain profile. Allowed values are:
      * CloudFoundry
      * Kubernetes
      * Microsoft
      * OpenShift
      * OpenStack
      * Redhat
      * VMware
    - preferred_encapsulation: (Optional) - The preferred encapsulation mode for object VMM domain. Allowed values are "unspecified", "vlan" and "vxlan". Default is "unspecified".
    - vlan_pool: (Optional) - Relation to class fvnsVlanInstP. Cardinality - N_TO_ONE. Type - String.
  * vswitch_policy: Virtual Switch Policy to assign to the Virtual Networking Policy.
    - annotation: (Optional) - Annotation of object VSwitch Policy Group.
    - cdp_interface_policy: (Optional) - (class cdpIfPol) - Name of the CDP Interface Policy.
    - description: (Optional) - Description of object VSwitch Policy Group.
    - enhanced_lag_policy: (Optional) - (class lacpEnhancedLagPol) A List of ehnanced lag policy attributes:
      * load_balancing_mode:
        - dst-ip: Destination IP Address
        - dst-ip-l4port: Destination IP Address and TCP/UDP Port
        - dst-ip-l4port-vlan: Destination IP Address, TCP/UDP Port and VLAN
        - dst-ip-vlan: Destination IP Address and VLAN
        - dst-l4port: Destination TCP/UDP Port
        - dst-mac: Destination MAC Address
        - src-dst-ip: Source and Destination IP Address
        - src-dst-ip-l4port: Source and Destination IP Address and TCP/UDP Port
        - src-dst-ip-l4port-vlan: Source and Destination IP Address, TCP/UDP Port and VLAN
        - src-dst-ip-vlan: Source and Destination IP Address and VLAN
        - src-dst-l4port: Source and Destination TCP/UDP Port
        - src-dst-mac: Source and Destination MAC Address
        - src-ip: Source IP Address
        - src-ip-l4port: Source IP Address and TCP/UDP Port
        - src-ip-l4port-vlan: Source IP Address, TCP/UDP Port and VLAN
        - src-ip-vlan: Source IP Address and VLAN
        - src-l4port: Source TCP/UDP Port
        - src-mac: Source MAC Address
        - src-port-id: Source Port ID
        - vlan: VLAN
      * mode: Options are:
        - active: LACP Active.
        - passive: LACP Passive.
      * number_of_links: (Optional) - The number of uplinks to create in the enhanced Lag Policy.
    - firewall_policy: (Optional) - (class nwsFwPol) - Name of the Firewall Policy.
    - lldp_interface_policy: (Optional) - (class lldpIfPol) - Name of the LLDP Interface Policy
    - mtu_policy: (Optional) - (class l2InstPol) - Name of the L2 Interface Policy.
    - port_channel_policy: (Optional) - (class lacpLagPol) - Name of the Port-Channel (LACP) Interface Policy.
    - vmm_netflow_export_policy - (Optional) - 
      * active_flow_time_out: (Optional) - The range of allowed values is "0" to "3600". Default value is "60".
      * idle_flow_time_out: (Optional) - The range of allowed values is "0" to "600". Default value is "15".
      * netflow_policy: (class netflowVmmExporterPol) (Required) - The Name of the Netflow Exporters for VM Networking Policy.
      * sampling_rate: (Optional) - The range of allowed values is "0" to "1000". Default value is "0".
  EOT
  type = map(object(
    {
      controllers = list(object(
        {
          annotation             = optional(string)
          datacenter             = string
          dvs_version            = optional(string)
          hostname               = string
          management_epg         = optional(string)
          management_epg_type    = optional(string)
          monitoring_policy      = optional(string)
          port                   = optional(number)
          sequence_number        = optional(number)
          stats_collection       = optional(string)
          switch_scope           = optional(string)
          trigger_inventory_sync = optional(string)
          vxlan_pool             = optional(string)
        }
      ))
      credentials = list(object(
        {
          description = optional(string)
          password    = number
          username    = string
        }
      ))
      domain = list(object(
        {
          access_mode                     = optional(string)
          annotation                      = optional(string)
          control_knob                    = optional(string)
          delimiter                       = optional(string)
          enable_tag_collection           = optional(bool)
          enable_vm_folder_data_retrieval = optional(bool)
          encapsulation                   = optional(string)
          endpoint_inventory_type         = optional(string)
          endpoint_retention_time         = optional(number)
          enforcement                     = optional(string)
          preferred_encapsulation         = optional(string)
          switch_mode                     = optional(string)
          switch_provider                 = optional(string)
          uplink_names                    = optional(list(string))
          vlan_pool                       = string
        }
      ))
      vswitch_policy = list(object(
        {
          annotation           = optional(string)
          active_flow_timeout  = optional(number)
          cdp_interface_policy = optional(string)
          enhanced_lag_policy = optional(list(object(
            {
              load_balancing_mode = optional(string)
              mode                = optional(string)
              number_of_links     = optional(number)
            }
          )))
          idle_flow_timeout     = optional(number)
          firewall_policy       = optional(string)
          lldp_interface_policy = optional(string)
          mtu_policy            = optional(string)
          port_channel_policy   = optional(string)
          sample_rate           = optional(number)
          vmm_netflow_export_policy = optional(list(object(
            {
              active_flow_timeout = optional(number)
              idle_flow_timeout   = optional(number)
              netflow_policy      = string
              sample_rate         = optional(number)
            }
          )))
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
 - Class: "vmmDomP"
 - Distinguished Name: "uni/vmmp-{switch_vendor}/dom-{name}
GUI Location:
 - Virtual Networking -> {switch_vendor} -> {domain_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_domain" "domains_vmm" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each            = local.domains_vmm
  access_mode         = each.value.access_mode
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl_knob           = each.value.control_knob
  delimiter           = each.value.delimiter
  enable_tag          = each.value.enable_tag_collection == true ? "yes" : "no"
  encap_mode          = each.value.encapsulation
  enf_pref            = each.value.enforcement
  ep_inventory_type   = each.value.endpoint_inventory_type
  ep_ret_time         = each.value.endpoint_retention_time
  mode                = each.value.switch_mode
  name                = each.key
  pref_encap_mode     = each.value.preferred_encapsulation
  provider_profile_dn = "uni/vmmp-${each.value.switch_provider}"
  relation_infra_rs_vlan_ns = length(compact([each.value.vlan_pool])
  ) > 0 ? aci_vlan_pool.pools_vlan[each.value.vlan_pool].id : ""
}

resource "aci_rest_managed" "vmm_domains_uplinks" {
  depends_on = [
    aci_vmm_domain.domains_vmm
  ]
  for_each   = local.vmm_uplinks
  dn         = "uni/vmmp-${each.value.switch_vendor}/dom-${each.value.domain}/uplinkpcont"
  class_name = "vmmUplinkPCont"
  content = {
    numOfUplinks = each.value.numOfUplinks
  }
}

resource "aci_rest_managed" "vmm_uplink_names" {
  depends_on = [
    aci_rest_managed.vmm_domains_uplinks
  ]
  for_each   = local.vmm_uplink_names
  dn         = "uni/vmmp-${each.value.switch_vendor}/dom-${each.value.domain}/uplinkpcont/uplinkp-${each.value.uplinkId}"
  class_name = "vmmUplinkP"
  content = {
    uplinkId   = each.value.uplinkId
    uplinkName = each.value.uplinkName
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmUsrAccP"
 - Distinguished Name: "uni/vmmp-{switch_vendor}/dom-{name}/usracc-{name}"
GUI Location:
 - Virtual Networking -> {switch_vendor} -> {domain_name} -> Credentials
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_credential" "credentials" {
  depends_on = [
    aci_vmm_domain.domains_vmm
  ]
  for_each      = local.vmm_credentials
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = each.value.description
  name          = each.value.domain
  vmm_domain_dn = aci_vmm_domain.domains_vmm[each.value.domain].id
  pwd = length(regexall(
    5, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_5 : length(regexall(
    4, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_4 : length(regexall(
    3, coalesce(each.value.password, 10))
    ) > 0 ? var.vmm_password_3 : length(regexall(
    2, coalesce(each.value.password, 10))
  ) > 0 ? var.vmm_password_2 : var.vmm_password_1
  usr = each.value.username
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmCtrlrP"
 - Distinguished Name: "uni/vmmp-{switch_vendor}/dom-{name}/ctrlr-{name}"
GUI Location:
 - Virtual Networking -> {switch_vendor} -> {domain_name} -> {controller_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_vmm_controller" "controllers" {
  depends_on = [
    aci_vmm_credential.credentials,
    aci_vmm_domain.domains_vmm
  ]
  for_each            = local.vmm_controllers
  vmm_domain_dn       = aci_vmm_domain.domains_vmm[each.value.domain].id
  name                = each.value.hostname
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  dvs_version         = each.value.dvs_version
  host_or_ip          = each.value.hostname
  inventory_trig_st   = each.value.trigger_inventory_sync
  mode                = each.value.switch_mode
  port                = each.value.port
  root_cont_name      = each.value.datacenter
  scope               = each.value.switch_scope
  seq_num             = each.value.sequence_number
  stats_mode          = each.value.stats_collection
  vxlan_depl_pref     = each.value.switch_mode == "nsx" ? "nsx" : "vxlan"
  relation_vmm_rs_acc = aci_vmm_credential.credentials[each.value.domain].id
  relation_vmm_rs_ctrlr_p_mon_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/infra/moninfra-${each.value.monitoring_policy}" : ""
  relation_vmm_rs_mgmt_e_pg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
  # relation_vmm_rs_to_ext_dev_mgr  = [each.value.external_device_manager]
  relation_vmm_rs_vxlan_ns = length(compact([each.value.vxlan_pool])
  ) > 0 ? "uni/infra/vxlanns-${each.value.vxlan_pool}" : ""
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vmmVSwitchPolicyCont"
 - Distinguished Name: "uni/vmmp-{switch_vendor}/dom-{name}/vswitchpolcont"
GUI Location:
 - Virtual Networking -> {switch_vendor} -> {domain_name} -> VSwitch Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_vswitch_policy" "vswitch_policies" {
  depends_on = [
    aci_vmm_domain.domains_vmm
  ]
  for_each      = local.vswitch_policies
  vmm_domain_dn = aci_vmm_domain.domains_vmm[each.value.domain].id
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  dynamic "relation_vmm_rs_vswitch_exporter_pol" {
    for_each = each.value.netflow_export_policy
    content {
      active_flow_time_out = relation_vmm_rs_vswitch_exporter_pol.value.active_flow_timeout
      idle_flow_time_out   = relation_vmm_rs_vswitch_exporter_pol.value.idle_flow_timeout
      sampling_rate        = relation_vmm_rs_vswitch_exporter_pol.value.sampling_rate
      target_dn            = "uni/infra/vmmexporterpol-${relation_vmm_rs_vswitch_exporter_pol.value.netflow_policy}"
    }
  }
  relation_vmm_rs_vswitch_override_cdp_if_pol = length(compact([each.value.cdp_interface_policy])
  ) > 0 ? "uni/infra/cdpIfP-${each.value.cdp_interface_policy}" : ""
  relation_vmm_rs_vswitch_override_fw_pol = length(compact([each.value.firewall_policy])
  ) > 0 ? "uni/infra/fwP-${each.value.firewall_policy}" : ""
  relation_vmm_rs_vswitch_override_lacp_pol = length(compact([each.value.port_channel_policy])
  ) > 0 ? "uni/infra/lacplagp-${each.value.port_channel_policy}" : ""
  relation_vmm_rs_vswitch_override_lldp_if_pol = length(compact([each.value.lldp_interface_policy])
  ) > 0 ? "uni/infra/lldpIfP-${each.value.lldp_interface_policy}" : ""
  relation_vmm_rs_vswitch_override_mtu_pol = "uni/fabric/l2pol-${each.value.mtu_policy}"
}