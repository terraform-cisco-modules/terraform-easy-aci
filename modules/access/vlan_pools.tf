#------------------------------------------
# Create VLAN Pools
#------------------------------------------

/*
API Information:
 - Class: "fvnsVlanInstP"
 - Distinguished name: "uni/infra/vlanns-[{name}]-{allocation_mode}"
GUI Location:
 - Fabric > Access Policies > Pools > VLAN:[{name}]
*/

variable "vlan_pools" {
  default = {
    "default" = {
      alias           = ""
      allocation_mode = "dynamic"
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
    * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    * allocation_mode: The allocation mode. The values can be:
      - dynamic (default): Managed internally by the APIC to allocate VLANs for endpoint groups (EPGs). A vCenter Domain can associate only to a dynamic pool.
      - static: One or more EPGs are associated with a domain, and that domain is associated with a static range of VLANs. You must configure statically deployed EPGs within that range of VLANs.
      When you create VLAN ranges, you can also assign the allocation mode to be inherited from the parent.
    * description: Description to add to the Object.    The description can be up to 128 alphanumeric characters.
    * encap_blocks:
      - allocation_mode: The allocation mode. The values can be:
        * dynamic: Managed internally by the APIC to allocate VLANs for endpoint groups (EPGs). A vCenter Domain can associate only to a dynamic pool.
        * inherit (default): The inherited mode from the parent device.
        * static: One or more EPGs are associated with a domain, and that domain is associated with a static range of VLANs. You must configure statically deployed EPGs within that range of VLANs.
      - description: Description to add to the Object.    The description can be up to 128 alphanumeric characters.
      - role: Role of the VLAN range. The options are:
        * external (Default): Used for allocating VLANs for each EPG assigned to the domain. The VLANs are used when packets are sent to or from leafs.
        * Internal: Used for private VLAN allocations in the internal vSwitch by the Cisco ACI Virtual Edge (AVE). The VLANs are not seen outside the ESX host or on the wire.
      - vlan_range: single vlan; i.e. 1.  range of vlans; i.e. 1-5. Or List of Vlans; i.e. 1-5,10-15
  EOT
  type = map(object(
    {
      alias           = optional(string)
      allocation_mode = optional(string)
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

resource "aci_vlan_pool" "vlan_pools" {
  for_each    = local.vlan_pools
  alloc_mode  = each.value.allocation_mode
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
}

resource "aci_ranges" "vlans" {
  depends_on = [
    aci_vlan_pool.vlan_pools
  ]
  for_each     = local.vlan_ranges
  description  = each.value.description
  alloc_mode   = each.value.allocation_mode
  from         = "vlan-${each.value.vlan}"
  to           = "vlan-${each.value.vlan}"
  role         = each.value.role
  vlan_pool_dn = aci_vlan_pool.vlan_pools[each.value.name].id
}
