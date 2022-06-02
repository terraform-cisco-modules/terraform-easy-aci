/*_____________________________________________________________________________________________________________________

Tenant - HSRP Interface Policy - Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_hsrp_group" {
  default = {
    "default" = {
      alias                             = ""
      annotation                        = ""
      description                       = ""
      enable_preemption_for_the_group   = false
      hello_interval                    = 3000
      hold_interval                     = 10000
      key                               = "cisco"
      max_seconds_to_prevent_preemption = 0
      min_preemption_delay              = 0
      preemption_delay_after_reboot     = 0
      priority                          = 100
      tenant                            = "common"
      timeout                           = 0
      type                              = "simple_authentication"
    }
  }
  description = <<-EOT
    Key - Name of the HSRP Interface Policy
    * alias - (Optional) Name name_alias for HSRP group policy object.
    * annotation - (Optional) Annotation for HSRP group policy object.
    * description - (Optional) Description for HSRP group policy object.
    * tenant - (Required) Name of the Tenant.
    * enable_preemption_for_the_group - (Optional) True or False
    * hello_interval - (Optional) The hello interval. Default value: "3000".
    * hold_interval - (Optional) The period of time before declaring that the neighbor is down. Default value: "10000".
    * key - (Optional) The key or password used to uniquely identify this configuration object. If key is set, the object key will reset when terraform configuration is applied. Default value: "cisco".
    * max_seconds_to_prevent_preemption - (Optional) Maximum number of seconds to allow IPredundancy clients to prevent preemption. Default value: "0".
    * min_preemption_delay - (Optional) HSRP Group's Minimum Preemption delay. Default value: "0".
    * preemption_delay_after_reboot - (Optional) Preemption delay after switch reboot. Default value: "0".
    * priority - (Optional) The QoS priority class ID. Default value: "100".
    * tenant - (optional) Name of the tenant.  "common" by default.
    * timeout - (Optional) Amount of time between authentication attempts. Default value: "0".
    * type - (Optional) Type of authentication.
      * md5_authentication
      * simple_authentication
  EOT
  type = map(object(
    {
      alias                             = optional(string)
      annotation                        = optional(string)
      description                       = optional(string)
      enable_preemption_for_the_group   = optional(bool)
      hello_interval                    = optional(number)
      hold_interval                     = optional(number)
      key                               = optional(string)
      max_seconds_to_prevent_preemption = optional(number)
      min_preemption_delay              = optional(number)
      preemption_delay_after_reboot     = optional(number)
      priority                          = optional(number)
      tenant                            = optional(string)
      timeout                           = optional(number)
      type                              = optional(string)
      delay                             = optional(number)
      reload_delay                      = optional(number)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpIfPol"
 - Distinguished Name: "/uni/tn-{tenant}/hsrpIfPol-{hsrp_policy}"
GUI Location:
tenants > {tenant} > Policies > Protocol > HSRP > Interface Policies > {hsrp_policy}
_______________________________________________________________________________________________________________________
*/
resource "aci_hsrp_group_policy" "policies_hsrp_group" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each               = local.policies_hsrp_group
  annotation             = each.value.annotation
  description            = each.value.description
  ctrl                   = each.value.enable_preemption_for_the_group == true ? "preempt" : 0
  hello_intvl            = each.value.hello_interval
  hold_intvl             = each.value.hold_interval
  key                    = each.value.key
  name                   = each.key
  name_alias             = each.value.alias
  preempt_delay_min      = each.value.min_preemption_delay
  preempt_delay_reload   = each.value.preemption_delay_after_reboot
  preempt_delay_sync     = each.value.max_seconds_to_prevent_preemption
  prio                   = each.value.priority
  timeout                = each.value.timeout
  hsrp_group_policy_type = each.value.type == "md5_authentication" ? "md5" : "simple"
  tenant_dn              = aci_tenant.tenants[each.value.tenant].id
}
