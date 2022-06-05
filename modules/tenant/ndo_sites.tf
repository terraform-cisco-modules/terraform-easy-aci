
/*_____________________________________________________________________________________________________________________

Nexus Dashboard — Sites
_______________________________________________________________________________________________________________________
*/
variable "ndo_sites" {
  default     = []
  description = "List of Sites to import from Nexus Dashboard Orchestrator."
  type        = list(string)
}

data "mso_site" "ndo_sites" {
  provider = mso
  for_each = toset(var.ndo_sites)
  name     = each.key
}

output "ndo_sites" {
  value = var.ndo_sites != [] ? { for v in sort(
    keys(data.mso_site.ndo_sites)
  ) : v => data.mso_site.ndo_sites[v].id } : {}
}
