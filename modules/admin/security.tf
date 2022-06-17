/*_____________________________________________________________________________________________________________________

Global Security — Variables
_______________________________________________________________________________________________________________________
*/
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
    Key — Name of your Firmware Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * lockout_user: (optional) — List of Lockout User Attributes.
      - enable_lockout: (optional) — Enable blocking of user logins after failed attempts. Allowed values are:
        * disable: (default)
        * enable
      - lockout_duration: (default: 60) — Duration in minutes for which login should be blocked.Duration in minutes for which future logins should be blocked Allowed range is 1-1440.
      - max_failed_attempts: (default: 5) — Maximum continuous failed logins before blocking user.max failed login attempts before blocking user login Allowed range is 1-15.
      - max_failed_attempts_window: (default: 5) — Time period for maximum continuous failed logins.times in minutes for max login failures to occur before blocking the user Allowed range is 1-720.
    * maximum_validity_period: (default: 24) — Maximum Validity Period in hours.The maximum validity period for a web token. Allowed range is 4-24.
    * no_change_interval: (default: 24) — No Password Change Interval in Hours.A minimum period after a password change before the user can change the password again. Allowed range is 0-745.
    * password_change_interval_enforce: (optional) — he change count/change interval policy selector. This property enables you to select an option for enforcing password change. Allowed values are:
      - disable
      - enable: (default)
    * password_change_interval: (default: 48) — A time interval for limiting the number of password changes. Allowed range is 0-745.
    * password_changes_within_interval: (default: 2) — Number of Password Changes in Interval.The number of password changes allowed within the change interval. Allowed range is 0-10.
    * password_expiration_warn_time: (default: 15) — Password Expiration Warn Time in Days.A warning period before password expiration. A warning will be displayed when a user logs in within this number of days of an impending password expiration. Allowed range is 0-30.
    * password_strength_check: (optional) — assword Strength Check.The password strength check specifies if the system enforces the strength of the user password. Allowed values are:
      - false
      - true: (default)
    * user_passwords_to_store_count: (default: 5) — Password History Count.How many retired passwords are stored in a user's password history. Allowed range is 0-15.
    * web_session_idle_timeout: (default: 1200) — GUI Idle Timeout in Seconds.The maximum interval time the GUI remains idle before login needs to be refreshed. Allowed range is 60-65525.
    * web_token_timeout: (default: 600) — Timeout in Seconds.The web token timeout interval. Allowed range is 300-9600.
  EOT
  type = map(object(
    {
      annotation = optional(string)
      lockout_user = optional(list(object(
        {
          enable_lockout             = optional(string)
          lockout_duration           = optional(number)
          max_failed_attempts        = optional(number)
          max_failed_attempts_window = optional(number)
        }
      )))
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
  block_duration             = each.value.lockout_user[0].lockout_duration
  change_count               = each.value.password_changes_within_interval
  change_during_interval     = each.value.password_change_interval_enforce
  change_interval            = each.value.password_change_interval
  enable_login_block         = each.value.lockout_user[0].enable_lockout
  expiration_warn_time       = each.value.password_expiration_warn_time
  history_count              = each.value.user_passwords_to_store_count
  no_change_interval         = each.value.no_change_interval
  max_failed_attempts        = each.value.lockout_user[0].max_failed_attempts
  max_failed_attempts_window = each.value.lockout_user[0].max_failed_attempts_window
  maximum_validity_period    = each.value.maximum_validity_period
  pwd_strength_check         = each.value.password_strength_check == true ? "yes" : "no"
  session_record_flags       = ["login", "logout", "refresh"]
  ui_idle_timeout_seconds    = each.value.web_session_idle_timeout
  webtoken_timeout_seconds   = each.value.web_token_timeout
  # relation_aaa_rs_to_user_ep = aci_global_security.example2.id
}
