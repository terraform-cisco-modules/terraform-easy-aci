
/*_____________________________________________________________________________________________________________________

Nexus Dashboard — Users
_______________________________________________________________________________________________________________________
*/
variable "ndo_users" {
  default     = []
  description = "List of Users to import from Nexus Dashboard Orchestrator."
  type        = list(string)
}

data "mso_user" "ndo_users" {
  provider = mso
  for_each = toset(var.ndo_users)
  username = each.key
}

output "ndo_users" {
  value = var.ndo_users != [] ? { for v in sort(
    keys(data.mso_user.ndo_users)
  ) : v => data.mso_user.ndo_users[v].id } : {}
}
