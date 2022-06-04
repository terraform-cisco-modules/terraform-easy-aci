/*_____________________________________________________________________________________________________________________

Syslog — Variables
_______________________________________________________________________________________________________________________
*/
variable "syslog" {
  default = {
    "default" = {
      admin_state = "enabled"
      annotation  = ""
      console_destination = [
        {
          admin_state = "enabled"
          severity    = "critical"
        }
      ]
      description = ""
      format      = "aci"
      include_types = [
        {
          audit_logs   = false
          events       = false
          faults       = true
          session_logs = false
        }
      ]
      local_file_destination = [
        {
          admin_state = "enabled"
          severity    = "warnings"
        }
      ]
      min_severity = "warnings"
      remote_destinations = [
        {
          admin_state         = "enabled"
          forwarding_facility = "local7"
          host                = "host.example.com"
          management_epg      = "default"
          management_epg_type = "oob"
          port                = 514
          severity            = "warnings"
          transport           = "udp"
        }
      ]
      show_milliseconds_in_timestamp = false
      show_time_zone_in_timestamp    = false
    }
  }
  description = <<-EOT
    Key - Name for the Syslog Profile
    * admin_state: (optional) — The administrative state of the syslog profile. The values can be:
      - disabled
      - enabled: (default)
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * console_destination: (optional) — Syslog settings for Console.
      - admin_state: (optional) — The administrative state of the console terminal. The values can be:
        * disabled
        * enabled: (default)
      - severity: (optional) — The minimum severity level of the messages to be displayed. The level can be:
        * emergencies
        * alerts
        * critical: (default)
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * format = "aci"
    * include_types: (optional) — The Type of messages to include in the Syslog Policy.
      - audit_logs: (default: false)
      - events: (default: false)
      - faults: (default: true)
      - session_logs: (default: false)
    * local_file_destination: (optional) — Syslog settings for Local File.
      - admin_state: (optional) — The administrative state of the local file. The values can be:
        * disabled
        * enabled: (default)
      - severity: (optional) — The severity of the event, alert, or issue that caused the syslog entry to be generated. The level can be:
        * emergencies
        * alerts
        * critical
        * errors
        * warnings: (default)
        * notifications
        * information
        * debugging
    * min_severity: (optional) — 
      - emergencies
      - alerts
      - critical
      - errors
      - warnings: (default)
      - notifications
      - information
      - debugging
    * remote_destinations: (optional) — 
      - admin_state: (optional) — The administrative state of the remote destination host. The values can be:
        * disabled
        * enabled: (default)
      - forwarding_facility: (optional) — The facility to be used to send messages to this destination.
        * local0
        * local1
        * local2
        * local3
        * local4
        * local5
        * local6
        * local7: (default)
      - host: (default: host.example.com) — The host name or IP address for export destination.
      - management_epg: (default: default) — The management EPG for the Smart Callhome destination group profile.
      - management_epg_type: (optional) — Type of management EPG.  Options are:
        * inb
        * oob: (default)
      - port: (default: 514) — The syslog service port of the remote destination. The range is from 0 to 65535.
      - severity: (optional) — The severity of the event, alert, or issue that caused the syslog entry to be generated. The level can be:
        * emergencies
        * alerts
        * critical
        * errors
        * warnings: (default)
        * notifications
        * information
        * debugging
      - transport: (optional) — The transport protocol to use for the messages. The values can be:
        * ssl — If you select ssl as the transport protocol, the Cisco ACI switch (acting as a client) makes a secure, encrypted outbound connection to remote syslog servers (acting as a server) supporting secure connectivity for logging. With authentication and encryption, this feature allows for a secure communication over an insecure network.
        * tcp
        * udp: (default)
    * show_milliseconds_in_timestamp: (optional) — Include msec in the log timestamp.
      - false: (default)
      - true
    * show_time_zone_in_timestamp: (optional) — Include the local time zone in the log timestamp.
      - false: (default)
      - true
  EOT
  type = map(object(
    {
      admin_state = optional(string)
      annotation  = optional(string)
      console_destination = optional(list(object(
        {
          admin_state = optional(string)
          severity    = optional(string)
        }
      )))
      description = optional(string)
      format      = optional(string)
      include_types = list(object(
        {
          audit_logs   = bool
          events       = bool
          faults       = bool
          session_logs = bool
        }
      ))
      local_file_destination = optional(list(object(
        {
          admin_state = optional(string)
          severity    = optional(string)
        }
      )))
      min_severity = optional(string)
      remote_destinations = optional(list(object(
        {
          admin_state         = optional(string)
          forwarding_facility = optional(string)
          host                = optional(string)
          management_epg      = optional(string)
          management_epg_type = optional(string)
          port                = optional(number)
          severity            = optional(string)
          transport           = optional(string)
        }
      )))
      show_milliseconds_in_timestamp = optional(bool)
      show_time_zone_in_timestamp    = optional(bool)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "syslogGroup"
 - Distinguished Name: "uni/fabric/slgroup-{Dest_Grp_Name}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Syslog > {Dest_Grp_Name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_destination_groups" {
  for_each   = local.syslog
  class_name = "syslogGroup"
  dn         = "uni/fabric/slgroup-${each.key}"
  content = {
    # annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr               = each.value.description
    format              = each.value.format
    includeMilliSeconds = each.value.show_milliseconds_in_timestamp == true ? "yes" : "no"
    includeTimeZone     = each.value.show_time_zone_in_timestamp == true ? "yes" : "no"
    name                = each.key
  }
  child {
    rn         = "console"
    class_name = "syslogConsole"
    content = {
      adminState = each.value.console_destination[0].admin_state
      severity   = each.value.console_destination[0].severity
    }
  }
  child {
    rn         = "file"
    class_name = "syslogFile"
    content = {
      adminState = each.value.local_file_destination[0].admin_state
      severity   = each.value.local_file_destination[0].severity
    }
  }
  child {
    rn         = "prof"
    class_name = "syslogProf"
    content = {
      adminState = each.value.admin_state
      # port      = each.value.port
      # transport = each.value.transport
    }
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "syslogRemoteDest"
 - Distinguished Name: " uni/fabric/slgroup-default/rdst-{syslog_server}"
GUI Location:
 - Admin > External Data Collectors > Monitoring Destinations > Syslog > {Destination Group} > 
   Create Syslog Remote Destination
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_remote_destinations" {
  depends_on = [
    aci_rest_managed.syslog_destination_groups
  ]
  for_each   = local.syslog_remote_destinations
  class_name = "syslogRemoteDest"
  dn         = "uni/fabric/slgroup-${each.value.key1}/rdst-${each.value.host}"
  content = {
    # annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
    adminState         = each.value.admin_state
    forwardingFacility = each.value.forwarding_facility
    host               = each.value.host
    name               = each.value.host
    port               = each.value.port
    # protocol           = each.value.transport
    severity = each.value.severity
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
 - Class: "syslogSrc"
 - Distinguished Name: "uni/fabric/moncommon/slsrc-{Dest_Grp_Name}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Common Policies > 
   Callhome/Smart Callhome/SNMP/Syslog/TACACS:Syslog > Create Syslog Source
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "syslog_sources" {
  depends_on = [
    aci_rest_managed.syslog_destination_groups
  ]
  for_each   = local.syslog
  class_name = "syslogSrc"
  dn         = "uni/fabric/moncommon/slsrc-${each.key}"
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
    minSev = each.value.min_severity
    name   = each.key
  }
  child {
    rn         = "rsdestGroup"
    class_name = "syslogRsDestGroup"
    content = {
      tDn = "uni/fabric/slgroup-${each.key}"
    }
  }
}
