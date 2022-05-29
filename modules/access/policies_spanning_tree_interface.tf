/*_____________________________________________________________________________________________________________________

Spanning-Tree Interface Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_spanning_tree_interface" {
  default = {
    "default" = {
      annotation   = ""
      bpdu_filter  = "disabled"
      bpdu_guard   = "disabled"
      description  = ""
      global_alias = ""
    }
  }
  description = <<-EOT
  Key: Name of the Spanning-Tree Interface Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bpdu_filter_enabled: (Default value is false).  The interface level control that enables the BPDU filter for extended chassis ports.
  * bpdu_guard_enabled: (Default value is false).  The interface level control that enables the BPDU guard for extended chassis ports.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  EOT
  type = map(object(
    {
      annotation   = optional(string)
      bpdu_filter  = optional(string)
      bpdu_guard   = optional(string)
      description  = optional(string)
      global_alias = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "stpIfPol"
 - Distinguished Name: "uni/infra/ifPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Spanning Tree Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_spanning_tree_interface_policy" "policies_spanning_tree_interface" {
  for_each   = local.policies_spanning_tree_interface
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl = alltrue(concat(
    [each.value.bpdu_filter == "enabled" ? true : false],
    [each.value.bpdu_guard == "enabled" ? true : false]
    )) ? ["bpdu-filter", "bpdu-guard"] : anytrue(concat(
    [each.value.bpdu_filter == "enabled" ? true : false],
    [each.value.bpdu_guard == "enabled" ? true : false]
    )) ? compact(
    [each.value.bpdu_filter == "enabled" ? "bpdu-filter" : ""],
    [each.value.bpdu_guard == "enabled" ? "bpdu-guard" : ""]
  ) : ["unspecified"]
  description = each.value.description
  name        = each.key
}
