/*_____________________________________________________________________________________________________________________

Policies — CDP Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_cdp_interface" {
  default = {
    "default" = {
      admin_state  = "enabled"
      annotation   = ""
      description  = ""
      global_alias = ""
    }
  }
  description = <<-EOT
    Key — Name of the CDP Interface Policy.
    * admin_state: (default: enabled) — The State of the CDP Protocol on the Interface.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * global_alias: (optional) — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  EOT
  type = map(object(
    {
      admin_state  = optional(string)
      annotation   = optional(string)
      description  = optional(string)
      global_alias = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_cdp_interface_policy" "policies_cdp_interface" {
  for_each    = local.policies_cdp_interface
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/cdpIfP-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "policies_cdp_interface_global_alias" {
  depends_on = [
    aci_cdp_interface_policy.policies_cdp_interface,
  ]
  for_each   = local.policies_cdp_interface_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/infra/cdpIfP-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
