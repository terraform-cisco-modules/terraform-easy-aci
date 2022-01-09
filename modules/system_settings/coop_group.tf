/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "coopPol"
 - Distinguished Named "uni/fabric/pol-default"
GUI Location:
 - System > System Settings > Coop Group > Type
_______________________________________________________________________________________________________________________
*/
resource "aci_coop_policy" "example" {
  annotation  = "orchestrator:terraform"
  type        = "compatible"
  name_alias  = "alias_coop_policy"
  description = "From Terraform"
}