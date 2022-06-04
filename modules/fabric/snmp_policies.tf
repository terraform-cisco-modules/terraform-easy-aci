/*_____________________________________________________________________________________________________________________

SNMP Policy — Variables
_______________________________________________________________________________________________________________________
*/
variable "snmp_policies" {
  default = {
    "default" = {
      admin_state = "enabled"
      annotation  = ""
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
      snmp_communities  = []
      snmp_destinations = []
      users             = []
    }
  }
  description = <<-EOT
    Key - Name for the DNS Profile
    * admin_state: (optional) — The administrative state of the SNMP policy. The state can be:
      - disabled
      - enabled: (default)
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * contact: (optional) — The contact information for the SNMP policy.
    * include_types: (optional) — The Type of messages to include in the SNMP Policy.
      - audit_logs: (default: false)
      - events: (default: false)
      - faults: (default: true)
      - session_logs: (default: false)
    * location: (optional) — The location for the SNMP policy.
    * snmp_client_groups: (required) — List of Client Groups to assign to the SNMP Policy.
      - clients             = []
        * address: (required) — The SNMP client profile IP address.
        * name: (default: address value) — The name of the client group profile. This name can be between 1 and 64 alphanumeric characters.
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - management_epg: (default: default) — The management EPG for the Smart Callhome destination group profile.
      - management_epg_type: (optional) — Type of management EPG.  Options are:
        * inb
        * oob: (default)
      - name: (default: default) — Name of the SNMP Client Group to create.
    * snmp_communities: (optional) — List of Communities to add to the Policy.
      - community_variable: (default: 1) — A value between 1 to 5 that will point to the snmp_community_{value} variable.
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * snmp_destinations = []
      - community_variable: (required if version is v2c) — A value between 1 to 5 that will point to the snmp_community_{value} variable.
      - host: (required) — The host for the SNMP trap destination. SNMP traps enable an agent to notify the management station of significant events by way of an unsolicited SNMP message.
      - management_epg: (default: default) — The management EPG for the Smart Callhome destination group profile.
      - management_epg_type: (optional) — Type of management EPG.  Options are:
        * inb
        * oob: (default)
      - port: (default: 162) — The service port of the SNMP trap destination. SNMP traps enable an agent to notify the management station of significant events by way of an unsolicited SNMP message. The range is from 0(unspecified) to 65535.
      - username: (required if version is v3) — The name of the SNMP User.
      - v3_security_level: (optional) — The SNMP V3 security level for the destination path. The level can be:
        * auth: (default)
        * noauth
        * priv
      - version: (optional) — The SNMP version to utilize for the Trap destination.
        * v1
        * v2c: (default)
        * v3
    * users: (optional) — SNMP Users to add to the SNMP Policy.
      - authorization_key: (default: 1) — A value between 1 to 5 that will point to the snmp_authorization_key_{value} variable.
      - authorization_type: (optional) — he authentication type for the user profile. The authentication type is a message authentication code (MAC) that is used between two parties sharing a secret key to validate information transmitted between them. HMAC (Hash MAC) is based on cryptographic hash functions. It can be used in combination with any iterated cryptographic hash function. HMAC MD5 and HMAC SHA1 are two constructs of the HMAC using the MD5 hash function and the SHA1 hash function. HMAC also uses a secret key for calculation and verification of the message authentication values. Supported types are:
       * hmac-md5-96
       * hmac-sha1-96: (default)
       * hmac-sha2-224
       * hmac-sha2-256
       * hmac-sha2-384
       * hmac-sha2-512
      - privacy_key: (optional) — A value between 1 to 5 that will point to the snmp_privacy_key_{value} variable.
      - privacy_type: (optional) — The privacy (encryption) type for the user profile. The type can be Data Encryption Standard (DES) or Advanced Encryption Standard (AES). Data Encryption Standard is a method of data encryption that uses a private (secret) key. DES applies a 56-bit key to each 64-bit block of data. Advanced Encryption Standard that uses a key with a length of 128 bits to encrypt data blocks with a length of 128 bits. The privacy types are:
        * aes-128
        * des
        * none: (default)
      - username: (required) — The name of the SNMP User to create.
  EOT
  type = map(object(
    {
      admin_state = optional(string)
      annotation  = optional(string)
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
      snmp_communities = optional(list(object(
        {
          community_variable = number
          description        = optional(string)
        }
      )))
      snmp_destinations = optional(list(object(
        {
          community_variable  = optional(number)
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
  class_name = "snmpPol"
  dn         = "uni/fabric/snmppol-${each.key}"
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
  class_name = "snmpClientGrpP"
  dn         = "uni/fabric/snmppol-${each.value.key1}/clgrp-${each.value.name}"
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
  class_name = "snmpClientP"
  dn         = "uni/fabric/snmppol-${each.value.snmp_policy}/clgrp-${each.value.client_group}/client-[${each.value.address}]"
  content = {
    addr       = each.value.address
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
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
resource "aci_snmp_community" "snmp_policies_communities" {
  depends_on = [
    aci_rest_managed.snmp_policies
  ]
  for_each  = local.snmp_policies_communities
  parent_dn = aci_rest_managed.snmp_policies[each.value.snmp_policy].id
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
  class_name = "snmpUserP"
  dn         = "uni/fabric/snmppol-${each.value.key1}/user-[${each.value.username}]"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
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
  lifecycle {
    ignore_changes = [
      content.authKey,
      content.privKey
    ]
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
  class_name = "snmpGroup"
  dn         = "uni/fabric/snmpgroup-${each.key}"
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
  class_name = "snmpTrapDest"
  dn         = "uni/fabric/snmpgroup-${each.value.key1}/trapdest-${each.value.host}-port-${each.value.port}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    host = each.value.host
    port = each.value.port
    secName = each.value.version != "v3" && length(regexall(
      5, each.value.community_variable)) > 0 ? var.snmp_community_5 : each.value.version != "v3" && length(regexall(
      4, each.value.community_variable)) > 0 ? var.snmp_community_4 : each.value.version != "v3" && length(regexall(
      3, each.value.community_variable)) > 0 ? var.snmp_community_3 : each.value.version != "v3" && length(regexall(
      2, each.value.community_variable)) > 0 ? var.snmp_community_2 : each.value.version != "v3" && length(regexall(
    1, each.value.community_variable)) > 0 ? var.snmp_community_1 : each.value.version == "v3" ? each.value.username : "unknown"
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
  class_name = "snmpTrapFwdServerP"
  dn         = "uni/fabric/snmppol-${each.value.key1}/trapfwdserver-[${each.value.host}]"
  content = {
    addr = each.value.host
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    port = each.value.port
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
  class_name = "snmpSrc"
  dn         = "uni/fabric/moncommon/snmpsrc-${each.key}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    incl = alltrue(
      [
        each.value.include_types[0].audit_logs,
        each.value.include_types[0].events,
        each.value.include_types[0].faults,
        each.value.include_types[0].session_logs
      ]
      ) ? "all,audit,events,faults,session" : anytrue(
      [
        each.value.include_types[0].audit_logs,
        each.value.include_types[0].events,
        each.value.include_types[0].faults,
        each.value.include_types[0].session_logs
      ]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.include_types[0].audit_logs)) > 0 ? "audit" : ""], [
        length(regexall(true, each.value.include_types[0].events)) > 0 ? "events" : ""], [
        length(regexall(true, each.value.include_types[0].faults)) > 0 ? "faults" : ""], [
        length(regexall(true, each.value.include_types[0].session_logs)) > 0 ? "session" : ""]
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
