variable "leaf_interface_policy_groups_breakout" {
  default = {
    "default" = {
      annotation   = ""
      breakout_map = "10g-4x"
      description  = ""
    }
  }
  description = <<-EOT
  Key: Name of the Attachable Access Entity Profile Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      annotation   = optional(string)
      breakout_map = optional(string)
      description  = optional(string)
    }
  ))
}

#------------------------------------------
# Create Breakout Port Policy Groups
#------------------------------------------

/*
API Information:
 - Class: "infraBrkoutPortGrp"
 - Distinguished Name: "uni/infra/funcprof/brkoutportgrp-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Interface > Leaf Interfaces > Policy Groups > Leaf Breakout Port Group:{{Name}}
*/
resource "aci_leaf_breakout_port_group" "leaf_interface_policy_groups_breakout" {
  for_each    = local.leaf_interface_policy_groups_breakout
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  brkout_map  = each.value.breakout_map
  description = each.value.description
  name        = each.key
}
