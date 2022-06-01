/*_____________________________________________________________________________________________________________________

Tenant - HSRP Interface Policy - Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_hsrp_interface" {
  default = {
    "default" = {
      alias       = ""
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
      tenant       = "common"
    }
  }
  description = <<-EOT
    Key - Name of the HSRP Interface Policy
    * alias - (Optional) Name name_alias for HSRP interface policy object.
    * annotation - (Optional) Annotation for HSRP interface policy object.
    * description - (Optional) Description for HSRP interface policy object.
    * control - (Optional) Control state for HSRP interface policy object. 
      - enable_bidirectional_forwarding_detection
      - use_burnt_in_mac_address_of_the_interface
    * delay - (Optional) Administrative port delay for HSRP interface policy object.Range: "0" to "10000". Default value is "0".
    * reload_delay - (Optional) Reload delay for HSRP interface policy object.Range: "0" to "10000". Default value is "0".
    * tenant - (Required) Name of the Tenant.
  EOT
  type = map(object(
    {
      alias       = optional(string)
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
 - Distinguished Name: "/uni/tn-{tenant}/hsrpIfPol-{hsrp_policy}"
GUI Location:
tenants > {tenant} > Policies > Protocol > HSRP > Interface Policies > {hsrp_policy}
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
  name_alias   = each.value.alias
  reload_delay = each.value.reload_delay
  tenant_dn    = aci_tenant.tenants[each.value.tenant].id
}
