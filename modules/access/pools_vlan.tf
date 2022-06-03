/*_____________________________________________________________________________________________________________________

Pools — VLAN — Variables
_______________________________________________________________________________________________________________________
*/
variable "pools_vlan" {
  default = {
    "default" = {
      allocation_mode = "dynamic"
      annotation      = ""
      description     = ""
      encap_blocks = {
        "default" = {
          allocation_mode = "inherit"
          description     = ""
          role            = "external"
          vlan_range      = "**REQUIRED**"
        }
      }
    }
  }
  description = <<-EOT
  key - name of the VLAN Pool
  * allocation_mode — The allocation mode. The values can be:
    - dynamic (default) — Managed internally by the APIC to allocate VLANs for endpoint groups (EPGs). A vCenter Domain can associate only to a dynamic pool.
    - static — One or more EPGs are associated with a domain, and that domain is associated with a static range of VLANs. You must configure statically deployed EPGs within that range of VLANs.
    When you create VLAN ranges, you can also assign the allocation mode to be inherited from the parent.
  * annotation — A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object. 
    * description — Description to add to the Object.  The description can be up to 128 characters.
  * encap_blocks:
    - allocation_mode — The allocation mode. The values can be:
      * dynamic — Managed internally by the APIC to allocate VLANs for endpoint groups (EPGs). A vCenter Domain can associate only to a dynamic pool.
      * inherit (default) — The inherited mode from the parent device.
      * static — One or more EPGs are associated with a domain, and that domain is associated with a static range of VLANs. You must configure statically deployed EPGs within that range of VLANs.
    - description — Description to add to the Object.    The description can be up to 128 alphanumeric characters.
    - role — Role of the VLAN range. The options are:
      * external (Default) — Used for allocating VLANs for each EPG assigned to the domain. The VLANs are used when packets are sent to or from leafs.
      * Internal — Used for private VLAN allocations in the internal vSwitch by the Cisco ACI Virtual Edge (AVE). The VLANs are not seen outside the ESX host or on the wire.
    - vlan_range — single vlan; i.e. 1.  range of vlans; i.e. 1-5. Or List of Vlans; i.e. 1-5,10-15
  EOT
  type = map(object(
    {
      allocation_mode = optional(string)
      annotation      = optional(string)
      description     = optional(string)
      encap_blocks = map(object(
        {
          allocation_mode = optional(string)
          description     = optional(string)
          role            = optional(string)
          vlan_range      = string
        }
      ))
    }
  ))
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvnsVlanInstP"
 - Distinguished name: "uni/infra/vlanns-[{name}]-{allocation_mode}"
GUI Location:
 - Fabric > Access Policies > Pools > VLAN:[{name}]
_______________________________________________________________________________________________________________________
*/
resource "aci_vlan_pool" "pools_vlan" {
  for_each    = local.pools_vlan
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  alloc_mode  = each.value.allocation_mode
  description = each.value.description
  name        = each.key
}

resource "aci_ranges" "vlans" {
  depends_on = [
    aci_vlan_pool.pools_vlan
  ]
  for_each     = local.vlan_ranges
  annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
  description  = each.value.description
  alloc_mode   = each.value.allocation_mode
  from         = "vlan-${each.value.vlan}"
  to           = "vlan-${each.value.vlan}"
  role         = each.value.role
  vlan_pool_dn = aci_vlan_pool.pools_vlan[each.value.key1].id
}
