/*_____________________________________________________________________________________________________________________

Tenant — Policies — HSRP Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_hsrp_interface" {
  default = {
    "default" = {
      annotation  = ""
      description = ""
      control = [
        {
          enable_bidirectional_forwarding_detection = false
          use_burnt_in_mac_address_of_the_interface = false
        }
      ]
      delay        = 0
      reload_delay = 0
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant            = local.folder_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the HSRP Interface Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * control: (optional) — Control state for HSRP interface policy object. 
      - enable_bidirectional_forwarding_detection: (default: false)
      - use_burnt_in_mac_address_of_the_interface: (default: false)
    * delay: (default: 0) — Administrative port delay for HSRP interface policy object.Range: "0-10000".
    * reload_delay: (default: 0) — Reload delay for HSRP interface policy object.Range: "0-10000".
    * tenant: (default: local.folder_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation  = optional(string)
      description = optional(string)
      control = optional(list(object(
        {
          enable_bidirectional_forwarding_detection = optional(bool)
          use_burnt_in_mac_address_of_the_interface = optional(bool)
        }
      )))
      delay        = optional(number)
      reload_delay = optional(number)
      tenant       = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "hsrpIfPol"
 - Distinguished Name: "/uni/tn-{tenant}/hsrpIfPol-{name}"
GUI Location:
tenants > {tenant} > Policies > Protocol > HSRP > Interface Policies > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_hsrp_interface_policy" "policies_hsrp_interface" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.policies_hsrp_interface
  annotation = each.value.annotation
  ctrl = anytrue(
    [each.value.enable_bidirectional_forwarding_detection, each.value.use_burnt_in_mac_address_of_the_interface]
    ) ? compact(concat([
      length(regexall(true, each.value.enable_bidirectional_forwarding_detection)) > 0 ? "bfd" : ""], [
      length(regexall(true, each.value.use_burnt_in_mac_address_of_the_interface)) > 0 ? "bia" : ""]
  )) : []
  delay        = each.value.delay
  description  = each.value.description
  name         = each.key
  reload_delay = each.value.reload_delay
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
