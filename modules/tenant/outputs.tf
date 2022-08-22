output "bridge_domains" {
  value = {
    apic_bridge_domains = var.bridge_domains != {} ? { for v in sort(
      keys(aci_bridge_domain.bridge_domains)
    ) : v => aci_bridge_domain.bridge_domains[v].id } : {}
    ndo_bridge_domains = var.bridge_domains != {} ? { for v in sort(
      keys(mso_schema_template_bd.bridge_domains)
    ) : v => mso_schema_template_bd.bridge_domains[v].id } : {}
  }
}

output "ndo_sites" {
  value = local.ndo_sites != [] ? { for v in sort(
    keys(data.mso_site.ndo_sites)
  ) : v => data.mso_site.ndo_sites[v].id } : {}
}

output "ndo_users" {
  value = local.ndo_users != [] ? { for v in sort(
    keys(data.mso_user.ndo_users)
  ) : v => data.mso_user.ndo_users[v].id } : {}
}

output "tenants" {
  value = {
    apic_tenants = var.tenants != {} ? { for v in sort(
      keys(aci_tenant.tenants)
    ) : v => aci_tenant.tenants[v].id } : {}
    ndo_tenants = var.tenants != {} ? { for v in sort(
      keys(mso_tenant.tenants)
    ) : v => mso_tenant.tenants[v].id } : {}
  }
}

