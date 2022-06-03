variable "bgp_route_reflectors" {
  default = {
    "default" = {
      annotation = ""
      node_list  = [101, 102]
    }
  }
  description = <<-EOT
  Key - Pod Identifier
  * node_id: Node Identifier for the Spine.
  EOT
  type = map(object(
    {
      annotation = optional(string)
      node_list  = list(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpRRNodePEp"
 - Distinguished Name: "uni/fabric/bgpInstP-default/rr/node-{Node_ID}"
GUI Location:
 - System > System Settings > BGP Route Reflector: Route Reflector Nodes
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "bgp_route_reflectors" {
  for_each   = local.bgp_route_reflectors
  class_name = "bgpRRNodePEp"
  dn         = "uni/fabric/bgpInstP-default/rr/node-${each.value.node_id}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    id    = each.value.node_id
    podId = each.value.pod_id
  }
}
