variable "l3_interface" {
  default = {
    "default" = {
      annotation                    = ""
      bfd_isis_policy_configuration = "enabled"
      description                   = ""
      name_alias                    = ""
    }
  }
  description = <<-EOT
  Key: Name of the Fabric Node Control Policy - **This should always be default.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * bfd_isis_policy_configuration: State ( enabled or disabled) of the BFD-IS-IS policy configuration.
    - enabled: Enables BFD-IS-IS policy.
    - disabled: Disables BFD-IS-IS policy.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  EOT
  type = map(object(
    {
      annotation                    = optional(string)
      bfd_isis_policy_configuration = optional(string)
      description                   = optional(string)
      name_alias                    = optional(string)
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
  for_each    = local.l3_interface
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  bfd_isis    = each.value.bfd_isis_policy_configuration
  description = each.value.description
  name        = "default"
  name_alias  = each.value.name_alias
}