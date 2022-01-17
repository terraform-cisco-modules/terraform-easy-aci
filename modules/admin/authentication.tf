variable "authentication" {
  default = {
    "default" = {
      annotation = ""
      icmp_reachability = [{
        reachable_providers_only = true
        retries                  = 1
        timeout                  = 5
      }]
      console_authentication = [{
        provider_group = ""
        realm          = "local"
        realm_sub_type = "default"
      }]
      default_authentication = [{
        fallback_domain_avialability = false
        provider_group               = ""
        realm                        = "local"
        realm_sub_type               = "default"
      }]
      remote_user_login_policy = "no-login"
    }
  }
}
resource "aci_authentication_properties" "authentication_properties" {
  for_each        = local.authentication_properties
  annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
  def_role_policy = each.value.remote_user_login_policy      # "no-login"
  ping_check      = each.value.icmp_reachable_providers_only # "true"
  retries         = each.value.retries
  timeout         = each.value.timeout
}

resource "aci_console_authentication" "console_authentication" {
  for_each       = local.console_authentication
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  provider_group = each.value.provider_group
  realm          = each.value.realm
  realm_sub_type = each.value.realm_sub_type
}

resource "aci_default_authentication" "default_authentication" {
  for_each       = local.default_authentication
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  fallback_check = each.value.fallback_domain_avialability
  provider_group = each.value.provider_group
  realm          = each.value.realm
  realm_sub_type = each.value.realm_sub_type
}