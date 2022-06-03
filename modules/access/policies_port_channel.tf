/*_____________________________________________________________________________________________________________________

Policies — Port-Channel — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_port_channel" {
  default = {
    "default" = {
      annotation = ""
      control = [
        {
          fast_select_hot_standby_ports = true
          graceful_convergence          = true
          load_defer_member_ports       = false
          suspend_individual_port       = true
          symmetric_hashing             = false
        }
      ]
      description             = ""
      global_alias            = ""
      maximum_number_of_links = 16
      minimum_number_of_links = 1
      mode                    = "off"
    }
  }
  description = <<-EOT
    Key — Name of the LACP Interface Policy.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * control — LACP Control Parameters:
      - fast_select_hot_standby_ports — (Default value is true).  Configures fast select for hot standby ports. Enabling this feature will allow fast selection of a hot standby port when last active port in the port-channel is going down.
      - graceful_convergence — (Default value is true).  Configures port-channel LACP graceful convergence. Disable this only with LACP ports connected to a Non-Nexus peer. Disabling this with Nexus peer can lead to port suspension.
      - load_defer_member_ports — (Default value is false).  Configures the load-balancing algorithm for port channels that applies to the entire device or to only one module.
      - suspend_individual_port — (Default value is true).  LACP sets a port to the suspended state if it does not receive an LACP bridge protocol data unit (BPDU) from the peer ports in a port channel. This can cause some servers to fail to boot up as they require LACP to logically bring up the port.
      - symmetric_hashing — (Default value is false).  Bidirectional traffic is forced to use the same physical interface and each physical interface in the port channel is effectively mapped to a set of flows.
    * description — Description to add to the Object.  The description can be up to 128 characters.
    * global_alias — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
    * maximum_number_of_links — (Default value is 16).  Maximum number of links. Allowed value range is 1-16.
    * minimum_number_of_links — (Default value is 1).  Minimum number of links in port channel. Allowed value range is 1-16. 
    * mode — (Default value is "off").  port-channel policy mode. 
      - active — LACP mode that places a port into an active negotiating state in which the port initiates negotiations with other ports by sending LACP packets.
      - mac-pin — Used for pinning VM traffic in a round-robin fashion to each uplink based on the MAC address of the VM. MAC Pinning is the recommended option for channeling when connecting to upstream switches that do not support multichassis EtherChannel (MEC).
      - mac-pin-nicload — Pins VM traffic in a round-robin fashion to each uplink based on the MAC address of the physical NIC.
      - off — All static port channels (that are not running LACP) remain in this mode. If you attempt to change the channel mode to active or passive before enabling LACP, the device displays an error message.
      - passive — LACP mode that places a port into a passive negotiating state in which the port responds to LACP packets that it receives but does not initiate LACP negotiation. Passive mode is useful when you do not know whether the remote system, or partner, supports LACP.
  EOT
  type = map(object(
    {
      annotation = optional(string)
      control = optional(list(object(
        {
          fast_select_hot_standby_ports = optional(bool)
          graceful_convergence          = optional(bool)
          load_defer_member_ports       = optional(bool)
          suspend_individual_port       = optional(bool)
          symmetric_hashing             = optional(bool)
        }
      )))
      description             = optional(string)
      global_alias            = optional(string)
      maximum_number_of_links = optional(number)
      minimum_number_of_links = optional(number)
      mode                    = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "lacpLagPol"
 - Distinguished Name: "uni/infra/lacplagp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Channel : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_lacp_policy" "policies_port_channel" {
  for_each   = local.policies_port_channel
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  ctrl = anytrue(
    [each.value.control[0]["fast_select_hot_standby_ports"
      ], each.value.control[0]["graceful_convergence"
      ], each.value.control[0]["load_defer_member_ports"
      ], each.value.control[0]["suspend_individual_port"
      ], each.value.control[0]["symmetric_hashing"]]) ? compact(concat(
      [length(regexall(true, each.value.control[0].fast_select_hot_standby_ports)
        ) > 0 ? "fast-sel-hot-stdby" : ""
        ], [length(regexall(true, each.value.control[0].graceful_convergence)
        ) > 0 ? "graceful-conv" : ""
        ], [length(regexall(true, each.value.control[0].load_defer_member_ports)
        ) > 0 ? "load-defer" : ""
        ], [length(regexall(true, each.value.control[0].suspend_individual_port)
        ) > 0 ? "susp-individual" : ""
        ], [length(regexall(true, each.value.control[0].symmetric_hashing)
    ) > 0 ? "symmetric-hash" : ""])) : [
  "fast-sel-hot-stdby", "graceful-conv", "susp-individual"]
  description = each.value.description
  max_links   = each.value.maximum_number_of_links
  min_links   = each.value.minimum_number_of_links
  name        = each.key
  mode        = each.value.mode
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/lacplagp-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Channel : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "policies_port_channel_global_alias" {
  depends_on = [
    aci_lacp_policy.policies_port_channel,
  ]
  for_each   = local.policies_port_channel_global_alias
  dn         = "uni/infra/lacplagp-${each.key}"
  class_name = "tagAliasInst"
  content = {
    name = each.value.global_alias
  }
}
