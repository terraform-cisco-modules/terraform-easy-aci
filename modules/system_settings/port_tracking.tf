/*_____________________________________________________________________________________________________________________

Port Tracking — Variables
_______________________________________________________________________________________________________________________
*/
variable "port_tracking" {
  default = {
    "default" = {
      annotation             = ""
      delay_restore_timer    = 120
      include_apic_ports     = false
      number_of_active_ports = 0
      port_tracking_state    = "on"
    }
  }
  description = <<-EOT
    Key - This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * delay_restore_timer: (default: 120) — The timer that controls the delay restore interval time in seconds. The range is from 1 second to 300 seconds.
    * include_apic_ports: (optional) — If you put a check in the box, port tracking brings down the Cisco Application Policy Infrastructure Controller (APIC) ports when the leaf switch loses connectivity to all fabric ports (that is, there are 0 fabric links). Enable this feature only if the Cisco APICs are dual- or multi-homed to the fabric. Bringing down the Cisco APIC ports helps in switching over to the secondary link in the case of a dual-homed Cisco APIC.
      - false: (default)
      - true
    * number_of_active_ports: (default: 0) — Number of active spine links that triggers port tracking. The range is from 0 to 12. 
    * port_tracking_state: (optional) — The administrative port tracking state. The state can be:
      - off
      - on: (default)
  EOT
  type = map(object(
    {
      annotation             = optional(string)
      delay_restore_timer    = optional(number)
      include_apic_ports     = optional(bool)
      number_of_active_ports = optional(number)
      port_tracking_state    = optional(string)
    }
  ))
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "infraPortTrackPol"
 - Distinguished Name: "uni/infra/trackEqptFabP-default"
GUI Location:
 - System > System Settings > Port Tracking
_______________________________________________________________________________________________________________________
*/
resource "aci_port_tracking" "port_tracking" {
  for_each           = local.port_tracking
  annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
  admin_st           = each.value.port_tracking_state
  delay              = each.value.delay_restore_timer
  include_apic_ports = each.value.include_apic_ports == true ? "yes" : "no"
  minlinks           = each.value.number_of_active_ports
}