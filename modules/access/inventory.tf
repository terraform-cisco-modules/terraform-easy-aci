/*
API Information:
 - Class: "fabricNode"
 - Distinguished Name: "topology/pod-{pod_id}/node-{node_id}"
GUI Location:
 - Fabric > Access Policies > Inventory > Fabric Membership:[Registered Nodes or Nodes Pending Registration]
*/
resource "aci_fabric_node_member" "fabric_node_members" {
  for_each    = local.fabric_node_members
  ext_pool_id = each.value.external_pool_id
  fabric_id   = "1"
  name        = each.value.name
  node_id     = each.key
  node_type   = each.value.node_type
  pod_id      = each.value.pod_id
  role        = each.value.role
  serial      = each.value.serial
}
