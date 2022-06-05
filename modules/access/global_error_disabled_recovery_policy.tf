/*_____________________________________________________________________________________________________________________

Global — Error Disabled Recovery Policy — Variables
_______________________________________________________________________________________________________________________
*/
variable "global_error_disabled_recovery_policy" {
  default = {
    "default" = {
      annotation                      = ""
      error_disable_recovery_interval = 300
      events = [
        {
          bpdu_guard             = true
          frequent_endpoint_move = true
          loop_indication_by_mcp = true
        }
      ]
    }
  }
  description = <<-EOT
    Key — This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * error_disable_recovery_interval: (default: 300) — Sets the error disable recovery interval, which specifies the time to recover from an error-disabled state. The interval range is from 30 seconds to 65535 seconds.
    * events: (optional) — Indicates whether an Error Disable Recovery type is enabled (true or false).
      - bpdu_guard: (default: true) — Flag to enable or disable recovery for a BPDU Guard event.
      - frequent_endpoint_move: (default: true) — Flag to enable or disable recovery for a Frequent Endpoint Move event.
      - loop_indication_by_mcp: (default: true) — Flag to enable or disable recovery for a Loop Indication by MCP event.
  EOT
  type = map(object(
    {
      annotation                      = optional(string)
      description                     = optional(string)
      error_disable_recovery_interval = optional(number)
      events = optional(list(object(
        {
          bpdu_guard             = optional(bool)
          frequent_endpoint_move = optional(bool)
          loop_indication_by_mcp = optional(bool)
        }
      )))
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "edrErrDisRecoverPol"
 - Distinguished Named "uni/infra/edrErrDisRecoverPol-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Error Disabled Recovery Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_error_disable_recovery" "global_error_disabled_recovery_policy" {
  for_each            = local.global_error_disabled_recovery_policy
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
  err_dis_recov_intvl = each.value.error_disable_recovery_interval
  edr_event {
    event   = "event-bpduguard"
    recover = each.value.events[0].bpdu_guard == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-ep-move"
    recover = each.value.events[0].frequent_endpoint_move == true ? "yes" : "no"
  }
  edr_event {
    event   = "event-mcp-loop"
    recover = each.value.events[0].loop_indication_by_mcp == true ? "yes" : "no"
  }
}
