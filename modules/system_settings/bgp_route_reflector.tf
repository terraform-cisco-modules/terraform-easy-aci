variable "autonomous_system_number" {
  default     = 65000
  description = "BGP Autonomous System Number."
  type        = number
}

variable "bgp_route_reflectors" {
  default = {
    "default" = {
      node_id = 101
      pod_id  = 1
    }
  }
  description = <<-EOT
  Key - Unique ID
  * node_id: Node Identifier for the Spine.
  * pod_id: Pod Identifier the Spine is Located in.
  EOT
  type = map(object(
    {
      node_id = number
      pod_id  = optional(number)
    }
  ))
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
  for_each   = local.bgp_route_reflectors
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value.node_id}"
  class_name = "bgpRRNodePEp"
  content = {
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}
