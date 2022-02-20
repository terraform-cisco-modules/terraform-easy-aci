/*_____________________________________________________________________________________________________________________

VPC Domain Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "vpc_domain_policies" {
  default = {
    "default" = {
      annotation    = ""
      dead_interval = 200
      description   = ""
      name_alias    = ""
    }
  }
  description = <<-EOT
  key - Name of Object VPC Explicit Protection Group.
    * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
    * dead_interval: The VPC peer dead interval time of object VPC Domain Policy. Range: 5-600. Default value is 200.
    * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  EOT
  type = map(object(
    {
      annotation    = optional(string)
      dead_interval = optional(number)
      description   = optional(string)
      name_alias    = optional(string)
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
  name_alias  = each.value.name_alias
}

/*_____________________________________________________________________________________________________________________

VPC Domain Variables
_______________________________________________________________________________________________________________________
*/
variable "vpc_domains" {
  default = {
    "default" = {
      annotation        = ""
      domain_id         = null
      switch_1          = null
      switch_2          = null
      vpc_domain_policy = "default"
    }
  }
  description = <<-EOT
  key - Name of Object VPC Explicit Protection Group.
    * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
    * domain_id: Explicit protection group ID. Integer values are allowed between 1-1000.
    * switch_1: Node Id of switch 1 to attach.
    * switch_2: Node Id of switch 2 to attach.
    * vpc_domain_policy: VPC domain policy name.
  EOT
  type = map(object(
    {
      annotation        = optional(string)
      domain_id         = number
      switch_1          = number
      switch_2          = number
      vpc_domain_policy = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricExplicitGEp"
 - Distinguished Name: "uni/fabric/protpol/expgep-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Virtual Port Channel default
*/
resource "aci_vpc_explicit_protection_group" "vpc_domains" {
  depends_on = [
    aci_rest_managed.fabric_membership,
    aci_vpc_domain_policy.vpc_domain_policies
  ]
  for_each                         = local.vpc_domains
  annotation                       = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                             = each.key
  switch1                          = each.value.switch_1
  switch2                          = each.value.switch_2
  vpc_domain_policy                = each.value.vpc_domain_policy
  vpc_explicit_protection_group_id = each.value.domain_id
}
