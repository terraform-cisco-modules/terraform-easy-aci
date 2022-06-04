/*_____________________________________________________________________________________________________________________

Endpoint Controls — Variables
_______________________________________________________________________________________________________________________
*/
variable "endpoint_controls" {
  default = {
    "default" = {
      annotation = ""
      ep_loop_protection = [{
        action = [{
          bd_learn_disable = false
          port_disable     = true
        }]
        administrative_state      = "enabled"
        loop_detection_interval   = 60
        loop_detection_multiplier = 4
      }]
      ip_aging = [{
        administrative_state = "enabled"
      }]
      rouge_ep_control = [{
        administrative_state = "enabled"
        hold_interval        = 1800
        rouge_interval       = 30
        rouge_multiplier     = 6
      }]
    }
  }
  description = <<-EOT
    Key - This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * ep_loop_protection: (required) — The endpoint loop protection policy specifies how loops detected by frequent MAC address moves are handled.
      - action: (optional) — Action to Perform when a Loop is dected.
        * bd_learn_disable: (optional) — Disable bridge domain learning when a loop is detected, options are:
          - false: (default)
          - true
        * port_disable: (optional) — Disable the Port when a loop is detected, options are:
          - false
          - true: (default)
      - administrative_state: (optional) — The administrative state of the endpoint loop protection policy, options are: 
        * disabled
        * enabled: (default)
      - loop_detection_interval: (default: 60) — Sets the loop detection interval, which specifies the time to detect a loop. The interval range is from 30 to 300 seconds.
      - loop_detection_multiplier: (default: 4) — Sets the loop detection multiplication factor, which is the number of times a single EP moves between ports within the loop detection interval.
    * ip_aging: (required) — When enabled, the IP aging policy ages unused IPs on an endpoint.  When the Administrative State is enabled, the IP aging policy sends ARP requests (for IPv4) and neighbor solicitations (for IPv6) to track IPs on endpoints. If no response is given, the policy ages the unused IPs.  Required: The endpoint retention policy specifies the timer used for tracking IPs on endpoints.
      - administrative_state: (optional) — Enables and disables the IP aging policy, options are:
        * disabled
        * enabled: (default)
    * rouge_ep_control: (required) — A rogue endpoint can attack leaf switches through frequently, repeatedly injecting packets on different leaf switch ports and changing 802.1Q tags (emulating endpoint moves), resulting in learned sclass and EPG port changes. Misconfigurations can also cause frequent IP and MAC addresss changes (moves).  The Rogue EP Control feature addresses this vulnerability.
      - administrative_state: (optional) — The administrative state of the Rogue EP Control policy, options are:
        * disabled
        * enabled: (default)
      - hold_interval: (default: 1800) — Interval in seconds after the endpoint is declared rogue, where it is kept static so learning is prevented and the traffic to and from the rogue endpoint is dropped. After this interval, the endpoint is deleted. Valid values are from 300 to 3600.
      - rouge_interval: (default: 30) — Sets the Rogue EP detection interval, which specifies the time to detect rogue endpoints. Valid values are from 0 to 65535 seconds.
      - rouge_multiplier: (default: 6) — Sets the Rogue EP Detection multiplication factor for determining if an endpoint is unauthorized. If the endpoint moves more times than this number, within the EP detection interval, the endpoint is declared rogue. Valid values are from 2 to 10.
  EOT
  type = map(object(
    {
      annotation = optional(string)
      ep_loop_protection = list(object(
        {
          action = optional(list(object(
            {
              bd_learn_disable = optional(bool)
              port_disable     = optional(bool)
            }
          )))
          administrative_state      = optional(string)
          loop_detection_interval   = optional(number)
          loop_detection_multiplier = optional(number)
        }
      ))
      ip_aging = list(object(
        {
          administrative_state = optional(string)
        }
      ))
      rouge_ep_control = list(object(
        {
          administrative_state = optional(string)
          hold_interval        = optional(number)
          rouge_interval       = optional(number)
          rouge_multiplier     = optional(number)
        }
      ))
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epControlP"
 - Distinguished Name: "uni/infra/epCtrlP-default"
GUI Location:
 - System > System Settings > Rogue EP Control
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_controls" "rouge_endpoint_control" {
  for_each              = local.rouge_ep_control
  admin_st              = each.value.administrative_state
  annotation            = each.value.annotation != "" ? each.value.annotation : var.annotation
  hold_intvl            = each.value.hold_interval
  rogue_ep_detect_intvl = each.value.rouge_interval
  rogue_ep_detect_mult  = each.value.rouge_multiplier
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epIpAgingP"
 - Distinguished Name: "uni/infra/ipAgingP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ip Aging
_______________________________________________________________________________________________________________________
*/
resource "aci_endpoint_ip_aging_profile" "ip_aging" {
  for_each   = local.ip_aging
  admin_st   = each.value.administrative_state
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "epLoopProtectP"
 - Distinguished Name: "uni/infra/epLoopProtectP-default"
GUI Location:
 - System > System Settings > Endpoint Controls > Ep Loop Protection
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ep_loop_protection" {
  for_each   = local.ep_loop_protection
  dn         = "uni/infra/epLoopProtectP-default"
  class_name = "epLoopProtectP"
  content = {
    action = anytrue(
      [
        each.value.action[0].bd_learn_disable,
        each.value.action[0].port_disable
      ]
      ) ? trim(join(",", compact(concat(
        [length(regexall(true, each.value.action[0].bd_learn_disable)) > 0 ? "bd-learn-disable" : ""
        ], [length(regexall(true, each.value.action[0].port_disable)) > 0 ? "port-disable" : ""]
    ))), ",") : ""
    adminSt = each.value.administrative_state
    # annotation      = each.value.annotation != "" ? each.value.annotation : var.annotation
    loopDetectIntvl = each.value.loop_detection_interval
    loopDetectMult  = each.value.loop_detection_multiplier
  }
}
# resource "aci_endpoint_loop_protection" "example" {
#   for_each          = local.ep_loop_protection
#   action            = each.value.action
#   admin_st          = each.value.administrative_state
#   loop_detect_intvl = each.value.loop_detection_interval
#   loop_detect_mult  = each.value.loop_detection_multiplier
# }