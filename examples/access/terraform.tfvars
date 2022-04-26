# Global Variables
annotation = "easy-aci:0.9.5"
apicUrl    = "https://64.100.14.15"
apicUser   = "admin"

# Domains
layer3_domains   = {}
physical_domains = {}
vmm_domains      = {}

# Global Policy Variables
aaep_policies = {
  # "moa" = {
  #   alias       = ""
  #   description = "Mother of all AAEP Policies."
  #   layer3_domains = [
  #     "l3_domain1",
  #     "l3_domain2"
  #   ]
  #   physical_domains = [
  #     "phys_domain1",
  #     "phys_domain2"
  #   ]
  #   vmm_domains = []
  # }
}
error_disabled_recovery_policy = {}
global_qos_class               = {}
mcp_instance_policy            = {}

# Interface Policy Variables
cdp_interface_policies = {
  "cdp_enabled" = {
    admin_state = "enabled"
    alias       = ""
    description = "CDP Enabled Policy."
  }
}
fc_interface_policies   = {}
l2_interface_policies   = {}
lacp_interface_policies = {}
link_level_policies     = {}
lldp_interface_policies = {
  "lldp_enabled" = {
    alias          = ""
    annotation     = ""
    description    = "LLDP Enabled Policy."
    receive_state  = "enabled"
    transmit_state = "enabled"
  }
}
mcp_interface_policies = {}
port_security_policies = {}
spanning_tree_interface_policies = {
  "filter_and_guard" = {
    alias       = ""
    annotation  = ""
    bpdu_filter = "enabled"
    bpdu_guard  = "enabled"
    description = "BPDU Filter and Guard Enabled"
  }
}

# Leaf Profile Variables
leaf_port_group_access   = {}
leaf_port_group_breakout = {}
leaf_port_group_bundle   = {}
leaf_policy_groups = {
  "default" = {
    bfd_ipv4_policy                = "default"
    bfd_ipv6_policy                = "default"
    bfd_multihop_ipv4_policy       = "default"
    bfd_multihop_ipv6_policy       = "default"
    cdp_policy                     = "cdp_enabled"
    copp_leaf_policy               = "default"
    copp_pre_filter                = "default"
    description                    = "Leaf Policy Group."
    dot1x_authentication_policy    = "default"
    equipment_flash_config         = "default"
    fast_link_failover_policy      = "default"
    fibre_channel_node_policy      = "default"
    fibre_channel_san_policy       = "default"
    forward_scale_profile_policy   = "default"
    lldp_policy                    = "lldp_enabled"
    monitoring_policy              = "default"
    netflow_node_policy            = "default"
    poe_node_policy                = "default"
    ptp_node_policy                = "default"
    spanning_tree_interface_policy = "default"
    synce_node_policy              = "default"
    usb_configuration_policy       = "default"
  }
}
leaf_profiles = {
  "201" = {
    alias       = ""
    annotation  = ""
    description = ""
    interfaces = {
      "1/1" = {
        interface_description  = "Connected to Server."
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
        sub_port               = false
      }
      "1/2" = {
        interface_description  = "Breakout Port."
        interface_policy_group = ""
        port_type              = "breakout"
        selector_description   = ""
        sub_port               = false
      }
      "1/2/1" = {
        interface_description  = "Connected to Server."
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
        sub_port               = true
      }
    }
    leaf_policy_group = "default"
    monitoring_policy = "default"
    name              = "asgard-leaf201"
    node_type         = "unspecified"
    pod_id            = 1
    role              = "leaf"
    serial            = "TEP-1-101"
    two_slot_leaf     = false
  }
  "202" = {
    alias       = ""
    description = ""
    interfaces = {
      "1/1" = {
        interface_description  = "Connected to Server."
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
        sub_port               = false
      }
      "1/2" = {
        interface_description  = "Breakout Port."
        interface_policy_group = ""
        port_type              = "breakout"
        selector_description   = ""
        sub_port               = false
      }
      "1/2/1" = {
        interface_description  = "Connected to Server."
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
        sub_port               = true
      }
    }
    leaf_policy_group = "default"
    monitoring_policy = "default"
    name              = "asgard-leaf202"
    node_type         = "unspecified"
    pod_id            = 1
    role              = "leaf"
    serial            = "TEP-1-102"
    two_slot_leaf     = false
  }
}

# Spine Profile Variables
spine_interface_policy_groups = {}
spine_policy_groups = {
  "default" = {
    bfd_ipv4_policy          = "default"
    bfd_ipv6_policy          = "default"
    cdp_policy               = "cdp_enabled"
    copp_pre_filter          = "default"
    copp_spine_policy        = "default"
    description              = "Spine Policy Group."
    lldp_policy              = "lldp_enabled"
    usb_configuration_policy = "default"
  }
}
spine_profiles = {
  "101" = {
    alias       = ""
    annotation  = ""
    description = "Spine 101 Profile."
    interfaces = {
      "1/1" = {
        interface_description  = "Testing Spine Interface"
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
      }
    }
    name               = "asgard-spine101"
    node_type          = "unspecified"
    pod_id             = 1
    serial             = "TEP-1-103"
    spine_policy_group = "default"
  }
  "102" = {
    alias       = ""
    annotation  = ""
    description = "Spine 102 Profile."
    interfaces = {
      "1/1" = {
        interface_description  = "Testing Spine Interface"
        interface_policy_group = ""
        port_type              = "access"
        selector_description   = ""
      }
    }
    name               = "asgard-spine102"
    node_type          = "unspecified"
    pod_id             = 1
    serial             = "TEP-1-104"
    spine_policy_group = "default"
  }
}

# VLAN Pool Variables
vlan_pools = {
  "dynamic_pool" = {
    alias           = ""
    allocation_mode = "dynamic"
    description     = "Dynamic VLAN Pool."
    encap_blocks = {
      "0" = {
        allocation_mode = "static"
        description     = "Dynamic VLAN Pool Range 1"
        role            = "external"
        vlan_range      = "1700-1709"
      }
    }
  }
  "static_pool" = {
    alias           = ""
    allocation_mode = "static"
    description     = "Static VLAN Pool."
    encap_blocks = {
      "0" = {
        allocation_mode = "static"
        description     = "Static VLAN Pool Range 1"
        role            = "external"
        vlan_range      = "10-15"
      }
    }
  }
}

# Virtual Machine Managed Domains
virtual_networking = {}

# VPC Domains
vpc_domains = {
  "asgard-leaf201-202" = {
    annotation        = ""
    domain_id         = 201
    switch_1          = 201
    switch_2          = 202
    vpc_domain_policy = "default"
  }
}