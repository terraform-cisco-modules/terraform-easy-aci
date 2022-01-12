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
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 1.2.0 |
| <a name="requirement_netascode"></a> [netascode](#requirement\_netascode) | >=0.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | 0.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_authentication_properties.authentication_properties](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/authentication_properties) | resource |
| [aci_configuration_export_policy.configuration_export](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/configuration_export_policy) | resource |
| [aci_console_authentication.console_authentication](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/console_authentication) | resource |
| [aci_default_authentication.default_authentication](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/default_authentication) | resource |
| [aci_duo_provider_group.duo_provider_groups](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/duo_provider_group) | resource |
| [aci_file_remote_path.export_remote_hosts](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/file_remote_path) | resource |
| [aci_global_security.security](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/global_security) | resource |
| [aci_login_domain.login_domain](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain.login_domain_tacacs](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain_provider.aci_login_domain_provider_radius](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_login_domain_provider.aci_login_domain_provider_tacacs](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_radius_provider.radius_providers](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/radius_provider) | resource |
| [aci_radius_provider_group.radius_provider_groups](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/radius_provider_group) | resource |
| [aci_recurring_window.recurring_window](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/recurring_window) | resource |
| [aci_rsa_provider.rsa_providers](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/rsa_provider) | resource |
| [aci_tacacs_accounting.tacacs_accounting](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/tacacs_accounting) | resource |
| [aci_tacacs_accounting_destination.tacacs_accounting_destinations](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/tacacs_accounting_destination) | resource |
| [aci_tacacs_provider.tacacs_providers](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/tacacs_provider) | resource |
| [aci_tacacs_provider_group.tacacs_provider_groups](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/tacacs_provider_group) | resource |
| [aci_tacacs_source.tacacs_sources](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/tacacs_source) | resource |
| [aci_trigger_scheduler.trigger_schedulers](https://registry.terraform.io/providers/ciscodevnet/aci/latest/docs/resources/trigger_scheduler) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apicPass"></a> [apicPass](#input\_apicPass) | Password for User based Authentication. | `string` | `""` | no |
| <a name="input_apicUrl"></a> [apicUrl](#input\_apicUrl) | Cisco APIC URL.  In Example http://apic.example.com | `string` | n/a | yes |
| <a name="input_apicUser"></a> [apicUser](#input\_apicUser) | Username for User based Authentication. | `string` | `""` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | n/a | <pre>map(object(<br>    {<br>      icmp_reachability = optional(list(object(<br>        {<br>          reachable_providers_only = optional(bool)<br>          retries                  = optional(number)<br>          timeout                  = optional(number)<br>        }<br>      )))<br>      console_authentication = optional(list(object(<br>        {<br>          provider_group = optional(string)<br>          realm          = optional(string)<br>          realm_sub_type = optional(string)<br>        }<br>      )))<br>      default_authentication = optional(list(object(<br>        {<br>          fallback_check = optional(bool)<br>          provider_group = optional(string)<br>          realm          = optional(string)<br>          realm_sub_type = optional(string)<br>        }<br>      )))<br>      remote_user_login_policy = optional(string)<br>      tags                     = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "console_authentication": [<br>      {<br>        "provider_group": "",<br>        "realm": "local",<br>        "realm_sub_type": "default"<br>      }<br>    ],<br>    "default_authentication": [<br>      {<br>        "fallback_check": false,<br>        "provider_group": "",<br>        "realm": "local",<br>        "realm_sub_type": "default"<br>      }<br>    ],<br>    "icmp_reachability": [<br>      {<br>        "reachable_providers_only": true,<br>        "retries": 1,<br>        "timeout": 5<br>      }<br>    ],<br>    "remote_user_login_policy": "no-login",<br>    "tags": ""<br>  }<br>}</pre> | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_configuration_backups"></a> [configuration\_backups](#input\_configuration\_backups) | n/a | <pre>map(object(<br>    {<br>      configuration_export = [{<br>        description           = optional(string)<br>        format                = optional(string)<br>        include_secure_fields = optional(string)<br>        max_snapshot_count    = optional(number)<br>        remote_hosts          = list(string)<br>        snapshot              = optional(string)<br>      }]<br>      recurring_window = list(object(<br>        {<br>          day                         = optional(string)<br>          delay_between_node_upgrades = optional(number)<br>          description                 = optional(string)<br>          hour                        = optional(number)<br>          maximum_concurrent_nodes    = optional(string)<br>          minute                      = optional(number)<br>          processing_break            = optional(string)<br>          processing_size_capacity    = optional(string)<br>          windows_type                = optional(string)<br>        }<br>      ))<br>      remote_hosts = list(object(<br>        {<br>          authentication_type = optional(string)<br>          description         = optional(string)<br>          hosts               = optional(string)<br>          management_epg      = optional(string)<br>          management_epg_type = optional(string)<br>          password            = optional(number)<br>          protocol            = optional(string)<br>          remote_path         = optional(string)<br>          remote_port         = optional(number)<br>          ssh_key_contents    = optional(number)<br>          ssh_key_passphrase  = optional(number)<br>          username            = optional(string)<br>        }<br>      ))<br>      tags = optional(string)<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |
| <a name="input_radius"></a> [radius](#input\_radius) | Key: Name of the RADIUS Login Domain.<br>* authorization\_protocol: The RADIUS authentication protocol. The protocol can be:<br>  - chap<br>  - mschap<br>  - pap (default)<br>* hosts: <br>  - host: The RADIUS host name or IP address.<br>  - key: a number between 1 and 5 to identify the variable radius\_key\_{id} to use.<br>  - management\_epg: The name of the Management EPG to assign the host to.<br>  - management\_epg\_type: Type of Management EPG.<br>    * oob (defualt)<br>    * inb<br>* port: The TCP port number to be used when making connections to the RADIUS daemon. The range is from 1 to 65535. The default is 1812.<br>* retries: The number of retries when contacting the RADIUS endpoint. The range is from 0 to 5 retries. The default is 1.<br>* server\_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.<br>  - admin\_state: Options are:<br>    * enabled<br>    * disabled (default)<br>  - password: a number between 1 and 5 to identify the variable radius\_monitoring\_password to use.<br>  - username: The username to assign to the server monitoring configuration.<br>* tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.<br>* type: Type of object RADIUS Provider. Allowed values are "duo" and "radius".<br>* timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used. | <pre>map(object(<br>    {<br>      authorization_protocol = optional(string)<br>      hosts = list(object(<br>        {<br>          host                = string<br>          key                 = optional(number)<br>          management_epg      = optional(string)<br>          management_epg_type = optional(string)<br>          order               = number<br>        }<br>      ))<br>      port    = optional(number)<br>      retries = optional(number)<br>      server_monitoring = optional(list(object(<br>        {<br>          admin_state = optional(string)<br>          password    = optional(number)<br>          username    = optional(string)<br>        }<br>      )))<br>      tags    = optional(string)<br>      timeout = optional(number)<br>      type    = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "authorization_protocol": "pap",<br>    "hosts": [<br>      {<br>        "host": "198.18.0.1",<br>        "key": 1,<br>        "management_epg": "default",<br>        "management_epg_type": "oob",<br>        "order": 5<br>      }<br>    ],<br>    "port": 1812,<br>    "retries": 1,<br>    "server_monitoring": [<br>      {<br>        "admin_state": "disabled",<br>        "password": 0,<br>        "username": "default"<br>      }<br>    ],<br>    "tags": "",<br>    "timeout": 5,<br>    "type": "radius"<br>  }<br>}</pre> | no |
| <a name="input_radius_key_1"></a> [radius\_key\_1](#input\_radius\_key\_1) | RADIUS Key 1. | `string` | `""` | no |
| <a name="input_radius_key_2"></a> [radius\_key\_2](#input\_radius\_key\_2) | RADIUS Key 2. | `string` | `""` | no |
| <a name="input_radius_key_3"></a> [radius\_key\_3](#input\_radius\_key\_3) | RADIUS Key 3. | `string` | `""` | no |
| <a name="input_radius_key_4"></a> [radius\_key\_4](#input\_radius\_key\_4) | RADIUS Key 4. | `string` | `""` | no |
| <a name="input_radius_key_5"></a> [radius\_key\_5](#input\_radius\_key\_5) | RADIUS Key 5. | `string` | `""` | no |
| <a name="input_radius_monitoring_password_1"></a> [radius\_monitoring\_password\_1](#input\_radius\_monitoring\_password\_1) | RADIUS Monitoring Password 1. | `string` | `""` | no |
| <a name="input_radius_monitoring_password_2"></a> [radius\_monitoring\_password\_2](#input\_radius\_monitoring\_password\_2) | RADIUS Monitoring Password 2. | `string` | `""` | no |
| <a name="input_radius_monitoring_password_3"></a> [radius\_monitoring\_password\_3](#input\_radius\_monitoring\_password\_3) | RADIUS Monitoring Password 3. | `string` | `""` | no |
| <a name="input_radius_monitoring_password_4"></a> [radius\_monitoring\_password\_4](#input\_radius\_monitoring\_password\_4) | RADIUS Monitoring Password 4. | `string` | `""` | no |
| <a name="input_radius_monitoring_password_5"></a> [radius\_monitoring\_password\_5](#input\_radius\_monitoring\_password\_5) | RADIUS Monitoring Password 5. | `string` | `""` | no |
| <a name="input_remote_password_1"></a> [remote\_password\_1](#input\_remote\_password\_1) | Remote Host Password 1. | `string` | `""` | no |
| <a name="input_remote_password_2"></a> [remote\_password\_2](#input\_remote\_password\_2) | Remote Host Password 2. | `string` | `""` | no |
| <a name="input_remote_password_3"></a> [remote\_password\_3](#input\_remote\_password\_3) | Remote Host Password 3. | `string` | `""` | no |
| <a name="input_remote_password_4"></a> [remote\_password\_4](#input\_remote\_password\_4) | Remote Host Password 4. | `string` | `""` | no |
| <a name="input_remote_password_5"></a> [remote\_password\_5](#input\_remote\_password\_5) | Remote Host Password 5. | `string` | `""` | no |
| <a name="input_security"></a> [security](#input\_security) | n/a | <pre>map(object(<br>    {<br>      lockout_user = list(object(<br>        {<br>          enable_lockout             = optional(string)<br>          lockout_duration           = optional(number)<br>          max_failed_attempts        = optional(number)<br>          max_failed_attempts_window = optional(number)<br>        }<br>      ))<br>      maximum_validity_period          = optional(number)<br>      no_change_interval               = optional(number)<br>      password_change_interval_enforce = optional(string)<br>      password_change_interval         = optional(number)<br>      password_changes_within_interval = optional(number)<br>      password_expiration_warn_time    = optional(number)<br>      password_strength_check          = optional(string)<br>      user_passwords_to_store_count    = optional(number)<br>      web_session_idle_timeout         = optional(number)<br>      web_token_timeout                = optional(number)<br>      tags                             = optional(string)<br><br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "lockout_user": [<br>      {<br>        "enable_lockout": "disable",<br>        "lockout_duration": 60,<br>        "max_failed_attempts": 5,<br>        "max_failed_attempts_window": 5<br>      }<br>    ],<br>    "maximum_validity_period": 24,<br>    "no_change_interval": 24,<br>    "password_change_interval": 48,<br>    "password_change_interval_enforce": "enable",<br>    "password_changes_within_interval": 2,<br>    "password_expiration_warn_time": 15,<br>    "password_strength_check": "yes",<br>    "tags": "",<br>    "user_passwords_to_store_count": 5,<br>    "web_session_idle_timeout": 1200,<br>    "web_token_timeout": 600<br>  }<br>}</pre> | no |
| <a name="input_ssh_key_contents"></a> [ssh\_key\_contents](#input\_ssh\_key\_contents) | SSH Private Key Based Authentication Contents. | `string` | `""` | no |
| <a name="input_ssh_key_passphrase"></a> [ssh\_key\_passphrase](#input\_ssh\_key\_passphrase) | SSH Private Key Based Authentication Passphrase. | `string` | `""` | no |
| <a name="input_tacacs"></a> [tacacs](#input\_tacacs) | Key: Name of the TACACS Login Domain, Accounting Destination Group, Source etc.<br>* accounting\_include: <br>  - audit\_logs (included by default)<br>  - events<br>  - faults<br>  - session\_logs (included by default)<br>* authorization\_protocol: The TACACS+ authentication protocol. The protocol can be:<br>  - chap<br>  - mschap<br>  - pap (default)<br>* hosts: <br>  - host: The TACACS+ host name or IP address.<br>  - key: a number between 1 and 5 to identify the variable tacacs\_key\_{id} to use.<br>  - management\_epg: The name of the Management EPG to assign the host to.<br>  - management\_epg\_type: Type of Management EPG.<br>    * oob (defualt)<br>    * inb<br>* port: The TCP port number to be used when making connections to the TACACS+ daemon. The range is from 1 to 65535. The default is 49.<br>* retries: The number of retries when contacting the TACACS+ endpoint. The range is from 0 to 5 retries. The default is 1.<br>* server\_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.<br>  - admin\_state: Options are:<br>    * enabled<br>    * disabled (default)<br>  - password: a number between 1 and 5 to identify the variable tacacs\_monitoring\_password to use.<br>  - username: The username to assign to the server monitoring configuration.<br>* tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.<br>* timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used. | <pre>map(object(<br>    {<br>      accounting_include = optional(list(object(<br>        {<br>          audit_logs   = optional(bool)<br>          events       = optional(bool)<br>          faults       = optional(bool)<br>          session_logs = optional(bool)<br>        }<br>      )))<br>      authorization_protocol = optional(string)<br>      hosts = list(object(<br>        {<br>          host                = string<br>          key                 = optional(number)<br>          management_epg      = optional(string)<br>          management_epg_type = optional(string)<br>          order               = number<br>        }<br>      ))<br>      port    = optional(number)<br>      retries = optional(number)<br>      server_monitoring = optional(list(object(<br>        {<br>          admin_state = optional(string)<br>          password    = optional(number)<br>          username    = optional(string)<br>        }<br>      )))<br>      tags    = optional(string)<br>      timeout = optional(number)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "accounting_include": [<br>      {<br>        "audit_logs": true,<br>        "events": false,<br>        "faults": false,<br>        "session_logs": true<br>      }<br>    ],<br>    "authorization_protocol": "pap",<br>    "hosts": [<br>      {<br>        "host": "198.18.0.1",<br>        "key": 1,<br>        "management_epg": "default",<br>        "management_epg_type": "oob",<br>        "order": 0<br>      }<br>    ],<br>    "port": 49,<br>    "retries": 1,<br>    "server_monitoring": [<br>      {<br>        "admin_state": "disabled",<br>        "password": 0,<br>        "username": "default"<br>      }<br>    ],<br>    "tags": "",<br>    "timeout": 5<br>  }<br>}</pre> | no |
| <a name="input_tacacs_key_1"></a> [tacacs\_key\_1](#input\_tacacs\_key\_1) | TACACS Key 1. | `string` | `""` | no |
| <a name="input_tacacs_key_2"></a> [tacacs\_key\_2](#input\_tacacs\_key\_2) | TACACS Key 2. | `string` | `""` | no |
| <a name="input_tacacs_key_3"></a> [tacacs\_key\_3](#input\_tacacs\_key\_3) | TACACS Key 3. | `string` | `""` | no |
| <a name="input_tacacs_key_4"></a> [tacacs\_key\_4](#input\_tacacs\_key\_4) | TACACS Key 4. | `string` | `""` | no |
| <a name="input_tacacs_key_5"></a> [tacacs\_key\_5](#input\_tacacs\_key\_5) | TACACS Key 5. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password_1"></a> [tacacs\_monitoring\_password\_1](#input\_tacacs\_monitoring\_password\_1) | TACACS Monitoring Password 1. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password_2"></a> [tacacs\_monitoring\_password\_2](#input\_tacacs\_monitoring\_password\_2) | TACACS Monitoring Password 2. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password_3"></a> [tacacs\_monitoring\_password\_3](#input\_tacacs\_monitoring\_password\_3) | TACACS Monitoring Password 3. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password_4"></a> [tacacs\_monitoring\_password\_4](#input\_tacacs\_monitoring\_password\_4) | TACACS Monitoring Password 4. | `string` | `""` | no |
| <a name="input_tacacs_monitoring_password_5"></a> [tacacs\_monitoring\_password\_5](#input\_tacacs\_monitoring\_password\_5) | TACACS Monitoring Password 5. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | workspace tag value. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tacacs_provider_groups"></a> [tacacs\_provider\_groups](#output\_tacacs\_provider\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
