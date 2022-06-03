/*_____________________________________________________________________________________________________________________

Policies — Link Level — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_link_level" {
  default = {
    "default" = {
      annotation                  = ""
      auto_negotiation            = "on"
      description                 = ""
      forwarding_error_correction = "inherit"
      global_alias                = ""
      link_debounce_interval      = 100
      speed                       = "inherit"
    }
  }
  description = <<-EOT
    Key — Name of the Link Level Policy.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * auto_negotiation: (optional) — Policy auto negotiation for object fabric if pol. Allowed values:
      - off
      - on: (default)
      - on-enforce
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * global_alias: (optional) — A label, unique within the fabric, that can serve as a substitute for an object's Distinguished Name (DN).  A global alias must be unique accross the fabric.
    * forwarding_error_correction: (optional) — Forwarding error correction for object fabric if pol. Allowed values: 
      - inherit: (default)
      - cl91-rs-fec
      - cl74-fc-fec
      - ieee-rs-fec
      - cons16-rs-fec
      - kp-fec
      - disable-fec
    * link_debounce_interval: (default: 100) — Link debounce interval for object fabric if pol. Range of allowed values: 0-5000.
    * speed: (optional) — Port speed for object fabric if pol. Allowed values: 
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
      - inherit: (optional)
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

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "tagAliasInst"
 - Distinguished Name: "uni/infra/hintfpol-{name}/alias"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Link Level : {name}: alias

_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "policies_link_level_global_alias" {
  depends_on = [
    aci_fabric_if_pol.policies_link_level,
  ]
  for_each   = local.policies_link_level_global_alias
  class_name = "tagAliasInst"
  dn         = "uni/infra/hintfpol-${each.key}"
  content = {
    name = each.value.global_alias
  }
}
