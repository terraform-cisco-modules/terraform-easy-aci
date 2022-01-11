output "tacacs_provider_groups" {
  value = var.tacacs != {} ? { for v in sort(
    keys(aci_tacacs_provider_group.tacacs_provider_groups)
  ) : v => aci_tacacs_provider_group.tacacs_provider_groups[v].id } : {}
}
