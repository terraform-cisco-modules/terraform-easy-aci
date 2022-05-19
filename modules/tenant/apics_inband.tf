/*_____________________________________________________________________________________________________________________

Switch Profile Variables
_______________________________________________________________________________________________________________________
*/
variable "apics_inband" {
  default     = {}
  description = <<-EOT
  key - Node ID of the APIC
  * pod_id: Identifier of the pod where the node is located.  Unless you are configuring Multi-Pod, this should always be 1.
  EOT
  type = map(object(
    {
      ipv4_address   = string
      ipv4_gateway   = string
      ipv6_address   = string
      ipv6_gateway   = string
      management_epg = string
      pod_id         = number
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtRsInBStNode" or "mgmtRsOoBStNode"
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/inb-{management_epg}/rsinBStNode-[topology/pod-{pod_id}/node-{node_id}]"
 or
 - Distinguished Name: "uni/tn-mgmt/mgmtp-default/oob-{management_epg}/rsooBStNode-[topology/pod-{pod_id}/node-{node_id}]"
GUI Location:
 - Tenants > mgmt > Node Management Addresses > Static Node Management Addresses
_______________________________________________________________________________________________________________________
*/
resource "aci_static_node_mgmt_address" "apic_static_node_mgmt_addresses" {
  depends_on = [
    aci_rest_managed.fabric_membership
  ]
  for_each          = local.apic_static_node_mgmt_addresses
  management_epg_dn = "uni/tn-mgmt/mgmtp-default/inb-${management_epg}"
  t_dn              = "topology/pod-${each.value.pod_id}/node-${each.value.node_id}"
  type              = "in_band"
  addr              = each.value.ipv4_address
  annotation        = var.annotation
  gw                = each.value.ipv4_gateway
  v6_addr           = each.value.ipv6_address
  v6_gw             = each.value.ipv6_gateway
}