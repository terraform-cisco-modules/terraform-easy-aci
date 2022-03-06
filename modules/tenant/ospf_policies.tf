variable "ospf_policies" {
  default = {
    "default" = {
      ospf_interface_policies = [
        {
          annotation        = ""
          cost_of_interface = 0
          dead_interval     = 40
          description       = ""
          hello_interval    = 10
          interface_controls = [
            {
              advertise_subnet      = true
              bfd                   = true
              mtu_ignore            = false
              passive_participation = false
            }
          ]
          name                = "default"
          name_alias          = ""
          network_type        = "bcast"
          priority            = 1
          retransmit_interval = 5
          transmit_delay      = 1
          tenant              = "common"
        }
      ]
      ospf_route_summarization_policies = [
        {
          annotation         = ""
          cost               = 0
          description        = ""
          inter_area_enabled = false
          name               = "default"
          name_alias         = ""
          tenant             = "common"
        }
      ]
      ospf_timers_policies = [
        {
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
          name                                        = "default"
          name_alias                                  = ""
          tenant                                      = "common"
        }
      ]
    }
  }
  description = <<-EOT
  * OSPF Interface Policies.
    - annotation:  Annotation for object OSPF interface policy.
    - cost_of_interface:  The OSPF cost for the interface. The cost (also called metric) of an interface in OSPF is an indication of the overhead required to send packets across a certain interface. The cost of an interface is inversely proportional to the bandwidth of that interface. A higher bandwidth indicates a lower cost. There is more overhead (higher cost) and time delays involved in crossing a 56k serial line than crossing a 10M ethernet line. The formula used to calculate the cost is: cost= 10000 0000/bandwidth in bps For example, it will cost 10 EXP8/10 EXP7 = 10 to cross a 10M Ethernet line and will cost 10 EXP8/1544000 = 64 to cross a T1 line. By default, the cost of an interface is calculated based on the bandwidth; you can force the cost of an interface with the ip OSPF cost value interface sub-configuration mode command. Allowed value range is 0-65535. Default is 0.
    - dead_interval:  The interval between hello packets from a neighbor before the router declares the neighbor as down. This value must be the same for all networking devices on a specific network. Specifying a smaller dead interval (seconds) will give faster detection of a neighbor being down and improve convergence, but might cause more routing instability. Allowed value range is 1-65535. Default value is 40.
    - description:  Description for object OSPF interface policy.
    - hello_interval:  The interval between hello packets that OSPF sends on the interface. Note that the smaller the hello interval, the faster topological changes will be detected, but more routing traffic will ensue. This value must be the same for all routers and access servers on a specific network. Allowed value range is 1-65535. Default value is 10.
    - interface_controls:  List of Interface Control Attributes.
      * advertise_subnet: Flag to Enable the connected interface subnet to be advertised.
      * bfd: Flag to Enable Bidirectional Forward Detection on the interface.
      * mtu_ignore: Flag to ignore the MTU when establishing neighbor relationships
      * passive: Flag to passively add the interface to the OSPF process.
    - name_alias:  Name name_alias for object OSPF interface policy.
    - network_type:  The OSPF interface policy network type. OSPF supports point-to-point and broadcast. Allowed values are "unspecified", "p2p" and "bcast". Default value is "unspecified".
    - priority:  The OSPF interface priority used to determine the designated router (DR) on a specific network. The router with the highest OSPF priority on a segment will become the DR for that segment. The same process is repeated for the backup designated router (BDR). In the case of a tie, the router with the highest RID will win. The default for the interface OSPF priority is one. Remember that the DR and BDR concepts are per multiaccess segment. Allowed range is 0-255. Default value is 1.
    - retransmit_interval:  The interval between LSA retransmissions. The retransmit interval occurs while the router is waiting for an acknowledgement from the neighbor router that it received the LSA. If no acknowlegment is received at the end of the interval, then the LSA is resent. Allowed value range is 1-65535. Default value is 5.
    - tenant: Name of parent Tenant object.
    - transmit_delay:  The delay time needed to send an LSA update packet. OSPF increments the LSA age time by the transmit delay amount before transmitting the LSA update. You should take into account the transmission and propagation delays for the interface when you set this value. Allowed value range is 1-450. Default is 1.  
  * OSPF Route Summarization Policies.
    - annotation - (Optional) Annotation for object OSPF route summarization.
    - cost - (Optional) The OSPF Area cost for the default summary LSAs. The Area cost is used with NSSA and stub area types only. Range of allowed values is "0" to "16777215". Default value: "unspecified".
    - description - Description for for object OSPF route summarization.
    - inter_area_enabled - (Optional) Inter area enabled flag for object OSPF route summarization. Allowed values: "no", "yes". Default value: "no".
    - name - (Required) Name of object OSPF route summarization.
    - name_alias - (Optional) Name name_alias for object OSPF route summarization.
    - tag - (Optional) The color of a policy label. Default value: "0".
    - tenant - (Required) Distinguished name of parent tenant object.
  * OSPF Timers Policies.
    - annotation - (Optional) Annotation for OSPF timers object.
    - bw_ref - (Optional) OSPF policy bandwidth for OSPF timers object. Range of allowed values is "1" to "4000000". Default value is "40000".
    - ctrl - (Optional) List of Control state for OSPF timers object. Allowed values are "name-lookup" and "pfx-suppress".
    - description - (Optional) Description for OSPF timers object.
    - dist - (Optional) Preferred administrative distance for OSPF timers object. Range of allowed values is "1" to "255". Default value is "110".
    - gr_ctrl - (Optional) Graceful restart enabled or helper only for OSPF timers object. The allowed value is "helper". The default value is "helper". To deselect the option, just pass gr_ctrl=""
    - lsa_arrival_intvl - (Optional) Minimum interval between the arrivals of lsas for OSPF timers object. The range of allowed values is "10" to "600000". The default value is "1000".
    - lsa_gp_pacing_intvl - (Optional) LSA group pacing interval for OSPF timers object. The range of allowed values is "1" to "1800". The default value is "10".
    - lsa_hold_intvl - (Optional) Throttle hold interval between LSAs for OSPF timers object. The range of allowed values is "50" to "30000". The default value is "5000".
    - lsa_max_intvl - (Optional) throttle max interval between LSAs for OSPF timers object. The range of allowed values is "50" to "30000". The default value is "5000".
    - lsa_start_intvl - (Optional) Throttle start-wait interval between LSAs for OSPF timers object. The range of allowed values is "0" to "5000". The default value is "0".
    - max_ecmp - (Optional) Maximum ECMP for OSPF timers object. The range of allowed values is "1" to "64". The default value is "8".
    - max_lsa_action - (Optional) Action to take when maximum LSA limit is reached for OSPF timers object. Allowed values are "reject", "log" and "restart". The default value is "reject".
    - max_lsa_num - (Optional) Maximum number of LSAs that are not self-generated for OSPF timers object. The range of allowed values is "1" to "4294967295". The default value is "20000".
    - max_lsa_reset_intvl - (Optional) Time until the sleep count is reset to zero for OSPF timers object. The range of allowed values is "1" to "1440". The default value is "10".
    - max_lsa_sleep_cnt - (Optional) Number of times OSPF can be placed in a sleep state for OSPF timers object. The range of allowed values is "1" to "4294967295". The default value is "5".
    - max_lsa_sleep_intvl - (Optional) Maximum LSA threshold for OSPF timers object. The range of allowed values is "1" to "1440". The default value is "5".
    - max_lsa_thresh - (Optional) Maximum LSA threshold for OSPF timers object. The range of allowed values is "1" to "100". The default value is "75".
    - name - (Required) Name of OSPF timers object.
    - name_alias - (Optional) Name alias for OSPF timers object.
    - spf_hold_intvl - (Optional) Minimum hold time between SPF calculations for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "1000".
    - spf_init_intvl - (Optional) Initial delay interval for the SPF schedule for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "200".
    - spf_max_intvl - (Optional) Maximum interval between SPF calculations for OSPF timers object. The range of allowed values is "1" to "600000". The default value is "5000".
    - tenant: Name of parent Tenant object.
  EOT
  type = map(object(
    {
      ospf_interface_policies = optional(list(object(
        {
          annotation        = optional(string)
          cost_of_interface = optional(number)
          dead_interval     = optional(number)
          description       = optional(string)
          hello_interval    = optional(number)
          interface_controls = optional(list(object(
            {
              advertise_subnet      = optional(bool)
              bfd                   = optional(bool)
              mtu_ignore            = optional(bool)
              passive_participation = optional(bool)
            }
          )))
          name                = optional(string)
          name_alias          = optional(string)
          network_type        = optional(string)
          priority            = optional(number)
          retransmit_interval = optional(number)
          transmit_delay      = optional(number)
          tenant              = optional(string)
        }
      )))
      ospf_route_summarization_policies = optional(list(object(
        {
          annotation         = optional(string)
          cost               = optional(number)
          description        = optional(string)
          inter_area_enabled = optional(bool)
          name               = optional(string)
          name_alias         = optional(string)
          tenant             = optional(string)
        }
      )))
      ospf_timers_policies = optional(list(object(
        {
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
          name                                        = optional(string)
          name_alias                                  = optional(string)
          tenant                                      = optional(string)
        }
      )))
    }
  ))
}

#------------------------------------------------
# Create a OSPF Interface Policy
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfPol"
 - Distinguished Name: "/uni/tn-{tenant}/ospfIfPol-{policy_name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > OSPF >  OSPF Interface > {policy_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_ospf_interface_policy" "ospf_interface_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each  = local.ospf_interface_policies
  tenant_dn = aci_tenant.tenants[each.value.tenant].id
  # annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
  cost        = each.value.cost_of_interface == 0 ? "unspecified" : each.value.cost_of_interface
  # Bug 805 Submitted
  ctrl = alltrue(
    [each.value.advertise_subnet, each.value.bfd, each.value.mtu_ignore, each.value.passive]
    ) ? ["advert-subnet", "bfd", "mtu-ignore", "passive"] : anytrue(
    [each.value.advertise_subnet, each.value.bfd, each.value.mtu_ignore, each.value.passive]
    ) ? compact(concat([
      length(regexall(true, each.value.advertise_subnet)) > 0 ? "advert-subnet" : ""], [
      length(regexall(true, each.value.bfd)) > 0 ? "bfd" : ""], [
      length(regexall(true, each.value.mtu_ignore)) > 0 ? "mtu-ignore" : ""], [
      length(regexall(true, each.value.passive_participation)) > 0 ? "passive" : ""]
  )) : ["unspecified"]
  dead_intvl  = each.value.dead_interval
  hello_intvl = each.value.hello_interval
  nw_t        = each.value.network_type
  # pfx_suppress  = each.value.pfx_suppress
  prio         = each.value.priority
  rexmit_intvl = each.value.retransmit_interval
  xmit_delay   = each.value.transmit_delay
}


resource "aci_ospf_route_summarization" "ospf_route_summarization_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.ospf_route_summarization_policies
  # annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
  cost               = each.value.cost == 0 ? "unspecified" : each.value.cost # 0 to 16777215
  description        = each.value.description
  inter_area_enabled = each.value.inter_area_enabled == true ? "yes" : "no"
  name               = each.key
  name_alias         = each.value.name_alias
  tag                = 0
  tenant_dn          = aci_tenant.tenants[each.value.tenant].id
}

resource "aci_ospf_timers" "ospf_timers_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.ospf_timers_policies
  # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  bw_ref = each.value.bandwidth_reference
  ctrl = alltrue(
    [each.value.name_lookup, each.value.prefix_suppress]
    ) ? ["name-lookup", "pfx-suppress"] : anytrue(
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
  name_alias          = each.value.name_alias
  spf_hold_intvl      = each.value.minimum_hold_time_between_spf_calculations
  spf_init_intvl      = each.value.initial_spf_scheduled_delay_interval
  spf_max_intvl       = each.value.maximum_wait_time_between_spf_calculations
  tenant_dn           = aci_tenant.tenants[each.value.tenant].id
}
