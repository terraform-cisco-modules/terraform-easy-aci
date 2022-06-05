/*_____________________________________________________________________________________________________________________

Tenant — Policies — DHCP Option — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_dhcp_option" {
  default = {
    "default" = {
      annotation  = ""
      description = ""
      options     = []
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant      = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Argument Reference
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * dhcp_option: (optional) — To manage DHCP Option from the DHCP Option Policy resource. It has the attributes like name, annotation,data,dhcp_option_id.
          annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
          data: (required) — The DHCP option data. Refer to RFC 2132 for more information.
          dhcp_option_id: (required) — The DHCP option ID.
          name: (required) — Name of Object DHCP Option.
    * tenant: (default: local.first_tenant) — Name of parent Tenant object.
  EOT
  type = map(object(
    {
      annotation  = optional(string)
      description = optional(string)
      options = optional(list(object(
        {
          annotation     = optional(string)
          data           = string
          dhcp_option_id = string
          name           = string
        }
      )))
      tenant = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "dhcpOptionPol"
 - Distinguised Name: "uni/tn-{name}/dhcpoptpol-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > DHCP > Options Policies > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_dhcp_option_policy" "policies_dhcp_option" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.policies_dhcp_option
  annotation  = each.value.annotation
  description = each.value.description
  name        = each.key
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
  dynamic "dhcp_option" {
    for_each = each.value.options
    content {
      annotation     = dhcp_option.value.annotation
      data           = dhcp_option.value.data
      dhcp_option_id = dhcp_option.value.dhcp_option_id
      name           = dhcp_option.value.name
    }
  }
}
