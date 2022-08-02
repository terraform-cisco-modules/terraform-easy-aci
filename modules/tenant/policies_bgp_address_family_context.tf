/*_____________________________________________________________________________________________________________________

Tenant — Policies — BGP Address Family Context — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bgp_address_family_context" {
  default = {
    "default" = {
      annotation             = ""
      description            = ""
      ebgp_distance          = 20
      ebgp_max_ecmp          = 16
      enable_host_route_leak = false
      ibgp_distance          = 200
      ibgp_max_ecmp          = 16
      local_distance         = 220
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                 = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BGP Address Family Context Policies
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * ebgp_distance: (default: 20) — Administrative distance of EBGP routes for BGP address family context object. Range of allowed values is 1-255.
    * ebgp_max_ecmp: (default: 16) — Maximum number of equal-cost paths for BGP address family context object.Range of allowed values is 1-64.
    * enable_host_route_leak: (optional) — Control state for BGP address family context object.
      - false: (default)
      - true
    * ibgp_distance: (default: 200) — Administrative distance of IBGP routes for BGP address family context object. Range of allowed values is 1-255.
    * ibgp_max_ecmp: (default: 16) — Maximum ECMP IBGP for BGP address family context object. Range of allowed values is 1 to 64. Default value is 16.
    * local_distance: (default: 220) — Administrative distance of local routes for BGP address family context object. Range of allowed values is 1-255.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation             = optional(string)
      description            = optional(string)
      ebgp_distance          = optional(number)
      ebgp_max_ecmp          = optional(number)
      enable_host_route_leak = optional(bool)
      ibgp_distance          = optional(number)
      ibgp_max_ecmp          = optional(number)
      local_distance         = optional(number)
      name                   = optional(string)
      /*  If undefined the variable of local.first_tenant will be used
      tenant                 = local.first_tenant
      */
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpCtxAfPol"
 - Distinguised Name: "uni/tn-{name}/bgpCtxAfP-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > BGP > BGP Address Family Context > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bgp_address_family_context" "policies_bgp_address_family_context" {
  depends_on = [
    aci_tenant.tenants
  ]
  # Missing Local Max ECMP
  for_each      = local.policies_bgp_address_family_context
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl          = each.value.enable_host_route_leak == true ? "host-rt-leak" : "none"
  description   = each.value.description
  e_dist        = each.value.ebgp_distance
  i_dist        = each.value.ibgp_distance
  local_dist    = each.value.local_distance
  max_ecmp      = each.value.ebgp_max_ecmp
  max_ecmp_ibgp = each.value.ibgp_max_ecmp
  name          = each.key
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
