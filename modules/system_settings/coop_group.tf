resource "aci_coop_policy" "example" {
  annotation  = "orchestrator:terraform"
  type        = "compatible"
  name_alias  = "alias_coop_policy"
  description = "From Terraform"
}