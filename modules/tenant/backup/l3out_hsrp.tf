resource "aci_l3out_hsrp_interface_group" "example" {
  l3out_hsrp_interface_profile_dn = aci_l3out_hsrp_interface_profile.example.id
  name                            = "one"
  annotation                      = "example"
  config_issues                   = "GroupMac-Conflicts-Other-Group"
  group_af                        = "ipv4"
  group_id                        = "20"
  group_name                      = "test"
  ip                              = "10.22.30.40"
  ip_obtain_mode                  = "admin"
  mac                             = "02:10:45:00:00:56"
  name_alias                      = "example"
}
# Argument Reference
# logical_interface_profile_dn - (Required) Distinguished name of parent logical interface profile object.
# name - (Required) Name of L3out HSRP interface group object.
# annotation - (Optional) Annotation for L3out HSRP interface group object.
# description - (Optional) Description for L3out HSRP interface group object.
# config_issues - (Optional) Configuration issues for L3out HSRP interface group object. Allowed values are "GroupMac-Conflicts-Other-Group", "GroupName-Conflicts-Other-Group", "GroupVIP-Conflicts-Other-Group", "Multiple-Version-On-Interface", "Secondary-vip-conflicts-if-ip", "Secondary-vip-subnet-mismatch", "group-vip-conflicts-if-ip", "group-vip-subnet-mismatch" and "none". Default value is "none".
# group_af - (Optional) Group type for L3out HSRP interface group object. Allowed values are "ipv4" and "ipv6". Default value is "ipv4".
# group_id - (Optional) Group id for L3out HSRP interface group object.
# group_name - (Optional) Group name for L3out HSRP interface group object.
# ip - (Optional) IP address for L3out HSRP interface group object.
# ip_obtain_mode - (Optional) IP obtain mode for L3out HSRP interface group object. Allowed values are "admin", "auto" and "learn". Default value is "admin".
# mac - (Optional) MAC address for L3out HSRP interface group object.
# name_alias - (Optional) Name alias for L3out HSRP interface group object.
# relation_hsrp_rs_group_pol - (Optional) Relation to class hsrpGroupPol. Cardinality - N_TO_ONE. Type - String.

resource "aci_l3out_hsrp_interface_profile" "example" {

  logical_interface_profile_dn = aci_logical_interface_profile.example.id
  annotation                   = "example"
  name_alias                   = "example"
  description                  = "from terraform"
  version                      = "v1"

}
# Argument Reference
# logical_interface_profile_dn - (Required) Distinguished name of parent logical interface profile object.
# annotation - (Optional) Annotation for object L3-out HSRP interface profile.
# description - (Optional) Description for object L3-out HSRP interface profile.
# name_alias - (Optional) Name alias for object L3-out HSRP interface profile.
# version - (Optional) Compatibility catalog version.
# Allowed values: "v1", "v2". Default value: "v1".
# relation_hsrp_rs_if_pol - (Optional) Relation to class hsrpIfPol. Cardinality - N_TO_ONE. Type - String.

resource "aci_l3out_hsrp_secondary_vip" "example" {

  l3out_hsrp_interface_group_dn = aci_l3out_hsrp_interface_group.example.id
  ip                            = "10.0.0.1"
  annotation                    = "example"
  config_issues                 = "GroupMac-Conflicts-Other-Group"
  name_alias                    = "example"
  description                   = "from terraform"

}
# Argument Reference
# l3out_hsrp_interface_group_dn - (Required) Distinguished name of parent hsrp group profile object.
# ip - (Required) IP of Object L3out HSRP Secondary VIP.
# annotation - (Optional) Annotation for object L3out HSRP Secondary VIP.
# description - (Optional) Description for object L3out HSRP Secondary VIP.
# config_issues - (Optional) Configuration Issues.
# Allowed values: "GroupMac-Conflicts-Other-Group", "GroupName-Conflicts-Other-Group", "GroupVIP-Conflicts-Other-Group", "Multiple-Version-On-Interface", "Secondary-vip-conflicts-if-ip", "Secondary-vip-subnet-mismatch", "group-vip-conflicts-if-ip", "group-vip-subnet-mismatch", "none". Default value: "none".
# ip - (Optional) IP address.
# name_alias - (Optional) Name alias for object L3out HSRP Secondary VIP.