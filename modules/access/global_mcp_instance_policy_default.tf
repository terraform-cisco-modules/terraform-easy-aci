/*_____________________________________________________________________________________________________________________

Fabric > Access Policies > Policies > Global > MCP Instance Policy default
_______________________________________________________________________________________________________________________
*/
variable "global_mcp_instance_policy" {
  default = {
    "default" = {
      admin_state                       = "enabled"
      annotation                        = ""
      description                       = ""
      enable_mcp_pdu_per_vlan           = true
      initial_delay                     = 180
      loop_detect_multiplication_factor = 3
      loop_protect_action               = true
      transmission_frequency = [
        {
          seconds = 2
          msec    = 0
        }
      ]
    }
  }
  description = <<-EOT
    Key — This should always be default
    * admin_state: (default: enabled) — The administrative state of the MCP instance policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * enable_mcp_pdu_per_vlan: (default: true) — When set to true it enables Enable MCP PDU per VLAN.  When set to false it disables Enable MCP PDU per VLAN.
    * initial_delay: (default: 180) — The delay time before the MCP starts taking action based on the value of the Loop Protection Action, which is a value configured by the user. From the system bootup until the Initial Delay Timer timeout, MCP will only create a syslog entry if a loop is detected. The range is from 0 to 1800 seconds.
    * loop_detect_multiplication_factor: (default: 3) — he multiplication factor that MCP uses to determine when a loop is formed. It denotes the number of continuous packets a port has to receive before claiming a loop is formed. The range is from 1 to 255. For strict mode MCP, during the grace timer period, the default value of 3 is overruled. Even if 1 packet is received, the port is disabled.
    * loop_protect_action: (default: true) — Determines how MCP acts when a loop is detected. MCP error-disables the port or syslog only based on this value. For strict mode MCP, even if you uncheck the Port Disable check box, the port is disabled if a loop is detected.
    * transmission_frequency — Sets the transmission frequency of the instance advertisements. The range is from 100 milliseconds to 300 seconds.
      - seconds: (default: 2)
      - msec: (default: 0)
  EOT
  type = map(object(
    {
      description                       = optional(string)
      admin_state                       = optional(string)
      annotation                        = optional(string)
      enable_mcp_pdu_per_vlan           = optional(bool)
      initial_delay                     = optional(number)
      loop_detect_multiplication_factor = optional(number)
      loop_protection_disable_port      = optional(bool)
      transmission_frequency = optional(list(object(
        {
          seconds = optional(number)
          msec    = optional(number)
        }
      )))
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
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy default
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
  tx_freq          = each.value.transmission_frequency[0].seconds
  tx_freq_msec     = each.value.transmission_frequency[0].msec
}
