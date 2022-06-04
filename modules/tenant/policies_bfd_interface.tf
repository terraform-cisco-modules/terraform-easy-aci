/*_____________________________________________________________________________________________________________________

Tenant — Policies — BFD Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_bfd_interface" {
  default = {
    "default" = {
      admin_state                       = "enabled"
      annotation                        = ""
      description                       = ""
      detection_multiplier              = 3
      echo_admin_state                  = "enabled"
      echo_recieve_interval             = 50
      enable_sub_interface_optimization = false
      minimum_recieve_interval          = 50
      minimum_transmit_interval         = 50
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant                            = local.folder_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the BFD Interface Policy.
    * admin_state: (optional) — Administrative state of the object BFD Interface Policy. Allowed values are:
      - disabled
      - enabled: (default)
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * detect_mult: (default: 3) — Detection multiplier for object BFD Interface Policy. Range: 1-50.
    * echo_admin_state: (optional) — Echo mode indicator for object BFD Interface Policy. Allowed values are:
      - disabled
      - enabled: (default)
    * echo_recieve_interval: (default: 50) — Echo rx interval for object BFD Interface Policy. Range: 50-999.
    * enable_sub_interface_optimization: (optional) — Control state for object BFD Interface Policy.
      - false: (default)
      - true
    * minimum_recieve_interval: (default: 50) — Required minimum rx interval for boject BFD Interface Policy. Range: 50-999.
    * minimum_transmit_interval: (default: 50) — Desired minimum tx interval for object BFD Interface Policy. Range: 50-999.
    * tenant: (default: local.folder_tenant) — Name of parent tenant object.
  EOT
  type = map(object(
    {
      admin_state                       = optional(string)
      annotation                        = optional(string)
      description                       = optional(string)
      detection_multiplier              = optional(number)
      echo_admin_state                  = optional(string)
      echo_recieve_interval             = optional(number)
      enable_sub_interface_optimization = optional(bool)
      minimum_recieve_interval          = optional(number)
      minimum_transmit_interval         = optional(number)
      tenant                            = optional(string)
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bfdIfPol"
 - Distinguised Name: "uni/tn-{name}/bfdIfPol-{name}"
GUI Location:
 - Tenants > {tenant} > Policies > Protocol > BFD > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_bfd_interface_policy" "policies_bfd_interface" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.policies_bfd_interface
  admin_st   = each.value.admin_state
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  # Bug 803 Submitted
  # ctrl          = each.value.enable_sub_interface_optimization == true ? "opt-subif" : "none"
  description   = each.value.description
  detect_mult   = each.value.detection_multiplier
  echo_admin_st = each.value.echo_admin_state
  echo_rx_intvl = each.value.echo_recieve_interval
  min_rx_intvl  = each.value.minimum_recieve_interval
  min_tx_intvl  = each.value.minimum_transmit_interval
  name          = each.key
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
