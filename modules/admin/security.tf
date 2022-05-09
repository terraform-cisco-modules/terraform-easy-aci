variable "security" {
  default = {
    "default" = {
      annotation = ""
      lockout_user = [
        {
          enable_lockout             = "disable"
          lockout_duration           = 60
          max_failed_attempts        = 5
          max_failed_attempts_window = 5
        }
      ]
      maximum_validity_period          = 24
      no_change_interval               = 24
      password_change_interval_enforce = "enable"
      password_change_interval         = 48
      password_changes_within_interval = 2
      password_expiration_warn_time    = 15
      password_strength_check          = true
      user_passwords_to_store_count    = 5
      web_session_idle_timeout         = 1200
      web_token_timeout                = 600
    }
  }
  description = <<-EOT
  EOT
  type = map(object(
    {
      annotation = optional(string)
      lockout_user = list(object(
        {
          enable_lockout             = optional(string)
          lockout_duration           = optional(number)
          max_failed_attempts        = optional(number)
          max_failed_attempts_window = optional(number)
        }
      ))
      maximum_validity_period          = optional(number)
      no_change_interval               = optional(number)
      password_change_interval_enforce = optional(string)
      password_change_interval         = optional(number)
      password_changes_within_interval = optional(number)
      password_expiration_warn_time    = optional(number)
      password_strength_check          = optional(bool)
      user_passwords_to_store_count    = optional(number)
      web_session_idle_timeout         = optional(number)
      web_token_timeout                = optional(number)

    }
  ))
}
/*
API Information:
 - Classes: "aaaPwdProfile", "aaaUserEp", "pkiWebTokenData"
 - Distinguished Name: "uni/userext"
GUI Location:
 - Admin > AAA > Security
*/
resource "aci_global_security" "security" {
  for_each                   = local.security
  annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
  block_duration             = each.value.lockout_duration
  change_count               = each.value.password_changes_within_interval
  change_during_interval     = each.value.password_change_interval_enforce
  change_interval            = each.value.password_change_interval
  enable_login_block         = each.value.enable_lockout
  expiration_warn_time       = each.value.password_expiration_warn_time
  history_count              = each.value.user_passwords_to_store_count
  no_change_interval         = each.value.no_change_interval
  max_failed_attempts        = each.value.max_failed_attempts
  max_failed_attempts_window = each.value.max_failed_attempts_window
  maximum_validity_period    = each.value.maximum_validity_period
  pwd_strength_check         = each.value.password_strength_check == true ? "yes" : "no"
  session_record_flags       = ["login", "logout", "refresh"]
  ui_idle_timeout_seconds    = each.value.web_session_idle_timeout
  webtoken_timeout_seconds   = each.value.web_token_timeout
  # relation_aaa_rs_to_user_ep = aci_global_security.example2.id
}
