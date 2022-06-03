/*_____________________________________________________________________________________________________________________

Policies — LLDP Interface — Variables
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
    Key — Name of the LLDP Interface Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * global_alias: (optional) — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
    * receive_state: (default: enabled) — The reception of LLDP packets on an interface. 
    * transmit_state: (default: enabled) — The transmission of LLDP packets on an interface. 
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

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/lldpIfP-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "policies_lldp_interface_global_alias" {
  depends_on = [
    aci_lldp_interface_policy.policies_lldp_interface,
  ]
  for_each   = local.policies_link_level_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/infra/lldpIfP-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
