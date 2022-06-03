/*_____________________________________________________________________________________________________________________

Policies — MCP Interface — Variables
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
    Key — Name of the MCP Interface Policy.
    * admin_state: (optional) — The administrative state of the MCP interface policy.  Options are:
      - disabled
      - enabled: (default)
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
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
