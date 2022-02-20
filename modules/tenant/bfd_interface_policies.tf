# Manages ACI BFD Interface Policy
# 
# API Information
# Class - bfdIfPol
# Distinguished Named - uni/tn-{name}/bfdIfPol-{name}
# GUI Information
# Location - Tenant -> Policies -> Protocol -> BFD
# Example Usage
resource "aci_bfd_interface_policy" "example" {
  depends_on = [
    aci_tenant.tenants
  ]
  admin_st      = each.value.admin_st
  annotation    = each.value.annotation
  ctrl          = each.value.ctrl
  description   = each.value.description
  detect_mult   = each.value.detect_mult
  echo_admin_st = each.value.echo_admin_st
  echo_rx_intvl = each.value.echo_rx_intvl
  min_rx_intvl  = each.value.min_rx_intvl
  min_tx_intvl  = each.value.min_tx_intvl
  name          = each.value.name
  name_alias    = each.value.name_alias
  tenant_dn     = aci_tenant.tenants[each.value.tenant].id
}
# Argument Reference
# tenant_dn - (Required) Distinguished name of parent tenant object.
# name - (Required) Name of object BFD Interface Policy.
# admin_st - (Optional) Administrative state of the object BFD Interface Policy. Allowed values are "disabled" and "enabled". Default is "enabled".
# annotation - (Optional) Annotation for object BFD Interface Policy.
# ctrl - (Optional) Control state for object BFD Interface Policy. Allowed value is "opt-subif".
# detect_mult - (Optional) Detection multiplier for object BFD Interface Policy. Range: "1" - "50". Default value is "3".
# echo_admin_st - (Optional) Echo mode indicator for object BFD Interface Policy. Allowed values are "disabled" and "enabled". Default is "enabled".
# echo_rx_intvl - (Optional) Echo rx interval for object BFD Interface Policy. Range: "50" - "999". Default value is "50".
# min_rx_intvl - (Optional) Required minimum rx interval for boject BFD Interface Policy. Range: "50" - "999". Default value is "50".
# min_tx_intvl - (Optional) Desired minimum tx interval for object BFD Interface Policy. Range: "50" - "999". Default value is "50".
# name_alias - (Optional) Name name_alias for object BFD Interface Policy.
# description - (Optional) Description for object BFD Interface Policy.