variable "bgp_policies" {
  default = {
    "default" = {
      bgp_address_family_context_policies = [
        {
          annotation             = ""
          description            = ""
          ebgp_distance          = 20
          ebgp_max_ecmp          = 16
          enable_host_route_leak = false
          ibgp_distance          = 200
          ibgp_max_ecmp          = 16
          local_distance         = 220
          name                   = "default"
          name_alias             = ""
          tenant                 = "common"
        }
      ]
      bgp_best_path_policies = [
        {
          annotation                = ""
          description               = ""
          name                      = "default"
          name_alias                = ""
          relax_as_path_restriction = false
          tenant                    = "common"
        }
      ]
      bgp_peer_prefix_policies = [
        {
          action                     = "reject"
          annotation                 = ""
          description                = ""
          maximum_number_of_prefixes = 20000
          name                       = "default"
          restart_time               = "infinite"
          tenant                     = "common"
          threshold                  = 75
        }
      ]
      bgp_route_summarization_policies = [
        {
          annotation                  = ""
          description                 = ""
          generate_as_set_information = false
          name                        = "default"
          name_alias                  = ""
          tenant                      = "common"
        }
      ]
      bgp_timers_policies = [
        {
          annotation              = ""
          description             = ""
          graceful_restart_helper = true
          hold_interval           = 180
          keepalive_interval      = 60
          maximum_as_limit        = 0
          name                    = "default"
          name_alias              = ""
          stale_interval          = 300
          tenant                  = "common"
        }
      ]
    }
  }
  description = <<-EOT
  * BGP Address Family Context Policies
    - annotation - (Optional) Annotation for BGP address family context object.
    - description - (Optional) Description for BGP address family context object.
    - ebgp_distance - (Optional) Administrative distance of EBGP routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 20.
    - ebgp_max_ecmp - (Optional) Maximum number of equal-cost paths for BGP address family context object.Range of allowed values is 1 to 64. Default value is 16.
    - enable_host_route_leak - (Optional) Control state for BGP address family context object.
      * false - Don't enable Host route leak
      * true - Enable Host route leak
    - ibgp_distance - (Optional) Administrative distance of IBGP routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 200.
    - ibgp_max_ecmp - (Optional) Maximum ECMP IBGP for BGP address family context object. Range of allowed values is 1 to 64. Default value is 16.
    - local_distance - (Optional) Administrative distance of local routes for BGP address family context object. Range of allowed values is 1 to 255. Default value is 220.
    - name - (Required) Name of BGP address family context object.
    - name_alias - (Optional) Name name_alias for BGP address family context object.
    - tenant - (Required) Name of parent Tenant object.
  * BGP Best Path Policies
    - tenant_dn - (Required) Distinguished name of parent tenant object.
    - name - (Required) Name of Object BGP Best Path Policy.
    - annotation - (Optional) Annotation for object BGP Best Path Policy.
    - description - (Optional) Description for object BGP Best Path Policy.
    - relax_as_path_restriction - (Optional) The control state.  Allowed values: "asPathMultipathRelax", "0". Default Value: "0".
    - name_alias - (Optional) Name name_alias for object BGP Best Path Policy.
    - tenant - (Required) Name of parent Tenant object.
  * BGP Peer Prefix Policies
    - action - (Optional) Action when the maximum prefix limit is reached for BGP peer prefix object. Allowed values are "log", "reject", "restart" and "shut". Default value is "reject".
    - annotation - (Optional) Annotation for BGP peer prefix object.
    - description - (Optional) Description for BGP peer prefix object.
    - maximum_number_of_prefixes - (Optional) Maximum number of prefixes allowed from the peer for BGP peer prefix object. Default value is "20000".
    - name - (Required) Name of BGP peer prefix object.
    - name_alias - (Optional) Name name_alias for BGP peer prefix object.
    - restart_time - (Optional) The period of time in minutes before restarting the peer when the prefix limit is reached for BGP peer prefix object. Default value is "infinite".
    - tenant - (Required) Name of parent Tenant object.
    - threshold - (Optional) Threshold percentage of the maximum number of prefixes before a warning is issued for BGP peer prefix object. Default value is "75".
  * BGP Route Summarization Policies
    - annotation - (Optional) Annotation for object BGP route summarization.
    - attrmap - (Optional) Summary attribute map.
    - generate_as_set_information - (Boolean) Generate AS-SET information
    - description - (Optional) Description for object BGP route summarization.
    - name - (Required) Name of Object BGP route summarization.
    - name_alias - (Optional) Name name_alias for object BGP route summarization.
    - tenant - (Required) Name of parent Tenant object.
  * BGP Timers Policies
    - annotation - (Optional) Annotation for bgp timers object.
    - description - (Optional) Description for bgp timers object.
    - graceful_restart_helper - (Boolean) Graceful restart enabled or helper only for bgp timers object.  Default is true
    - hold_interval - (Optional) Time period before declaring neighbor down for bgp timers object. Default value is 180.
    - keepalive_interval - (Optional) Interval time between keepalive messages for bgp timers object. Default value is 60.
    - maximum_as_limit - (Optional) Maximum AS limit for bgp timers object. Range of allowed values is 0 to 2000. Default value is 0.
    - name - (Required) Name of bgp timers object.
    - name_alias - (Optional) Name name_alias for bgp timers object. Default value is "default".
    - stale_interval - (Optional) Stale interval for routes advertised by peer for bgp timers object. Range of allowed values is 1 to 3600. Default value is 300.
    - tenant - (Required) Name of parent Tenant object.
  EOT
  type = map(object(
    {
      bgp_address_family_context_policies = optional(list(object(
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
          name_alias             = optional(string)
          tenant                 = optional(string)
        }
      )))
      bgp_best_path_policies = optional(list(object(
        {
          annotation                = optional(string)
          description               = optional(string)
          name                      = optional(string)
          name_alias                = optional(string)
          relax_as_path_restriction = optional(bool)
          tenant                    = optional(string)
        }
      )))
      bgp_peer_prefix_policies = optional(list(object(
        {
          action                     = optional(string)
          annotation                 = optional(string)
          description                = optional(string)
          maximum_number_of_prefixes = optional(number)
          name                       = optional(string)
          restart_time               = optional(string)
          tenant                     = optional(string)
          threshold                  = optional(number)
        }
      )))
      bgp_route_summarization_policies = optional(list(object(
        {
          annotation                  = optional(string)
          description                 = optional(string)
          generate_as_set_information = optional(bool)
          name                        = optional(string)
          name_alias                  = optional(string)
          tenant                      = optional(string)
        }
      )))
      bgp_timers_policies = optional(list(object(
        {
          annotation              = optional(string)
          description             = optional(string)
          graceful_restart_helper = optional(bool)
          hold_interval           = optional(number)
          keepalive_interval      = optional(number)
          maximum_as_limit        = optional(number)
          name                    = optional(string)
          name_alias              = optional(string)
          stale_interval          = optional(number)
          tenant                  = optional(string)
        }
      )))
    }
  ))
}
resource "aci_bgp_address_family_context" "bgp_address_family_context_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  # Missing Local Max ECMP
  for_each = local.bgp_address_family_context_policies
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
  name_alias    = each.value.name_alias
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}


resource "aci_bgp_best_path_policy" "bgp_best_path_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.bgp_best_path_policies
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl        = each.value.relax_as_path_restriction == true ? "asPathMultipathRelax" : "0"
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}


#------------------------------------------------
# Create a BGP Peer Connectivity Profile
#------------------------------------------------

/*
API Information:
 - Class: "bgpPeerPfxPol"
 - Distinguished Name: "uni/tn-{tenant}/bgpPfxP-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > BGP >  BGP Peer Prefix > {name}
*/
resource "aci_bgp_peer_prefix" "bgp_peer_prefix_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.bgp_peer_prefix_policies
  action   = each.value.action # log|reject|restart|shut default is log
  # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  name         = each.key
  max_pfx      = each.value.maximum_number_of_prefixes # default is 20000
  restart_time = each.value.restart_time               # default is inifinite
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
  thresh       = each.value.threshold # default is 75
}


resource "aci_bgp_route_summarization" "bgp_route_summarization_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.bgp_route_summarization_policies
  #annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  # attrmap     = each.value.attrmap
  ctrl        = each.value.generate_as_set_information == true ? "as-set" : "none"
  description = each.value.description
  name        = each.value.name
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}

resource "aci_bgp_timers" "bgp_timers_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.bgp_timers_policies
  # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  gr_ctrl      = each.value.graceful_restart_helper == true ? "helper" : "none"
  hold_intvl   = each.value.hold_interval
  ka_intvl     = each.value.keepalive_interval
  max_as_limit = each.value.maximum_as_limit
  name         = each.key
  name_alias   = each.value.name_alias
  stale_intvl  = each.value.stale_interval == 300 ? "default" : each.value.stale_interval
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
