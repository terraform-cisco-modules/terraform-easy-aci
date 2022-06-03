/*_____________________________________________________________________________________________________________________

Policies — Spanning-Tree Interface — Variables
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
    Key — Name of the Spanning-Tree Interface Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * bpdu_filter_enabled: (optional) — The interface level control that enables the BPDU filter for extended chassis ports.
      - disabled: (default)
      - enabled
    * bpdu_guard_enabled: (optional) — The interface level control that enables the BPDU guard for extended chassis ports.
      - disabled: (default)
      - enabled
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * global_alias: (optional) — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
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

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/ifPol-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Spanning Tree Interface : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "policies_spanning_tree_interface_global_alias" {
  depends_on = [
    aci_spanning_tree_interface_policy.policies_spanning_tree_interface,
  ]
  for_each   = local.policies_spanning_tree_interface_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/infra/ifPol-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
