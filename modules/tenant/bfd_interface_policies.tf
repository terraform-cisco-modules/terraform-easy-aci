# Manages ACI BFD Interface Policy
#
variable "bfd_interface_policies" {
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
      name_alias                        = ""
      tenant                            = "common"
    }
  }
  description = <<-EOT
  * Argument Reference
  * admin_state - (Optional) Administrative state of the object BFD Interface Policy. Allowed values are "disabled" and "enabled". Default is "enabled".
  * annotation - (Optional) Annotation for object BFD Interface Policy.
  * description - (Optional) Description for object BFD Interface Policy.
  * detect_mult - (Optional) Detection multiplier for object BFD Interface Policy. Range: "1" - "50". Default value is "3".
  * echo_admin_state - (Optional) Echo mode indicator for object BFD Interface Policy. Allowed values are "disabled" and "enabled". Default is "enabled".
  * echo_recieve_interval - (Optional) Echo rx interval for object BFD Interface Policy. Range: "50" - "999". Default value is "50".
  * enable_sub_interface_optimization - (Boolean) Control state for object BFD Interface Policy.  Default is false.
  * minimum_recieve_interval - (Optional) Required minimum rx interval for boject BFD Interface Policy. Range: "50" - "999". Default value is "50".
  * minimum_transmit_interval - (Optional) Desired minimum tx interval for object BFD Interface Policy. Range: "50" - "999". Default value is "50".
  * name - (Required) Name of object BFD Interface Policy.
  * name_alias - (Optional) Name name_alias for object BFD Interface Policy.
  * tenant - (Required) Name of parent tenant object.
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
      name_alias                        = optional(string)
      tenant                            = optional(string)
    }
  ))
}
# API Information
# Class - bfdIfPol
# Distinguished Named - uni/tn-{name}/bfdIfPol-{name}
# GUI Information
# Location - Tenant -> Policies -> Protocol -> BFD
# Example Usage
resource "aci_bfd_interface_policy" "bfd_interface_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each   = local.bfd_interface_policies
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
  name_alias    = each.value.name_alias
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
