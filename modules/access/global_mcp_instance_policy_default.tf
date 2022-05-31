/*_____________________________________________________________________________________________________________________

MCP Instance Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "global_mcp_instance_policy" {
  default = {
    "default" = {
      admin_state                       = "enabled"
      description                       = ""
      annotation                        = ""
      enable_mcp_pdu_per_vlan           = true
      initial_delay                     = 180
      loop_detect_multiplication_factor = 3
      loop_protect_action               = true
      transmission_frequency_seconds    = 2
      transmission_frequency_msec       = 0
    }
  }
  description = <<-EOT
  Key: Name of the Layer2 Interface Policy.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * admin_state                       = "enabled"
  * annotation                              = ""
  * enable_mcp_pdu_per_vlan           = true
  * initial_delay                     = 180
  * loop_detect_multiplication_factor = 3
  * loop_protection_disable_port               = true
  * transmission_frequency_seconds    = 2
  * transmission_frequency_msec       = 0
  EOT
  type = map(object(
    {
      description                       = optional(string)
      admin_state                       = optional(string)
      annotation                        = optional(string)
      enable_mcp_pdu_per_vlan           = bool
      initial_delay                     = optional(number)
      loop_detect_multiplication_factor = optional(number)
      loop_protection_disable_port      = optional(bool)
      transmission_frequency_seconds    = optional(number)
      transmission_frequency_msec       = optional(number)
    }
  ))
}

variable "mcp_instance_key" {
  description = "The key or password to uniquely identify the MCP packets within this fabric."
  sensitive   = true
  type        = string
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mcpInstPol"
 - Distinguished Named "uni/infra/mcpInstP-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy Default
_______________________________________________________________________________________________________________________
*/
resource "aci_mcp_instance_policy" "global_mcp_instance_policy" {
  for_each         = local.global_mcp_instance_policy
  admin_st         = each.value.admin_state
  annotation       = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl             = each.value.enable_mcp_pdu_per_vlan == true ? ["pdu-per-vlan", "stateful-ha"] : ["stateful-ha"]
  description      = each.value.description
  init_delay_time  = each.value.initial_delay
  key              = var.mcp_instance_key
  loop_detect_mult = each.value.loop_detect_multiplication_factor
  loop_protect_act = each.value.loop_protection_disable_port == true ? "port-disable" : "none"
  tx_freq          = each.value.transmission_frequency_seconds
  tx_freq_msec     = each.value.transmission_frequency_msec
}
