#------------------------------------------
# Add Node Block(s) to a Maintenance Group
#------------------------------------------

/*
API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Nodes > {Maintenance Group Name}
*/
resource "aci_maintenance_group_node" "maintenance_group_nodes" {
    depends_on  = [
        aci_pod_maintenance_group.maintenance_groups
    ]
    pod_maintenance_group_dn = aci_pod_maintenance_group.maintenance_groups[each.value.maintenance_group].id
    name                     = "blk${each.value.node_id}-${each.value.node_id}"
    from_                    = each.value.node_id
    to_                      = each.value.node_id
}
