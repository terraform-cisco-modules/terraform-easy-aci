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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 2.1.0 |
| <a name="requirement_mso"></a> [mso](#requirement\_mso) | >= 0.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_access_port_block.leaf_port_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_block) | resource |
| [aci_access_port_selector.leaf_interface_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_port_selector) | resource |
| [aci_access_sub_port_block.leaf_port_subblocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/access_sub_port_block) | resource |
| [aci_leaf_interface_profile.leaf_interface_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_interface_profile) | resource |
| [aci_leaf_profile.leaf_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_profile) | resource |
| [aci_leaf_selector.leaf_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/leaf_selector) | resource |
| [aci_node_block.leaf_profile_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/node_block) | resource |
| [aci_rest_managed.fabric_membership](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_policy_group](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_interface_selectors](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_rest_managed.spine_profile_node_blocks](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rest_managed) | resource |
| [aci_spine_interface_profile.spine_interface_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_interface_profile) | resource |
| [aci_spine_profile.spine_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_profile) | resource |
| [aci_spine_switch_association.spine_profiles](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/spine_switch_association) | resource |
| [aci_static_node_mgmt_address.static_node_mgmt_addresses](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/static_node_mgmt_address) | resource |
| [aci_vpc_explicit_protection_group.vpc_domains](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/vpc_explicit_protection_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotation"></a> [annotation](#input\_annotation) | workspace tag value. | `string` | `""` | no |
| <a name="input_apicHostname"></a> [apicHostname](#input\_apicHostname) | Cisco APIC Hostname | `string` | `"apic.example.com"` | no |
| <a name="input_apicPass"></a> [apicPass](#input\_apicPass) | Password for User based Authentication. | `string` | `""` | no |
| <a name="input_apicUser"></a> [apicUser](#input\_apicUser) | Username for User based Authentication. | `string` | `"admin"` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_ndoDomain"></a> [ndoDomain](#input\_ndoDomain) | Authentication Domain for Nexus Dashboard Orchestrator Authentication. | `string` | `"local"` | no |
| <a name="input_ndoHostname"></a> [ndoHostname](#input\_ndoHostname) | Cisco Nexus Dashboard Orchestrator Hostname | `string` | `"nxo.example.com"` | no |
| <a name="input_ndoPass"></a> [ndoPass](#input\_ndoPass) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `""` | no |
| <a name="input_ndoUser"></a> [ndoUser](#input\_ndoUser) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |
| <a name="input_switch_profiles"></a> [switch\_profiles](#input\_switch\_profiles) | key — Node ID of the Leaf or Spine<br>* annotation: (optional) — A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. <br>* description: (optional) — Description to add to the Object.  The description can be up to 128 characters.<br>* external\_pool\_id: (optional) — External Pool ID for a remote leaf.<br>* interfaces: (required)<br>  - description: (optional) — Description to add to the Object.  The description can be up to 128 alphanumeric characters.<br>  - interface: (optional) — Physical Port on the Switch.<br>  - interface\_description: (optional) — Description to add to the Object.  The description can be up to 128 alphanumeric characters.<br>  - policy\_group: (optional) — Name of the Interface Policy Group<br>  - policy\_group\_type: (optional) — The type of Policy to Apply to the Port.<br>    * access: (default) — Access Port Policy Group<br>    * breakout — Breakout Port Policy Group<br>    * bundle — Port-Channel or Virtual Port-Channel Port Policy Group<br>  - sub\_port: (default: false) — Flag to tell the Script to create a Sub-Port Block or regular Port Block<br>* monitoring\_policy: (optional) — Name of the Monitoring Policy to assign to the Fabric Node Member.<br>* name: (required) — Hostname of the Leaf plus Name of the Leaf Profile, Leaf Interface Profile, and Leaf Profile Selector.<br>* node\_type: (optional):<br>  - leaf: (default)<br>  - remote-leaf-wan<br>  - spine<br>  - tier-2-leaf<br>* pod\_id: (default: 1) — Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.<br>* role: (optional) — The role to assign to the switch.  Options are:<br>  - leaf<br>  - spine<br>  - unspecified: (default)<br>* serial\_number: (required) — Manufacturing Serial Number of the Switch.<br>* two\_slot\_leaf: (default: false) — Flag to Tell the Script this is a Leaf with more than 99 ports.  It will Name Leaf Selectors as Eth1-001 instead of Eth1-01. | <pre>map(object(<br>    {<br>      annotation       = optional(string)<br>      description      = optional(string)<br>      external_pool_id = optional(number)<br>      inband_addressing = optional(list(object(<br>        {<br>          ipv4_address   = optional(string)<br>          ipv4_gateway   = optional(string)<br>          ipv6_address   = optional(string)<br>          ipv6_gateway   = optional(string)<br>          management_epg = optional(string)<br>        }<br>      )))<br>      interfaces = list(object(<br>        {<br>          description           = optional(string)<br>          interface             = string<br>          interface_description = optional(string)<br>          policy_group          = optional(string)<br>          policy_group_type     = optional(string)<br>          sub_port              = optional(bool)<br>        }<br>      ))<br>      monitoring_policy = optional(string)<br>      name              = string<br>      node_type         = optional(string)<br>      ooband_addressing = optional(list(object(<br>        {<br>          ipv4_address   = optional(string)<br>          ipv4_gateway   = optional(string)<br>          ipv6_address   = optional(string)<br>          ipv6_gateway   = optional(string)<br>          management_epg = optional(string)<br>        }<br>      )))<br>      policy_group  = optional(string)<br>      pod_id        = optional(number)<br>      role          = optional(string)<br>      serial_number = string<br>      two_slot_leaf = optional(bool)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "description": "",<br>    "external_pool_id": 0,<br>    "inband_addressing": [],<br>    "interfaces": [<br>      {<br>        "description": "",<br>        "interface": "1/1",<br>        "interface_description": "",<br>        "policy_group": "",<br>        "policy_group_type": "access",<br>        "sub_port": false<br>      }<br>    ],<br>    "monitoring_policy": "default",<br>    "name": "**REQUIRED**",<br>    "node_type": "leaf",<br>    "ooband_addressing": [],<br>    "pod_id": 1,<br>    "policy_group": "default",<br>    "role": "unspecified",<br>    "serial_number": "**REQUIRED**",<br>    "two_slot_leaf": false<br>  }<br>}</pre> | no |
| <a name="input_vpc_domains"></a> [vpc\_domains](#input\_vpc\_domains) | key — Name of VPC Explicit Protection Group.<br>  * annotation: (optional) — A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. <br>  * domain\_id: (required) — Explicit protection group ID. Integer values are allowed between 1-1000.<br>  * switches: (required) — List of Node IDs.<br>  * vpc\_domain\_policy: (default: default) — VPC domain policy name. | <pre>map(object(<br>    {<br>      annotation        = optional(string)<br>      domain_id         = number<br>      switches          = list(number)<br>      vpc_domain_policy = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "domain_id": null,<br>    "switches": [],<br>    "vpc_domain_policy": "default"<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
