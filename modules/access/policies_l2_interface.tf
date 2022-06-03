/*_____________________________________________________________________________________________________________________

Policies — L2 Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_l2_interface" {
  default = {
    "default" = {
      annotation       = ""
      description      = ""
      qinq             = "disabled"
      reflective_relay = "disabled"
      vlan_scope       = "global"
    }
  }
  description = <<-EOT
    Key — Name of the Layer2 Interface Policy.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description — Description to add to the Object.  The description can be up to 128 characters.
    * qinq — (Default value is "disabled").  To enable or disable an interface for Dot1q Tunnel or Q-in-Q encapsulation modes, select one of the following:
      - corePort — Configure this core-switch interface to be included in a Dot1q Tunnel.  You can configure multiple corePorts, for multiple customers, to be used in a Dot1q Tunnel.
      - disabled — Disable this interface to be used in a Dot1q Tunnel.
      - doubleQtagPort — Configure this interface to be used for Q-in-Q encapsulated traffic.
      - edgePort — Configure this edge-switch interface (for a single customer) to be included in a Dot1q Tunnel.
    * reflective_relay — (Default value is "disabled").  Enable or disable reflective relay for ports that consume the policy.
    * vlan_scope — (Default value is "global").  The layer 2 interface VLAN scope. The scope can be:
      - global — Sets the VLAN encapsulation value to map only to a single EPG per leaf.
      - portlocal — Allows allocation of separate (Port, Vlan) translation entries in both ingress and egress directions. This configuration is not valid when the EPGs belong to a single bridge domain.
      VLAN Scope is not supported if edgePort is selected in the QinQ field.
      Note:  Changing the VLAN scope from Global to Port Local or Port Local to Global will cause the ports where this policy is applied to flap and traffic will be disrupted.
  EOT
  type = map(object(
    {
      annotation       = optional(string)
      description      = optional(string)
      qinq             = optional(string)
      reflective_relay = optional(string)
      vlan_scope       = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l2IfPol"
 - Distinguished Name: "uni/infra/l2IfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > L2 Interface : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_l2_interface_policy" "policies_l2_interface" {
  for_each    = local.policies_l2_interface
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  qinq        = each.value.qinq
  vepa        = each.value.reflective_relay
  vlan_scope  = each.value.vlan_scope
}
