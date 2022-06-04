/*_____________________________________________________________________________________________________________________

Smart CallHome — Variables
_______________________________________________________________________________________________________________________
*/
variable "smart_callhome" {
  default = {
    "default" = {
      admin_state            = "enabled"
      annotation             = ""
      contact_information    = ""
      contract_id            = ""
      customer_contact_email = ""
      customer_id            = ""
      description            = ""
      smart_destinations = [
        {
          admin_state   = "enabled"
          email         = "admin@example.com"
          format        = "short-txt" # aml|short-txt|xml
          rfc_compliant = true
        }
      ]
      from_email     = ""
      phone_contact  = ""
      reply_to_email = ""
      site_id        = ""
      street_address = ""
      smtp_server = [
        {
          management_epg      = "default"
          management_epg_type = "oob" # inb|oob
          port_number         = 25
          secure_smtp         = false
          smtp_server         = "relay.example.com"
          username            = ""
        }
      ]
    }
  }
  description = <<-EOT
    Key - Name for the Smart CallHome.  You can only have one Smart CallHome Profile.
    * admin_state: (optional) — The admin state of the Smart Callhome destination group profile. The state can be Enabled or Disabled. If enabled, the system uses the profile policy when an event or fault matching the associated cause is encountered. If disabled, the system ignores the policy even if a matching error occurs.  Options are:
      - disabled
      - enabled: (default)
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * contact_information: (optional) — The customer contact ID. Note that the customer ID associated with the Smart Callhome configuration in Cisco UCS must be the CCO (Cisco.com) account name associated with a support contract that includes Smart Callhome.
    * contract_id: (optional) — The contract information provided by the customer.
    * customer_contact_email: (optional) — The email address of the contact for the system or site. This address is not necessarily the same as the reply-to addresses used in the outgoing emails.
    * customer_id: (optional) — The customer for the Smart Callhome destination group profile.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * smart_destinations: (required) — List of email addresses to send smart callHome information.
      - admin_state: (optional) — The admin state of the Smart Callhome destination group.
        * disabled
        * enabled: (default)
      - email: (default: admin@example.com) — The email address of the sender.
      - format: (optional) —         = "short-txt"
        * aml
        * short-txt: (default)
        * xml
      - rfc_compliant: (optional) — Messages are only to be sent in RFC-compliant formats.
        * NOTE:  If this flag is enabled, messages will not be backward compatible and might have issues with Microsoft Outlook on OSX.
          - If rfc_compliant is not checked, there will be no message body though.
        * false
        * true: (default)
    * from_email: (optional) — The email address of the sender.
    * phone_contact: (optional) — The customer contact phone number.
    * reply_to_email: (optional) — The reply-to email address for emails sent.
    * site_id: (optional) — The site ID provided by the customer. This is the ID of the network where the site is deployed.
    * street_address: (optional) — The contact address of the customer.
    * smtp_server: (required) —  = [
      - management_epg: (default: default) — The management EPG for the Smart Callhome destination group profile.
      - management_epg_type: (optional) — Type of management EPG.  Options are:
        * inb
        * oob: (default)
      - port_number: (default: 25) — The SMTP server port number for the Smart Callhome destination group profile. Note that you must configure the SMTP server address for the Smart Callhome functionality to work. You can also configure the from and reply-to e-mail addresses. The port rage is from 0 to 65535.
      - secure_smtp: (optional) — Flag to enable smtp authentication when required.
        * false: (default)
        * true
      - smtp_server: (default: relay.example.com) — The hostname or IP for the Smart Callhome destination group profile. Smart Callhome sends email messages to either the IP address or hostname and the associated port number.
      - username: (required if secure_smtp set to true) — Username for the smtp server when secure_smtp is enabled.
  EOT
  type = map(object(
    {
      admin_state            = optional(string)
      annotation             = optional(string)
      contact_information    = optional(string)
      contract_id            = optional(string)
      customer_contact_email = optional(string)
      customer_id            = optional(string)
      description            = optional(string)
      smart_destinations = list(object(
        {
          admin_state   = optional(string)
          email         = optional(string)
          format        = optional(string)
          rfc_compliant = optional(bool)
        }
      ))
      from_email     = optional(string)
      phone_contact  = optional(string)
      reply_to_email = optional(string)
      site_id        = optional(string)
      street_address = optional(string)
      smtp_server = list(object(
        {
          management_epg      = optional(string)
          management_epg_type = optional(string)
          port_number         = optional(number)
          secure_smtp         = optional(bool)
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
resource "aci_rest_managed" "smart_callhome_destination_groups" {
  for_each   = local.smart_callhome
  class_name = "callhomeSmartGroup"
  dn         = "uni/fabric/smartgroup-${each.key}"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr = each.value.description
    name  = each.key
  }
}

resource "aci_rest_managed" "smart_callhome_destination_groups_callhome_profile" {
  for_each   = local.smart_callhome
  class_name = "callhomeProf"
  dn         = "uni/fabric/smartgroup-${each.key}/prof"
  content = {
    addr       = each.value.street_address
    adminState = each.value.admin_state
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    contract   = each.value.contract_id
    contact    = each.value.contact_information
    customer   = each.value.customer_id
    email      = each.value.customer_contact_email
    from       = each.value.from_email
    replyTo    = each.value.reply_to_email
    phone      = each.value.phone_contact
    port       = each.value.smtp_server[0].port_number
    pwd        = each.value.smtp_server[0].secure_smtp == true ? var.smtp_password : ""
    secureSmtp = each.value.smtp_server[0].secure_smtp == true ? "yes" : "no"
    site       = each.value.site_id
    username   = each.value.smtp_server[0].username
  }
}

resource "aci_rest_managed" "smart_callhome_smtp_servers" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome_smtp_servers
  class_name = "callhomeSmtpServer"
  dn         = "uni/fabric/smartgroup-${each.value.key1}/prof/smtp"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    host = each.value.smtp_server
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
resource "aci_rest_managed" "smart_callhome_destinations" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome_destinations
  class_name = "callhomeSmartDest"
  dn         = "uni/fabric/smartgroup-${each.value.key1}/smartdest-${each.value.name}"
  content = {
    # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
    adminState   = each.value.admin_state
    email        = each.value.email
    format       = each.value.format
    name         = each.value.name
    rfcCompliant = each.value.rfc_compliant == true ? "yes" : "no"
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
resource "aci_rest_managed" "smart_callhome_source" {
  depends_on = [
    aci_rest_managed.smart_callhome_destination_groups
  ]
  for_each   = local.smart_callhome
  dn         = "uni/fabric/moncommon/smartchsrc"
  class_name = "callhomeSmartSrc"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    # incl = alltrue(
    #   [
    #     each.value.include_types[0].audit_logs,
    #     each.value.include_types[0].events,
    #     each.value.include_types[0].faults,
    #     each.value.include_types[0].session_logs
    #   ]
    #   ) ? "all" : anytrue(
    #   [
    #     each.value.include_types[0].audit_logs,
    #     each.value.include_types[0].events,
    #     each.value.include_types[0].faults,
    #     each.value.include_types[0].session_logs
    #   ]
    #   ) ? replace(trim(join(",", concat([
    #     length(regexall(true, each.value.include_types[0].audit_logs)) > 0 ? "audit" : ""], [
    #     length(regexall(true, each.value.include_types[0].events)) > 0 ? "events" : ""], [
    #     length(regexall(true, each.value.include_types[0].faults)) > 0 ? "faults" : ""], [
    #     length(regexall(true, each.value.include_types[0].session_logs)) > 0 ? "session" : ""]
    # )), ","), ",,", ",") : "none"
  }
  child {
    rn         = "rssmartdestGroup"
    class_name = "callhomeRsSmartdestGroup"
    content = {
      tDn = "uni/fabric/smartgroup-${each.key}"
    }
  }
}
