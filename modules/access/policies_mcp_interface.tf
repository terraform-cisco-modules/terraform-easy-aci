/*_____________________________________________________________________________________________________________________

MCP Interface Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_mcp_interface" {
  default = {
    "default" = {
      admin_state = "enabled"
      annotation  = ""
      description = ""
    }
  }
  description = <<-EOT
  Key: Name of the MCP Interface Policy.
  * admin_state: (Default value is "enabled").  The administrative state of the MCP interface policy. The state can be:
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      admin_state = optional(string)
      annotation  = optional(string)
      description = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mcpIfPol"
 - Distinguished Name: "uni/infra/mcpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > MCP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_miscabling_protocol_interface_policy" "policies_mcp_interface" {
  for_each    = local.policies_mcp_interface
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
}
