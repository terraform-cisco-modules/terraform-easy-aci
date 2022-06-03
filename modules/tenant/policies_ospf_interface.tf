/*_____________________________________________________________________________________________________________________

Tenant — Policies — OSPF Interface — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_ospf_interface" {
  default = {
    "default" = {
      alias             = ""
      annotation        = ""
      cost_of_interface = 0
      dead_interval     = 40
      description       = ""
      hello_interval    = 10
      interface_controls = [
        {
          advertise_subnet      = true
          bfd                   = true
          mtu_ignore            = false
          passive_participation = false
        }
      ]
      network_type        = "bcast"
      priority            = 1
      retransmit_interval = 5
      transmit_delay      = 1
      tenant              = "common"
    }
  }
  description = <<-EOT
  Key - Name of the OSPF Interface Policy
  * alias:  Name alias for object OSPF interface policy.
  * annotation:  Annotation for object OSPF interface policy.
  * cost_of_interface:  The OSPF cost for the interface. The cost (also called metric) of an interface in OSPF is an indication of the overhead required to send packets across a certain interface. The cost of an interface is inversely proportional to the bandwidth of that interface. A higher bandwidth indicates a lower cost. There is more overhead (higher cost) and time delays involved in crossing a 56k serial line than crossing a 10M ethernet line. The formula used to calculate the cost is: cost= 10000 0000/bandwidth in bps For example, it will cost 10 EXP8/10 EXP7 = 10 to cross a 10M Ethernet line and will cost 10 EXP8/1544000 = 64 to cross a T1 line. By default, the cost of an interface is calculated based on the bandwidth; you can force the cost of an interface with the ip OSPF cost value interface sub-configuration mode command. Allowed value range is 0-65535. Default is 0.
  * dead_interval:  The interval between hello packets from a neighbor before the router declares the neighbor as down. This value must be the same for all networking devices on a specific network. Specifying a smaller dead interval (seconds) will give faster detection of a neighbor being down and improve convergence, but might cause more routing instability. Allowed value range is 1-65535. Default value is 40.
  * description:  Description for object OSPF interface policy.
  * hello_interval:  The interval between hello packets that OSPF sends on the interface. Note that the smaller the hello interval, the faster topological changes will be detected, but more routing traffic will ensue. This value must be the same for all routers and access servers on a specific network. Allowed value range is 1-65535. Default value is 10.
  * interface_controls:  List of Interface Control Attributes.
    - advertise_subnet: Flag to Enable the connected interface subnet to be advertised.
    - bfd: Flag to Enable Bidirectional Forward Detection on the interface.
    - mtu_ignore: Flag to ignore the MTU when establishing neighbor relationships
    - passive: Flag to passively add the interface to the OSPF process.
  * network_type:  The OSPF interface policy network type. OSPF supports point-to-point and broadcast. Allowed values are "unspecified", "p2p" and "bcast". Default value is "unspecified".
  * priority:  The OSPF interface priority used to determine the designated router (DR) on a specific network. The router with the highest OSPF priority on a segment will become the DR for that segment. The same process is repeated for the backup designated router (BDR). In the case of a tie, the router with the highest RID will win. The default for the interface OSPF priority is one. Remember that the DR and BDR concepts are per multiaccess segment. Allowed range is 0-255. Default value is 1.
  * retransmit_interval:  The interval between LSA retransmissions. The retransmit interval occurs while the router is waiting for an acknowledgement from the neighbor router that it received the LSA. If no acknowlegment is received at the end of the interval, then the LSA is resent. Allowed value range is 1-65535. Default value is 5.
  * tenant: Name of parent Tenant object.
  * transmit_delay:  The delay time needed to send an LSA update packet. OSPF increments the LSA age time by the transmit delay amount before transmitting the LSA update. You should take into account the transmission and propagation delays for the interface when you set this value. Allowed value range is 1-450. Default is 1.  
  EOT
  type = map(object(
    {
      alias             = optional(string)
      annotation        = optional(string)
      cost_of_interface = optional(number)
      dead_interval     = optional(number)
      description       = optional(string)
      hello_interval    = optional(number)
      interface_controls = optional(list(object(
        {
          advertise_subnet      = optional(bool)
          bfd                   = optional(bool)
          mtu_ignore            = optional(bool)
          passive_participation = optional(bool)
        }
      )))
      network_type        = optional(string)
      priority            = optional(number)
      retransmit_interval = optional(number)
      transmit_delay      = optional(number)
      tenant              = optional(string)
    }
  ))
}

#------------------------------------------------
# Create a OSPF Interface Policy
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfIfPol"
 - Distinguished Name: "/uni/tn-{tenant}/ospfIfPol-{policy_name}"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > OSPF >  OSPF Interface > {policy_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_ospf_interface_policy" "policies_ospf_interface" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each  = local.policies_ospf_interface
  tenant_dn = aci_tenant.tenants[each.value.tenant].id
  # annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.alias
  cost        = each.value.cost_of_interface == 0 ? "unspecified" : each.value.cost_of_interface
  # Bug 805 Submitted
  ctrl = anytrue(
    [
      each.value.interface_controls[0].advertise_subnet,
      each.value.interface_controls[0].bfd,
      each.value.interface_controls[0].mtu_ignore,
      each.value.interface_controls[0].passive_participation
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.interface_controls[0].advertise_subnet)) > 0 ? "advert-subnet" : ""], [
      length(regexall(true, each.value.interface_controls[0].bfd)) > 0 ? "bfd" : ""], [
      length(regexall(true, each.value.interface_controls[0].mtu_ignore)) > 0 ? "mtu-ignore" : ""], [
      length(regexall(true, each.value.interface_controls[0].passive_participation)) > 0 ? "passive" : ""]
  )) : ["unspecified"]
  dead_intvl  = each.value.dead_interval
  hello_intvl = each.value.hello_interval
  nw_t        = each.value.network_type
  # pfx_suppress  = each.value.pfx_suppress
  prio         = each.value.priority
  rexmit_intvl = each.value.retransmit_interval
  xmit_delay   = each.value.transmit_delay
}

