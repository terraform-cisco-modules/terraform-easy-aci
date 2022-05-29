output "domains_layer3" {
  value = var.domains_layer3 != {} ? { for v in sort(
    keys(aci_l3_domain_profile.domains_layer3)
  ) : v => aci_l3_domain_profile.domains_layer3[v].id } : {}
}

output "domains_physical" {
  value = var.domains_physical != {} ? { for v in sort(
    keys(aci_physical_domain.domains_physical)
  ) : v => aci_physical_domain.domains_physical[v].id } : {}
}

output "global_attachable_access_entity_profiles" {
  value = var.global_attachable_access_entity_profiles != {} ? { for v in sort(
    keys(aci_attachable_access_entity_profile.global_attachable_access_entity_profiles)
  ) : v => aci_attachable_access_entity_profile.global_attachable_access_entity_profiles[v].id } : {}
}

# output "vmm_domains" {
#   value = var.vmm_domains != {} ? { for v in sort(
#     keys(aci_vmm_domain.vmm_domains)
#   ) : v => aci_vmm_domain.vmm_domains[v].id } : {}
# }
