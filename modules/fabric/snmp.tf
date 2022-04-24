variable "snmp_policies" {
  default = {
    "default" = {
      admin_state = "enabled"
      annotation  = ""
      communities = []
      contact     = ""
      description = ""
      include_types = [
        {
          audit_logs   = false
          events       = false
          faults       = true
          session_logs = false
        }
      ]
      location = ""
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
      annotation  = optional(string)
      communities = optional(list(object(
        {
          community_variable = number
          description        = optional(string)
        }
      )))
      contact     = optional(string)
      description = optional(string)
      include_types = list(object(
        {
          audit_logs   = bool
          events       = bool
          faults       = bool
          session_logs = bool
        }
      ))
      location = optional(string)
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
          authorization_type = optional(string)
          privacy_key        = optional(number)
          privacy_type       = optional(string)
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
resource "aci_rest_managed" "snmp_policies" {
  for_each   = local.snmp_policies
  dn         = "uni/fabric/snmppol-${each.key}"
  class_name = "snmpPol"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    adminSt = each.value.admin_state
    contact = each.value.contact
    descr   = each.value.description
    loc     = each.value.location
    name    = each.key
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientGrpP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: {client_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_client_groups" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_client_groups
  dn         = "uni/fabric/snmppol-${each.value.key1}/clgrp-${each.value.name}"
  class_name = "snmpClientGrpP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpClientP"
 - Distinguished Name: "uni/fabric/snmppol-default/clgrp-{Mgmt_Domain}/client-[{SNMP_Client}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > default > Client Group Policies: {client_group} > Client Entries
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_client_group_clients" {
  depends_on = [
    aci_rest_managed.snmp_policies,
    aci_rest_managed.snmp_client_groups
  ]
  for_each   = local.snmp_client_group_clients
  dn         = "uni/fabric/snmppol-${each.value.key1}/clgrp-${each.value.key2}/client-[${each.value.address}]"
  class_name = "snmpClientP"
  content = {
    addr       = each.value.address
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name       = each.value.name
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpCommunityP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/community-{sensitive_var}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy} > Community Policies
_______________________________________________________________________________________________________________________
*/
resource "aci_snmp_community" "communities" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each  = local.snmp_policies_communities
  parent_dn = aci_snmp_policy.example.id
  name = length(regexall(
    5, each.value.community_variable)) > 0 ? var.snmp_community_5 : length(regexall(
    4, each.value.community_variable)) > 0 ? var.snmp_community_4 : length(regexall(
    3, each.value.community_variable)) > 0 ? var.snmp_community_3 : length(regexall(
  2, each.value.community_variable)) > 0 ? var.snmp_community_2 : var.snmp_community_1
}
# resource "aci_rest_managed" "snmp_policies_communities" {
#   depends_on = [
#     aci_rest_managed.snmp_policies
#   ]
#   for_each   = local.snmp_policies_communities
#   dn         = "uni/fabric/snmppol-${each.value.key1}/community-[${each.value.community_variable}]"
#   class_name = "snmpCommunityP"
#   content = {
#     annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
#     descr      = each.value.description
#     name       = each.value.community
#     # name    = length(regexall(
#     #   5, each.value.community_variable)) > 0 ? var.snmp_community_5 : length(regexall(
#     #   4, each.value.community_variable)) > 0 ? var.snmp_community_4 : length(regexall(
#     #   3, each.value.community_variable)) > 0 ? var.snmp_community_3 : length(regexall(
#     #   2, each.value.community_variable)) > 0 ? var.snmp_community_2 : var.snmp_community_1
#   }
# }


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpUserP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: SNMP V3 Users
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policies_users" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_policies_users
  dn         = "uni/fabric/snmppol-${each.value.key1}/user-[${each.value.username}]"
  class_name = "snmpUserP"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpGroup"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_monitoring_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_monitoring_destination_groups" {
  for_each   = local.snmp_policies
  dn         = "uni/fabric/snmpgroup-${each.key}"
  class_name = "snmpGroup"
  content = {
    descr = each.value.description
    name  = each.key
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapDest"
 - Distinguished Name: "uni/fabric/snmpgroup-{snmp_monitoring_destination_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > SNMP > {snmp_monitoring_destination_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_trap_destinations" {
  depends_on = [
    aci_rest_managed.snmp_monitoring_destination_groups
  ]
  for_each   = local.snmp_trap_destinations
  dn         = "uni/fabric/snmpgroup-${each.value.key1}/trapdest-${each.value.host}-port-${each.value.port}"
  class_name = "snmpTrapDest"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    host       = each.value.host
    port       = each.value.port
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpTrapFwdServerP"
 - Distinguished Name: "uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}]"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > SNMP > {snmp_policy}: Trap Forward Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_policies_trap_servers" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each   = local.snmp_trap_destinations
  dn         = "uni/fabric/snmpgroup-${each.value.key1}/trapfwdserver-[${each.value.host}]"
  class_name = "snmpTrapFwdServerP"
  content = {
    addr       = each.value.host
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    port       = each.value.port
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "snmpSrc"
 - Distinguished Name: "uni/fabric/moncommon/snmpsrc-{SNMP_Source}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policy > Callhome/Smart Callhome/SNMP/Syslog/TACACS: SNMP
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "snmp_trap_source" {
  for_each   = local.snmp_policies
  dn         = "uni/fabric/moncommon/snmpsrc-${each.key}"
  class_name = "snmpSrc"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    incl = alltrue(
      [each.value.include_a, each.value.include_e, each.value.include_f, each.value.include_s]
      ) ? "all" : anytrue(
      [each.value.include_a, each.value.include_e, each.value.include_f, each.value.include_s]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.include_a)) > 0 ? "audit" : ""], [
        length(regexall(true, each.value.include_e)) > 0 ? "events" : ""], [
        length(regexall(true, each.value.include_f)) > 0 ? "faults" : ""], [
        length(regexall(true, each.value.include_s)) > 0 ? "session" : ""]
    )), ","), ",,", ",") : "none"
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
