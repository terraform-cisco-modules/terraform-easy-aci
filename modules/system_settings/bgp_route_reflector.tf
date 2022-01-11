variable "autonomous_system_number" {
  default     = 65000
  description = "BGP Autonomous System Number."
  type        = number
}

variable "bgp_route_reflectors" {
  default = {
    "default" = {
      node_list = [101, 102]
      tags      = ""
    }
  }
  description = <<-EOT
  Key - Pod Identifier
  * node_id: Node Identifier for the Spine.
  EOT
  type = map(object(
    {
      node_list = list(string)
      tags      = optional(string)
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
    annotation = var.tags
    asn        = var.autonomous_system_number
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
    annotation = each.value.tags != "" ? each.value.tags : var.tags
    id         = each.value.node_id
    podId      = each.value.pod_id
  }
}
