/*_____________________________________________________________________________________________________________________

VPC Domain — Variables
_______________________________________________________________________________________________________________________
*/
variable "vpc_domains" {
  default = {
    "default" = {
      annotation        = ""
      domain_id         = null
      switches          = []
      vpc_domain_policy = "default"
    }
  }
  description = <<-EOT
    key — Name of VPC Explicit Protection Group.
      * annotation: (optional) — A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
      * domain_id: (required) — Explicit protection group ID. Integer values are allowed between 1-1000.
      * switches: (required) — List of Node IDs.
      * vpc_domain_policy: (default: default) — VPC domain policy name.
  EOT
  type = map(object(
    {
      annotation        = optional(string)
      domain_id         = number
      switches          = list(number)
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
  ]
  for_each                         = { for k, v in local.vpc_domains : k => v if length(v.switches) > 1 }
  annotation                       = each.value.annotation != "" ? each.value.annotation : var.annotation
  name                             = each.key
  switch1                          = element(each.value.switches, 0)
  switch2                          = element(each.value.switches, 1)
  vpc_domain_policy                = each.value.vpc_domain_policy
  vpc_explicit_protection_group_id = each.value.domain_id
}
