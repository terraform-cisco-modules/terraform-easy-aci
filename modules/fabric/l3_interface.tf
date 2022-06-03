/*_____________________________________________________________________________________________________________________

L3 Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "l3_interface" {
  default = {
    "default" = {
      annotation                    = ""
      bfd_isis_policy_configuration = "enabled"
      description                   = ""
    }
  }
  description = <<-EOT
    Key — Name of the Fabric Node Control Policy - **This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * bfd_isis_policy_configuration: (optional) — State ( enabled or disabled) of the BFD-IS-IS policy configuration.
      - enabled: (default)
      - disabled
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
  EOT
  type = map(object(
    {
      annotation                    = optional(string)
      bfd_isis_policy_configuration = optional(string)
      description                   = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3IfPol"
 - Distinguished Named "uni/fabric/l3IfP-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > L3 Interface > default
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_interface_policy" "l3_interface" {
  for_each = local.l3_interface
  # annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  bfd_isis    = each.value.bfd_isis_policy_configuration
  description = each.value.description
  name        = "default"
}