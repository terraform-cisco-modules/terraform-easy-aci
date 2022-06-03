/*_____________________________________________________________________________________________________________________

Authentication — Variables
_______________________________________________________________________________________________________________________
*/
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
    Key — This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * icmp_reachability — Map of ICMP Testing Parameters.
      - retries: (default: 1) — The number of attempts that the authentication method is tried. Allowed range: "0" - "5".
      - timeout: (default: 5) — The amount of time between authentication attempts. Allowed range: "1" - "60".
      - use_icmp_reachable_providers_only — Heart beat ping checks for RADIUS/TACACS/LDAP/SAML/RSA server reachability.
    * console_authentication: (optional) — Map of Console Authentication Parameters.
      - login_domain: (optional) — Name of the Login Domain to assign to default authentication.
      - realm: (optional) — The security method for processing authentication and authorization requests. The realm allows the protected resources on the associated server to be partitioned into a set of protection spaces, each with its own authentication authorization database. This is an abstract class and cannot be instantiated.   Options are:
        * duo_proxy_ldap
        * duo_proxy_radius
        * ldap
        * local: (default)
        * radius
        * rsa
        * saml
        * tacacs
    * default_authentication: (optional) — Map of Local Authentication Parameters.
      - fallback_domain_avialability: (default: false) — Flag to allow fallback to local authentication in the event the login_domain is unavailable.
      - login_domain — Name of the Login Domain to assign to default authentication.
      - realm — The security method for processing authentication and authorization requests. The realm allows the protected resources on the associated server to be partitioned into a set of protection spaces, each with its own authentication authorization database. This is an abstract class and cannot be instantiated.   Options are:
        * duo_proxy_ldap
        * duo_proxy_radius
        * ldap
        * local: (default)
        * radius
        * rsa
        * saml
        * tacacs
    * remote_user_login_policy: (optional) — The default role policy of remote user. Allowed values are:
      - assign-default-role
      - no-login: (default)
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

/*_____________________________________________________________________________________________________________________

API Information:
 - Classes: "aaaAuthRealm" & "aaaPingEp"
 - Distinguished Named: "uni/userext/authrealm"
 - Distinguished Named: "uni/userext/pingext"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_authentication_properties" "authentication_properties" {
  for_each        = local.authentication_properties
  annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
  def_role_policy = each.value.remote_user_login_policy          # "no-login"
  ping_check      = each.value.use_icmp_reachable_providers_only # "true"
  retries         = each.value.retries
  timeout         = each.value.timeout
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaConsoleAuth"
 - Distinguished Named: "uni/userext/authrealm/consoleauth"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
resource "aci_console_authentication" "console_authentication" {
  for_each       = local.console_authentication
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  provider_group = each.value.login_domain
  realm = length(regexall(
    "duo_proxy_ldap", each.value.realm)) > 0 ? "ldap" : length(regexall(
  "duo_proxy_radius", each.value.realm)) > 0 ? "radius" : each.value.realm
  realm_sub_type = length(regexall("duo", each.value.realm)) > 0 ? "duo" : "default"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "aaaDefaultAuth"
 - Distinguished Named: "uni/userext/authrealm/defaultauth"
GUI Location:
 - Admin > AAA > Authentication
_______________________________________________________________________________________________________________________
*/
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