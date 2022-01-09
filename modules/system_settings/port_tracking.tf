/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortTrackPol"
 - Distinguished Name: "uni/infra/trackEqptFabP-default"
GUI Location:
 - System > System Settings > Port Tracking
_______________________________________________________________________________________________________________________
*/
resource "aci_port_tracking" "example" {
  admin_st           = "off"
  annotation         = "orchestrator:terraform"
  delay              = "120"
  description        = "From Terraform"
  include_apic_ports = "no"
  minlinks           = "0"
  name_alias         = "port_tracking_alias"
}