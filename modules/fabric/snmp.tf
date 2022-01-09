variable "snmp_policies" {
  default = {
    "default" = {
      admin_state = "enabled"
      communities = []
      contact     = ""
      description = ""
      location    = ""
      snmp_client_groups = [
        {
          clients             = []
          description         = ""
          management_epg      = "default"
          management_epg_type = "oob"
          name                = "default"
        }
      ]
      trap_destinations = []
      users             = []
    }
  }
  type = map(object(
    {
      admin_state = optional(string)
      communities = optional(list(object(
        {
          community          = string
          community_variable = number
          description        = optional(string)
        }
      )))
      contact     = optional(string)
      description = optional(string)
      location    = optional(string)
      snmp_client_groups = list(object(
        {
          clients = optional(list(object(
            {
              address = string
              name    = optional(string)
            }
          )))
          description         = optional(string)
          management_epg      = optional(string)
          management_epg_type = optional(string)
          name                = string
        }
      ))
      trap_destinations = optional(list(object(
        {
          community           = optional(number)
          host                = string
          management_epg      = optional(string)
          management_epg_type = optional(string)
          port                = optional(number)
          username            = optional(string)
          v3_security_level   = optional(string)
          version             = optional(string)
        }
      )))
      users = optional(list(object(
        {
          authorization_key  = number
          authorization_type = optional(string) # hmac-md5-96, hmac-sha1-96, hmac-sha2-224, hmac-sha2-256,hmac-sha2-384, hmac-sha2-512
          privacy_key        = optional(number)
          privacy_type       = optional(string) # aes-128, des, none
          username           = string
        }
      )))
    }
  ))
}

variable "snmp_authorization_key_1" {
  default     = ""
  description = "SNMP Authorization Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_2" {
  default     = ""
  description = "SNMP Authorization Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_3" {
  default     = ""
  description = "SNMP Authorization Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_4" {
  default     = ""
  description = "SNMP Authorization Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_authorization_key_5" {
  default     = ""
  description = "SNMP Authorization Key 5."
  sensitive   = true
  type        = string
}

variable "snmp_community_1" {
  default     = ""
  description = "SNMP Community 1."
  sensitive   = true
  type        = string
}

variable "snmp_community_2" {
  default     = ""
  description = "SNMP Community 2."
  sensitive   = true
  type        = string
}

variable "snmp_community_3" {
  default     = ""
  description = "SNMP Community 3."
  sensitive   = true
  type        = string
}

variable "snmp_community_4" {
  default     = ""
  description = "SNMP Community 4."
  sensitive   = true
  type        = string
}

variable "snmp_community_5" {
  default     = ""
  description = "SNMP Community 5."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_1" {
  default     = ""
  description = "SNMP Privacy Key 1."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_2" {
  default     = ""
  description = "SNMP Privacy Key 2."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_3" {
  default     = ""
  description = "SNMP Privacy Key 3."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_4" {
  default     = ""
  description = "SNMP Privacy Key 4."
  sensitive   = true
  type        = string
}

variable "snmp_privacy_key_5" {
  default     = ""
  description = "SNMP Privacy Key 5."
  sensitive   = true
  type        = string
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpPol"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_policies" {
  provider   = netascode
  for_each   = local.snmp_policies
  dn         = "uni/fabric/snmppol-${each.key}"
  class_name = "snmpPol"
  content = {
    adminSt = each.value.admin_state
    contact = each.value.contact
    descr   = each.value.description
    loc     = each.value.location
    name    = each.key
  }
}

# resource "aci_rest" "snmp" {
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}.json"
#   class_name = "snmpPol"
#   payload    = <<EOF
# {
#   "snmpPol": {
#     "attributes": {
#       "adminSt": "{admin_state}",
#       "contact": "{contact}",
#       "descr": "{description}",
#       "dn": "uni/fabric/snmppol-{snmp_policy}",
#       "loc": "{location}",
#       "name": "{snmp_policy}"
#     },
#     "children": []
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientGrpP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: {client_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_client_groups" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_policies
  ]
  for_each   = local.snmp_client_groups
  dn         = "uni/fabric/snmppol-${each.value.key1}/clgrp-${each.value.name}"
  class_name = "snmpClientGrpP"
  content = {
    descr = each.value.description
    name  = each.value.name
  }
  child {
    rn         = "rsepg"
    class_name = "snmpRsEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
    }
  }
}

# resource "aci_rest" "snmp_client_groups" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}.json"
#   class_name = "snmpClientGrpP"
#   payload    = <<EOF
# {
#   "snmpClientGrpP": {
#     "attributes": {
#       "descr": "{description}",
#       "dn": "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}",
#       "name": "{client_group}",
#     },
#     "children": [
#       {
#         "snmpRsEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientP"
 - Distinguished Name: "uni/fabric/snmppol-default/clgrp-{Mgmt_Domain}/client-[{SNMP_Client}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > default > Client Group Policies: {client_group} > Client Entries
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_client_group_clients" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_policies,
    aci_rest.snmp_client_groups
  ]
  for_each   = local.snmp_client_group_clients
  dn         = "uni/fabric/snmppol-${each.value.key1}/clgrp-${each.value.key2}/client-[${each.value.address}]"
  class_name = "snmpClientP"
  content = {
    addr = each.value.address
    name = each.value.name
  }
}

# resource "aci_rest" "snmp_policy_{snmp_policy}_client_group_{client_group}_Client_{SNMP_Client_}" {
#   depends_on = [
#     aci_rest.snmp_policies,
#     aci_rest.snmp_client_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}/client-[{SNMP_Client}].json"
#   class_name = "snmpClientP"
#   payload    = <<EOF
# {
#   "snmpClientP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}/client-[{SNMP_Client}]",
#       "name": "{SNMP_Client_Name}",
#       "addr": "{SNMP_Client}",
#     },
#     "children": []
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpCommunityP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/community-{sensitive_var}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy} > Community Policies
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_policies_communities" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_policies
  ]
  for_each   = local.snmp_policies_communities
  dn         = "uni/fabric/snmppol-${each.value.key1}/community-[${each.value.community_variable}]"
  class_name = "snmpCommunityP"
  content = {
    descr = each.value.description
    name  = each.value.community_variable
    # name    = length(regexall(
    #   5, each.value.community_variable)) > 0 ? var.snmp_community_5 : length(regexall(
    #   4, each.value.community_variable)) > 0 ? var.snmp_community_4 : length(regexall(
    #   3, each.value.community_variable)) > 0 ? var.snmp_community_3 : length(regexall(
    #   2, each.value.community_variable)) > 0 ? var.snmp_community_2 : var.snmp_community_1
  }
}

# resource "aci_rest" "snmp_policies_communities" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-${each.value.key1}/community-${var.sensitive_var}.json"
#   class_name = "snmpCommunityP"
#   payload    = <<EOF
# {
#   "snmpCommunityP": {
#     "attributes": {
#       "descr": "{Description}"
#       "dn": "uni/fabric/snmppol-{snmp_policy}/community-${var.sensitive_var}",
#       "name": "${var.sensitive_var}",
#     },
#     "children": []
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpUserP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: SNMP V3 Users
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_policies_users" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_policies
  ]
  for_each   = local.snmp_policies_users
  dn         = "uni/fabric/snmppol-${each.value.key1}/user-[${each.value.username}]"
  class_name = "snmpUserP"
  content = {
    authKey = length(regexall(
      5, each.value.authorization_key)) > 0 ? var.snmp_authorization_key_5 : length(regexall(
      4, each.value.authorization_key)) > 0 ? var.snmp_authorization_key_4 : length(regexall(
      3, each.value.authorization_key)) > 0 ? var.snmp_authorization_key_3 : length(regexall(
    2, each.value.authorization_key)) > 0 ? var.snmp_authorization_key_2 : var.snmp_authorization_key_1
    authType = each.value.authorization_type
    name     = each.value.username
    privKey = length(regexall(
      5, each.value.privacy_key)) > 0 ? var.snmp_privacy_key_5 : length(regexall(
      4, each.value.privacy_key)) > 0 ? var.snmp_privacy_key_4 : length(regexall(
      3, each.value.privacy_key)) > 0 ? var.snmp_privacy_key_3 : length(regexall(
      2, each.value.privacy_key)) > 0 ? var.snmp_privacy_key_2 : length(regexall(
    1, each.value.privacy_key)) > 0 ? var.snmp_privacy_key_1 : ""
    privType = each.value.privacy_type
  }
}
# resource "aci_rest" "snmp_policy_{snmp_policy}_V3_User_{snmp_user}" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}.json"
#   class_name = "snmpUserP"
#   payload    = <<EOF
# {
#   "snmpUserP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}",
#       "name": "{snmp_user}",
#       "privType": "{Privacy_Type}",
#       "privKey": "${var.sensitive_var1}",
#       "authType": "{Authorization_Type}",
#       "authKey": "${var.sensitive_var2}"
#     },
#     "children": []
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpGroup"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_monitoring_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_monitoring_destination_groups" {
  provider   = netascode
  for_each   = local.snmp_policies
  dn         = "uni/fabric/snmpgroup-${each.key}"
  class_name = "snmpGroup"
  content = {
    descr = each.value.description
    name  = each.key
  }
}

# resource "aci_rest" "snmp_trap_destination_groups" {
#   path       = "/api/node/mo/uni/fabric/snmpgroup-${each.key}.json"
#   class_name = "snmpGroup"
#   payload    = <<EOF
# {
#   "snmpGroup": {
#     "attributes": {
#       "dn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}",
#       "descr": "{Description}",
#       "name": "{SNMP_Trap_DG}"
#     }
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapDest"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_monitoring_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_trap_destinations" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_monitoring_destination_groups
  ]
  for_each   = local.snmp_trap_destinations
  dn         = "uni/fabric/snmpgroup-${each.value.key1}/trapdest-${each.value.host}-port-${each.value.port}"
  class_name = "snmpTrapDest"
  content = {
    host = each.value.host
    port = each.value.port
    secName = each.value.version != "v3" && length(regexall(
      5, each.value.community)) > 0 ? var.snmp_community_5 : each.value.version != "v3" && length(regexall(
      4, each.value.community)) > 0 ? var.snmp_community_4 : each.value.version != "v3" && length(regexall(
      3, each.value.community)) > 0 ? var.snmp_community_3 : each.value.version != "v3" && length(regexall(
      2, each.value.community)) > 0 ? var.snmp_community_2 : each.value.version != "v3" && length(regexall(
    1, each.value.community)) > 0 ? var.snmp_community_1 : each.value.version == "v3" ? each.value.username : "unknown"
    v3SecLvl = each.value.version == "v3" ? each.value.v3_security_level : "noauth"
    ver      = each.value.version
  }
  child {
    rn         = "rsARemoteHostToEpg"
    class_name = "fileRsARemoteHostToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
    }
  }
}
# resource "aci_rest" "SNMP_Trap_DestGrp_{SNMP_Trap_DG}_Receiver_{Trap_Server_}" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmpgroup-{SNMP_Trap_DG}/trapdest-{Trap_Server}-port-{Destination_Port}.json"
#   class_name = "snmpTrapDest"
#   payload    = <<EOF
# {
#   "snmpTrapDest": {
#     "attributes": {
#       "dn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}/trapdest-{Trap_Server}-port-{Destination_Port}",
#       "host": "{Trap_Server}",
#       "port": "{Destination_Port}",
#       "secName": "{Community_or_Username}",
#       "v3SecLvl": "{Security_Level}",
#       "ver": "{Version}",
#     },
#     "children": [
#       {
#         "fileRsARemoteHostToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#   EOF
# }


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapFwdServerP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: Trap Forward Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_policies_trap_servers" {
  provider = netascode
  depends_on = [
    aci_rest.snmp_policies
  ]
  for_each   = local.snmp_trap_destinations
  dn         = "uni/fabric/snmpgroup-${each.value.key1}/trapfwdserver-[${each.value.host}]"
  class_name = "snmpTrapFwdServerP"
  content = {
    addr = each.value.host
    port = each.value.port
  }
}
# resource "aci_rest" "snmp_policy_{snmp_policy}_Trap_Server_{Trap_Server_}" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}].json"
#   class_name = "snmpTrapFwdServerP"
#   payload    = <<EOF
# {
#   "snmpTrapFwdServerP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}]",
#       "addr": "{Trap_Server}",
#       "port": "{Destination_Port}"
#     },
#     "children": []
#   }
# }
#   EOF
# }


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpSrc"
 - Distinguished Name: "uni/fabric/moncommon/snmpsrc-{SNMP_Source}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policy > Callhome/Smart Callhome/SNMP/Syslog/TACACS: SNMP
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "snmp_trap_source" {
  provider   = netascode
  for_each   = local.snmp_policies
  dn         = "uni/fabric/moncommon/snmpsrc-${each.key}"
  class_name = "snmpSrc"
  content = {
    name = each.key
  }
  child {
    rn         = "rsdestGroup"
    class_name = "snmpRsDestGroup"
    content = {
      tDn = "uni/fabric/snmpgroup-${each.key}"
    }
  }
}

# resource "aci_rest" "SNMP_Trap_Source" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/moncommon/snmpsrc-{SNMP_Source}.json"
#   class_name = "snmpSrc"
#   payload    = <<EOF
# {
#   "snmpSrc": {
#     "attributes": {
#       "dn": "uni/fabric/moncommon/snmpsrc-{SNMP_Source}",
#       "incl": "{Included_Types}",
#       "name": "{SNMP_Source}",
#     },
#     "children": [
#       {
#         "snmpRsDestGroup": {
#           "attributes": {
#             "tDn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}",
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }
