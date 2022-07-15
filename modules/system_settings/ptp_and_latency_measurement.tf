/*_____________________________________________________________________________________________________________________

PTP and Latency Measurement — Variables
_______________________________________________________________________________________________________________________
*/
variable "ptp_and_latency_measurement" {
  default = {
    "default" = {
      annotation              = ""
      announce_interval       = "1"
      announce_timeout        = 3
      delay_request_interval  = "-2"
      global_domain           = 0
      global_priority_1       = 255
      global_priority_2       = 255
      precision_time_protocol = "enabled"
      ptp_profile             = "AES67-2015"
      sync_interval           = "-3"
    }
  }
  description = <<-EOT
    Key - This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * announce_interval: (default: 1) — Specifies the logarithm of the mean interval in seconds with base 2 for a master port to send announce messages. The range depends on the chosen profile:
      - AES67-2015: 0 to 4. These values result in a range of 1 to 16 seconds.
      - Default: 0 to 4. These values result in a range of 1 to 16 seconds.
      - SMPTE-2059-2: -3 to 1. These values result in a range of 0.125 to 2 seconds.
      - The value is applied to all PTP-enabled fabric links.
    * announce_timeout: (default: 3) — Specifies the number of announce messages that the system waits before the PTP announce message is considered expired. The range and the default depend on the chosen PTP profile:
      - AES67-2015: 2 to 10.
      - Default: 2 to 10.
      - SMPTE-2059-2: 2 to 10.
      - The value is applied to all PTP-enabled fabric links.
    * delay_request_interval: (default: -2) — Specifies the logarithm of the mean interval in seconds with base 2 for a slave port to send delay request messages. The range depends on the chosen PTP profile:
      - AES67-2015: -3 to 5. These values result in a range of 0.125 to 32 seconds.
      - Default: 0 to 5. These values result in a range of 0.5 to 2 seconds.
      - SMPTE-2059-2: 0 to 5. These values result in a range of 0.5 to 2 seconds.
      - The value is applied to all PTP-enabled fabric links.
    * global_domain: (default: 0) — Specifies the PTP domain number. Although multiple PTP domains are not supported in Cisco ACI, you can still change the domain number used in Cisco ACI. The same value is used on all leaf and spine nodes.  The valid range of values is 0 to 128. The default is 0.
    * global_priority_1: (default: 255) — Specifies a value that is used to decide the grandmaster clock. The same value is used on all leaf and spine nodes. The ftag0 root spine switch uses the configured value, minus 1.  The valid range of values is 1 to 255. The default is 255 so that the root spine of ftag0 tree can be the grandmaster in case there is no external node that can serve as the grandmaster.
    * global_priority_2: (default: 255) — Specifies a value that is used to decide the grandmaster clock. The same value is used on all leaf and spine nodes. The ftag0 root spine switch uses the configured value, minus 1.  The valid range of values is 1 to 255. The default is 255 so that the root spine of ftag0 tree can be the grandmaster in case there is no external node that can serve as the grandmaster.
    * precision_time_protocol: (otpional) — Specifies the protocol administrative state. The state can be:
      - disabled — PTP is disabled on all leaf and spine nodes.
      - enabled: (default) — PTP is enabled on all fabric links that belong to the ftag tree with ID 0 (ftag0 tree), which is one of the internal tree topologies that is automatically built based on Cisco ACI infra ISIS for loop free connectivity between all leaf and spine nodes in each pod.
    * ptp_profile: (default: 255) — Specifies the PTP profile, which defines the range and default value of various PTP parameters, such as intervals. The values are:
      - AES67-2015: (default) — AES67-2015, which is the standard for audio over Ethernet and audio over IP interoperability.
      - Default — IEEE 1588-2008, which is the default PTP profile for clock synchronization.
      - SMPTE-2059-2 — SMTPE ST2059-2015, which is the standard for video over IP.
      - The profile is applied to all PTP-enabled fabric links.
    * sync_interval: (default: -3) — Specifies the logarithm of the mean interval in seconds with base 2 for a master port to send synchronization messages. The range and the default depend on the chosen PTP profile:
      - AES67-2015: -4 to 1. These values result in a range of 0.0625 to 16 seconds.
      - Default: -1 to 1. These values result in a range of 0.5 to 2 seconds.
      - SMPTE-2059-2: -4 to -1. These values result in a range of 0.0625 to 0.5 seconds. SMPTE defines this as -7 to -1. However, Cisco ACI allows only -4 to -1 for hardware and software stability.
      - The value is applied to all PTP-enabled fabric links.
  EOT
  type = map(object(
    {
      annotation              = optional(string)
      announce_interval       = optional(string)
      announce_timeout        = optional(number)
      delay_request_interval  = optional(string)
      global_domain           = optional(number)
      global_priority_1       = optional(number)
      global_priority_2       = optional(number)
      precision_time_protocol = optional(string)
      ptp_profile             = optional(string)
      sync_interval           = optional(string)
      precision_time_protocol = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "latencyPtpMode"
 - Distinguished Name: "uni/fabric/ptpmode"
GUI Location:
 - System > System Settings > PTP and Latency Measurement
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ptp_and_latency_measurement" {
  for_each   = local.ptp_and_latency_measurement
  class_name = "latencyPtpMode"
  dn         = "uni/fabric/ptpmode"
  content = {
    # annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
    fabAnnounceIntvl   = each.value.announce_interval
    fabAnnounceTimeout = each.value.announce_timeout
    fabDelayIntvl      = each.value.delay_request_interval
    fabProfileTemplate = each.value.ptp_profile
    fabSyncIntvl       = each.value.sync_interval
    globalDomain       = each.value.global_domain
    prio1              = each.value.global_priority_1
    prio2              = each.value.global_priority_2
    state              = each.value.precision_time_protocol
  }
}