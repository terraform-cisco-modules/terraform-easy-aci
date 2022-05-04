variable "authentication" {
  default = {
    "default" = {
      annotation = ""
      icmp_reachability = [{
        retries                           = 1
        timeout                           = 5
        use_icmp_reachable_providers_only = true
      }]
      console_authentication = [{
        login_domain = ""
        realm        = "local"
      }]
      default_authentication = [{
        fallback_domain_avialability = false
        login_domain                 = ""
        realm                        = "local"
      }]
      remote_user_login_policy = "no-login"
    }
  }
  description = <<-EOT
  blah
  EOT
  type = map(object(
    {
      annotation = optional(string)
      icmp_reachability = optional(list(object(
        {
          retries                           = optional(number)
          timeout                           = optional(number)
          use_icmp_reachable_providers_only = optional(bool)
        }
      )))
      console_authentication = optional(list(object(
        {
          login_domain = optional(string)
          realm        = optional(string)
        }
      )))
      default_authentication = optional(list(object(
        {
          fallback_domain_avialability = optional(bool)
          login_domain                 = optional(string)
          realm                        = optional(string)
        }
      )))
      remote_user_login_policy = optional(string)
    }
  ))
}

resource "aci_authentication_properties" "authentication_properties" {
  for_each        = local.authentication_properties
  annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
  def_role_policy = each.value.remote_user_login_policy          # "no-login"
  ping_check      = each.value.use_icmp_reachable_providers_only # "true"
  retries         = each.value.retries
  timeout         = each.value.timeout
}

resource "aci_console_authentication" "console_authentication" {
  for_each       = local.console_authentication
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  provider_group = each.value.login_domain
  realm = length(regexall(
    "duo_proxy_ldap", each.value.realm)) > 0 ? "ldap" : length(regexall(
  "duo_proxy_radius", each.value.realm)) > 0 ? "radius" : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}

resource "aci_default_authentication" "default_authentication" {
  for_each       = local.default_authentication
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  fallback_check = each.value.fallback_domain_avialability
  provider_group = each.value.login_domain
  realm = length(regexall(
    "duo_proxy_ldap", each.value.realm)) > 0 ? "ldap" : length(regexall(
  "duo_proxy_radius", each.value.realm)) > 0 ? "radius" : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}