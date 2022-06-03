/*_____________________________________________________________________________________________________________________

Firmware Management - Maintenance Policies
_______________________________________________________________________________________________________________________
*/
variable "firmware" {
  default = {
    "default" = {
      annotation          = ""
      compatibility_check = false
      description         = ""
      graceful_upgrade    = false
      maintenance_groups = [
        {
          name      = "MG_A"
          node_list = [101, 201]
          start_now = false
        }
      ]
      notify_conditions      = "notifyOnlyOnFailures"
      policy_type            = "switch"
      run_mode               = "pauseOnlyOnFailures"
      simulator              = false
      version                = "5.2(4e)"
      version_check_override = "untriggered"
    }
  }
  description = <<-EOT
    Key — Name of your Firmware Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * compatibility_check: (optional) — A property that specifies whether compatibility checks should be ignored when applying the firmware policy. Allowed values: 
      - false: (default)
      - true
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * graceful_upgrade: (optional) — Whether the system will bring down the nodes gracefully during an upgrade, which reduces traffic lost. Allowed values: 
      - false: (default)
      - true
    * maintenance_groups: (requied) — List of Maintenance Group settings.
          name: (required) — Name of the Maintenance Group.
          node_list: (required) — List of Fabric Node ID's to add to the group.
          start_now: (optional) — The administrative state of the executable policies. It will trigger an immediate upgrade for nodes if adminst is set to triggered. Once upgrade is done, value is reset back to untriggered. Allowed values:
          - false: (default)
          - true
    * notify_conditions: (optional) — Specifies under what pause condition will admin be notified via email/text as configured. This notification mechanism is independent of events/faults. Allowed values:
      - notifyOnlyOnFailures: (default)
      - notifyAlwaysBetweenSets
      - notifyNever
    * policy_type: (optional) — The firmware type for pod maintenance group object. Allowed values are:
      - catalog
      - config
      - controller
      - plugin
      - pluginPackage
      - switch: (default)
    * run_mode: (optional) — Specifies whether to proceed automatically to next set of nodes once a set of nodes have gone through maintenance successfully. Allowed values:
      - pauseOnlyOnFailures: (default)
      - pauseAlwaysBetweenSets
      - pauseNever
    * simulator: (default: false) — This is a flag for the script to determine the name structure of the firmware version.
    * version: (default: 5.2(4e)) — The Version of software to apply to the policy.
    * version_check_override: (optional) — The version check override. This is a directive to ignore the version check for the next install. The version check, which occurs during a maintenance window, checks to see if the desired version matches the running version. If the versions do not match, the install is performed. If the versions do match, the install is not performed. The version check override is a one-time override that performs the install whether or not the versions match. Allowed values:
      - trigger-immediate
      - trigger
      - triggered
      - untriggered: (default)
    
  EOT
  type = map(object(
    {
      annotation          = optional(string)
      compatibility_check = optional(bool)
      description         = optional(string)
      graceful_upgrade    = optional(bool)
      maintenance_groups = list(object(
        {
          name      = string
          node_list = list(number)
          start_now = optional(bool)
        }
      ))
      notify_conditions      = optional(string)
      policy_type            = optional(string)
      run_mode               = optional(string)
      simulator              = optional(bool)
      version                = optional(string)
      version_check_override = optional(string)

    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareRsFwgrpp"
 - Distinguished Name: "uni/fabric/fwgrp-{name}/rsfwgrpp"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
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
  version_check_override = each.value.version_check_override
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "firmwareFwGrp"
 - Distinguished Name: "uni/fabric/maintgrp-{name}"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_pod_maintenance_group" "maintenance_groups" {
  depends_on = [
    aci_maintenance_policy.maintenance_group_policy
  ]
  for_each                   = local.maintenance_groups
  annotation                 = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                = each.value.description
  fwtype                     = each.value.policy_type # controller|switch
  name                       = each.value.name
  pod_maintenance_group_type = "range"
  relation_maint_rs_mgrpp    = aci_maintenance_policy.maintenance_group_policy[each.value.maintenance_policy].id
}

#------------------------------------------
# Add Node Block(s) to a Maintenance Group
#------------------------------------------
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeBlk"
 - Distinguished Name: "uni/fabric/maintgrp-{name}/nodeblk-blk{node_id}-{node_id}"
GUI Location:
 - Admin > Firmware > Nodes > {maintenance_group_name}
_______________________________________________________________________________________________________________________
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
