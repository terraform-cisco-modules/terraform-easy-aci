# ACI Access Policy Module

## Use this module to create Access Policies in the APIC Controller

## Usage

```hcl
module "access" {

  source = "terraform-cisco-modules/aci//modules/access"

  # omitted...
}
```

This module will create the following Access Policies in an APIC Controller:

* Domains
 - Access Domains
 - l3Out Domains
 - Physical Domains

* Global Polices
 - Attachable Access Entity (AEP) Policies

* Interface Policies
  - CDP Interface Policies
  - Fibre-Channel Interface Policies
  - Layer2 Interface Policies
  - LACP (Port-Channel) Interface Policies
  - Link Level Policies
  - LLDP Interface Policies
  - MisCabling Protocol (MCP) Interface Policies
  - Port Security Policies
  - Spanning Tree Interface Policies

* Leaf
  - Fabric Membership
  - Interface Profiles
  - Interface Selectors
  - Switch Profiles
  - Switch Policy Groups

* Spine
  - Fabric Membership
  - Interface Profiles
  - Interface Selectors
  - Switch Profiles
  - Switch Policy Groups

* VLAN Pools

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.1.0 |
| <a name="requirement_mso"></a> [mso](#requirement\_mso) | >= 0.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_coop_policy.coop_group_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/coop_policy) | resource |
| [aci_encryption_key.global_aes_passphrase](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/encryption_key) | resource |
| [aci_endpoint_controls.rouge_endpoint_control](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_controls) | resource |
| [aci_endpoint_ip_aging_profile.ip_aging](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/endpoint_ip_aging_profile) | resource |
| [aci_isis_domain_policy.isis_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/isis_domain_policy) | resource |
| [aci_mgmt_preference.apic_connectivity_preference](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/mgmt_preference) | resource |
| [aci_port_tracking.port_tracking](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/port_tracking) | resource |
| [aci_rest_managed.bgp_autonomous_system_number](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.bgp_route_reflectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.ep_loop_protection](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.fabric_wide_settings_5_2_3](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aes_passphrase"></a> [aes\_passphrase](#input\_aes\_passphrase) | Global AES Passphrase. | `string` | n/a | yes |
| <a name="input_annotation"></a> [annotation](#input\_annotation) | workspace tag value. | `string` | `""` | no |
| <a name="input_apicHostname"></a> [apicHostname](#input\_apicHostname) | Cisco APIC Hostname | `string` | `"apic.example.com"` | no |
| <a name="input_apicPass"></a> [apicPass](#input\_apicPass) | Password for User based Authentication. | `string` | `""` | no |
| <a name="input_apicUser"></a> [apicUser](#input\_apicUser) | Username for User based Authentication. | `string` | `"admin"` | no |
| <a name="input_apic_connectivity_preference"></a> [apic\_connectivity\_preference](#input\_apic\_connectivity\_preference) | * The preferred management connectivity preference. Options are:<br>  - inband — Executes in-band management connectivity between the APIC server to external devices through leaf switches on the ACI fabric.<br>  - ooband: (default) — Executes out-of-band management connectivity between the APIC server to external devices through connections external to the ACI fabric. | `string` | `"ooband"` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_bgp_autonomous_system_number"></a> [bgp\_autonomous\_system\_number](#input\_bgp\_autonomous\_system\_number) | BGP Autonomous System Number. | `number` | `65000` | no |
| <a name="input_bgp_route_reflectors"></a> [bgp\_route\_reflectors](#input\_bgp\_route\_reflectors) | * Key - Pod Identifier<br>* annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.<br>* node\_list: (required) — List of Spine Node Identifiers to add as route reflectors. | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      node_list  = list(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "node_list": [<br>      101,<br>      102<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_coop_group_policy"></a> [coop\_group\_policy](#input\_coop\_group\_policy) | COOP protocol is enhanced to support two ZMQ authentication modes:<br>- compatible — Type COOP accepts both MD5 authenticated and non-authenticated ZMQ connections for message transportation.<br>- strict: (defualt) — COOP allows MD5 authenticated ZMQ connections only.<br>Note: The APIC provides a managed object (fabric:SecurityToken), that includes an attribute to be used for the MD5 password. An attribute in this managed object, called "token", is a string that changes every hour. COOP obtains the notification from the DME to update the password for ZMQ authentication. The attribute token value is not displayed. | `string` | `"strict"` | no |
| <a name="input_endpoint_controls"></a> [endpoint\_controls](#input\_endpoint\_controls) | Key - This should always be default.<br>* annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.<br>* ep\_loop\_protection: (required) — The endpoint loop protection policy specifies how loops detected by frequent MAC address moves are handled.<br>  - action: (optional) — Action to Perform when a Loop is dected.<br>    * bd\_learn\_disable: (optional) — Disable bridge domain learning when a loop is detected, options are:<br>      - false: (default)<br>      - true<br>    * port\_disable: (optional) — Disable the Port when a loop is detected, options are:<br>      - false<br>      - true: (default)<br>  - administrative\_state: (optional) — The administrative state of the endpoint loop protection policy, options are: <br>    * disabled<br>    * enabled: (default)<br>  - loop\_detection\_interval: (default: 60) — Sets the loop detection interval, which specifies the time to detect a loop. The interval range is from 30 to 300 seconds.<br>  - loop\_detection\_multiplier: (default: 4) — Sets the loop detection multiplication factor, which is the number of times a single EP moves between ports within the loop detection interval.<br>* ip\_aging: (required) — When enabled, the IP aging policy ages unused IPs on an endpoint.  When the Administrative State is enabled, the IP aging policy sends ARP requests (for IPv4) and neighbor solicitations (for IPv6) to track IPs on endpoints. If no response is given, the policy ages the unused IPs.  Required: The endpoint retention policy specifies the timer used for tracking IPs on endpoints.<br>  - administrative\_state: (optional) — Enables and disables the IP aging policy, options are:<br>    * disabled<br>    * enabled: (default)<br>* rouge\_ep\_control: (required) — A rogue endpoint can attack leaf switches through frequently, repeatedly injecting packets on different leaf switch ports and changing 802.1Q tags (emulating endpoint moves), resulting in learned sclass and EPG port changes. Misconfigurations can also cause frequent IP and MAC addresss changes (moves).  The Rogue EP Control feature addresses this vulnerability.<br>  - administrative\_state: (optional) — The administrative state of the Rogue EP Control policy, options are:<br>    * disabled<br>    * enabled: (default)<br>  - hold\_interval: (default: 1800) — Interval in seconds after the endpoint is declared rogue, where it is kept static so learning is prevented and the traffic to and from the rogue endpoint is dropped. After this interval, the endpoint is deleted. Valid values are from 300 to 3600.<br>  - rouge\_interval: (default: 30) — Sets the Rogue EP detection interval, which specifies the time to detect rogue endpoints. Valid values are from 0 to 65535 seconds.<br>  - rouge\_multiplier: (default: 6) — Sets the Rogue EP Detection multiplication factor for determining if an endpoint is unauthorized. If the endpoint moves more times than this number, within the EP detection interval, the endpoint is declared rogue. Valid values are from 2 to 10. | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      ep_loop_protection = list(object(<br>        {<br>          action = optional(list(object(<br>            {<br>              bd_learn_disable = optional(bool)<br>              port_disable     = optional(bool)<br>            }<br>          )))<br>          administrative_state      = optional(string)<br>          loop_detection_interval   = optional(number)<br>          loop_detection_multiplier = optional(number)<br>        }<br>      ))<br>      ip_aging = list(object(<br>        {<br>          administrative_state = optional(string)<br>        }<br>      ))<br>      rouge_ep_control = list(object(<br>        {<br>          administrative_state = optional(string)<br>          hold_interval        = optional(number)<br>          rouge_interval       = optional(number)<br>          rouge_multiplier     = optional(number)<br>        }<br>      ))<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "ep_loop_protection": [<br>      {<br>        "action": [<br>          {<br>            "bd_learn_disable": false,<br>            "port_disable": true<br>          }<br>        ],<br>        "administrative_state": "enabled",<br>        "loop_detection_interval": 60,<br>        "loop_detection_multiplier": 4<br>      }<br>    ],<br>    "ip_aging": [<br>      {<br>        "administrative_state": "enabled"<br>      }<br>    ],<br>    "rouge_ep_control": [<br>      {<br>        "administrative_state": "enabled",<br>        "hold_interval": 1800,<br>        "rouge_interval": 30,<br>        "rouge_multiplier": 6<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_fabric_wide_settings"></a> [fabric\_wide\_settings](#input\_fabric\_wide\_settings) | Key - This should always be default.<br>* annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.<br>* disable\_remote\_ep\_learning: (optional) — You should enable this policy in fabrics which include the Cisco Nexus 9000 series switches, 93128 TX, 9396 PX, or 9396 TX switches with the N9K-M12PQ uplink module, after all the nodes have been successfully upgraded to APIC Release 2.2(2x).<br>  - Note: After any of the following configuration changes, you may need to manually flush previously learned IP endpoints:<br>    * Remote IP endpoint learning is disabled.<br>    * The VRF is configured for ingress policy enforcement.<br>    * At least one Layer 3 interface exists in the VRF.<br>  - To manually flush previously learned IP endpoints, enter the following command on both VPC peers: vsh -c "clear system internal epm endpoint vrf <vrf-name> remote"<br>  - false<br>  - true: (default)<br>* enforce\_domain\_validation: (optional) — Enable a validation check when static paths are added, to ensure that a domain is attached to the EPG on the path.<br>  - false<br>  - true: (default)<br>* enforce\_epg\_vlan\_validation: (optional) — When checked, the system globally prevents overlapping VLAN pools from being assigned to EPGs.<br>  - Note:  If overlapping VLAN pools already exist and this parameter is checked, the system returns an error. You must assign VLAN pools that are not overlapping to the EPGs before choosing this feature.<br>  - If this parameter is checked and an attempt is made to add an overlapping VLAN pool to an EPG, the system returns an error.<br>  - false: (default)<br>  - true<br>* enforce\_subnet\_check: (optional) — When checked, IP address learning on outside of subnets configured in a VRF, for all VRFs are disabled.<br>  - false<br>  - true: (default)<br>* leaf\_opflex\_client\_authentication: (optional) — To enforce Opflex client certificate authentication on leaf switches for GOLF and Linux.<br>  - false<br>  - true: (default)<br>* leaf\_ssl\_opflex: (optional) — To enable SSL Opflex transport for leaf switches.<br>  - false<br>  - true: (default)<br>* reallocate\_gipo: (optional) — Enable reallocating group IP outer addresses (Gipos) on non-stretched BDs to make room for stretched BDs.<br>  - false: (default)<br>  - true<br>* restrict\_infra\_vlan\_traffic: (optional) — This feature restricts Infra VLAN traffic to only network paths specified by Infra security entry policies. When this feature is enabled, each leaf switch limits Infra VLAN traffic between compute nodes to allow only iVXLAN traffic. The switch also limits traffic to fabric nodes to allow only OpFlex and iVXLAN/VXLAN traffic. APIC management traffic is allowed on front panel ports on the Infra VLAN.<br>  - false: (default)<br>  - true<br>* ssl\_opflex\_versions: (optional) — This is only applicable to APIC version 5.2 and greater.<br>  - TLSv1: (default: false)<br>  - TLSv1\_1: (default: false)<br>  - TLSv1\_2: (default: true)<br>* spine\_opflex\_client\_authentication: (optional) — To enforce Opflex client certificate authentication on spine switches for GOLF and Linux.<br>  - false<br>  - true: (default)<br>* spine\_ssl\_opflex: (optional) — To enable SSL Opflex transport for spine switches.<br>  - false<br>  - true: (default) | <pre>map(object(<br>    {<br>      annotation                        = optional(string)<br>      disable_remote_ep_learning        = optional(bool)<br>      enforce_domain_validation         = optional(bool)<br>      enforce_epg_vlan_validation       = optional(bool)<br>      enforce_subnet_check              = optional(bool)<br>      leaf_opflex_client_authentication = optional(bool)<br>      leaf_ssl_opflex                   = optional(bool)<br>      reallocate_gipo                   = optional(bool)<br>      restrict_infra_vlan_traffic       = optional(bool)<br>      ssl_opflex_versions = optional(list(object(<br>        {<br>          TLSv1   = optional(bool)<br>          TLSv1_1 = optional(bool)<br>          TLSv1_2 = optional(bool)<br>        }<br>      )))<br>      spine_opflex_client_authentication = optional(bool)<br>      spine_ssl_opflex                   = optional(bool)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "disable_remote_ep_learning": true,<br>    "enforce_domain_validation": true,<br>    "enforce_epg_vlan_validation": false,<br>    "enforce_subnet_check": true,<br>    "leaf_opflex_client_authentication": true,<br>    "leaf_ssl_opflex": true,<br>    "reallocate_gipo": false,<br>    "restrict_infra_vlan_traffic": false,<br>    "spine_opflex_client_authentication": true,<br>    "spine_ssl_opflex": true,<br>    "ssl_opflex_versions": [<br>      {<br>        "TLSv1": false,<br>        "TLSv1_1": false,<br>        "TLSv1_2": true<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_global_aes_encryption_settings"></a> [global\_aes\_encryption\_settings](#input\_global\_aes\_encryption\_settings) | Key - This should always be default.<br>* clear\_passphrase: (optional) — Flag to clear the passphrase when disabling Global AES Encryption.<br>  - false: (default)<br>  - true<br>* enable\_encryption: (optional) — Enables strong encryption on the import or export policy.<br>  - false<br>  - true: (default)<br>* passphrase\_key\_derivation\_version: (default: v1) — v1 is the only option today. | <pre>map(object(<br>    {<br>      clear_passphrase                  = optional(bool)<br>      enable_encryption                 = optional(bool)<br>      passphrase_key_derivation_version = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "clear_passphrase": false,<br>    "enable_encryption": true,<br>    "passphrase_key_derivation_version": "v1"<br>  }<br>}</pre> | no |
| <a name="input_isis_policy"></a> [isis\_policy](#input\_isis\_policy) | Key - This should always be default.<br>* annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.<br>* isis\_mtu: (default: 1492) — The IS-IS Domain policy LSP MTU. The MTU is from 128 to 4352.<br>* isis\_metric\_for\_redistributed\_routes: (default: 60) — The IS-IS metric that is used for all imported routes into IS-IS. The values available are from 1 to 63.<br>* lsp\_fast\_flood\_mode: (optional) — The IS-IS Fast-Flooding of LSPs improves Intermediate System-to-Intermediate System (IS-IS) convergence time when new link-state packets (LSPs) are generated in the network and shortest path first (SPF) is triggered by the new LSPs. The mode can be:<br>  - disabled<br>  - enabled: (default)<br>* lsp\_generation\_initial\_wait\_interval: (default: 50) — The LSP generation initial wait interval. This is used in the LSP generation interval for the LSP MTU.<br>* lsp\_generation\_maximum\_wait\_interval: (default: 8000) — The LSP generation maximum wait interval. This is used in the LSP generation interval for the LSP MTU. <br>* lsp\_generation\_second\_wait\_interval: (default: 50) — The LSP generation second wait interval. This is used in the LSP generation interval for the LSP MTU. <br>* sfp\_computation\_frequency\_initial\_wait\_interval: (default: 50) — The SPF computation frequency initial wait interval. This is used in the SPF computations for the LSP MTU.<br>* sfp\_computation\_frequency\_maximum\_wait\_interval: (default: 8000) — The SPF computation frequency maximum wait interval. This is used in the SPF computations for the LSP MTU.<br>* sfp\_computation\_frequency\_second\_wait\_interval: (default: 50) — The SPF computation frequency second wait interval. This is used in the SPF computations for the LSP MTU. | <pre>map(object(<br>    {<br>      annotation                                      = optional(string)<br>      isis_mtu                                        = optional(number)<br>      isis_metric_for_redistributed_routes            = optional(number)<br>      lsp_fast_flood_mode                             = optional(string)<br>      lsp_generation_initial_wait_interval            = optional(number)<br>      lsp_generation_maximum_wait_interval            = optional(number)<br>      lsp_generation_second_wait_interval             = optional(number)<br>      sfp_computation_frequency_initial_wait_interval = optional(number)<br>      sfp_computation_frequency_maximum_wait_interval = optional(number)<br>      sfp_computation_frequency_second_wait_interval  = optional(number)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "isis_metric_for_redistributed_routes": 63,<br>    "isis_mtu": 1492,<br>    "lsp_fast_flood_mode": "enabled",<br>    "lsp_generation_initial_wait_interval": 50,<br>    "lsp_generation_maximum_wait_interval": 8000,<br>    "lsp_generation_second_wait_interval": 50,<br>    "sfp_computation_frequency_initial_wait_interval": 50,<br>    "sfp_computation_frequency_maximum_wait_interval": 8000,<br>    "sfp_computation_frequency_second_wait_interval": 50<br>  }<br>}</pre> | no |
| <a name="input_ndoDomain"></a> [ndoDomain](#input\_ndoDomain) | Authentication Domain for Nexus Dashboard Orchestrator Authentication. | `string` | `"local"` | no |
| <a name="input_ndoHostname"></a> [ndoHostname](#input\_ndoHostname) | Cisco Nexus Dashboard Orchestrator Hostname | `string` | `"nxo.example.com"` | no |
| <a name="input_ndoPass"></a> [ndoPass](#input\_ndoPass) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `""` | no |
| <a name="input_ndoUser"></a> [ndoUser](#input\_ndoUser) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_port_tracking"></a> [port\_tracking](#input\_port\_tracking) | Key - This should always be default.<br>* annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.<br>* delay\_restore\_timer: (default: 120) — The timer that controls the delay restore interval time in seconds. The range is from 1 second to 300 seconds.<br>* include\_apic\_ports: (optional) — If you put a check in the box, port tracking brings down the Cisco Application Policy Infrastructure Controller (APIC) ports when the leaf switch loses connectivity to all fabric ports (that is, there are 0 fabric links). Enable this feature only if the Cisco APICs are dual- or multi-homed to the fabric. Bringing down the Cisco APIC ports helps in switching over to the secondary link in the case of a dual-homed Cisco APIC.<br>  - false: (default)<br>  - true<br>* number\_of\_active\_ports: (default: 0) — Number of active spine links that triggers port tracking. The range is from 0 to 12. <br>* port\_tracking\_state: (optional) — The administrative port tracking state. The state can be:<br>  - off<br>  - on: (default) | <pre>map(object(<br>    {<br>      annotation             = optional(string)<br>      delay_restore_timer    = optional(number)<br>      include_apic_ports     = optional(bool)<br>      number_of_active_ports = optional(number)<br>      port_tracking_state    = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "delay_restore_timer": 120,<br>    "include_apic_ports": false,<br>    "number_of_active_ports": 0,<br>    "port_tracking_state": "on"<br>  }<br>}</pre> | no |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
