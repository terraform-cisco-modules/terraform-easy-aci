/*_____________________________________________________________________________________________________________________

Global QoS Class Variables
_______________________________________________________________________________________________________________________
*/
variable "global_qos_class" {
  default = {
    "default" = {
      description                       = ""
      elephant_trap_age_period          = 0
      elephant_trap_bandwidth_threshold = 0
      elephant_trap_byte_count          = 0
      elephant_trap_state               = false
      fabric_flush_interval             = 500
      fabric_flush_state                = false
      micro_burst_spine_queues          = 0
      micro_burst_leaf_queues           = 0
      preserve_cos                      = true
      annotation                        = ""
    }
  }
  description = <<-EOT
  Key: Name of the Layer2 Interface Policy.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * qinq: (Default value is "disabled").  To enable or disable an interface for Dot1q Tunnel or Q-in-Q encapsulation modes, select one of the following:
    - corePort: Configure this core-switch interface to be included in a Dot1q Tunnel.  You can configure multiple corePorts, for multiple customers, to be used in a Dot1q Tunnel.
    - disabled: Disable this interface to be used in a Dot1q Tunnel.
    - doubleQtagPort: Configure this interface to be used for Q-in-Q encapsulated traffic.
    - edgePort: Configure this edge-switch interface (for a single customer) to be included in a Dot1q Tunnel.
  * reflective_relay: (Default value is "disabled").  Enable or disable reflective relay for ports that consume the policy.
  * vlan_scope: (Default value is "global").  The layer 2 interface VLAN scope. The scope can be:
    - global: Sets the VLAN encapsulation value to map only to a single EPG per leaf.
    - portlocal: Allows allocation of separate (Port, Vlan) translation entries in both ingress and egress directions. This configuration is not valid when the EPGs belong to a single bridge domain.
    VLAN Scope is not supported if edgePort is selected in the QinQ field.
    Note:  Changing the VLAN scope from Global to Port Local or Port Local to Global will cause the ports where this policy is applied to flap and traffic will be disrupted.
  EOT
  type = map(object(
    {
      description                       = optional(string)
      elephant_trap_age_period          = optional(number)
      elephant_trap_bandwidth_threshold = optional(number)
      elephant_trap_byte_count          = optional(number)
      elephant_trap_state               = optional(bool)
      fabric_flush_interval             = optional(number)
      fabric_flush_state                = optional(bool)
      micro_burst_spine_queues          = optional(string)
      micro_burst_leaf_queues           = optional(string)
      preserve_cos                      = optional(bool)
      annotation                        = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

*/
resource "aci_qos_instance_policy" "global_qos_class" {
  for_each              = local.global_qos_class
  annotation            = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl                  = each.value.preserve_cos == true ? "dot1p-preserve" : "none"
  description           = each.value.description
  etrap_age_timer       = each.value.elephant_trap_age_period
  etrap_bw_thresh       = each.value.elephant_trap_bandwidth_threshold
  etrap_byte_ct         = each.value.elephant_trap_byte_count
  etrap_st              = each.value.elephant_trap_state == true ? "yes" : "no"
  fabric_flush_interval = each.value.fabric_flush_interval
  fabric_flush_st       = each.value.fabric_flush_state == true ? "yes" : "no"
  uburst_spine_queues   = each.value.micro_burst_spine_queues
  uburst_tor_queues     = each.value.micro_burst_leaf_queues
}
