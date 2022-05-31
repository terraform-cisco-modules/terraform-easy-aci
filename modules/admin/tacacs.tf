variable "tacacs" {
  default = {
    "default" = {
      accounting_include = [
        {
          audit_logs   = true
          events       = false
          faults       = false
          session_logs = true
        }
      ]
      annotation             = ""
      authorization_protocol = "pap"
      hosts = [
        {
          host                = "198.18.0.1"
          key                 = 1
          management_epg      = "default"
          management_epg_type = "oob"
          order               = 0
        }
      ]
      port    = 49
      retries = 1
      server_monitoring = [
        {
          admin_state = "disabled"
          password    = 0
          username    = "admin"
        }
      ]
      timeout = 5
    }
  }
  description = <<-EOT
  Key: Name of the TACACS Login Domain, Accounting Destination Group, Source etc.
  * accounting_include: 
    - audit_logs (included by default)
    - events
    - faults
    - session_logs (included by default)
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * authorization_protocol: The TACACS+ authentication protocol. The protocol can be:
    - chap
    - mschap
    - pap (default)
  * hosts: 
    - host: The TACACS+ host name or IP address.
    - key: a number between 1 and 5 to identify the variable tacacs_key_{id} to use.
    - management_epg: The name of the Management EPG to assign the host to.
    - management_epg_type: Type of Management EPG.
      * oob (defualt)
      * inb
  * port: The TCP port number to be used when making connections to the TACACS+ daemon. The range is from 1 to 65535. The default is 49.
  * retries: The number of retries when contacting the TACACS+ endpoint. The range is from 0 to 5 retries. The default is 1.
  * server_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.
    - admin_state: Options are:
      * enabled
      * disabled (default)
    - password: a number between 1 and 5 to identify the variable tacacs_monitoring_password to use.
    - username: The username to assign to the server monitoring configuration.
  * timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used.
  EOT
  type = map(object(
    {
      accounting_include = optional(list(object(
        {
          audit_logs   = optional(bool)
          events       = optional(bool)
          faults       = optional(bool)
          session_logs = optional(bool)
        }
      )))
      annotation             = optional(string)
      authorization_protocol = optional(string)
      hosts = list(object(
        {
          host                = string
          key                 = optional(number)
          management_epg      = optional(string)
          management_epg_type = optional(string)
          order               = number
        }
      ))
      port    = optional(number)
      retries = optional(number)
      server_monitoring = optional(list(object(
        {
          admin_state = optional(string)
          password    = optional(number)
          username    = optional(string)
        }
      )))
      timeout = optional(number)
    }
  ))
}

variable "tacacs_key_1" {
  default     = ""
  description = "TACACS Key 1."
  sensitive   = true
  type        = string
}

variable "tacacs_key_2" {
  default     = ""
  description = "TACACS Key 2."
  sensitive   = true
  type        = string
}

variable "tacacs_key_3" {
  default     = ""
  description = "TACACS Key 3."
  sensitive   = true
  type        = string
}

variable "tacacs_key_4" {
  default     = ""
  description = "TACACS Key 4."
  sensitive   = true
  type        = string
}

variable "tacacs_key_5" {
  default     = ""
  description = "TACACS Key 5."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_1" {
  default     = ""
  description = "TACACS Monitoring Password 1."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_2" {
  default     = ""
  description = "TACACS Monitoring Password 2."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_3" {
  default     = ""
  description = "TACACS Monitoring Password 3."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_4" {
  default     = ""
  description = "TACACS Monitoring Password 4."
  sensitive   = true
  type        = string
}

variable "tacacs_monitoring_password_5" {
  default     = ""
  description = "TACACS Monitoring Password 5."
  sensitive   = true
  type        = string
}

/*
API Information:
 - Class: "tacacsGroup"
 - Distinguished Name: "uni/fabric/tacacsgroup-{accounting_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > TACACS > {accounting_destination_group}
*/
resource "aci_tacacs_accounting" "tacacs_accounting" {
  for_each    = local.tacacs
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = "${each.key} Accounting"
  name        = each.key
}

/*
API Information:
 - Class: "tacacsTacacsDest"
 - Distinguished Name: "uni/fabric/tacacsgroup-{accounting_destination_group}/tacacsdest-{host}-port-{port}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > TACACS > {accounting_destination_group} > [TACACS Destinations]
*/
resource "aci_tacacs_accounting_destination" "tacacs_accounting_destinations" {
  depends_on = [
    aci_tacacs_accounting.tacacs_accounting
  ]
  for_each      = local.tacacs_hosts
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = "${each.value.host} Accounting Destination."
  host          = each.value.host
  key = length(regexall(
    5, each.value.key)) > 0 ? var.tacacs_key_5 : length(regexall(
    4, each.value.key)) > 0 ? var.tacacs_key_4 : length(regexall(
    3, each.value.key)) > 0 ? var.tacacs_key_3 : length(regexall(
  2, each.value.key)) > 0 ? var.tacacs_key_2 : var.tacacs_key_1
  name                 = each.value.host
  port                 = each.value.port
  tacacs_accounting_dn = aci_tacacs_accounting.tacacs_accounting[each.value.key1].id
  # relation_aaa_rs_prov_to_epp     = 5
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

/*
API Information:
 - Class: "aaaTacacsPlusProvider"
 - Distinguished Name: "userext/tacacsext/tacacsplusprovider-{host}"
GUI Location:
 - Admin > AAA > Authentication:TACACS > Create TACACS Provider
*/
resource "aci_tacacs_provider" "tacacs_providers" {
  for_each      = local.tacacs_hosts
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = "${each.value.host} Provider."
  key = length(regexall(
    5, each.value.key)) > 0 ? var.tacacs_key_5 : length(regexall(
    4, each.value.key)) > 0 ? var.tacacs_key_4 : length(regexall(
    3, each.value.key)) > 0 ? var.tacacs_key_3 : length(regexall(
  2, each.value.key)) > 0 ? var.tacacs_key_2 : var.tacacs_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.tacacs_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.tacacs_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.tacacs_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.tacacs_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.tacacs_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  port            = each.value.port
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = 5
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

/*
API Information:
 - Class: "aaaProviderRef"
 - Distinguished Name: "uni/userext/tacacsext/tacacsplusprovidergroup-{login_domain}/providerref-{host}"
GUI Location:
 - Admin > AAA > Authentication:AAA > Login Domain
*/
resource "aci_tacacs_provider_group" "tacacs_provider_groups" {
  for_each   = local.tacacs
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  name       = each.key
}

/*
API Information:
 - Class: "tacacsSrc"
 - Distinguished Name: "uni/fabric/moncommon/tacacssrc-{accounting_source_group}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > Callhome/Smart Callhome/SNMP/Syslog/TACACS:TACACS > Create TACACS Source
*/
resource "aci_tacacs_source" "tacacs_sources" {
  depends_on = [
    aci_tacacs_accounting.tacacs_accounting
  ]
  for_each   = local.tacacs
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  incl = compact(concat([
    length(regexall(true, each.value.accounting_include[0].audit_logs)) > 0 ? "audit" : ""], [
    length(regexall(true, each.value.accounting_include[0].events)) > 0 ? "events" : ""], [
    length(regexall(true, each.value.accounting_include[0].faults)) > 0 ? "faults" : ""], [
    length(regexall(true, each.value.accounting_include[0].session_logs)) > 0 ? "session" : ""]
  ))
  name                          = each.key
  parent_dn                     = "uni/fabric/moncommon"
  relation_tacacs_rs_dest_group = aci_tacacs_accounting.tacacs_accounting[each.key].id
}

resource "aci_login_domain" "login_domain_tacacs" {
  depends_on = [
    aci_tacacs_provider.tacacs_providers
  ]
  for_each       = local.tacacs
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description    = "${each.key} Login Domain."
  name           = each.key
  realm          = "tacacs"
  realm_sub_type = "default"
}

resource "aci_login_domain_provider" "aci_login_domain_provider_tacacs" {
  depends_on = [
    aci_login_domain.login_domain_tacacs,
    aci_tacacs_provider.tacacs_providers,
    aci_tacacs_provider_group.tacacs_provider_groups
  ]
  for_each    = local.tacacs_hosts
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = "${each.value.host} Login Domain Provider."
  name        = each.value.host
  order       = each.value.order
  parent_dn   = aci_tacacs_provider_group.tacacs_provider_groups[each.value.key1].id
}
