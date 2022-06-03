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
    Key - Name for the DNS Profile
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
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