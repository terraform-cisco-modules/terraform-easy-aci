variable "policies_bgp_address_family_context" {
  default = {
    "default" = {
      alias                  = ""
      annotation             = ""
      description            = ""
      ebgp_distance          = 20
      ebgp_max_ecmp          = 16
      enable_host_route_leak = false
      ibgp_distance          = 200
      ibgp_max_ecmp          = 16
      local_distance         = 220
      tenant                 = "common"
    }
  }
  description = <<-EOT
  Key - Name of the BGP Address Family Context Policies
  * alias - (Optional) Name alias for BGP address family context object.
  * annotation - (Optional) Annotation for BGP address family context object.
  * description - (Optional) Description for BGP address family context object.
  * ebgp_distance - (Optional) Administrative distance of EBGP routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 20.
  * ebgp_max_ecmp - (Optional) Maximum number of equal-cost paths for BGP address family context object.Range of allowed values is 1 to 64. Default value is 16.
  * enable_host_route_leak - (Optional) Control state for BGP address family context object.
    - false - Don't enable Host route leak
    - true - Enable Host route leak
  * ibgp_distance - (Optional) Administrative distance of IBGP routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 200.
  * ibgp_max_ecmp - (Optional) Maximum ECMP IBGP for BGP address family context object. Range of allowed values is 1 to 64. Default value is 16.
  * local_distance - (Optional) Administrative distance of local routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 220.
  * tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias                  = optional(string)
      annotation             = optional(string)
      description            = optional(string)
      ebgp_distance          = optional(number)
      ebgp_max_ecmp          = optional(number)
      enable_host_route_leak = optional(bool)
      ibgp_distance          = optional(number)
      ibgp_max_ecmp          = optional(number)
      local_distance         = optional(number)
      name                   = optional(string)
      tenant                 = optional(string)
    }
  ))
}

resource "aci_bgp_address_family_context" "policies_bgp_address_family_context" {
  depends_on = [
    aci_tenant.tenants
  ]
  # Missing Local Max ECMP
  for_each = local.policies_bgp_address_family_context
  # annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  # Bug 804 Submitted
  # ctrl          = each.value.enable_host_route_leak == true ? "host-rt-leak" : "none"
  description   = each.value.description
  e_dist        = each.value.ebgp_distance
  i_dist        = each.value.ibgp_distance
  local_dist    = each.value.local_distance
  max_ecmp      = each.value.ebgp_max_ecmp
  max_ecmp_ibgp = each.value.ibgp_max_ecmp
  name          = each.key
  name_alias    = each.value.alias
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
