/*_____________________________________________________________________________________________________________________

BGP Route Reflector — Variables
_______________________________________________________________________________________________________________________
*/
variable "bgp_route_reflectors" {
  default = {
    "default" = {
      annotation = ""
      node_list  = [101, 102]
    }
  }
  description = <<-EOT
    * Key - Pod Identifier
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * node_list: (required) — List of Spine Node Identifiers to add as route reflectors.
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
