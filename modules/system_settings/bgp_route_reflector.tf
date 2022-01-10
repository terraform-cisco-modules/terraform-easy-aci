variable "autonomous_system_number" {
  default     = 65000
  description = "BGP Autonomous System Number."
  type        = number
}

variable "route_reflector_nodes" {
  default     = [101, 102]
  description = "List of Spine ID's to configure as Route Reflectors."
  type        = list(string)
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpAsP"
 - Distinguished Name: "uni/fabric/bgpInstP-default"
GUI Location:
 - System > System Settings > BGP Route Reflector: {BGP_ASN}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "bgp_asn" {
  provider   = netascode
  dn         = "uni/fabric/bgpInstP-default/as"
  class_name = "bgpAsP"
  content = {
    asn = var.autonomous_system_number
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpRRNodePEp"
 - Distinguished Name: "uni/fabric/bgpInstP-default/rr/node-{Node_ID}"
GUI Location:
 - System > System Settings > BGP Route Reflector: Route Reflector Nodes
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "bgp_route_reflectors" {
  provider   = netascode
  for_each   = toset(var.route_reflector_nodes)
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value}"
  class_name = "bgpRRNodePEp"
  content = {
    id = each.value
  }
}
