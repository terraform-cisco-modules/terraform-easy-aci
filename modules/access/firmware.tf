variable "firmware" {
  default = {
    "default" = {
      annotation          = ""
      compatibility_check = false
      description         = ""
      policy_type         = "switch"
      graceful_upgrade    = false
      maintenance_groups = [
        {
          start_now = false
          name      = "MG_A"
          nodes     = [101, 201]
        }
      ]
      notify_conditions      = "notifyOnlyOnFailures"
      run_mode               = "pauseOnlyOnFailures"
      simulator              = true
      version                = "5.2(1g)"
      version_check_override = false
    }
  }
  description = <<-EOT
  EOT
  type = map(object(
    {
      annotation          = optional(string)
      compatibility_check = optional(bool)
      description         = optional(string)
      policy_type         = optional(string)
      graceful_upgrade    = optional(bool)
      maintenance_groups = list(object(
        {
          start_now = optional(bool)
          name      = string
          nodes     = list(number)
        }
      ))
      notify_conditions      = optional(string)
      run_mode               = optional(string)
      simulator              = optional(bool)
      version                = optional(string)
      version_check_override = optional(bool)

    }
  ))
}
#------------------------------------------
# Add Node Block(s) to a Maintenance Group
#------------------------------------------

/*
API Information:
 - Class: "maintRsMgrpp"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/rsmgrpp"
GUI Location:
 - Admin > Firmware > Nodes > {Maintenance Group Name}
*/
resource "aci_maintenance_policy" "maintenance_group_policy" {
  for_each               = local.maintenance_groups
  admin_st               = each.value.start_now == true ? "triggered" : "untriggered" # triggered|untriggered
  annotation             = each.value.annotation != "" ? each.value.annotation : var.annotation
  description            = each.value.description
  graceful               = each.value.graceful_upgrade == true ? "yes" : "no"    # yes|no
  ignore_compat          = each.value.compatibility_check == true ? "yes" : "no" # yes|no
  name                   = each.key
  notif_cond             = each.value.notify_conditions # notifyOnlyOnFailures|notifyAlwaysBetweenSets|notifyNever
  run_mode               = each.value.run_mode          # pauseOnlyOnFailures|pauseAlwaysBetweenSets|pauseNever
  version                = each.value.simulator == true ? "simsw-${each.value.version}" : "n9000-1${each.value.version}"
  version_check_override = each.value.version_check_override == true ? "trigger-immediate" : "untriggered" # trigger-immediate|trigger|triggered|untriggered
}

/*
API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Nodes > {Maintenance Group Name}
*/
resource "aci_pod_maintenance_group" "maintenance_groups" {
  depends_on = [
    aci_maintenance_policy.maintenance_group_policy
  ]
  for_each                   = local.maintenance_groups
  annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                = each.value.description
  fwtype                     = each.value.policy_type # controller|switch
  name                       = each.key
  pod_maintenance_group_type = "range"
  relation_maint_rs_mgrpp    = aci_maintenance_policy.maintenance_group_policy[each.key].id
}

/*
API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Nodes > {Maintenance Group Name}
*/
resource "aci_maintenance_group_node" "maintenance_group_nodes" {
  depends_on = [
    aci_pod_maintenance_group.maintenance_groups
  ]
  for_each                 = local.maintenance_group_nodes
  from_                    = each.value.node_id
  name                     = "blk${each.value.node_id}-${each.value.node_id}"
  pod_maintenance_group_dn = aci_pod_maintenance_group.maintenance_groups[each.value.name].id
  to_                      = each.value.node_id
}
