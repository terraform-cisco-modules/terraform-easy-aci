/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epControlP"
 - Distinguished Name: "uni/infra/epCtrlP-default"
GUI Location:
 - System > System Settings > Rogue EP Control
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_controls" "example" {
  admin_st              = "disabled"
  annotation            = "orchestrator:terraform"
  hold_intvl            = "1800"
  rogue_ep_detect_intvl = "60"
  rogue_ep_detect_mult  = "4"
  description           = "from terraform"
  name_alias            = "example_name_alias"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epIpAgingP"
 - Distinguished Name: "uni/infra/ipAgingP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ip Aging
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_ip_aging_profile" "example" {
  admin_st    = "disabled"
  annotation  = "orchestrator:terraform"
  description = "from terraform"
  name_alias  = "example_name_alias"
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epLoopProtectP"
 - Distinguished Name: "uni/infra/epLoopProtectP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ep Loop Protection
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_loop_protection" "example" {
  action            = ["port-disable"]
  admin_st          = "disabled"
  annotation        = "orchestrator:terraform"
  loop_detect_intvl = "60"
  loop_detect_mult  = "4"
  name_alias        = "endpoint_loop_protection_alias"
  description       = "From Terraform"
}