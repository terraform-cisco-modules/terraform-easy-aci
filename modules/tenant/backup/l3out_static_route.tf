resource "aci_l3out_static_route" "example" {
  fabric_node_dn = aci_logical_node_to_fabric_node.example.id
  ip             = "10.0.0.1"
  aggregate      = "no"
  annotation     = "example"
  name_alias     = "example"
  pref           = "1"
  rt_ctrl        = "bfd"
  description    = "from terraform"
}
# Argument Reference
# fabric_node_dn - (Required) Distinguished name of parent fabric node object.
# ip - (Required) The static route IP address assigned to the outside network.
# aggregate - (Optional) Aggregated Route for object l3out static route. Allowed values: "no", "yes". Default value is "no".
# annotation - (Optional) Annotation for object l3out static route.
# description - (Optional) Description for object l3out static route.
# name_alias - (Optional) Name alias for object l3out static route.
# pref - (Optional) The administrative preference value for this route. This value is useful for resolving routes advertised from different protocols. Range of allowed values is "1" to "255". Default value is "1".
# rt_ctrl - (Optional) Route control for object l3out static route. Allowed values: "bfd", "unspecified". Default value is "unspecified".
# relation_ip_rs_route_track - (Optional) Relation to class fvTrackList. Cardinality - N_TO_ONE. Type - String.

resource "aci_l3out_static_route_next_hop" "example" {

  static_route_dn      = aci_l3out_static_route.example.id
  nh_addr              = "10.0.0.1"
  annotation           = "example"
  name_alias           = "example"
  pref                 = "1"
  nexthop_profile_type = "prefix"
  description          = "from terraform"

}
# Argument Reference
# static_route_dn - (Required) Distinguished name of parent static route object.
# nh_addr - (Required) The nexthop IP address for the static route to the outside network.
# annotation - (Optional) Annotation for object l3out static route next hop.
# description - (Optional) Description for object l3out static route next hop.
# name_alias - (Optional) Name alias for object l3out static route next hop.
# pref - (Optional) Administrative preference value for this route. Range: "1" to "255" Allowed values: "unspecified". Default value: "unspecified".
# nexthop_profile_type - (Optional) Component type.
# Allowed values: "none", "prefix". Default value: "prefix".
# relation_ip_rs_nexthop_route_track - (Optional) Relation to class fvTrackList. Cardinality - N_TO_ONE. Type - String.
# relation_ip_rs_nh_track_member - (Optional) Relation to class fvTrackMember. Cardinality - N_TO_ONE. Type - String.