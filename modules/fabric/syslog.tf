variable "syslog" {
  default = {
    "default" = {
      description = ""
      admin_state = "enabled"
      console_destination = [
        {
          admin_state = "enabled"
          severity    = "warnings"
        }
      ]
      format = "aci"
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
      show_milliseconds_in_timestamp = "no"
      show_time_zone_in_timestamp    = "no"
    }
  }
  description = <<-EOT
  EOT
  type = map(object(
    {
      admin_state = optional(string)
      description = optional(string)
      console_destination = optional(list(object(
        {
          admin_state = optional(string)
          severity    = optional(string)
        }
      )))
      format = optional(string)
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
      show_milliseconds_in_timestamp = optional(string)
      show_time_zone_in_timestamp    = optional(string)
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
resource "aci_rest" "syslog_destination_groups" {
  provider   = netascode
  for_each   = local.syslog
  dn         = "uni/fabric/slgroup-${each.key}"
  class_name = "syslogGroup"
  content = {
    annotation          = each.value.tags != "" ? each.value.tags : var.tags
    descr               = each.value.description
    format              = each.value.format
    includeMilliSeconds = each.value.show_milliseconds_in_timestamp
    includeTimeZone     = each.value.show_time_zone_in_timestamp
    name                = each.key
  }
  child {
    rn         = "console"
    class_name = "syslogConsole"
    content = {
      adminState = each.value.console_admin_state
      severity   = each.value.console_severity
    }
  }
  child {
    rn         = "file"
    class_name = "syslogFile"
    content = {
      adminState = each.value.local_admin_state
      severity   = each.value.local_severity
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
resource "aci_rest" "syslog_remote_destinations" {
  provider = netascode
  depends_on = [
    aci_rest.syslog_destination_groups
  ]
  for_each   = local.syslog_remote_destinations
  dn         = "uni/fabric/slgroup-${each.value.key1}/rdst-${each.value.host}"
  class_name = "syslogRemoteDest"
  content = {
    annotation         = each.value.tags != "" ? each.value.tags : var.tags
    adminState         = each.value.admin_state
    forwardingFacility = each.value.forwarding_facility
    host               = each.value.host
    name               = each.value.host
    port               = each.value.port
    protocol           = each.value.transport
    severity           = each.value.severity
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
resource "aci_rest" "syslog_sources" {
  provider = netascode
  depends_on = [
    aci_rest.syslog_destination_groups
  ]
  for_each   = local.syslog
  dn         = "uni/fabric/moncommon/slsrc-${each.key}"
  class_name = "syslogSrc"
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
