variable "endpoint_controls" {
  default = {
    "default" = {
      annotation = ""
      ep_loop_protection = [{
        action = [{
          bd_learn_disable = false
          port_disable     = false
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
  Key: Name of the APIC Connectivity Preference Map.  This should be default.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * type: COOP protocol is enhanced to support two ZMQ authentication modes:
    - compatible Type: COOP accepts both MD5 authenticated and non-authenticated ZMQ connections for message transportation.
    - strict: COOP allows MD5 authenticated ZMQ connections only.
    Note: The APIC provides a managed object (fabric:SecurityToken), that includes an attribute to be used for the MD5 password. An attribute in this managed object, called "token", is a string that changes every hour. COOP obtains the notification from the DME to update the password for ZMQ authentication. The attribute token value is not displayed.
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