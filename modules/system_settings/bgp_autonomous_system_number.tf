variable "bgp_autonomous_system_number" {
  default     = 65000
  description = "BGP Autonomous System Number."
  type        = number
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpAsP"
 - Distinguished Name: "uni/fabric/bgpInstP-default"
GUI Location:
 - System > System Settings > BGP Route Reflector: {BGP_ASN}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "bgp_autonomous_system_number" {
  dn         = "uni/fabric/bgpInstP-default/as"
  class_name = "bgpAsP"
  content = {
    # annotation = var.annotation
    asn = var.autonomous_system_number
  }
}
