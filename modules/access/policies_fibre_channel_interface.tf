/*_____________________________________________________________________________________________________________________

Fibre-Channel Interface Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_fibre_channel_interface" {
  default = {
    "default" = {
      annotation            = ""
      auto_max_speed        = "32G"
      description           = ""
      fill_pattern          = "ARBFF"
      port_mode             = "f"
      receive_buffer_credit = 64
      speed                 = "auto"
      trunk_mode            = "trunk-off"
    }
  }
  description = <<-EOT
  Key: Name of the Fibre-Channel Interface Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * auto_max_speed: (Default value is "32G").  Auto-max-speed for object interface FC policy. Allowed values are:
    - 4G
    - 8G
    - 16G
    - 32G
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * fill_pattern: (Default value is "ARBFF").  Fill Pattern for native FC ports. Allowed values are:
    - ARBFF
    - IDLE
  * port_mode: (Default value is "f").  In which mode Ports should be used. Allowed values are "f" and "np".
  * receive_buffer_credit: (Default value is 64).  Receive buffer credits for native FC ports Range:(16 - 64).
  * speed: (Default value is "auto").  CPU or port speed. All the supported values are:
    - unknown
    - auto
    - 4G
    - 8G
    - 16G
    - 32G
  * trunk_mode: (Default value is "trunk-off").  Trunking on/off for native FC ports. Allowed values are:
    - un-init
    - trunk-off
    - trunk-on
    - auto
  EOT
  type = map(object(
    {
      auto_max_speed        = optional(string)
      description           = optional(string)
      fill_pattern          = optional(string)
      port_mode             = optional(string)
      receive_buffer_credit = optional(number)
      speed                 = optional(string)
      annotation            = optional(string)
      trunk_mode            = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fcIfPol"
 - Distinguished Name: "uni/infra/fcIfPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Fibre Channel Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_interface_fc_policy" "policies_fibre_channel_interface" {
  for_each     = local.policies_fibre_channel_interface
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  automaxspeed = each.value.auto_max_speed
  description  = each.value.description
  fill_pattern = each.value.fill_pattern
  name         = each.key
  port_mode    = each.value.port_mode
  rx_bb_credit = each.value.receive_buffer_credit
  speed        = each.value.speed
  trunk_mode   = each.value.trunk_mode
}
