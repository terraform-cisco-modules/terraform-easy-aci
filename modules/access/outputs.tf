output "layer3_domains" {
  value = var.layer3_domains != {} ? { for v in sort(
    keys(aci_l3_domain_profile.layer3_domains)
  ) : v => aci_l3_domain_profile.layer3_domains[v].id } : {}
}

output "physical_domains" {
  value = var.physical_domains != {} ? { for v in sort(
    keys(aci_physical_domain.physical_domains)
  ) : v => aci_physical_domain.physical_domains[v].id } : {}
}

output "vmm_domains" {
  value = var.vmm_domains != {} ? { for v in sort(
    keys(aci_vmm_domain.vmm_domains)
  ) : v => aci_vmm_domain.vmm_domains[v].id } : {}
}

output "aaep_policies" {
  value = var.aaep_policies != {} ? { for v in sort(
    keys(aci_attachable_access_entity_profile.aaep_policies)
  ) : v => aci_attachable_access_entity_profile.aaep_policies[v].id } : {}
}

output "vpc_domains" {
  value = var.vpc_domains != {} ? { for v in sort(
    keys(aci_vpc_explicit_protection_group.vpc_domains)
  ) : v => aci_vpc_explicit_protection_group.vpc_domains[v].id } : {}
}
