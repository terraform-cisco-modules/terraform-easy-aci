resource "aci_authentication_properties" "example" {
  annotation = "orchestrator:terraform"
  name_alias = "example_name_alias"
  description = "from terraform"
  def_role_policy = "no-login"
  ping_check = "true"
  retries = "1"
  timeout = "5"
}

resource "aci_console_authentication" "example" {
  annotation     = "orchestrator:terraform"
  provider_group = "60"
  realm          = "ldap"
  realm_sub_type = "default"
  name_alias     = "console_alias"
  description    = "From Terraform"
}

resource "aci_default_authentication" "example" {
  annotation = "orchestrator:terraform"
  fallback_check = "false"
  realm = "local"
  realm_sub_type = "default"
  name_alias = "example_name_alias"
  description = "from terraform"
}