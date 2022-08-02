/*_____________________________________________________________________________________________________________________

Tenant — Policies — OSPF Timers — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_ospf_timers" {
  default = {
    "default" = {
      annotation                = ""
      admin_distance_preference = 110
      bandwidth_reference       = 400000
      control_knobs = [
        {
          enable_name_lookup_for_router_ids = false
          prefix_suppress                   = false
        }
      ]
      description                                 = ""
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
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                                      = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the OSPF Timers Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * admin_distance_preference: (optional) — Preferred administrative distance for OSPF timers object. Range of allowed values is "1-255". Default value is "110".
    * bandwidth_reference: (default: 400000) — OSPF policy bandwidth for OSPF timers object. Range of allowed values is "1-4000000".
    * control_knobs: (optional) — List of Control state for OSPF timers object.
      - enable_name_lookup_for_router_ids: (default: false)
      - prefix_suppress: (default: false)
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * graceful_restart_helper: (optional) — Graceful restart enabled or helper only for OSPF timers object. The allowed values are:
      - false
      - true: (default)
    * lsa_arrival_intvl: (optional) — Minimum interval between the arrivals of lsas for OSPF timers object. The range of allowed values is "10-600000".
    * lsa_group_pacing_interval: (default: 10) — LSA group pacing interval for OSPF timers object. The range of allowed values is "1-1800". The default value is "10".
    * lsa_generation_throttle_hold_interval: (default: 5000) — Throttle hold interval between LSAs for OSPF timers object. The range of allowed values is "50-30000".
    * lsa_generation_throttle_maximum_interval: (default: 5000) — throttle max interval between LSAs for OSPF timers object. The range of allowed values is "50-30000".
    * lsa_generation_throttle_start_wait_interval: (default: 0) — Throttle start-wait interval between LSAs for OSPF timers object. The range of allowed values is "0-5000".
      initial_spf_scheduled_delay_interval        = 200
      lsa_threshold                               = 75
      maximum_lsa_reset_interval                  = 10
      maximum_lsa_sleep_count                     = 5
      maximum_lsa_sleep_interval                  = 5
      maximum_number_of_not_self_generated_lsas   = 20000
      minimum_hold_time_between_spf_calculations  = 1000
      minimum_interval_between_arrival_of_a_lsa   = 1000
      maximum_wait_time_between_spf_calculations  = 5000
    * lsa_maximum_action: (optional) — Action to take when maximum LSA limit is reached for OSPF timers object. Allowed values are:
      - log
      - reject: (default)
      - restart
    * lsa_threshold: (default: 75) — Maximum LSA threshold for OSPF timers object. The range of allowed values is "1-100". The default value is "75".
    * maximum_ecmp: (default: 8) — Maximum ECMP for OSPF timers object. The range of allowed values is "1-64".
    * maximum_lsa_reset_interval: (default: 10) — Time until the sleep count is reset to zero for OSPF timers object. The range of allowed values is "1-1440".
    * maximum_lsa_sleep_count: (default: 5) — Number of times OSPF can be placed in a sleep state for OSPF timers object. The range of allowed values is "1-4294967295".
    * maximum_lsa_sleep_interval: (default: 5) — Maximum LSA threshold for OSPF timers object. The range of allowed values is "1-1440".
    * maximum_number_of_not_self_generated_lsas: (default: 20000) — Maximum number of LSAs that are not self-generated for OSPF timers object. The range of allowed values is "1-4294967295".
    * minimum_hold_time_between_spf_calculations: (default: 1000) — Minimum hold time between SPF calculations for OSPF timers object. The range of allowed values is "1-600000".
    * minimum_interval_between_arrival_of_a_lsa: (default: 1000) — Initial delay interval for the SPF schedule for OSPF timers object. The range of allowed values is "1-600000".
    * maximum_wait_time_between_spf_calculations: (default: 5000) — Maximum interval between SPF calculations for OSPF timers object. The range of allowed values is "1-600000".
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation                = optional(string)
      admin_distance_preference = optional(number)
      bandwidth_reference       = optional(number)
      control_knobs = optional(list(object(
        {
          enable_name_lookup_for_router_ids = optional(bool)
          prefix_suppress                   = optional(bool)
        }
      )))
      description                                 = optional(string)
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfCtxPol"
 - Distinguished Name: "/uni/tn-{tenant}/ospfCtxP-{name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > OSPF >  OSPF Timers > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_ospf_timers" "policies_ospf_timers" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.policies_ospf_timers
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  bw_ref     = each.value.bandwidth_reference
  ctrl = anytrue(
    [
      each.value.control_knobs[0].enable_name_lookup_for_router_ids,
      each.value.control_knobs[0].prefix_suppress
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.control_knobs[0].enable_name_lookup_for_router_ids)
      ) > 0 ? "name-lookup" : ""], [
      length(regexall(true, each.value.control_knobs[0].prefix_suppress)
      ) > 0 ? "pfx-suppress" : ""]
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
  spf_hold_intvl      = each.value.minimum_hold_time_between_spf_calculations
  spf_init_intvl      = each.value.initial_spf_scheduled_delay_interval
  spf_max_intvl       = each.value.maximum_wait_time_between_spf_calculations
  tenant_dn           = aci_tenant.tenants[each.value.tenant].id
}
