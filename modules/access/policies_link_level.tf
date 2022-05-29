/*_____________________________________________________________________________________________________________________

Link Level Policy Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_link_level" {
  default = {
    "default" = {
      annotation                  = ""
      auto_negotiation            = true
      description                 = ""
      forwarding_error_correction = "inherit"
      global_alias                = ""
      link_debounce_interval      = 100
      speed                       = "inherit"
    }
  }
  description = <<-EOT
  Key: Name of the Link Level Policy.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * auto_negotiation: (Default value is true).  Policy auto negotiation for object fabric if pol. Allowed values:
    - off
    - on
    - on-enforce
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * global_alias: A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
  * forwarding_error_correction: (Default value is "inherit").  Forwarding error correction for object fabric if pol. Allowed values: 
    - inherit
    - cl91-rs-fec
    - cl74-fc-fec
    - ieee-rs-fec
    - cons16-rs-fec
    - kp-fec
    - disable-fec
  * link_debounce_interval: (Default value is 100).  Link debounce interval for object fabric if pol. Range of allowed values: 0-5000.
  * speed: (Default value is "inherit").  Port speed for object fabric if pol. Allowed values: 
    - unknown
    - 100M
    - 1G
    - 10G
    - 25G
    - 40G
    - 50G
    - 100G
    - 200G
    - 400G
    * inherit
  EOT
  type = map(object(
    {
      annotation                  = optional(string)
      auto_negotiation            = optional(string)
      description                 = optional(string)
      forwarding_error_correction = optional(string)
      global_alias                = optional(string)
      link_debounce_interval      = optional(number)
      speed                       = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricHIfPol"
 - Distinguished Name: "uni/infra/hintfpol-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_fabric_if_pol" "policies_link_level" {
  for_each      = local.policies_link_level
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
  auto_neg      = each.value.auto_negotiation
  description   = each.value.description
  fec_mode      = each.value.forwarding_error_correction
  link_debounce = each.value.link_debounce_interval
  name          = each.key
  speed         = each.value.speed
}
