/*_____________________________________________________________________________________________________________________

Fabric > Access Policies > Policies > Global > QoS Class
_______________________________________________________________________________________________________________________
*/
variable "global_qos_class" {
  default = {
    "default" = {
      annotation                        = ""
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
    }
  }
  description = <<-EOT
    Key — This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * elephant_trap_age_period: (default: 0) — Elephant Trap Age Timer.  Minimum allowed value is 0.
    * elephant_trap_bandwidth_threshold: (default: 0) — Elephant flow track activeness.  Minimum allowed value is 0.
    * elephant_trap_byte_coun: (default: 0) — Elephant Trap flow identifier.  Minimum allowed value is 0.
    * elephant_trap_state: (default: false) — Elephant Trap state.  Set to true to enable
    * fabric_flush_interval: (default: 500) — Fabric Flush Interval in milliseconds.  Range is 100-1000.
    * fabric_flush_state: (default: false) — Fabric Priority Flow Control flush State.
    * micro_burst_spine_queues: (default: 0) —  Micro Burst Spine Queues percent.  Range is 0-100.  **Note: Requires version 5.X of the APIC.
    * micro_burst_leaf_queues: (default: 0) — Micro Burst Leaf Queues percent.  Range is 0-100.  **Note: Requires version 5.X of the APIC.
    * preserve_cos: (default: true) — CoS Preservation, to guarantee the QoS priority settings of the various traffic streams, in a single-pod topology. In multipod topologies, use a DSCP policy to enable preserving QoS priority mapping for the traffic streams as they transit the inter-pod network.  QoS Class—Priority flow control requires that CoS levels be globally enabled for the fabric and assigned to the profiles of applications that generate FCoE traffic.
  EOT
  type = map(object(
    {
      annotation                        = optional(string)
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
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

_______________________________________________________________________________________________________________________
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
