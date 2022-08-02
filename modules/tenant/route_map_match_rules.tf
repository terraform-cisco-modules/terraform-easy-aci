/*_____________________________________________________________________________________________________________________

Tenant — Policies — Route-Map Match Rules — Variables
_______________________________________________________________________________________________________________________
*/
variable "route_map_match_rules" {
  default = {
    "default" = {
      annotation  = ""
      description = ""
      name_alias  = ""
      rules = {
        "default" = {
          community      = ""
          community_type = "regular"
          description    = ""
          greater_than   = 0
          less_than      = 0
          network        = "198.18.0.0/24"
          regex          = ""
          type           = "match_prefix"
        },
      }
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name of the Set Rule.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
    * rules: These are the Match Rules and their Attributes.  Details about attributes for each type are below:
      - type: Type of Match Rule.  Options are:
        * match_community or match_regex_community: These Rule(s) Attributes as follows:
          - community       = "<community_value>" # **Required
          - community_type  = "regular"           # Options are regular and extended
          - description     = ""                  # Optional
          - regex           = "<regex_value>"     # Required for match_regex_community type.
        * match_prefix: Attributes as follows:
          - greater_than  = <value>              # Optional
          - less_than     = <value>              # Optional
          - network       = "<network>/<prefix>" # Required
    * tenant: Name of the Tenant to configure the rules in.
  EOT
  type = map(object(
    {
      annotation  = optional(string)
      description = optional(string)
      name_alias  = optional(string)
      rules = optional(map(object(
        {
          community      = optional(string)
          community_type = optional(string)
          description    = optional(string)
          greater_than   = optional(number)
          less_than      = optional(number)
          network        = optional(string)
          regex          = optional(string)
          type           = string
        }
      )))
      tenant = optional(string)
    }
  ))
}

resource "aci_match_rule" "route_map_match_rules" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each    = local.route_map_match_rules
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
  name_alias  = each.value.name_alias
  tenant_dn   = aci_tenant.tenants[each.value.tenant].id
}

resource "aci_rest_managed" "route_map_rules_match_community" {
  depends_on = [
    aci_match_rule.route_map_match_rules
  ]
  for_each   = { for k, v in local.match_rule_rules : k => v if v.type == "match_community" }
  dn         = "uni/tn-${each.value.tenant}/subj-${each.value.match_rule}/commtrm-${each.value.community}"
  class_name = "rtctrlMatchCommTerm"
  content = {
    descr = each.value.description
    name  = each.value.community
    type  = "community"
  }
}

resource "aci_rest_managed" "route_map_rules_match_regex_community" {
  depends_on = [
    aci_match_rule.route_map_match_rules
  ]
  for_each   = { for k, v in local.match_rule_rules : k => v if v.type == "match_regex_community" }
  dn         = "uni/tn-${each.value.tenant}/subj-${each.value.match_rule}/commrxtrm-${each.value.community_type}"
  class_name = "rtctrlMatchCommRegexTerm"
  content = {
    commType = each.value.community_type # regular|extended
    descr    = each.value.description
    name     = each.value.name
    regex    = each.value.regex
    type     = "community-regex"
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "rtctrlMatchRtDest"
 - Distinguished Name: "/uni/tn-{tenant}/subj-{match_rule}/dest-[{network}]"
GUI Location:
 - Tenants > {tenant} > Networking > Policies > Protocol > Match Rules > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_match_route_destination_rule" "route_map_rules_match_prefix" {
  depends_on = [
    aci_match_rule.route_map_match_rules
  ]
  for_each          = { for k, v in local.match_rule_rules : k => v if v.type == "match_prefix" }
  aggregate         = each.value.greater_than == 0 && each.value.less_than == 0 ? "no" : "yes"
  annotation        = each.value.annotation != "" ? each.value.annotation : var.annotation
  match_rule_dn     = aci_match_rule.route_map_match_rules[each.value.match_rule].id
  greater_than_mask = each.value.greater_than
  ip                = each.value.network
  less_than_mask    = each.value.less_than
}
