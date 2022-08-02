/*_____________________________________________________________________________________________________________________

Tenant — Policies — Endpoint Retention — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_endpoint_retention" {
  default = {
    "default" = {
      annotation                     = ""
      bounce_entry_aging_interval    = 630
      bounce_trigger                 = "protocol"
      description                    = ""
      hold_interval                  = 300
      local_endpoint_aging_interval  = 900
      move_frequency                 = 256
      remote_endpoint_aging_interval = 300
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                         = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the OSPF Interface Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * bounce_entry_aging_interval: (default: 630) — The aging interval for a bounce entry. When an endpoint (VM) migrates to another switch, the endpoint is marked as bouncing for the specified aging interval and is deleted afterwards. Allowed value range is 0-65535.
    * bounce_trigger: (optional) — Specifies whether to install the bounce entry by RARP flood or by COOP protocol. Allowed values are:
      - protocol: (default)
      - rarp-flood
    * hold_interval: (default: 300) — A time period during which new endpoint learn events will not be honored. This interval is triggered when the maximum endpoint move frequency is exceeded. Allowed value range is 5-65535.
    * local_endpoint_aging_interval: (default: 900) — The aging interval for all local endpoints learned in this bridge domain. When 75% of the interval is reached, 3 ARP requests are sent to verify the existence of the endpoint. If no response is received, the endpoint is deleted. Allowed value range is 0,120-65535. "0" is treated as special value here. Providing interval as "0" is treated as infinite interval.
    * move_frequency: (default: 256) — A maximum allowed number of endpoint moves per second. If the move frequency is exceeded, the hold interval is triggered, and new endpoint learn events will not be honored until after the hold interval expires. Allowed value range is 0-65535.
    * remote_endpoint_aging_interval: (default: 300) — The aging interval for all remote endpoints learned in this bridge domain.Allowed value range is "120" - "0xffff". Default is "900". "0" is treated as special value here. Providing interval as "0" is treated as infinite interval.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation                     = optional(string)
      bounce_entry_aging_interval    = optional(number)
      bounce_trigger                 = optional(string)
      description                    = optional(string)
      hold_interval                  = optional(number)
      local_endpoint_aging_interval  = optional(number)
      move_frequency                 = optional(number)
      remote_endpoint_aging_interval = optional(number)
      tenant                         = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvEpRetPol"
 - Distinguised Name: "uni/tn-{name}/epRPol-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > End Point Retention > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_end_point_retention_policy" "policies_endpoint_retention" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each            = local.policies_endpoint_retention
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  bounce_age_intvl    = each.value.bounce_entry_aging_interval
  bounce_trig         = each.value.bounce_trigger
  description         = each.value.description
  hold_intvl          = each.value.hold_interval
  local_ep_age_intvl  = each.value.local_endpoint_aging_interval
  move_freq           = each.value.move_frequency
  name                = each.key
  remote_ep_age_intvl = each.value.remote_endpoint_aging_interval == 0 ? "infinite" : each.value.remote_endpoint_aging_interval
  tenant_dn           = aci_tenant.tenants[each.value.tenant].id
}
output "policies_endpoint_retention" {
  value = var.policies_endpoint_retention != {} ? { for v in sort(
    keys(aci_end_point_retention_policy.policies_endpoint_retention)
  ) : v => aci_end_point_retention_policy.policies_endpoint_retention[v].id } : {}
}
