#------------------------------------------
# Create Interface Policies
#------------------------------------------

variable "interface_policies" {
  default = {
    "default" = {
      cdp_interface_policies = {
        "default" = {
          admin_state = "disabled"
          alias       = ""
          description = ""
        }
      }
      fc_interface_policies = {
        "default" = {
          alias                 = ""
          auto_max_speed        = "32G"
          description           = ""
          fill_pattern          = "ARBFF"
          port_mode             = "f"
          receive_buffer_credit = "64"
          speed                 = "auto"
          trunk_mode            = "trunk-off"
        }
      }
      l2_interface_policies = {
        "default" = {
          alias            = ""
          description      = ""
          qinq             = optional(string)
          reflective_relay = optional(string)
          vlan_scope       = optional(string)
        }
      }
      lacp_interface_policies = {
        "default" = {
          alias                     = ""
          description               = ""
          fast_select_standby_ports = optional(bool)
          graceful_convergence      = optional(bool)
          load_defer_member_ports   = optional(bool)
          maximum_number_of_links   = optional(string)
          minimum_number_of_links   = optional(string)
          mode                      = optional(string)
          suspend_individual_port   = optional(bool)
          symmetric_hashing         = optional(bool)
        }
      }
      link_level_policies = {
        "default" = {
          alias                       = ""
          auto_negotiation            = optional(string)
          description                 = ""
          forwarding_error_correction = optional(string)
          link_debounce_interval      = optional(string)
          speed                       = optional(string)
        }
      }
      lldp_interface_policies = {
        "default" = {
          alias          = ""
          description    = ""
          receive_state  = optional(string)
          tags           = ""
          transmit_state = optional(string)
        }
      }
      mcp_interface_policies = {
        "default" = {
          admin_state = optional(string)
          alias       = ""
          description = ""
          tags        = ""
        }
      }
      port_security_policies = {
        "default" = {
          alias                 = ""
          description           = ""
          maximum_endpoints     = optional(string)
          port_security_timeout = optional(string)
          tags                  = ""
        }
      }
      spanning_tree_interface_policies = {
        "default" = {
          alias               = ""
          bpdu_filter_enabled = optional(string)
          bpdu_guard_enabled  = optional(string)
          description         = ""
          tags                = ""
        }
      }
    }
  }
  description = <<-EOT
  key - Unused - Just a filler
  * cdp_interface_policies:
    - admin_state: (Default value is "enabled").  The State of the CDP Protocol on the Interface.
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * fc_interface_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - auto_max_speed: (Default value is "32G").  Auto-max-speed for object interface FC policy. Allowed values are:
      * 4G
      * 8G
      * 16G
      * 32G
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - fill_pattern: (Default value is "ARBFF").  Fill Pattern for native FC ports. Allowed values are:
      * ARBFF
      * IDLE
    - port_mode: (Default value is "f").  In which mode Ports should be used. Allowed values are "f" and "np".
    - receive_buffer_credit: (Default value is "64").  Receive buffer credits for native FC ports Range:(16 - 64).
    - speed: (Default value is "auto").  CPU or port speed. All the supported values are:
      * unknown
      * auto
      * 4G
      * 8G
      * 16G
      * 32G
    - trunk_mode: (Default value is "trunk-off").  Trunking on/off for native FC ports. Allowed values are:
      * un-init
      * trunk-off
      * trunk-on
      * auto
  * l2_interface_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - qinq: (Default value is "disabled").  To enable or disable an interface for Dot1q Tunnel or Q-in-Q encapsulation modes, select one of the following:
      * corePort: Configure this core-switch interface to be included in a Dot1q Tunnel.  You can configure multiple corePorts, for multiple customers, to be used in a Dot1q Tunnel.
      * disabled: Disable this interface to be used in a Dot1q Tunnel.
      * doubleQtagPort: Configure this interface to be used for Q-in-Q encapsulated traffic.
      * edgePort: Configure this edge-switch interface (for a single customer) to be included in a Dot1q Tunnel.
    - reflective_relay: (Default value is "disabled").  Enable or disable reflective relay for ports that consume the policy.
    - vlan_scope: (Default value is "global").  The layer 2 interface VLAN scope. The scope can be:
      * global: Sets the VLAN encapsulation value to map only to a single EPG per leaf.
      * portlocal: Allows allocation of separate (Port, Vlan) translation entries in both ingress and egress directions. This configuration is not valid when the EPGs belong to a single bridge domain.
      VLAN Scope is not supported if edgePort is selected in the QinQ field.
      Note:  Changing the VLAN scope from Global to Port Local or Port Local to Global will cause the ports where this policy is applied to flap and traffic will be disrupted.
  * lacp_interface_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - fast_select_standby_ports: (Default value is true).  Configures fast select for hot standby ports. Enabling this feature will allow fast selection of a hot standby port when last active port in the port-channel is going down.
    - graceful_convergence: (Default value is true).  Configures port-channel LACP graceful convergence. Disable this only with LACP ports connected to a Non-Nexus peer. Disabling this with Nexus peer can lead to port suspension.
    - load_defer_member_ports: (Default value is false).  Configures the load-balancing algorithm for port channels that applies to the entire device or to only one module.
    - maximum_number_of_links: (Default value is "16").  Maximum number of links. Allowed value range is "1" - "16".
    - minimum_number_of_links: (Default value is "1").  Minimum number of links in port channel. Allowed value range is "1" - "16". 
    - mode: (Default value is "off").  policy mode. Allowed values are "off", "active", "passive", "mac-pin" and "mac-pin-nicload".
      * active: LACP mode that places a port into an active negotiating state in which the port initiates negotiations with other ports by sending LACP packets.
      * mac-pin: Used for pinning VM traffic in a round-robin fashion to each uplink based on the MAC address of the VM. MAC Pinning is the recommended option for channeling when connecting to upstream switches that do not support multichassis EtherChannel (MEC).
      * mac-pin-nicload: Pins VM traffic in a round-robin fashion to each uplink based on the MAC address of the physical NIC.
      * off: All static port channels (that are not running LACP) remain in this mode. If you attempt to change the channel mode to active or passive before enabling LACP, the device displays an error message.
      * passive: LACP mode that places a port into a passive negotiating state in which the port responds to LACP packets that it receives but does not initiate LACP negotiation. Passive mode is useful when you do not know whether the remote system, or partner, supports LACP.
    - suspend_individual_port: (Default value is true).  LACP sets a port to the suspended state if it does not receive an LACP bridge protocol data unit (BPDU) from the peer ports in a port channel. This can cause some servers to fail to boot up as they require LACP to logically bring up the port.
    - symmetric_hashing: (Default value is false).  Bidirectional traffic is forced to use the same physical interface and each physical interface in the port channel is effectively mapped to a set of flows.
  * link_level_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - auto_negotiation: (Default value is "on").  Policy auto negotiation for object fabric if pol. Allowed values:
      * on
      * off
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - forwarding_error_correction: (Default value is "inherit").  Forwarding error correction for object fabric if pol. Allowed values: 
      * inherit
      * cl91-rs-fec
      * cl74-fc-fec
      * ieee-rs-fec
      * cons16-rs-fec
      * kp-fec
      * disable-fec
    - link_debounce_interval: (Default value is "100").  Link debounce interval for object fabric if pol. Range of allowed values: "0" to "5000".
    - speed: (Default value is "inherit").  Port speed for object fabric if pol. Allowed values: 
      * unknown
      * 100M
      * 1G
      * 10G
      * 25G
      * 40G
      * 50G
      * 100G
      * 200G
      * 400G
      * inherit
  * lldp_interface_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - receive_state: (Default value is "enabled").  The reception of LLDP packets on an interface. 
    - tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
    - transmit_state: (Default value is "enabled").  The transmission of LLDP packets on an interface. 
  * mcp_interface_policies:
    - admin_state: (Default value is "enabled").  The administrative state of the MCP interface policy. The state can be:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * port_security_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - maximum_endpoints: (Default value is "0").  The maximum number of endpoints that can be learned on the interface. The current supported range for the maximum endpoints configured value is from 0 to 12000. If the maximum endpoints value is 0, the port security policy is disabled on that port.
    - port_security_timeout: (Default value is "60").  The delay time before MAC learning is re-enabled. The current supported range for the timeout value is from 60 to 3600.
    - tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * spanning_tree_interface_policies:
    - alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
    - bpdu_filter_enabled: (Default value is false).  The interface level control that enables the BPDU filter for extended chassis ports.
    - bpdu_guard_enabled: (Default value is false).  The interface level control that enables the BPDU guard for extended chassis ports.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - tags: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  EOT
  type = map(object(
    {
      cdp_interface_policies = map(object(
        {
          admin_state = optional(string)
          alias       = optional(string)
          description = optional(string)
        }
      ))
      fc_interface_policies = map(object(
        {
          alias                 = optional(string)
          auto_max_speed        = optional(string)
          description           = optional(string)
          fill_pattern          = optional(string)
          port_mode             = optional(string)
          receive_buffer_credit = optional(string)
          speed                 = optional(string)
          trunk_mode            = optional(string)
        }
      ))
      l2_interface_policies = map(object(
        {
          alias            = optional(string)
          description      = optional(string)
          qinq             = optional(string)
          reflective_relay = optional(string)
          vlan_scope       = optional(string)
        }
      ))
      lacp_interface_policies = map(object(
        {
          alias                     = optional(string)
          fast_select_standby_ports = optional(bool)
          graceful_convergence      = optional(bool)
          load_defer_member_ports   = optional(bool)
          suspend_individual_port   = optional(bool)
          symmetric_hashing         = optional(bool)
          description               = optional(string)
          maximum_number_of_links   = optional(string)
          minimum_number_of_links   = optional(string)
          mode                      = optional(string)
        }
      ))
      link_level_policies = map(object(
        {
          alias                       = optional(string)
          auto_negotiation            = optional(string)
          description                 = optional(string)
          forwarding_error_correction = optional(string)
          link_debounce_interval      = optional(string)
          speed                       = optional(string)
        }
      ))
      lldp_interface_policies = map(object(
        {
          alias          = optional(string)
          description    = optional(string)
          receive_state  = optional(string)
          tags           = optional(string)
          transmit_state = optional(string)
        }
      ))
      mcp_interface_policies = map(object(
        {
          admin_state = optional(string)
          alias       = optional(string)
          description = optional(string)
          tags        = optional(string)
        }
      ))
      port_security_policies = map(object(
        {
          alias                 = optional(string)
          description           = optional(string)
          maximum_endpoints     = optional(string)
          port_security_timeout = optional(string)
          tags                  = optional(string)
        }
      ))
      spanning_tree_interface_policies = map(object(
        {
          alias               = optional(string)
          bpdu_filter_enabled = optional(string)
          bpdu_guard_enabled  = optional(string)
          description         = optional(string)
          tags                = optional(string)
        }
      ))
    }
  ))
}
#------------------------------------------
# Create CDP Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "cdpIfPol"
 - Distinguished Name: "uni/infra/cdpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > CDP Interface : {name}
*/
resource "aci_cdp_interface_policy" "cdp_interface_policies" {
  for_each    = local.cdp_interface_policies
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
}


#------------------------------------------
# Create Fibre-Channel Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "fcIfPol"
 - Distinguished Name: "uni/infra/fcIfPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Fibre Channel Interface : {name}
*/
resource "aci_interface_fc_policy" "fc_interface_policies" {
  for_each     = local.fc_interface_policies
  automaxspeed = each.value.auto_max_speed
  description  = each.value.description
  fill_pattern = each.value.fill_pattern
  name         = each.key
  name_alias   = each.value.alias
  port_mode    = each.value.port_mode
  rx_bb_credit = each.value.receive_buffer_credit
  speed        = each.value.speed
  trunk_mode   = each.value.trunk_mode
}


#------------------------------------------
# Create an L2 Interface Policy
#------------------------------------------

/*
API Information:
 - Class: "l2IfPol"
 - Distinguished Name: "uni/infra/l2IfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > L2 Interface : {name}
*/
resource "aci_l2_interface_policy" "l2_interface_policies" {
  for_each    = local.l2_interface_policies
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  qinq        = each.value.qinq
  vepa        = each.value.reflective_relay
  vlan_scope  = each.value.vlan_scope
}


#------------------------------------------
# Create Port-Channel Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "lacpLagPol"
 - Distinguished Name: "uni/infra/lacplagp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Channel : {name}
*/
resource "aci_lacp_policy" "lacp_interface_policies" {
  for_each    = local.lacp_interface_policies
  ctrl        = [each.value.control]
  description = each.value.description
  max_links   = each.value.maximum_number_of_links
  min_links   = each.value.minimum_number_of_links
  name        = each.key
  name_alias  = each.value.alias
  mode        = each.value.mode
}


#------------------------------------------
# Create Interface Link Level Policies
#------------------------------------------

/*
API Information:
 - Class: "fabricHIfPol"
 - Distinguished Name: "uni/infra/hintfpol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}
*/
resource "aci_fabric_if_pol" "link_level_policies" {
  for_each      = local.link_level_policies
  auto_neg      = each.value.auto_negotiation
  description   = each.value.description
  fec_mode      = each.value.forwarding_error_correction
  link_debounce = each.value.link_debounce_interval
  name          = each.key
  name_alias    = each.value.alias
  speed         = each.value.speed
}


#------------------------------------------
# Create LLDP Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "lldpIfPol"
 - Distinguished Name: "uni/infra/lldpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > LLDP Interface : {name}
*/
resource "aci_lldp_interface_policy" "lldp_interface_policies" {
  for_each    = local.lldp_interface_policies
  admin_rx_st = each.value.receive_state
  admin_tx_st = each.value.transmit_state
  annotation  = each.value.tags
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
}

#------------------------------------------
# Create Mis-Cabling Protocol Policies
#------------------------------------------

/*
API Information:
 - Class: "mcpIfPol"
 - Distinguished Name: "uni/infra/mcpIfP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > MCP Interface : {name}
*/
resource "aci_miscabling_protocol_interface_policy" "mcp_interface_policies" {
  for_each    = local.mcp_interface_policies
  annotation  = each.value.tags
  admin_st    = each.value.admin_state
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
}


#------------------------------------------
# Create Port Security Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "l2PortSecurityPol"
 - Distinguished Name: "uni/infra/portsecurityP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Security : {name}
*/
resource "aci_port_security_policy" "port_security_policies" {
  for_each    = local.port_security_policies
  annotation  = each.value.tags
  description = each.value.description
  maximum     = each.value.maximum_endpoints
  name        = each.key
  name_alias  = each.value.alias
  timeout     = each.value.port_security_timeout
  violation   = "protect"
}


#------------------------------------------
# Create Spanning-Tree Interface Policies
#------------------------------------------

/*
API Information:
 - Class: "stpIfPol"
 - Distinguished Name: "uni/infra/ifPol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Spanning Tree Interface : {name}
*/
resource "aci_spanning_tree_interface_policy" "spanning_tree_interface_policies" {
  for_each    = local.spanning_tree_interface_policies
  ctrl        = [each.value.interface_controls]
  annotation  = each.value.tags
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
}
