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
| <a name="input_apic_connectivity_preference"></a> [apic\_connectivity\_preference](#input\_apic\_connectivity\_preference) | * The preferred management connectivity preference. Options are:<br>  - inband: Executes in-band management connectivity between the APIC server to external devices through leaf switches on the ACI fabric.<br>  - ooband: Executes out-of-band management connectivity between the APIC server to external devices through connections external to the ACI fabric. | `string` | `"inband"` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_bgp_autonomous_system_number"></a> [bgp\_autonomous\_system\_number](#input\_bgp\_autonomous\_system\_number) | BGP Autonomous System Number. | `number` | `65000` | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_coop_group_policy"></a> [coop\_group\_policy](#input\_coop\_group\_policy) | COOP protocol is enhanced to support two ZMQ authentication modes:<br>- compatible Type: COOP accepts both MD5 authenticated and non-authenticated ZMQ connections for message transportation.<br>- strict: COOP allows MD5 authenticated ZMQ connections only.<br>Note: The APIC provides a managed object (fabric:SecurityToken), that includes an attribute to be used for the MD5 password. An attribute in this managed object, called "token", is a string that changes every hour. COOP obtains the notification from the DME to update the password for ZMQ authentication. The attribute token value is not displayed. | `string` | `"strict"` | no |
| <a name="input_endpoint_controls"></a> [endpoint\_controls](#input\_endpoint\_controls) | Key: Name of the APIC Connectivity Preference Map.  This should be default.<br>* annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.<br>* description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.<br>* type: COOP protocol is enhanced to support two ZMQ authentication modes:<br>  - compatible Type: COOP accepts both MD5 authenticated and non-authenticated ZMQ connections for message transportation.<br>  - strict: COOP allows MD5 authenticated ZMQ connections only.<br>  Note: The APIC provides a managed object (fabric:SecurityToken), that includes an attribute to be used for the MD5 password. An attribute in this managed object, called "token", is a string that changes every hour. COOP obtains the notification from the DME to update the password for ZMQ authentication. The attribute token value is not displayed. | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      ep_loop_protection = list(object(<br>        {<br>          action = optional(list(object(<br>            {<br>              bd_learn_disable = optional(bool)<br>              port_disable     = optional(bool)<br>            }<br>          )))<br>          administrative_state      = optional(string)<br>          loop_detection_interval   = optional(number)<br>          loop_detection_multiplier = optional(number)<br>        }<br>      ))<br>      ip_aging = list(object(<br>        {<br>          administrative_state = optional(string)<br>        }<br>      ))<br>      rouge_ep_control = list(object(<br>        {<br>          administrative_state = optional(string)<br>          hold_interval        = optional(number)<br>          rouge_interval       = optional(number)<br>          rouge_multiplier     = optional(number)<br>        }<br>      ))<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "ep_loop_protection": [<br>      {<br>        "action": [<br>          {<br>            "bd_learn_disable": false,<br>            "port_disable": false<br>          }<br>        ],<br>        "administrative_state": "enabled",<br>        "loop_detection_interval": 60,<br>        "loop_detection_multiplier": 4<br>      }<br>    ],<br>    "ip_aging": [<br>      {<br>        "administrative_state": "enabled"<br>      }<br>    ],<br>    "rouge_ep_control": [<br>      {<br>        "administrative_state": "enabled",<br>        "hold_interval": 1800,<br>        "rouge_interval": 30,<br>        "rouge_multiplier": 6<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_fabric_wide_settings"></a> [fabric\_wide\_settings](#input\_fabric\_wide\_settings) | n/a | <pre>map(object(<br>    {<br>      annotation                        = optional(string)<br>      disable_remote_ep_learning        = optional(bool)<br>      enforce_domain_validation         = optional(bool)<br>      enforce_epg_vlan_validation       = optional(bool)<br>      enforce_subnet_check              = optional(bool)<br>      leaf_opflex_client_authentication = optional(bool)<br>      leaf_ssl_opflex                   = optional(bool)<br>      reallocate_gipo                   = optional(bool)<br>      restrict_infra_vlan_traffic       = optional(bool)<br>      ssl_opflex_versions = optional(list(object(<br>        {<br>          TLSv1   = optional(bool)<br>          TLSv1_1 = optional(bool)<br>          TLSv1_2 = optional(bool)<br>        }<br>      )))<br>      spine_opflex_client_authentication = optional(bool)<br>      spine_ssl_opflex                   = optional(bool)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "disable_remote_ep_learning": true,<br>    "enforce_domain_validation": true,<br>    "enforce_epg_vlan_validation": false,<br>    "enforce_subnet_check": true,<br>    "leaf_opflex_client_authentication": true,<br>    "leaf_ssl_opflex": true,<br>    "reallocate_gipo": false,<br>    "restrict_infra_vlan_traffic": false,<br>    "spine_opflex_client_authentication": true,<br>    "spine_ssl_opflex": true,<br>    "ssl_opflex_versions": [<br>      {<br>        "TLSv1": false,<br>        "TLSv1_1": false,<br>        "TLSv1_2": true<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_global_aes_encryption_settings"></a> [global\_aes\_encryption\_settings](#input\_global\_aes\_encryption\_settings) | Key - This should be default.<br>* clear\_passphrase: <br>* enable\_encryption: <br>* passphrase\_key\_derivation\_version: | <pre>map(object(<br>    {<br>      clear_passphrase                  = optional(bool)<br>      enable_encryption                 = optional(bool)<br>      passphrase_key_derivation_version = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "clear_passphrase": false,<br>    "enable_encryption": true,<br>    "passphrase_key_derivation_version": "v1"<br>  }<br>}</pre> | no |
| <a name="input_isis_policy"></a> [isis\_policy](#input\_isis\_policy) | n/a | <pre>map(object(<br>    {<br>      annotation                                      = optional(string)<br>      isis_mtu                                        = optional(number)<br>      isis_metric_for_redistributed_routes            = optional(number)<br>      lsp_fast_flood_mode                             = optional(string)<br>      lsp_generation_initial_wait_interval            = optional(number)<br>      lsp_generation_maximum_wait_interval            = optional(number)<br>      lsp_generation_second_wait_interval             = optional(number)<br>      sfp_computation_frequency_initial_wait_interval = optional(number)<br>      sfp_computation_frequency_maximum_wait_interval = optional(number)<br>      sfp_computation_frequency_second_wait_interval  = optional(number)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "isis_metric_for_redistributed_routes": 63,<br>    "isis_mtu": 1492,<br>    "lsp_fast_flood_mode": "enabled",<br>    "lsp_generation_initial_wait_interval": 50,<br>    "lsp_generation_maximum_wait_interval": 8000,<br>    "lsp_generation_second_wait_interval": 50,<br>    "sfp_computation_frequency_initial_wait_interval": 50,<br>    "sfp_computation_frequency_maximum_wait_interval": 50,<br>    "sfp_computation_frequency_second_wait_interval": 50<br>  }<br>}</pre> | no |
| <a name="input_ndoDomain"></a> [ndoDomain](#input\_ndoDomain) | Authentication Domain for Nexus Dashboard Orchestrator Authentication. | `string` | `"local"` | no |
| <a name="input_ndoHostname"></a> [ndoHostname](#input\_ndoHostname) | Cisco Nexus Dashboard Orchestrator Hostname | `string` | `"nxo.example.com"` | no |
| <a name="input_ndoPass"></a> [ndoPass](#input\_ndoPass) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `""` | no |
| <a name="input_ndoUser"></a> [ndoUser](#input\_ndoUser) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_port_tracking"></a> [port\_tracking](#input\_port\_tracking) | n/a | <pre>map(object(<br>    {<br>      annotation             = optional(string)<br>      delay_restore_timer    = optional(number)<br>      include_apic_ports     = optional(bool)<br>      number_of_active_ports = optional(number)<br>      port_tracking_state    = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "delay_restore_timer": 120,<br>    "include_apic_ports": false,<br>    "number_of_active_ports": 0,<br>    "port_tracking_state": "on"<br>  }<br>}</pre> | no |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_route_reflectors"></a> [bgp\_route\_reflectors](#output\_bgp\_route\_reflectors) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
