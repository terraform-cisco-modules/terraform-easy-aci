# ACI Tenant Policy Module

## Use this module to create Tenant Policies in the APIC Controller and Nexus Dashboard Orchestrator.

## Usage

```hcl
module "access" {

  source = "terraform-cisco-modules/aci//modules/access"

  # omitted...
}
```

This module will create the following Access Policies in an the Controller:

* Tenant

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 1.2.0 |
| <a name="requirement_mso"></a> [mso](#requirement\_mso) | >= 0.4.1 |
| <a name="requirement_netascode"></a> [netascode](#requirement\_netascode) | >=0.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 0.2.3 |
| <a name="provider_mso"></a> [mso](#provider\_mso) | 0.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_tenant.apic_tenants](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tenant) | resource |
| [mso_tenant.ndo_cisco_tenants](https://registry.terraform.io/providers/CiscoDevNet/mso/latest/docs/resources/tenant) | resource |
| [mso_site.sites](https://registry.terraform.io/providers/CiscoDevNet/mso/latest/docs/data-sources/site) | data source |
| [mso_user.users](https://registry.terraform.io/providers/CiscoDevNet/mso/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apicPass"></a> [apicPass](#input\_apicPass) | Password for User based Authentication. | `string` | `""` | no |
| <a name="input_apicUrl"></a> [apicUrl](#input\_apicUrl) | Cisco APIC URL.  In Example http://apic.example.com | `string` | n/a | yes |
| <a name="input_apicUser"></a> [apicUser](#input\_apicUser) | Username for User based Authentication. | `string` | `""` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_ndoDomain"></a> [ndoDomain](#input\_ndoDomain) | Authentication Domain for Nexus Dashboard Orchestrator Authentication. | `string` | `"local"` | no |
| <a name="input_ndoPass"></a> [ndoPass](#input\_ndoPass) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `""` | no |
| <a name="input_ndoUrl"></a> [ndoUrl](#input\_ndoUrl) | Cisco Nexus Dashboard Orchestrator URL.  In Example https://nxo.example.com | `string` | `"https://nxo.example.com"` | no |
| <a name="input_ndoUser"></a> [ndoUser](#input\_ndoUser) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |
| <a name="input_sites"></a> [sites](#input\_sites) | List of Sites to import from Nexus Dashboard Orchestrator. | `list(string)` | <pre>[<br>  "site1",<br>  "site2"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | workspace tag value. | `string` | `""` | no |
| <a name="input_tenants"></a> [tenants](#input\_tenants) | n/a | <pre>map(object(<br>    {<br>      alias             = optional(string)<br>      description       = optional(string)<br>      monitoring_policy = optional(string)<br>      name              = string<br>      sites             = optional(list(string))<br>      tags              = optional(string)<br>      type              = optional(string)<br>      users             = optional(list(string))<br>      vendor            = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "alias": "",<br>    "description": "",<br>    "monitoring_policy": "",<br>    "name": "common",<br>    "sites": [],<br>    "tags": "",<br>    "type": "apic",<br>    "users": [],<br>    "vendor": "cisco"<br>  }<br>}</pre> | no |
| <a name="input_users"></a> [users](#input\_users) | List of Users to import from Nexus Dashboard Orchestrator. | `list(string)` | <pre>[<br>  "user1",<br>  "user2"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sites"></a> [sites](#output\_sites) | n/a |
| <a name="output_tenants"></a> [tenants](#output\_tenants) | n/a |
| <a name="output_users"></a> [users](#output\_users) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
