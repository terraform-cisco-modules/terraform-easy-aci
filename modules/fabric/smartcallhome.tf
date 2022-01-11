variable "smart_callhome" {
  default = {
    "default" = {
      admin_state            = "enabled"
      contact_information    = ""
      contract_id            = ""
      customer_contact_email = ""
      customer_id            = ""
      description            = ""
      destinations = [
        {
          admin_state   = "enabled"
          email         = "admin@example.com"
          format        = "short-txt" # aml|short-txt|xml
          rfc_compliant = "no"
        }
      ]
      from_email = ""
      include_types = [
        {
          audit_logs   = false
          events       = false
          faults       = true
          session_logs = false
        }
      ]
      phone_contact  = ""
      reply_to_email = ""
      site_id        = ""
      street_address = ""
      smtp_server = [
        {
          management_epg      = "default"
          management_epg_type = "oob" # inb|oob
          port_number         = 25
          secure_smtp         = "no"
          smtp_server         = "relay.example.com"
          username            = ""
        }
      ]
    }
  }
  type = map(object(
    {
      admin_state            = optional(string)
      contact_information    = optional(string)
      contract_id            = optional(string)
      customer_contact_email = optional(string)
      customer_id            = optional(string)
      description            = optional(string)
      destinations = list(object(
        {
          admin_state   = optional(string)
          email         = optional(string)
          format        = optional(string)
          rfc_compliant = optional(string)
        }
      ))
      from_email = optional(string)
      include_types = list(object(
        {
          audit_logs   = bool
          events       = bool
          faults       = bool
          session_logs = bool
        }
      ))
      phone_contact  = optional(string)
      reply_to_email = optional(string)
      site_id        = optional(string)
      street_address = optional(string)
      smtp_server = list(object(
        {
          management_epg      = optional(string)
          management_epg_type = optional(string)
          port_number         = optional(number)
          secure_smtp         = optional(string)
          smtp_server         = string
          username            = optional(string)
        }
      ))
    }
  ))
}

variable "smtp_password" {
  default     = ""
  description = "Password to use if Secure SMTP is enabled for the Smart CallHome Destination Group Mail Server."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmartGroup"
 - Distinguished Name: "uni/fabric/smartgroup-{DestGrp_Name}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > [Smart CallHome Dest Group]
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "smart_callhome_destination_groups" {
  provider   = netascode
  for_each   = local.smart_callhome
  dn         = "uni/fabric/smartgroup-${each.key}"
  class_name = "callhomeSmartGroup"
  content = {
    annotation = each.value.tags != "" ? each.value.tags : var.tags
    descr      = each.value.description
    name       = each.key
  }
  child {
    rn         = "prof"
    class_name = "callhomeProf"
    content = {
      addr       = each.value.street_address
      adminState = each.value.admin_state
      annotation = each.value.tags != "" ? each.value.tags : var.tags
      contract   = each.value.contract_id
      contact    = each.value.contact_information
      customer   = each.value.customer_id
      email      = each.value.customer_contact_email
      from       = each.value.from_email
      replyTo    = each.value.reply_to_email
      phone      = each.value.phone_contact
      port       = each.value.port_number
      pwd        = var.smtp_password
      secureSmtp = each.value.secure_smtp
      site       = each.value.site_id
      username   = each.value.username
    }
  }
}

resource "aci_rest" "smart_callhome_smtp_servers" {
  provider = netascode
  depends_on = [
    aci_rest.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome_smtp_servers
  dn         = "uni/fabric/smartgroup-${each.value.key1}/prof/smtp"
  class_name = "callhomeSmtpServer"
  content = {
    annotation = each.value.tags != "" ? each.value.tags : var.tags
    host       = each.value.smtp_server
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
 - Class: "callhomeSmartDest"
 - Distinguished Name: "uni/fabric/smartgroup-{destionation_group}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Smart Callhome > {destionation_group}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "smart_callhome_destinations" {
  provider = netascode
  depends_on = [
    aci_rest.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome_destinations
  dn         = "uni/fabric/smartgroup-${each.value.key1}/smartdest-${each.value.name}"
  class_name = "callhomeSmartDest"
  content = {
    annotation   = each.value.tags != "" ? each.value.tags : var.tags
    adminState   = each.value.admin_state
    email        = each.value.email
    format       = each.value.format
    name         = each.value.name
    rfcCompliant = each.value.rfc_compliant
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "callhomeSmartSrc"
 - Distinguished Name: "uni/infra/moninfra-default/smartchsrc"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > Callhome/Smart Callhome/SNMP/Syslog/TACACS:Smart CallHome > Create Smart CallHome Source
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "smart_callhome_source" {
  provider = netascode
  depends_on = [
    aci_rest.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome
  dn         = "uni/fabric/moncommon/smartchsrc"
  class_name = "callhomeSmartSrc"
  content = {
    annotation = each.value.tags != "" ? each.value.tags : var.tags
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
  }
  child {
    rn         = "rssmartdestGroup"
    class_name = "callhomeRsSmartdestGroup"
    content = {
      tDn = "uni/fabric/smartgroup-${each.key}"
    }
  }
}
