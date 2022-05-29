/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}
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
  Key: Name of the CDP Interface Policy.
  * admin_state: (Default value is "enabled").  The State of the CDP Protocol on the Interface.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
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


resource "aci_cdp_interface_policy" "policies_cdp_interface" {
  for_each    = local.policies_cdp_interface
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
}
