/*_____________________________________________________________________________________________________________________

Tenant — Policies — HSRP Group — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_hsrp_group" {
  default = {
    "default" = {
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
      timeout                           = 0
      type                              = "simple_authentication"
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                            = local.folder_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the HSRP Interface Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * enable_preemption_for_the_group: (optional)
      - false: (default)
      - true
    * hello_interval: (default: 3000) — he interval between hello packets that HSRP sends on the interface. Note that the smaller the hello interval, the faster topological changes will be detected, but more routing traffic will ensue. The range is from 250 to 254000 milliseconds.
    * hold_interval: (default: 10000) — TSets the HSRP extended hold timer, in milliseconds, for both IPv4 and IPv6 groups. The timer range is from 750 to 255000.
    * key: (default: cisco) — The key or password used to uniquely identify this configuration object. If key is set, the object key will reset when terraform configuration is applied.
    * max_seconds_to_prevent_preemption: (default: 0) — The maximum amount of time allowed for the HSRP client to prevent preemption.  This is disabled by default by setting the value to 0.
    * min_preemption_delay: (default: 0) — Configures the router to take over as the active router for an HSRP group if it has a higher priority than the current active router.Configures the router to take over as the active router for an HSRP group if it has a higher priority than the current active router. This is disabled by default by setting the value to 0.
    * preemption_delay_after_reboot: (default: 0) — The delay time for the preemptive action after the active HSRP leaf is reloaded.  This is disabled by default by setting the value to 0.
    * priority: (default: 100) — Sets the priority in HSRP to define the active router and the standby router. This is used to exchanged HSRP hello messages.  The level range is from 0 to 255.
    * tenant: Name of parent Tenant object.
    * tenant: (default: local.folder_tenant) — Name of parent Tenant object.
    * timeout: (optional) — Configures MD5 authentication for HSRP on this interface. You can use a key chain or key string. If you use a key string, you can optionally set the timeout for when HSRP will only accept a new key.  The range is from 0 to 32767 seconds.
    * type: (optional) — Type of authentication.
      * md5_authentication
      * simple_authentication
  EOT
  type = map(object(
    {
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
 - Class: "hsrpGroupPol"
 - Distinguished Name: "/uni/tn-{tenant}/hsrpGroupPol-{name}"
GUI Location:
tenants > {tenant} > Policies > Protocol > HSRP > Group Policies > {name}
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
  preempt_delay_min      = each.value.min_preemption_delay
  preempt_delay_reload   = each.value.preemption_delay_after_reboot
  preempt_delay_sync     = each.value.max_seconds_to_prevent_preemption
  prio                   = each.value.priority
  timeout                = each.value.timeout
  hsrp_group_policy_type = each.value.type == "md5_authentication" ? "md5" : "simple"
  tenant_dn              = aci_tenant.tenants[each.value.tenant].id
}
