resource "aci_endpoint_controls" "example" {
  admin_st = "disabled"
  annotation = "orchestrator:terraform"
  hold_intvl = "1800"
  rogue_ep_detect_intvl = "60"
  rogue_ep_detect_mult = "4"
  description = "from terraform"
  name_alias = "example_name_alias"
}

resource "aci_endpoint_ip_aging_profile" "example" {
  admin_st = "disabled"
  annotation = "orchestrator:terraform"
  description = "from terraform"
  name_alias = "example_name_alias"
}

resource "aci_endpoint_loop_protection" "example" {
  action            = ["port-disable"]
  admin_st          = "disabled"
  annotation        = "orchestrator:terraform"
  loop_detect_intvl = "60"
  loop_detect_mult  = "4"
  name_alias        = "endpoint_loop_protection_alias"
  description       = "From Terraform"
}