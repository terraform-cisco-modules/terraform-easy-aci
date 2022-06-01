
variable "policies_ospf_timers" {
  default = {
    "default" = {
      alias               = ""
      annotation          = ""
      bandwidth_reference = 400000
      control_knobs = [
        {
          enable_name_lookup_for_router_ids = false
          prefix_suppress                   = false
        }
      ]
      description                                 = ""
      admin_distance_preference                   = 110
      graceful_restart_helper                     = true
      initial_spf_scheduled_delay_interval        = 200
      lsa_group_pacing_interval                   = 10
      lsa_generation_throttle_hold_interval       = 5000
      lsa_generation_throttle_maximum_interval    = 5000
      lsa_generation_throttle_start_wait_interval = 0
      lsa_maximum_action                          = "reject"
      lsa_threshold                               = 75
      maximum_ecmp                                = 8
      maximum_lsa_reset_interval                  = 10
      maximum_lsa_sleep_count                     = 5
      maximum_lsa_sleep_interval                  = 5
      maximum_number_of_not_self_generated_lsas   = 20000
      minimum_hold_time_between_spf_calculations  = 1000
      minimum_interval_between_arrival_of_a_lsa   = 1000
      maximum_wait_time_between_spf_calculations  = 5000
      tenant                                      = "common"
    }
  }
  description = <<-EOT
  Key - Name of the OSPF Timers Policy.
  * alias - (Optional) Name alias for OSPF timers object.
  * annotation - (Optional) Annotation for OSPF timers object.
  * bw_ref - (Optional) OSPF policy bandwidth for OSPF timers object. Range of allowed values is "1" to "4000000". Default value is "40000".
  * ctrl - (Optional) List of Control state for OSPF timers object. Allowed values are "name-lookup" and "pfx-suppress".
  * description - (Optional) Description for OSPF timers object.
  * dist - (Optional) Preferred administrative distance for OSPF timers object. Range of allowed values is "1" to "255". Default value is "110".
  * gr_ctrl - (Optional) Graceful restart enabled or helper only for OSPF timers object. The allowed value is "helper". The default value is "helper". To deselect the option, just pass gr_ctrl=""
  * lsa_arrival_intvl - (Optional) Minimum interval between the arrivals of lsas for OSPF timers object. The range of allowed values is "10" to "600000". The default value is "1000".
  * lsa_gp_pacing_intvl - (Optional) LSA group pacing interval for OSPF timers object. The range of allowed values is "1" to "1800". The default value is "10".
  * lsa_hold_intvl - (Optional) Throttle hold interval between LSAs for OSPF timers object. The range of allowed values is "50" to "30000". The default value is "5000".
  * lsa_max_intvl - (Optional) throttle max interval between LSAs for OSPF timers object. The range of allowed values is "50" to "30000". The default value is "5000".
  * lsa_start_intvl - (Optional) Throttle start-wait interval between LSAs for OSPF timers object. The range of allowed values is "0" to "5000". The default value is "0".
  * max_ecmp - (Optional) Maximum ECMP for OSPF timers object. The range of allowed values is "1" to "64". The default value is "8".
  * max_lsa_action - (Optional) Action to take when maximum LSA limit is reached for OSPF timers object. Allowed values are "reject", "log" and "restart". The default value is "reject".
  * max_lsa_num - (Optional) Maximum number of LSAs that are not self-generated for OSPF timers object. The range of allowed values is "1" to "4294967295". The default value is "20000".
  * max_lsa_reset_intvl - (Optional) Time until the sleep count is reset to zero for OSPF timers object. The range of allowed values is "1" to "1440". The default value is "10".
  * max_lsa_sleep_cnt - (Optional) Number of times OSPF can be placed in a sleep state for OSPF timers object. The range of allowed values is "1" to "4294967295". The default value is "5".
  * max_lsa_sleep_intvl - (Optional) Maximum LSA threshold for OSPF timers object. The range of allowed values is "1" to "1440". The default value is "5".
  * max_lsa_thresh - (Optional) Maximum LSA threshold for OSPF timers object. The range of allowed values is "1" to "100". The default value is "75".
  * spf_hold_intvl - (Optional) Minimum hold time between SPF calculations for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "1000".
  * spf_init_intvl - (Optional) Initial delay interval for the SPF schedule for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "200".
  * spf_max_intvl - (Optional) Maximum interval between SPF calculations for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "5000".
  * tenant: Name of parent Tenant object.
  EOT
  type = map(object(
    {
      alias               = optional(string)
      annotation          = optional(string)
      bandwidth_reference = optional(number)
      control_knobs = optional(list(object(
        {
          enable_name_lookup_for_router_ids = optional(bool)
          prefix_suppress                   = optional(bool)
        }
      )))
      description                                 = optional(string)
      admin_distance_preference                   = optional(number)
      graceful_restart_helper                     = optional(bool)
      initial_spf_scheduled_delay_interval        = optional(number)
      lsa_group_pacing_interval                   = optional(number)
      lsa_generation_throttle_hold_interval       = optional(number)
      lsa_generation_throttle_maximum_interval    = optional(number)
      lsa_generation_throttle_start_wait_interval = optional(number)
      lsa_maximum_action                          = optional(string)
      lsa_threshold                               = optional(number)
      maximum_ecmp                                = optional(number)
      maximum_lsa_reset_interval                  = optional(number)
      maximum_lsa_sleep_count                     = optional(number)
      maximum_lsa_sleep_interval                  = optional(number)
      maximum_number_of_not_self_generated_lsas   = optional(number)
      minimum_hold_time_between_spf_calculations  = optional(number)
      minimum_interval_between_arrival_of_a_lsa   = optional(number)
      maximum_wait_time_between_spf_calculations  = optional(number)
      tenant                                      = optional(string)
    }
  ))
}

resource "aci_ospf_timers" "policies_ospf_timers" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.policies_ospf_timers
  # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  bw_ref = each.value.bandwidth_reference
  ctrl = anytrue(
    [each.value.name_lookup, each.value.prefix_suppress]
    ) ? compact(concat([
      length(regexall(true, each.value.name_lookup)) > 0 ? "name-lookup" : ""], [
      length(regexall(true, each.value.prefix_suppress)) > 0 ? "pfx-suppress" : ""]
  )) : []
  description         = each.value.description
  dist                = each.value.admin_distance_preference
  gr_ctrl             = each.value.graceful_restart_helper == true ? "helper" : "none"
  lsa_arrival_intvl   = each.value.minimum_interval_between_arrival_of_a_lsa
  lsa_gp_pacing_intvl = each.value.lsa_group_pacing_interval
  lsa_hold_intvl      = each.value.lsa_generation_throttle_hold_interval
  lsa_max_intvl       = each.value.lsa_generation_throttle_maximum_interval
  lsa_start_intvl     = each.value.lsa_generation_throttle_start_wait_interval
  max_ecmp            = each.value.maximum_ecmp
  max_lsa_action      = each.value.lsa_maximum_action
  max_lsa_num         = each.value.maximum_number_of_not_self_generated_lsas
  max_lsa_reset_intvl = each.value.maximum_lsa_reset_interval
  max_lsa_sleep_cnt   = each.value.maximum_lsa_sleep_count
  max_lsa_sleep_intvl = each.value.maximum_lsa_sleep_interval
  max_lsa_thresh      = each.value.lsa_threshold
  name                = each.key
  name_alias          = each.value.alias
  spf_hold_intvl      = each.value.minimum_hold_time_between_spf_calculations
  spf_init_intvl      = each.value.initial_spf_scheduled_delay_interval
  spf_max_intvl       = each.value.maximum_wait_time_between_spf_calculations
  tenant_dn           = aci_tenant.tenants[each.value.tenant].id
}
