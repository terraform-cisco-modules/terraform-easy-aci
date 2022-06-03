/*_____________________________________________________________________________________________________________________

Leaf Interfaces — Breakout Policy Group — Variables
_______________________________________________________________________________________________________________________
*/
variable "leaf_interfaces_policy_groups_breakout" {
  default = {
    "default" = {
      annotation   = ""
      breakout_map = "10g-4x"
      description  = ""
    }
  }
  description = <<-EOT
    Key — Name of the Leaf Breakout Policy Group.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * breakout_map — Enable the port as a breakout port with one of the following options:
      - 10g-4x — Enables a 40 Gigabit Ethernet (GE) port to be connected with a Cisco 40-Gigabit-to-4x10-Gigabit breakout cable to 4 10GE-capable devices.
      - 25g-4x — Enables a 100GE port to be connected with a Cisco 100-Gigabit-to-4x25-Gigabit breakout cable to 4 25GE-capable devices.
      - 50g-8x — Enables a 400GE port to be connected with a Cisco 400-Gigabit-to-8x50-Gigabit breakout cable to 8 50GE-capable devices.
      - 100g-2x — Enables a 400GE port to be connected with a Cisco 400-Gigabit-to-4x25-Gigabit breakout cable to 2 200GE-capable devices.
      - 100g-4x — Enables a 400GE port to be connected with a Cisco 400-Gigabit-to-4x100-Gigabit breakout cable to 4 100GE-capable devices.
    * description — Description to add to the Object.  The description can be up to 128 characters.
  EOT
  type = map(object(
    {
      annotation   = optional(string)
      breakout_map = optional(string)
      description  = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraBrkoutPortGrp"
 - Distinguished Name: "uni/infra/funcprof/brkoutportgrp-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Interface > Leaf Interfaces > Policy Groups > Leaf Breakout Port Group:{{Name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_leaf_breakout_port_group" "leaf_interfaces_policy_groups_breakout" {
  for_each    = local.leaf_interfaces_policy_groups_breakout
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  brkout_map  = each.value.breakout_map
  description = each.value.description
  name        = each.key
}
