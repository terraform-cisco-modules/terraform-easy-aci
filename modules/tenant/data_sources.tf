
variable "sites" {
  default     = []
  description = "List of Sites to import from Nexus Dashboard Orchestrator."
  type        = list(string)
}

variable "users" {
  default     = []
  description = "List of Users to import from Nexus Dashboard Orchestrator."
  type        = list(string)
}

data "mso_site" "sites" {
  provider = mso
  for_each = toset(var.sites)
  name     = each.key
}

data "mso_user" "users" {
  provider = mso
  for_each = toset(var.users)
  username = each.key
}

output "sites" {
  value = var.sites != {} ? { for v in sort(
    keys(data.mso_site.sites)
  ) : v => data.mso_site.sites[v].id } : {}
}

output "users" {
  value = var.users != {} ? { for v in sort(
    keys(data.mso_user.users)
  ) : v => data.mso_user.users[v].id } : {}
}
