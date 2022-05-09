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
| <a name="provider_aci"></a> [aci](#provider\_aci) | 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aci_authentication_properties.authentication_properties](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/authentication_properties) | resource |
| [aci_configuration_export_policy.configuration_export](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/configuration_export_policy) | resource |
| [aci_console_authentication.console_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/console_authentication) | resource |
| [aci_default_authentication.default_authentication](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/default_authentication) | resource |
| [aci_duo_provider_group.duo_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/duo_provider_group) | resource |
| [aci_file_remote_path.export_remote_hosts](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/file_remote_path) | resource |
| [aci_global_security.security](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/global_security) | resource |
| [aci_login_domain.login_domain](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain.login_domain_tacacs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain) | resource |
| [aci_login_domain_provider.aci_login_domain_provider_radius](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_login_domain_provider.aci_login_domain_provider_tacacs](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/login_domain_provider) | resource |
| [aci_maintenance_group_node.maintenance_group_nodes](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/maintenance_group_node) | resource |
| [aci_maintenance_policy.maintenance_group_policy](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/maintenance_policy) | resource |
| [aci_pod_maintenance_group.maintenance_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/pod_maintenance_group) | resource |
| [aci_radius_provider.radius_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider) | resource |
| [aci_radius_provider_group.radius_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/radius_provider_group) | resource |
| [aci_recurring_window.recurring_window](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/recurring_window) | resource |
| [aci_rsa_provider.rsa_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/rsa_provider) | resource |
| [aci_tacacs_accounting.tacacs_accounting](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_accounting) | resource |
| [aci_tacacs_accounting_destination.tacacs_accounting_destinations](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_accounting_destination) | resource |
| [aci_tacacs_provider.tacacs_providers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_provider) | resource |
| [aci_tacacs_provider_group.tacacs_provider_groups](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_provider_group) | resource |
| [aci_tacacs_source.tacacs_sources](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/tacacs_source) | resource |
| [aci_trigger_scheduler.trigger_schedulers](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs/resources/trigger_scheduler) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotation"></a> [annotation](#input\_annotation) | workspace tag value. | `string` | `""` | no |
| <a name="input_apicHostname"></a> [apicHostname](#input\_apicHostname) | Cisco APIC Hostname | `string` | `"apic.example.com"` | no |
| <a name="input_apicPass"></a> [apicPass](#input\_apicPass) | Password for User based Authentication. | `string` | `""` | no |
| <a name="input_apicUser"></a> [apicUser](#input\_apicUser) | Username for User based Authentication. | `string` | `"admin"` | no |
| <a name="input_apic_version"></a> [apic\_version](#input\_apic\_version) | The Version of ACI Running in the Environment. | `string` | `"5.2(1g)"` | no |
| <a name="input_authentication"></a> [authentication](#input\_authentication) | blah | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      icmp_reachability = optional(list(object(<br>        {<br>          retries                           = optional(number)<br>          timeout                           = optional(number)<br>          use_icmp_reachable_providers_only = optional(bool)<br>        }<br>      )))<br>      console_authentication = optional(list(object(<br>        {<br>          login_domain = optional(string)<br>          realm        = optional(string)<br>        }<br>      )))<br>      default_authentication = optional(list(object(<br>        {<br>          fallback_domain_avialability = optional(bool)<br>          login_domain                 = optional(string)<br>          realm                        = optional(string)<br>        }<br>      )))<br>      remote_user_login_policy = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "console_authentication": [<br>      {<br>        "login_domain": "",<br>        "realm": "local"<br>      }<br>    ],<br>    "default_authentication": [<br>      {<br>        "fallback_domain_avialability": false,<br>        "login_domain": "",<br>        "realm": "local"<br>      }<br>    ],<br>    "icmp_reachability": [<br>      {<br>        "retries": 1,<br>        "timeout": 5,<br>        "use_icmp_reachable_providers_only": true<br>      }<br>    ],<br>    "remote_user_login_policy": "no-login"<br>  }<br>}</pre> | no |
| <a name="input_certName"></a> [certName](#input\_certName) | Cisco ACI Certificate Name for SSL Based Authentication | `string` | `""` | no |
| <a name="input_configuration_backups"></a> [configuration\_backups](#input\_configuration\_backups) | n/a | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      configuration_export = list(object(<br>        {<br>          authentication_type   = optional(string)<br>          description           = optional(string)<br>          format                = optional(string)<br>          include_secure_fields = optional(bool)<br>          management_epg        = optional(string)<br>          management_epg_type   = optional(string)<br>          max_snapshot_count    = optional(number)<br>          password              = optional(number)<br>          protocol              = optional(string)<br>          remote_hosts          = list(string)<br>          remote_path           = optional(string)<br>          remote_port           = optional(number)<br>          snapshot              = optional(bool)<br>          ssh_key_contents      = optional(number)<br>          ssh_key_passphrase    = optional(number)<br>          start_now             = optional(string)<br>          username              = optional(string)<br>        }<br>      ))<br>      recurring_window = list(object(<br>        {<br>          delay_between_node_upgrades = optional(number)<br>          description                 = optional(string)<br>          maximum_concurrent_nodes    = optional(string)<br>          maximum_running_time        = optional(string)<br>          processing_break            = optional(string)<br>          processing_size_capacity    = optional(string)<br>          scheduled_days              = optional(string)<br>          scheduled_hour              = optional(number)<br>          scheduled_minute            = optional(number)<br>          window_type                 = optional(string)<br>        }<br>      ))<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "configuration_export": [<br>      {<br>        "authentication_type": "usePassword",<br>        "description": "",<br>        "format": "json",<br>        "include_secure_fields": true,<br>        "management_epg": "default",<br>        "management_epg_type": "oob",<br>        "max_snapshot_count": 0,<br>        "password": 1,<br>        "protocol": "sftp",<br>        "remote_hosts": [<br>          "fileserver.example.com"<br>        ],<br>        "remote_path": "/tmp",<br>        "remote_port": 22,<br>        "snapshot": false,<br>        "ssh_key_contents": 0,<br>        "ssh_key_passphrase": 0,<br>        "start_now": "untriggered",<br>        "username": "admin"<br>      }<br>    ],<br>    "recurring_window": [<br>      {<br>        "delay_between_node_upgrades": 0,<br>        "description": "",<br>        "maximum_concurrent_nodes": "unlimited",<br>        "maximum_running_time": "unlimited",<br>        "processing_break": "none",<br>        "processing_size_capacity": "unlimited",<br>        "scheduled_days": "every-day",<br>        "scheduled_hour": 23,<br>        "scheduled_minute": 45,<br>        "window_type": "recurring"<br>      }<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_firmware"></a> [firmware](#input\_firmware) | n/a | <pre>map(object(<br>    {<br>      annotation          = optional(string)<br>      compatibility_check = optional(bool)<br>      description         = optional(string)<br>      graceful_upgrade    = optional(bool)<br>      maintenance_groups = list(object(<br>        {<br>          name      = string<br>          node_list = list(number)<br>          start_now = optional(bool)<br>        }<br>      ))<br>      notify_conditions      = optional(string)<br>      policy_type            = optional(string)<br>      run_mode               = optional(string)<br>      simulator              = optional(bool)<br>      version                = optional(string)<br>      version_check_override = optional(bool)<br><br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "compatibility_check": false,<br>    "description": "",<br>    "graceful_upgrade": false,<br>    "maintenance_groups": [<br>      {<br>        "name": "MG_A",<br>        "node_list": [<br>          101,<br>          201<br>        ],<br>        "start_now": false<br>      }<br>    ],<br>    "notify_conditions": "notifyOnlyOnFailures",<br>    "policy_type": "switch",<br>    "run_mode": "pauseOnlyOnFailures",<br>    "simulator": true,<br>    "version": "5.2(1g)",<br>    "version_check_override": false<br>  }<br>}</pre> | no |
| <a name="input_ndoDomain"></a> [ndoDomain](#input\_ndoDomain) | Authentication Domain for Nexus Dashboard Orchestrator Authentication. | `string` | `"local"` | no |
| <a name="input_ndoHostname"></a> [ndoHostname](#input\_ndoHostname) | Cisco Nexus Dashboard Orchestrator Hostname | `string` | `"nxo.example.com"` | no |
| <a name="input_ndoPass"></a> [ndoPass](#input\_ndoPass) | Password for Nexus Dashboard Orchestrator Authentication. | `string` | `""` | no |
| <a name="input_ndoUser"></a> [ndoUser](#input\_ndoUser) | Username for Nexus Dashboard Orchestrator Authentication. | `string` | `"admin"` | no |
| <a name="input_privateKey"></a> [privateKey](#input\_privateKey) | Cisco ACI Private Key for SSL Based Authentication. | `string` | `""` | no |
| <a name="input_radius"></a> [radius](#input\_radius) | Key: Name of the RADIUS Login Domain.<br>* annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.<br>* authorization\_protocol: The RADIUS authentication protocol. The protocol can be:<br>  - chap<br>  - mschap<br>  - pap (default)<br>* hosts: <br>  - host: The RADIUS host name or IP address.<br>  - key: a number between 1 and 5 to identify the variable radius\_key\_{id} to use.<br>  - management\_epg: The name of the Management EPG to assign the host to.<br>  - management\_epg\_type: Type of Management EPG.<br>    * oob (defualt)<br>    * inb<br>* port: The TCP port number to be used when making connections to the RADIUS daemon. The range is from 1 to 65535. The default is 1812.<br>* retries: The number of retries when contacting the RADIUS endpoint. The range is from 0 to 5 retries. The default is 1.<br>* server\_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.<br>  - admin\_state: Options are:<br>    * enabled<br>    * disabled (default)<br>  - password: a number between 1 and 5 to identify the variable radius\_monitoring\_password to use.<br>  - username: The username to assign to the server monitoring configuration.<br>* type: Type of object RADIUS Provider. Allowed values are "duo" and "radius".<br>* timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used. | <pre>map(object(<br>    {<br>      annotation             = optional(string)<br>      authorization_protocol = optional(string)<br>      hosts = list(object(<br>        {<br>          host                = string<br>          key                 = optional(number)<br>          management_epg      = optional(string)<br>          management_epg_type = optional(string)<br>          order               = number<br>        }<br>      ))<br>      port    = optional(number)<br>      retries = optional(number)<br>      server_monitoring = optional(list(object(<br>        {<br>          admin_state = optional(string)<br>          password    = optional(number)<br>          username    = optional(string)<br>        }<br>      )))<br>      timeout = optional(number)<br>      type    = optional(string)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "authorization_protocol": "pap",<br>    "hosts": [<br>      {<br>        "host": "198.18.0.1",<br>        "key": 1,<br>        "management_epg": "default",<br>        "management_epg_type": "oob",<br>        "order": 5<br>      }<br>    ],<br>    "port": 1812,<br>    "retries": 1,<br>    "server_monitoring": [<br>      {<br>        "admin_state": "disabled",<br>        "password": 0,<br>        "username": "admin"<br>      }<br>    ],<br>    "timeout": 5,<br>    "type": "radius"<br>  }<br>}</pre> | no |
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
| <a name="input_security"></a> [security](#input\_security) | n/a | <pre>map(object(<br>    {<br>      annotation = optional(string)<br>      lockout_user = list(object(<br>        {<br>          enable_lockout             = optional(string)<br>          lockout_duration           = optional(number)<br>          max_failed_attempts        = optional(number)<br>          max_failed_attempts_window = optional(number)<br>        }<br>      ))<br>      maximum_validity_period          = optional(number)<br>      no_change_interval               = optional(number)<br>      password_change_interval_enforce = optional(string)<br>      password_change_interval         = optional(number)<br>      password_changes_within_interval = optional(number)<br>      password_expiration_warn_time    = optional(number)<br>      password_strength_check          = optional(bool)<br>      user_passwords_to_store_count    = optional(number)<br>      web_session_idle_timeout         = optional(number)<br>      web_token_timeout                = optional(number)<br><br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "annotation": "",<br>    "lockout_user": [<br>      {<br>        "enable_lockout": "disable",<br>        "lockout_duration": 60,<br>        "max_failed_attempts": 5,<br>        "max_failed_attempts_window": 5<br>      }<br>    ],<br>    "maximum_validity_period": 24,<br>    "no_change_interval": 24,<br>    "password_change_interval": 48,<br>    "password_change_interval_enforce": "enable",<br>    "password_changes_within_interval": 2,<br>    "password_expiration_warn_time": 15,<br>    "password_strength_check": true,<br>    "user_passwords_to_store_count": 5,<br>    "web_session_idle_timeout": 1200,<br>    "web_token_timeout": 600<br>  }<br>}</pre> | no |
| <a name="input_ssh_key_contents"></a> [ssh\_key\_contents](#input\_ssh\_key\_contents) | SSH Private Key Based Authentication Contents. | `string` | `""` | no |
| <a name="input_ssh_key_passphrase"></a> [ssh\_key\_passphrase](#input\_ssh\_key\_passphrase) | SSH Private Key Based Authentication Passphrase. | `string` | `""` | no |
| <a name="input_tacacs"></a> [tacacs](#input\_tacacs) | Key: Name of the TACACS Login Domain, Accounting Destination Group, Source etc.<br>* accounting\_include: <br>  - audit\_logs (included by default)<br>  - events<br>  - faults<br>  - session\_logs (included by default)<br>* annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.<br>* authorization\_protocol: The TACACS+ authentication protocol. The protocol can be:<br>  - chap<br>  - mschap<br>  - pap (default)<br>* hosts: <br>  - host: The TACACS+ host name or IP address.<br>  - key: a number between 1 and 5 to identify the variable tacacs\_key\_{id} to use.<br>  - management\_epg: The name of the Management EPG to assign the host to.<br>  - management\_epg\_type: Type of Management EPG.<br>    * oob (defualt)<br>    * inb<br>* port: The TCP port number to be used when making connections to the TACACS+ daemon. The range is from 1 to 65535. The default is 49.<br>* retries: The number of retries when contacting the TACACS+ endpoint. The range is from 0 to 5 retries. The default is 1.<br>* server\_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.<br>  - admin\_state: Options are:<br>    * enabled<br>    * disabled (default)<br>  - password: a number between 1 and 5 to identify the variable tacacs\_monitoring\_password to use.<br>  - username: The username to assign to the server monitoring configuration.<br>* timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used. | <pre>map(object(<br>    {<br>      accounting_include = optional(list(object(<br>        {<br>          audit_logs   = optional(bool)<br>          events       = optional(bool)<br>          faults       = optional(bool)<br>          session_logs = optional(bool)<br>        }<br>      )))<br>      annotation             = optional(string)<br>      authorization_protocol = optional(string)<br>      hosts = list(object(<br>        {<br>          host                = string<br>          key                 = optional(number)<br>          management_epg      = optional(string)<br>          management_epg_type = optional(string)<br>          order               = number<br>        }<br>      ))<br>      port    = optional(number)<br>      retries = optional(number)<br>      server_monitoring = optional(list(object(<br>        {<br>          admin_state = optional(string)<br>          password    = optional(number)<br>          username    = optional(string)<br>        }<br>      )))<br>      timeout = optional(number)<br>    }<br>  ))</pre> | <pre>{<br>  "default": {<br>    "accounting_include": [<br>      {<br>        "audit_logs": true,<br>        "events": false,<br>        "faults": false,<br>        "session_logs": true<br>      }<br>    ],<br>    "annotation": "",<br>    "authorization_protocol": "pap",<br>    "hosts": [<br>      {<br>        "host": "198.18.0.1",<br>        "key": 1,<br>        "management_epg": "default",<br>        "management_epg_type": "oob",<br>        "order": 0<br>      }<br>    ],<br>    "port": 49,<br>    "retries": 1,<br>    "server_monitoring": [<br>      {<br>        "admin_state": "disabled",<br>        "password": 0,<br>        "username": "admin"<br>      }<br>    ],<br>    "timeout": 5<br>  }<br>}</pre> | no |
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

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tacacs_provider_groups"></a> [tacacs\_provider\_groups](#output\_tacacs\_provider\_groups) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
