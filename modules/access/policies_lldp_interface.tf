/*_____________________________________________________________________________________________________________________

LLDP Interface Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_lldp_interface" {
  default = {
    "default" = {
      annotation     = ""
      description    = ""
      global_alias   = ""
      receive_state  = "enabled"
      transmit_state = "enabled"
    }
  }
  description = <<-EOT
  Key: Name of the LLDP Interface Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  * receive_state: (Default value is "enabled").  The reception of LLDP packets on an interface. 
  * transmit_state: (Default value is "enabled").  The transmission of LLDP packets on an interface. 
  EOT
  type = map(object(
    {
      annotation     = optional(string)
      description    = optional(string)
      global_alias   = optional(string)
      receive_state  = optional(string)
      transmit_state = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > LLDP Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_lldp_interface_policy" "policies_lldp_interface" {
  for_each    = local.policies_lldp_interface
  admin_rx_st = each.value.receive_state
  admin_tx_st = each.value.transmit_state
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
}
