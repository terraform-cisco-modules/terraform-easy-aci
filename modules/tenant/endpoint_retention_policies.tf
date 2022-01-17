variable "endpoint_retention_policies" {
  default = {
    "default" = {
      annotation                     = ""
      bounce_entry_aging_interval    = 630
      bounce_trigger                 = "protocol"
      description                    = ""
      hold_interval                  = 300
      local_endpoint_aging_interval  = 900
      move_frequency                 = 256
      remote_endpoint_aging_interval = 900
      tenant                         = "common"
    }
  }
  description = <<-EOT
    annotation - (Optional) annotation for object end_point_retention_policy.
    bounce_entry_aging_interval - (Optional) The aging interval for a bounce entry. When an endpoint (VM) migrates to another switch, the endpoint is marked as bouncing for the specified aging interval and is deleted afterwards. Allowed value range is "0" - "0xffff". Default is "630".
    bounce_trigger - (Optional) Specifies whether to install the bounce entry by RARP flood or by COOP protocol. Allowed values are "rarp-flood" and "protocol". Default is "protocol".
    hold_interval - (Optional) A time period during which new endpoint learn events will not be honored. This interval is triggered when the maximum endpoint move frequency is exceeded. Allowed value range is "5" - "0xffff". Default is "300".
    name - (Required) name of Object end_point_retention_policy.
    local_endpoint_aging_interval - (Optional) The aging interval for all local endpoints learned in this bridge domain. When 75% of the interval is reached, 3 ARP requests are sent to verify the existence of the endpoint. If no response is received, the endpoint is deleted. Allowed value range is "120" - "0xffff". Default is "900". "0" is treated as special value here. Providing interval as "0" is treated as infinite interval.
    move_frequency - (Optional) A maximum allowed number of endpoint moves per second. If the move frequency is exceeded, the hold interval is triggered, and new endpoint learn events will not be honored until after the hold interval expires. Allowed value range is "0" - "0xffff". Default is "256".
    alias - (Optional) name_alias for object end_point_retention_policy.
    remote_endpoint_aging_interval - (Optional) The aging interval for all remote endpoints learned in this bridge domain.Allowed value range is "120" - "0xffff". Default is "900". "0" is treated as special value here. Providing interval as "0" is treated as infinite interval.
    tenant_dn - (Required) Distinguished name of parent Tenant object.
    EOT
}
resource "aci_end_point_retention_policy" "endpoint_retention_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each            = local.endpoint_retention_policies
  annotation          = each.value.annotation
  bounce_age_intvl    = each.value.bounce_entry_aging_interval
  bounce_trig         = each.value.bounce_trigger
  description         = each.value.description
  hold_intvl          = each.value.hold_interval
  local_ep_age_intvl  = each.value.local_endpoint_aging_interval
  move_freq           = each.value.move_frequency
  name                = each.key
  name_alias          = ""
  remote_ep_age_intvl = each.value.remote_endpoint_aging_interval
  tenant_dn           = aci_tenant.tenants[each.value.tenant].id
}

output "endpoint_retention_policies" {
  value = var.endpoint_retention_policies != {} ? { for v in sort(
    keys(aci_end_point_retention_policy.endpoint_retention_policies)
  ) : v => aci_end_point_retention_policy.endpoint_retention_policies[v].id } : {}
}
