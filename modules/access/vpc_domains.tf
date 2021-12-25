#----------------------------------------------
# Create a VPC Domain Pair
#----------------------------------------------

/*
API Information:
 - Class: "fabricExplicitGEp"
 - Distinguished Name: "uni/fabric/protpol/expgep-{{Name}}"
GUI Location:
 - Fabric > Access Policies > Policies > Virtual Port Channel default
*/
resource "aci_vpc_explicit_protection_group" "vpc_domains" {
  depends_on = [
    aci_fabric_node_member.fabric_node_members
  ]
  for_each                         = local.vpc_domains
  name                             = each.key
  annotation                       = each.value.tags
  switch1                          = each.value.node_id_1
  switch2                          = each.value.node_id_2
  vpc_domain_policy                = each.value.vpc_domain_policy
  vpc_explicit_protection_group_id = each.value.domain_id
}
