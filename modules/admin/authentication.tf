# resource "aci_authentication_properties" "example" {
#   annotation      = "orchestrator:terraform"
#   name_alias      = "example_name_alias"
#   description     = "from terraform"
#   def_role_policy = "no-login"
#   ping_check      = "true"
#   retries         = "1"
#   timeout         = "5"
# }
# 
# resource "aci_console_authentication" "console_authentication" {
#   annotation     = each.value.tags
#   provider_group = each.value.provider_group
#   realm          = each.value.realm
#   realm_sub_type = each.value.realm_sub_type
# }
# 
# resource "aci_default_authentication" "default_authentication" {
#   annotation     = each.value.tags
#   fallback_check = each.value.fallback_check
#   provider_group = each.value.provider_group
#   realm          = each.value.realm
#   realm_sub_type = each.value.realm_sub_type
# }