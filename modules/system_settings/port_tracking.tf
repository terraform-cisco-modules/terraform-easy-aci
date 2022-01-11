variable "port_tracking" {
  default = {
    "default" = {
      delay_restore_timer    = 120
      include_apic_ports     = "no"
      number_of_active_ports = 0
      port_tracking_state    = "on"
      tags                   = ""
    }
  }
  type = map(object(
    {
      delay_restore_timer    = optional(number)
      include_apic_ports     = optional(string)
      number_of_active_ports = optional(number)
      port_tracking_state    = optional(string)
      tags                   = optional(string)
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
  annotation         = each.value.tags != "" ? each.value.tags : var.tags
  admin_st           = each.value.port_tracking_state
  delay              = each.value.delay_restore_timer
  include_apic_ports = each.value.include_apic_ports
  minlinks           = each.value.number_of_active_ports
}