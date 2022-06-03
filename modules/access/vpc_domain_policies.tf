/*_____________________________________________________________________________________________________________________

VPC Domain Policy — Variables
_______________________________________________________________________________________________________________________
*/
variable "vpc_domain_policies" {
  default = {
    "default" = {
      annotation    = ""
      dead_interval = 200
      description   = ""
    }
  }
  description = <<-EOT
  key - Name of Object VPC Explicit Protection Group.
    * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
    * dead_interval: The VPC peer dead interval time of object VPC Domain Policy. Range: 5-600. Default value is 200.
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  EOT
  type = map(object(
    {
      annotation    = optional(string)
      dead_interval = optional(number)
      description   = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vpcInstPol"
 - Distinguished Name: "uni/fabric/vpcInst-{name}"
GUI Location:
 - Fabric -> Access Policies -> Policies -> Switch -> VPC Domain -> Create VPC Domain Policy
*/
resource "aci_vpc_domain_policy" "vpc_domain_policies" {
  for_each    = local.vpc_domain_policies
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  dead_intvl  = each.value.dead_interval
  description = each.value.description
  name        = each.key
}
