variable "radius" {
  default = {
    "default" = {
      annotation             = ""
      authorization_protocol = "pap"
      hosts = [
        {
          host                = "198.18.0.1"
          key                 = 1
          management_epg      = "default"
          management_epg_type = "oob"
          order               = 5
        }
      ]
      port    = 1812
      retries = 1
      server_monitoring = [
        {
          admin_state = "disabled"
          password    = 0
          username    = "default"
        }
      ]
      timeout = 5
      type    = "radius"
    }
  }
  description = <<-EOT
  Key: Name of the RADIUS Login Domain.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * authorization_protocol: The RADIUS authentication protocol. The protocol can be:
    - chap
    - mschap
    - pap (default)
  * hosts: 
    - host: The RADIUS host name or IP address.
    - key: a number between 1 and 5 to identify the variable radius_key_{id} to use.
    - management_epg: The name of the Management EPG to assign the host to.
    - management_epg_type: Type of Management EPG.
      * oob (defualt)
      * inb
  * port: The TCP port number to be used when making connections to the RADIUS daemon. The range is from 1 to 65535. The default is 1812.
  * retries: The number of retries when contacting the RADIUS endpoint. The range is from 0 to 5 retries. The default is 1.
  * server_monitoring: Enabling Server Monitoring allows the connectivity of the remote AAA servers to be tested.
    - admin_state: Options are:
      * enabled
      * disabled (default)
    - password: a number between 1 and 5 to identify the variable radius_monitoring_password to use.
    - username: The username to assign to the server monitoring configuration.
  * type: Type of object RADIUS Provider. Allowed values are "duo" and "radius".
  * timeout: The period of time (in seconds) the device will wait for a response from the daemon before it times out and declares an error. The range is from 1 to 60 seconds. The default is 5 seconds. If set to 0, the AAA provider timeout is used.
  EOT
  type = map(object(
    {
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
      type    = optional(string)
    }
  ))
}

variable "radius_key_1" {
  default     = ""
  description = "RADIUS Key 1."
  sensitive   = true
  type        = string
}

variable "radius_key_2" {
  default     = ""
  description = "RADIUS Key 2."
  sensitive   = true
  type        = string
}

variable "radius_key_3" {
  default     = ""
  description = "RADIUS Key 3."
  sensitive   = true
  type        = string
}

variable "radius_key_4" {
  default     = ""
  description = "RADIUS Key 4."
  sensitive   = true
  type        = string
}

variable "radius_key_5" {
  default     = ""
  description = "RADIUS Key 5."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_1" {
  default     = ""
  description = "RADIUS Monitoring Password 1."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_2" {
  default     = ""
  description = "RADIUS Monitoring Password 2."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_3" {
  default     = ""
  description = "RADIUS Monitoring Password 3."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_4" {
  default     = ""
  description = "RADIUS Monitoring Password 4."
  sensitive   = true
  type        = string
}

variable "radius_monitoring_password_5" {
  default     = ""
  description = "RADIUS Monitoring Password 5."
  sensitive   = true
  type        = string
}

/*
API Information:
 - Class: "aaaRadiusProvider"
 - Distinguished Name: "uni/userext/radiusext/radiusprovider-{{host}}"
GUI Location:
 - Admin > AAA > Authentication:RADIUS > Create RADIUS Provider
*/
resource "aci_radius_provider" "radius_providers" {
  for_each      = { for k, v in local.radius_hosts : k => v if length(regexall("duo|radius", v.type)) > 0 }
  auth_port     = each.value.port
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = "${each.value.host} Provider."
  key = length(regexall(
    5, each.value.key)) > 0 ? var.radius_key_5 : length(regexall(
    4, each.value.key)) > 0 ? var.radius_key_4 : length(regexall(
    3, each.value.key)) > 0 ? var.radius_key_3 : length(regexall(
  2, each.value.key)) > 0 ? var.radius_key_2 : var.radius_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.radius_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.radius_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.radius_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.radius_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.radius_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  type            = each.value.type
  # relation_aaa_rs_prov_to_epp     = "5"
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

resource "aci_rsa_provider" "rsa_providers" {
  for_each      = { for k, v in local.radius_hosts : k => v if length(regexall("rsa", v.type)) > 0 }
  auth_port     = each.value.port
  auth_protocol = each.value.authorization_protocol
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  description   = "${each.value.host} Provider."
  key = length(regexall(
    5, each.value.key)) > 0 ? var.radius_key_5 : length(regexall(
    4, each.value.key)) > 0 ? var.radius_key_4 : length(regexall(
    3, each.value.key)) > 0 ? var.radius_key_3 : length(regexall(
  2, each.value.key)) > 0 ? var.radius_key_2 : var.radius_key_1
  monitor_server = each.value.server_monitoring
  monitoring_password = length(regexall(
    5, each.value.password)) > 0 ? var.radius_monitoring_password_5 : length(regexall(
    4, each.value.password)) > 0 ? var.radius_monitoring_password_4 : length(regexall(
    3, each.value.password)) > 0 ? var.radius_monitoring_password_3 : length(regexall(
    2, each.value.password)) > 0 ? var.radius_monitoring_password_2 : length(regexall(
  1, each.value.password)) > 0 ? var.radius_monitoring_password_1 : ""
  monitoring_user = each.value.username
  name            = each.value.host
  retries         = each.value.retries
  timeout         = each.value.timeout
  # relation_aaa_rs_prov_to_epp     = "5"
  relation_aaa_rs_sec_prov_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

/*
API Information:
 - Class: "aaaProviderRef"
 - Distinguished Name: "uni/userext/radiusext/radiusprovidergroup-{{login_domain}}/providerref-{{host}}"
GUI Location:
 - Admin > AAA > Authentication:AAA > Login Domain
*/
resource "aci_radius_provider_group" "radius_provider_groups" {
  for_each   = { for k, v in local.radius : k => v if length(regexall("(radius|rsa)", v.type)) > 0 }
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  name       = each.key
}

resource "aci_duo_provider_group" "duo_provider_groups" {
  for_each             = { for k, v in local.radius : k => v if v.type == "duo" }
  annotation           = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                 = each.key
  auth_choice          = "CiscoAVPair"
  provider_type        = "radius"
  sec_fac_auth_methods = ["auto"]
}

resource "aci_login_domain" "login_domain" {
  depends_on = [
    aci_radius_provider.radius_providers,
    aci_rsa_provider.rsa_providers
  ]
  for_each       = local.radius
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description    = "${each.key} Login Domain."
  name           = each.key
  realm          = each.value.type == "rsa" ? "rsa" : "radius"
  realm_sub_type = each.value.type == "duo" ? "duo" : "default"
}

resource "aci_login_domain_provider" "aci_login_domain_provider_radius" {
  depends_on = [
    aci_login_domain.login_domain,
    aci_radius_provider_group.radius_provider_groups
  ]
  for_each    = local.radius_hosts
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = "${each.value.host} Login Domain Provider."
  name        = each.value.host
  order       = each.value.order
  parent_dn = length(regexall(
    "duo", each.value.type)
    ) > 0 ? aci_duo_provider_group.duo_provider_groups[each.value.key1].id : length(regexall(
    "(radius|rsa)", each.value.type)
  ) > 0 ? aci_radius_provider_group.radius_provider_groups[each.value.key1].id : ""
}