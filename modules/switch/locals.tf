locals {
  #__________________________________________________________
  #
  # Leaf Profiles Variables
  #__________________________________________________________

  switch_profiles = {
    for k, v in var.switch_profiles : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      description       = v.description != null ? v.description : ""
      external_pool_id  = length(compact([v.external_pool_id])) > 0 ? v.external_pool_id : 0
      inband_addressing = v.inband_addressing != null ? v.inband_addressing : []
      interfaces        = v.interfaces != null ? v.interfaces : []
      policy_group      = v.policy_group != null ? v.policy_group : "default"
      monitoring_policy = v.monitoring_policy != null ? v.monitoring_policy : "default"
      name              = v.name
      node_type         = v.node_type != null ? v.node_type : "leaf"
      ooband_addressing = v.ooband_addressing != null ? v.ooband_addressing : []
      pod_id            = v.pod_id != null ? v.pod_id : 1
      serial_number     = v.serial_number
      two_slot_leaf     = v.two_slot_leaf != null ? v.two_slot_leaf : false
    }
  }

  interface_selectors_loop = flatten([
    for k, v in local.switch_profiles : [
      for s in v.interfaces : {
        annotation            = v.annotation != null ? v.annotation : ""
        description           = s.description != null ? s.description : ""
        interface_description = s.interface_description != null ? s.interface_description : ""
        interface_name = coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
          regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-00${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
          )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
          regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-0${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
          )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == true && length(
          regexall("^\\d{3}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
          )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
          regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-00${element(split("/", s.interface), 1
          )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
          regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-0${element(split("/", s.interface), 1
          )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == true && length(
          regexall("^\\d{3}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-${element(split("/", s.interface), 1
          )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == false && length(
          regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-0${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
          )}" : coalesce(s.sub_port, false) == true && v.two_slot_leaf == false && length(
          regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-${element(split("/", s.interface), 1)}-${element(split("/", s.interface), 2
          )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == false && length(
          regexall("^\\d$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-0${element(split("/", s.interface), 1
          )}" : coalesce(s.sub_port, false) == false && v.two_slot_leaf == false && length(
          regexall("^\\d{2}$", element(split("/", s.interface), 1))) > 0 ? "Eth${element(split("/", s.interface), 0
            )}-${element(split("/", s.interface), 1
        )}" : ""
        key1              = k
        key2              = s.interface
        module            = element(split("/", s.interface), 0)
        name              = k
        node_type         = v.node_type
        port              = element(split("/", s.interface), 1)
        policy_group      = s.policy_group != null ? s.policy_group : ""
        policy_group_type = s.policy_group_type != null ? s.policy_group_type : "access"
        sub_port          = s.sub_port != false ? element(split("/", s.interface), 2) : ""
      }
    ]
  ])


  interface_selectors = {
    for k, v in local.interface_selectors_loop : "${v.key1}_Eth${v.key2}" => v
  }

  inband_loop = flatten([
    for k, v in local.switch_profiles : [
      for s in v.inband_addressing : {
        annotation          = v.annotation != null ? v.annotation : ""
        ipv4_address        = s.ipv4_address != null ? s.ipv4_address : ""
        ipv4_gateway        = s.ipv4_gateway != null ? s.ipv4_gateway : ""
        ipv6_address        = s.ipv6_address != null ? s.ipv6_address : ""
        ipv6_gateway        = s.ipv6_gateway != null ? s.ipv6_gateway : ""
        management_epg      = s.management_epg != null ? s.management_epg : "default"
        management_epg_type = "inb"
        node_id             = k
        pod_id              = v.pod_id
      }
    ]
  ])
  inband = { for k, v in local.inband_loop : "${v.node_id}_${v.management_epg_type}" => v }

  ooband_loop = flatten([
    for k, v in local.switch_profiles : [
      for s in v.inband_addressing : {
        annotation          = v.annotation != null ? v.annotation : ""
        ipv4_address        = s.ipv4_address != null ? s.ipv4_address : ""
        ipv4_gateway        = s.ipv4_gateway != null ? s.ipv4_gateway : ""
        ipv6_address        = s.ipv6_address != null ? s.ipv6_address : ""
        ipv6_gateway        = s.ipv6_gateway != null ? s.ipv6_gateway : ""
        management_epg      = s.management_epg != null ? s.management_epg : "default"
        management_epg_type = "oob"
        node_id             = k
        pod_id              = v.pod_id
      }
    ]
  ])
  ooband = { for k, v in local.ooband_loop : "${v.node_id}_${v.management_epg_type}" => v }

  static_node_mgmt_addresses = merge(local.inband, local.inband)

  #__________________________________________________________
  #
  # VPC Domains Variables
  #__________________________________________________________

  vpc_domains = {
    for k, v in var.vpc_domains : k => {
      annotation        = v.annotation != null ? v.annotation : ""
      domain_id         = v.domain_id
      switches          = v.switches != null ? v.switches : []
      vpc_domain_policy = v.vpc_domain_policy != null ? v.vpc_domain_policy : "default"
    }
  }

}
