/*_____________________________________________________________________________________________________________________

Tenant — Application EPG — Variables
_______________________________________________________________________________________________________________________
*/
variable "application_epgs" {
  default = {
    "default" = {
      alias               = ""
      annotation          = ""
      annotations         = []
      application_profile = "default"
      /* If undefined the top level EPG Attributes will be used
      bd_schema              = application_epg_schema
      bd_template            = application_epg_template
      bd_tenant              = application_epg_tenant
      */
      bridge_domain          = "default"
      contract_exception_tag = null
      contracts              = []
      controller_type        = "apic"
      custom_qos_policy      = ""
      data_plane_policer     = ""
      description            = ""
      domains                = []
      /* 
      - Physical Domain Example
      domains = [
        {
          domain      = "access"
        }
      ]
      - VMM Domain Example
      domains = [
        {
          domain        = "vds_example"
          domain_type   = "vmm"
          security = [
            {
              allow_promiscuous = "accept"
              forged_transmits  = "accept"
              mac_changes       = "reject"
            }
          ]
          switch_provider = "VMware"
          vlan_mode       = "dynamic"
          vlans           = []
        }
      ]
      */
      epg_admin_state      = "admin_up"
      epg_contract_masters = []
      epg_to_aaeps         = []
      /* Example EPG to AAEP Mapping
      epg_to_aaeps = [
        {
          aaep                      = "default"
          instrumentation_immediacy = "on-demand"
          mode                      = "trunk"
          vlans                     = [11]
        }
      ]
      */
      epg_type                 = "standard"
      fhs_trust_control_policy = ""
      flood_in_encapsulation   = "disabled"
      global_alias             = ""
      has_multicast_source     = false
      label_match_criteria     = "AtleastOne"
      intra_epg_isolation      = "unenforced"
      monitoring_policy        = "default"
      preferred_group_member   = false
      qos_class                = "unspecified"
      sites                    = []
      static_paths             = []
      /* example
      static_paths = [
        {
          encapsulation_type = "vlan"
          mode               = "trunk"
          name               = "1/1"
          nodes              = [201]
          path_type          = "port"
          pod                = 1
          vlans              = [1]
        }
      ]
      */
      useg_epg = false
      vlan     = null # This is just used for the Inband Management EPG
      vrf      = "default"
      /* If undefined the variable of local.first_tenant will be used for:
      policy_source_tenant = local.first_tenant
      schema               = local.first_tenant
      template             = local.first_tenant
      tenant               = local.first_tenant
      vrf_schema           = local.first_tenant
      vrf_template         = local.first_tenant
      */
      vzGraphCont = ""
    }
  }
  description = <<-EOT
    Key — Name of the Application EPG.
    * bd_tenant: (default: epg tenant) — The name of the tenant for the Bridge Domain.
    * bridge_domain: (required) — Name of the Bridge Domain to assign to the EPG.
    * contract_exception_tag: (optional) — Contracts between EPGs are enhanced to include exceptions to subjects or contracts. This enables a subset of EPGs to be excluded in contract filtering. For example, a provider EPG can communicate with all consumer EPGs except those that match criteria configured in a Subject Exception in the contract governing their communication.  Assign a Tag Attribute to the EPG.
    * contracts: (optional) — List of Contracts and their attributes to assign to the EPG.
      - contract_type: (required) — The Type of Contract.  Options are:
        * consumed
        * contract_interface
        * intra_epg
        * provided
        * taboo
      - name: (required) — Name of the Contract to assign to the EPG.
      - tenant: (optional: epg tenant) — The Name of the Tenant the Contract exists in.
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * custom_qos_policy: (optional) — Name of a Custom QoS Policy to assign to the EPG.
    * data_plane_policer: (optional) — Name of a Data Plane Policer Policy to assign to the EPG.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * domains: (optional) — 
      - annotation: (VMM Domains - optional) — 
      - allow_micro_segmentation: (VMM Domains - optional) — Allows microsegmentation for the base EPG.
        * false: (default)
        * true
      - delimiter: (VMM Domains - optional) — The delimiter symbol to use with the VMware portgroup name.
        * The acceptable symbols are |, ~, !, @, ^, +, =, and _.
        * The default symbol is "|"
      - deploy_immediacy: (VMM Domains - optional) — Once policies are downloaded to the leaf software, deployment immediacy can specify when the policy is pushed into the hardware policy CAM. The options are:
        * immediate — Specifies that the policy is programmed in the hardware policy CAM when the policy is downloaded in the leaf software.
        * on-demand: (default) — Specifies that the policy is programmed in the hardware policy CAM only when the first packet is received through the data path. This process helps to optimize the hardware space.
      - domain: (required) — Name of the Domain to assign to the EPG.
      - domain_type: (optional) — The Type of Domain you are assigning.  Options are:
        * physical: (default)
        * vmm
      - enhanced_lag_policy: (VMM Domains - optional) — Allows you to associate the EPG with a vCenter domain that has an enhanced link aggregation group (LAG) configured on it.  The policy consists of distributed virtual switch (DVS) uplink port groups configured in LAGs and associated with a load-balancing algorithm.  You need to configure the policy first for the VMM domain.
      - number_of_ports: (VMM Domains - optional) — REQUIRED If Port Binding is staticBinding.  Number of Ports to assign to the VMM Domain Policy.
      - port_allocation: (VMM Domains - optional) — The port allocation mode.  Only used when port_binding is staticBinding.  Options are:
        * elastic
        * fixed
        * none: (default)
      - port_binding: (VMM Domains - optional) — Enables you to choose a port-binding method:
        * default — Default
        * dynamic_binding — Dynamic Binding
        * ephemeral — Ephemeral
        * static_binding — Static
      - resolution_immediacy: (VMM Domains - optional) — Specifies whether policies are resolved immediately or when needed. The options are:
        * immediate — Specifies that EPG policies (including contracts and filters) are downloaded to the associated leaf switch software upon hypervisor attachment to the VMware vSphere Distributed Switch (VDS). LLDP or OpFlex permissions are used to resolve the hypervisor to leaf node attachments.
        * on-demand — Specifies that a policy (for example, VLAN, VXLAN bindings, contracts, or filters) is pushed to the leaf node only when a hypervisor is attached to VDS and a VM is placed in the port group (EPG).
        * pre-provision: (default) — Specifies that a policy (for example, VLAN, VXLAN binding, contracts, or filters) is downloaded to a leaf switch even before a hypervisor is attached to the VDS, thereby pre-provisioning the configuration on the switch.
        * Notes:  The default for Cisco AVS and Cisco ACI Virtual Edge is immediate.  The default for VMware VDS is pre-provision unless the Allow Microsegmentation check box is checked. In that case, resolution is immediate, and the options are grayed out.
      - security: (VMM Domains - optional) — 
        * allow_promiscuous: (VMM Domains - optional) — Allows all packets to pass to the VMM domain, which is often used to monitor network activity.
          - accept — All traffic is received within the VMM domain.
          - reject: (default) — Packets that do not include the network address are dropped.
        * forged_transmits: (VMM Domains - optional) — Specifies whether to allow forged transmits. A forged transmit occurs when a network adapter starts sending out traffic that identifies itself as something else. This security policy compares the effective address of the virtual network adapter and the source address inside of an 802.3 Ethernet frame generated by the virtual machine to ensure that they match.
          - accept — Non-matching frames are received.
          - reject: (default) — All non-matching frames are dropped.
        * mac_changes: (VMM Domains - optional) — Allows definition of new MAC addresses for the network adapter within the virtual machine (VM).
          - accept — Allows new MAC addresses.
          - reject: (default) — Does not allow new MAC addresses.
      - switch_provider: (VMM Domains - optional) — The provider type of the VMM Domain.  Options are:
        * CloudFoundry
        * Kubernetes
        * Microsoft
        * OpenShift
        * OpenStack
        * Redhat
        * VMware: (default)
      - vlan_mode: (VMM Domains - optional) — Setting to determine the Mode of the VLAN Assignment.  Options are:
        * dynamic: (default) — The VLAN is dynamically assigned from the VLAN Pool.
        * static — The VLAN is statically assigned from the VLAN Pool.
      - vlans: (VMM Domains - optional) — Only required when the vlan_mode is set to static.  List of VLANs to assign to the VMM Domain.  The list should contain One VLAN for typical deployments, encapsulation VLAN.  If doing micro-segmentation/private-vlan then the list should contain two vlans with the first VLAN for encapsulation and the second VLAN for primary encapsulation.
    * epg_admin_state: (optional) — Operational state of the EPG.  Options are:
      - admin_up
      - admin_shut
    * epg_contract_masters: (optional) — Use this to assign EPG(s) that will serve as contract master(s) for this EPG, from which this EPG will inherit contracts (you must have previously created the contract master EPG.)
      - application_profile: (default: EPG application profile) - Name of the Application Profile for the contract master EPG.
      - application_epg: (required) - Name of the Application EPG that will act as a contract master.
    * epg_to_aaeps: (optional) — List of Objects to assign EPG to AAEP mappings.
      - aaep: (required) — Name of the Attachable Access Entity Profile to assign
      - instrumentation_immediacy: (optional) — The EPG to AAEP deployment immediacy.  Options are:
        * immediate — Specifies that EPG policies (including contracts and filters) are downloaded to the associated leaf switch software upon deployment.
        * on-demand: (default) — Specifies that a policy (for example, VLAN, VXLAN bindings, contracts, or filters) is pushed to the leaf node only when an endpoint is discovered, attached to the (EPG).
      - mode: (optional) — The Mode of the Port.  Options are:
        * access — Select this mode if the traffic from the host is untagged (without VLAN ID). When a leaf switch is configured for an EPG to be untagged, for every port this EPG uses, the packets will exit the switch untagged.
        * dot1p — Select this mode if the traffic from the host is tagged with a 802.1P tag. When an access port is configured with a single EPG in native 802.1p mode, its packets exit that port untagged. When an access port is configured with multiple EPGs, one in native 802.1p mode, and some with VLAN tags, all packets exiting that access port are tagged VLAN 0 for EPG configured in native 802.1p mode and for all other EPGs packets exit with their respective VLAN tags.
        * trunk: (default) — Select this mode if the traffic from the host is tagged with a VLAN ID.
      - vlans: (optional) — List of VLANs to assign to the aaep mapping.  The list should contain One VLAN for typical deployments, encapsulation VLAN.  If doing micro-segmentation/private-vlan then the list should contain two vlans with the first VLAN for encapsulation and the second VLAN for primary encapsulation.
    * epg_type: (optional) — The Type of EPG to Create.  Options are:
      - inb — Use this option to create an Inband EPG.
      - oob — Use this option to create an Out-of-Band EPG.
      - standard: (default)
    * fhs_trust_control_policy: (optional) — Name of a First Hop Security Control Policy to assign to the EPG.
    * flood_in_encapsulation: (optional) — Specifies whether flooding is enabled for the routing protocols. If flooding is disabled, unicast routing is performed on the target IP address.  The options are:
      - disabled: (default)
      - enabled
    * has_multicast_source: (optional) — 
    * label_match_criteria: (optional) — The Match criteria can be:
      - All
      - AtleastOne
      - AtmostOne
      - None
    * intra_epg_isolation: (optional) — Name of a Custom QoS Policy to assign to the EPG.
      - false: (default)
      - true
    * policy_source_tenant: (default: epg tenant) — Name of a source tenant for policies.
    * preferred_group_member   = optional(bool)
    * static_paths: List of Paths to assign to the EPG.
      - encapsulation_type: The Type of Encapsulation to use on the Interface
        * micro_seg — 
        * qinq — Port Encapsulation is QinQ based.
        * vlan: (default) — Port Encapsulation is VLAN based.
        * vxlan — Port Encapsulation is VXLAN based.
      - mode:  Mode of the static association with the path.
        * access — Select this mode if the traffic from the host is untagged (without VLAN ID). When a leaf switch is configured for an EPG to be untagged, for every port this EPG uses, the packets will exit the switch untagged.
        * dot1p — Select this mode if the traffic from the host is tagged with a 802.1P tag. When an access port is configured with a single EPG in native 802.1p mode, its packets exit that port untagged. When an access port is configured with multiple EPGs, one in native 802.1p mode, and some with VLAN tags, all packets exiting that access port are tagged VLAN 0 for EPG configured in native 802.1p mode and for all other EPGs packets exit with their respective VLAN tags.
        * trunk: (default) — Select this mode if the traffic from the host is tagged with a VLAN ID.
      - name: (required) — Name of the Path.  For a Physical Port this will be the slot/port.  For PC/VPC this is the name of the Policy Group.
      - nodes: (required) — If the Path type is vpc this should be a list of 2 leaf's.  Otherwise a list of 1 leaf.
      - path_type: (requierd)
        * pc — Path Type is Port-Channel
        * port: (default) — Path Type is Physical Port
        * vpc — Path Type is Virtual-Port-Channel
      - pod: (default: 1) — Identifier for the Pod the Nodes are assigned to for the static path.
      - vlans: For VLAN and VXLAN this is a list of One.  For micro_seg and qinq this is a list of Two.
    * tenant: (default: local.first_tenant) — The name of the tenant to for the Application EPG.
    APIC Specific Attributes:
    * alias: (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    * monitoring_policy: (optional) — Name of a Monitoring Policy to assign to the EPG.
    * qos_class: (optional) — The priority class identifier. Allowed values are:
      - level1
      - level2
      - level3
      - level4
      - level5
      - level6
      - unspecified: (default)
    Nexus Dashboard Orchestrator Specific Attributes:
    * bd_schema: (default: epg schema) — Name of the Schema containing the Bridge Domain.
    * bd_template: (default: epg template) — The Template name containing the Bridge Domain.
    * contracts:
      - schema: (default: epg schema) — Name of the Schema containing the Contract.
      - template: (default: epg template) — The Template name containing the Contract.
    * schema: (default: local.first_tenant) — Schema Name.
    * sites: (default: local.first_tenant) — List of Site Names to assign site specific attributes.
    * template: (default: local.first_tenant) — The Template name to create the object within.
  EOT
  type = map(object(
    {
      alias      = optional(string)
      annotation = optional(string)
      annotations = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      application_profile    = optional(string)
      bd_schema              = optional(string)
      bd_template            = optional(string)
      bd_tenant              = optional(string)
      bridge_domain          = optional(string)
      contract_exception_tag = optional(number)
      contracts = optional(list(object(
        {
          contract_type = string # consumed|contract_interface|intra_epg|provided|taboo
          name          = string
          qos_class     = optional(string)
          schema        = optional(string)
          template      = optional(string)
          tenant        = optional(string)

        }
      )))
      controller_type    = optional(string)
      custom_qos_policy  = optional(string)
      data_plane_policer = optional(string)
      description        = optional(string)
      domains = optional(list(object(
        {
          annotation               = optional(string)
          allow_micro_segmentation = optional(bool)
          delimiter                = optional(string)
          deploy_immediacy         = optional(string)
          domain                   = string
          domain_type              = optional(string)
          enhanced_lag_policy      = optional(string)
          number_of_ports          = optional(string)
          port_allocation          = optional(string)
          port_binding             = optional(string)
          resolution_immediacy     = optional(string)
          security = optional(list(object(
            {
              allow_promiscuous = optional(string)
              forged_transmits  = optional(string)
              mac_changes       = optional(string)
            }
          )))
          switch_provider = optional(string)
          vlan_mode       = optional(string)
          vlans           = optional(list(number))
        }
      )))
      epg_admin_state = optional(string)
      epg_contract_masters = optional(list(object(
        {
          application_profile = optional(string)
          application_epg     = string
        }
      )))
      epg_to_aaeps = optional(list(object(
        {
          aaep                      = string
          instrumentation_immediacy = optional(string)
          mode                      = optional(string)
          vlans                     = list(number)
        }
      )))
      epg_type                 = optional(string)
      fhs_trust_control_policy = optional(string)
      flood_in_encapsulation   = optional(string)
      global_alias             = optional(string)
      has_multicast_source     = optional(bool)
      label_match_criteria     = optional(string)
      intra_epg_isolation      = optional(string)
      monitoring_policy        = optional(string)
      policy_source_tenant     = optional(string)
      preferred_group_member   = optional(bool)
      qos_class                = optional(string)
      schema                   = optional(string)
      sites                    = optional(list(string))
      static_paths = optional(list(object(
        {
          encapsulation_type = optional(string)
          mode               = optional(string)
          name               = string
          nodes              = list(string)
          path_type          = string
          pod                = optional(number)
          vlans              = list(number)
        }
      )))
      template     = optional(string)
      tenant       = optional(string)
      useg_epg     = optional(bool)
      vlan         = optional(number)
      vrf          = optional(string)
      vrf_schema   = optional(string)
      vrf_template = optional(string)
      vzGraphCont  = optional(string)
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvAEPg"
 - Distinguished Name: /uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG}
_______________________________________________________________________________________________________________________
*/
resource "aci_application_epg" "application_epgs" {
  depends_on = [
    aci_tenant.tenants,
    aci_application_profile.application_profiles,
    aci_bridge_domain.bridge_domains
  ]
  for_each               = { for k, v in local.application_epgs : k => v if v.epg_type == "standard" && v.controller_type == "apic" }
  annotation             = each.value.annotation != "" ? each.value.annotation : var.annotation
  application_profile_dn = aci_application_profile.application_profiles[each.value.application_profile].id
  description            = each.value.description
  exception_tag          = each.value.contract_exception_tag
  flood_on_encap         = each.value.flood_in_encapsulation
  fwd_ctrl               = each.value.intra_epg_isolation == true ? "proxy-arp" : "none"
  has_mcast_source       = each.value.has_multicast_source == true ? "yes" : "no"
  is_attr_based_epg      = each.value.useg_epg == true ? "yes" : "no"
  match_t                = each.value.label_match_criteria
  name                   = each.key
  name_alias             = each.value.alias
  pc_enf_pref            = each.value.intra_epg_isolation
  pref_gr_memb           = each.value.preferred_group_member == true ? "include" : "exclude"
  prio                   = each.value.qos_class
  shutdown               = each.value.epg_admin_state == "admin_shut" ? "yes" : "no"
  relation_fv_rs_bd      = "uni/tn-${each.value.bd_tenant}/BD-${each.value.bridge_domain}"
  relation_fv_rs_sec_inherited = each.value.epg_contract_masters != [] ? [
    for s in each.value.epg_contract_masters : "uni/tn-${each.value.tenant}/ap-${s.application_profile}/epg-${s.application_epg}"
  ] : []
  relation_fv_rs_cust_qos_pol = length(compact([each.value.custom_qos_policy])
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/qoscustom-${each.value.custom_qos_policy}" : ""
  relation_fv_rs_dpp_pol = each.value.data_plane_policer
  relation_fv_rs_aepg_mon_pol = length(compact([each.value.monitoring_policy])
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/monepg-${each.value.monitoring_policy}" : ""
  relation_fv_rs_trust_ctrl = length(compact([each.value.fhs_trust_control_policy])
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/trustctrlpol-${each.value.fhs_trust_control_policy}" : ""
  # relation_fv_rs_graph_def     = each.value.vzGraphCont
}


resource "mso_schema_template_anp_epg" "application_epgs" {
  provider = mso
  depends_on = [
    mso_tenant.tenants
  ]
  for_each                   = { for k, v in local.application_epgs : k => v if v.controller_type == "ndo" }
  anp_name                   = each.value.application_profile
  bd_name                    = each.value.bridge_domain
  bd_schema_id               = mso_schema.schemas[each.value.bd_schema].id
  bd_template_name           = each.value.bd_template
  display_name               = each.key
  intra_epg                  = each.value.intra_epg_isolation
  intersite_multicast_source = false
  name                       = each.key
  preferred_group            = each.value.preferred_group_member
  proxy_arp                  = each.value.intra_epg_isolation == true ? true : false
  schema_id                  = mso_schema.schemas[each.value.schema].id
  template_name              = each.value.template
  useg_epg                   = each.value.useg_epg
  vrf_name                   = each.value.vrf
  vrf_schema_id              = mso_schema.schemas[each.value.vrf_schema].id
  vrf_template_name          = each.value.vrf_template
}
/*_____________________________________________________________________________________________________________________

* Inband
API Information:
 - Class: "mgmtInB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{epg}"
GUI Location:
 - Tenants > mgmt > Node Management EPGs > In-Band EPG - {epg}

* Out-of-Band
API Information:
 - Class: "mgmtOoB"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{epg}"
GUI Location:
 - Tenants > mgmt > Node Management EPGs > Out-of-Band EPG - {epg}
_______________________________________________________________________________________________________________________
*/
resource "aci_node_mgmt_epg" "mgmt_epgs" {
  depends_on = [
    aci_bridge_domain.bridge_domains,
  ]
  for_each                 = { for k, v in local.application_epgs : k => v if length(regexall("(inb|oob)", v.epg_type)) > 0 && v.controller_type == "apic" }
  management_profile_dn    = "uni/tn-mgmt/mgmtp-default"
  name                     = each.key
  annotation               = each.value.annotation != "" ? each.value.annotation : var.annotation
  encap                    = each.value.epg_type == "inb" ? "vlan-${each.value.vlan}" : ""
  match_t                  = each.value.epg_type == "inb" ? each.value.label_match_criteria : "AtleastOne"
  name_alias               = each.value.alias
  pref_gr_memb             = "exclude"
  prio                     = each.value.qos_class
  type                     = each.value.epg_type == "inb" ? "in_band" : "out_of_band"
  relation_mgmt_rs_mgmt_bd = each.value.epg_type == "inb" ? "uni/tn-mgmt/BD-${each.value.bridge_domain}" : ""
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsDomAtt"
 - Distinguished Name: /uni/tn-{Tenant}/ap-{App_Profile}/epg-{EPG}/rsdomAtt-[uni/{domain}]
GUI Location:
Tenants > {Tenant} > Application Profiles > {App_Profile} > Application EPGs > {EPG} > Domains (VMs and Bare-Metals)
_______________________________________________________________________________________________________________________
*/
resource "aci_epg_to_domain" "epg_to_domains" {
  depends_on = [
    aci_application_epg.application_epgs
  ]
  for_each           = { for k, v in local.epg_to_domains : k => v if v.controller_type == "apic" && v.epg_type == "standard" }
  application_epg_dn = aci_application_epg.application_epgs[each.value.application_epg].id
  tdn = length(
    regexall("physical", each.value.domain_type)
    ) > 0 ? "uni/phys-${each.value.domain}" : length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "uni/vmmp-${each.value.vmm_vendor}/dom-${each.value.domain}" : ""
  annotation = each.value.annotation != null ? each.value.annotation : var.annotation
  binding_type = length(
    regexall("physical", each.value.domain_type)
    ) > 0 ? "none" : length(regexall(
      "dynamic_binding", each.value.port_binding)) > 0 ? "dynamicBinding" : length(regexall(
      "default", each.value.port_binding)) > 0 ? "none" : length(regexall(
  "static_binding", each.value.port_binding)) > 0 ? "staticBinding" : each.value.port_binding
  allow_micro_seg = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.allow_micro_segmentation : false
  delimiter = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.delimiter : ""
  encap = each.value.vlan_mode != "dynamic" && length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : "unknown"
  encap_mode = each.value.vlan_mode == "static" && length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "vlan" : "auto"
  epg_cos = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "Cos0" : "Cos0"
  epg_cos_pref = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "disabled" : "disabled"
  instr_imedcy = each.value.deploy_immediacy == "on-demand" ? "lazy" : each.value.deploy_immediacy
  enhanced_lag_policy = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.enhanced_lag_policy : ""
  netflow_dir = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "both" : "both"
  netflow_pref = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? "disabled" : "disabled"
  num_ports = length(
    regexall("vmm", each.value.domain_type)) > 0 && (length(regexall(
      "dynamic_binding", each.value.port_binding)) > 0 || length(regexall(
    "static_binding", each.value.port_binding)) > 0
  ) ? each.value.number_of_ports : 0
  port_allocation = length(
    regexall("vmm", each.value.domain_type)) > 0 && length(regexall(
    "static_binding", each.value.port_binding)
  ) > 0 ? each.value.port_allocation : "none"
  primary_encap = length(
    regexall("vmm", each.value.domain_type)) > 0 && length(regexall(
    "static", each.value.vlan_mode)) > 0 && length(each.value.vlans
  ) > 1 ? "vlan-${element(each.value.vlans, 1)}" : "unknown"
  primary_encap_inner = length(
    regexall("vmm", each.value.domain_type)) > 0 && length(regexall(
    "static", each.value.vlan_mode)) > 0 && length(each.value.vlans
  ) > 2 ? "vlan-${element(each.value.vlans, 2)}" : "unknown"
  res_imedcy = each.value.resolution_immediacy == "on-demand" ? "lazy" : each.value.resolution_immediacy
  secondary_encap_inner = length(
    regexall("vmm", each.value.domain_type)) > 0 && length(regexall(
    "static", each.value.vlan_mode)) > 0 && length(each.value.vlans
  ) > 3 ? "vlan-${element(each.value.vlans, 3)}" : "unknown"
  switching_mode = "native"
  vmm_allow_promiscuous = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["allow_promiscuous"] : ""
  vmm_forged_transmits = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["forged_transmits"] : ""
  vmm_mac_changes = length(
    regexall("vmm", each.value.domain_type)
  ) > 0 ? each.value.security[0]["mac_changes"] : ""
}


#------------------------------------------
# Assign Contract to EPG
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
* Consumer Contract
 - Class: "fvRsCons"
 - Distinguished Name: "uni/tn-{tenant}/ap-{application_profile}/epg-{epg}/rscons-{contract}"
* Provider Contract
 - Class: "fvRsProv"
 - Distinguished Name: "uni/tn-{tenant}/ap-{application_profile}/epg-{epg}/rsprov-{contract}"
GUI Location:
 - Tenants > {tenant} > Application Profiles > {application_profile} > Application EPGs > {epg} > Contracts
_______________________________________________________________________________________________________________________
*/
# resource "aci_epg_to_contract" "contract_to_epg" {
#     depends_on          = [
#         aci_tenant.tenants,
#         aci_application_epg.application_epgs,
#         aci_contract.contracts
#     ]
#     application_epg_dn  = aci_application_epg.application_epgs[each.value.application_epg].id
#     contract_dn         = length(regexall(
#       "oob", each.value.type)
#       ) > 0 ? aci_rest_managed.oob_contracts[each.value.contract].id : length(regexall(
#       "standard", each.value.type)
#       ) > 0 ? aci_contract.contracts[each.value.contract].id : length(regexall(
#       "taboo", each.value.type)
#     ) > 0 ? apic_taboo_contracts.contracts[each.value.contract].id : ""
#     contract_type       = each.value.type
# }

resource "aci_rest_managed" "contract_to_epgs" {
  depends_on = [
    aci_contract.contracts,
    aci_taboo_contract.contracts,
  ]
  for_each   = { for k, v in local.contract_to_epgs : k => v if v.epg_type == "standard" }
  dn         = "uni/tn-${each.value.tenant}/ap-${each.value.application_profile}/epg-${each.value.application_epg}/${each.value.contract_dn}-${each.value.contract}"
  class_name = each.value.contract_class
  content = {
    annotation = each.value.annotation != null ? each.value.annotation : var.annotation
    # matchT = each.value.match_type
    prio = each.value.qos_class
  }
}

resource "aci_rest_managed" "contract_to_oob_epgs" {
  depends_on = [
    aci_contract.contracts,
    aci_rest_managed.oob_contracts,
    aci_taboo_contract.contracts,
  ]
  for_each   = { for k, v in local.contract_to_epgs : k => v if v.epg_type == "oob" && v.contract_type == "provided" }
  dn         = "uni/tn-${each.value.tenant}/mgmtp-default/oob-${each.value.application_epg}/${each.value.contract_dn}-${each.value.contract}"
  class_name = each.value.contract_class
  content = {
    annotation = each.value.annotation != null ? each.value.annotation : var.annotation
    # matchT = each.value.match_type
    prio = each.value.qos_class
  }
}

resource "aci_rest_managed" "contract_to_inb_epgs" {
  depends_on = [
    aci_contract.contracts,
    aci_rest_managed.oob_contracts,
    aci_taboo_contract.contracts,
  ]
  for_each   = { for k, v in local.contract_to_epgs : k => v if v.epg_type == "inb" }
  dn         = "uni/tn-${each.value.tenant}/mgmtp-default/inb-${each.value.application_epg}/${each.value.contract_dn}-${each.value.contract}"
  class_name = each.value.contract_class
  content = {
    annotation = each.value.annotation != null ? each.value.annotation : var.annotation
    # matchT = each.value.match_type
    prio = each.value.qos_class
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsPathAtt"
 - Distinguished Name: "uni/tn-{tenant}/ap-{application_profile}/epg-{application_epg}/{static_path}"
GUI Location:
Tenants > {tenant} > Application Profiles > {application_profile} > Application EPGs > {application_epg} > Static Ports > {GUI_Static}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "epg_to_static_paths" {
  depends_on = [
    aci_application_epg.application_epgs
  ]
  for_each = local.epg_to_static_paths
  dn = length(
    regexall("^pc$", each.value.path_type)
    ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.name}]]" : length(
    regexall("^port$", each.value.path_type)
    ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[eth${each.value.name}]]" : length(
    regexall("^vpc$", each.value.path_type)
  ) > 0 ? "${aci_application_epg.application_epgs[each.value.epg].id}/rspathAtt-[topology/pod-${each.value.pod}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.name}]]" : ""
  class_name = "fvRsPathAtt"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    encap = length(
      regexall("micro_seg", each.value.encapsulation_type)
      ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : length(
      regexall("qinq", each.value.encapsulation_type)
      ) > 0 ? "qinq-${element(each.value.vlans, 0)}-${element(each.value.vlans, 1)}" : length(
      regexall("vlan", each.value.encapsulation_type)
      ) > 0 ? "vlan-${element(each.value.vlans, 0)}" : length(
      regexall("vxlan", each.value.encapsulation_type)
    ) > 0 ? "vxlan-${element(each.value.vlans, 0)}" : ""
    mode = length(
      regexall("dot1p", each.value.mode)
      ) > 0 ? "native" : length(
      regexall("access", each.value.mode)
    ) > 0 ? "untagged" : "regular"
    primaryEncap = each.value.encapsulation_type == "micro_seg" ? "vlan-${element(each.value.vlans, 1)}" : "unknown"
    tDn = length(
      regexall("^pc$", each.value.path_type)
      ) > 0 ? "topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[${each.value.name}]" : length(
      regexall("^port$", each.value.path_type)
      ) > 0 ? "topology/pod-${each.value.pod}/paths-${element(each.value.nodes, 0)}/pathep-[eth${each.value.name}]" : length(
      regexall("^vpc$", each.value.path_type)
    ) > 0 ? "topology/pod-${each.value.pod}/protpaths-${element(each.value.nodes, 0)}-${element(each.value.nodes, 1)}/pathep-[${each.value.name}]" : ""
  }
}


#------------------------------------------------------
# Create Attachable Access Entity Generic Encap Policy
#------------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{AAEP}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {AAEP}
_______________________________________________________________________________________________________________________
*/
resource "aci_epgs_using_function" "epg_to_aaeps" {
  depends_on = [
    aci_application_epg.application_epgs
  ]
  for_each          = local.epg_to_aaeps
  access_generic_dn = "uni/infra/attentp-${each.value.aaep}/gen-default"
  encap             = length(each.value.vlans) > 0 ? "vlan-${element(each.value.vlans, 0)}" : "unknown"
  instr_imedcy      = each.value.instrumentation_immediacy == "on-demand" ? "lazy" : each.value.instrumentation_immediacy
  mode              = each.value.mode == "trunk" ? "regular" : each.value.mode == "access" ? "untagged" : "native"
  primary_encap     = length(each.value.vlans) > 1 ? "vlan-${element(each.value.vlans, 1)}" : "unknown"
  tdn               = aci_application_epg.application_epgs[each.value.epg].id
}
