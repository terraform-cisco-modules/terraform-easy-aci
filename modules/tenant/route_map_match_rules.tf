variable "route_map_match_rules" {
  default = {
    "default" = {
      alias       = ""
      annotation  = ""
      description = ""
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
      tenant = "common"
    }
  }
  description = <<-EOT
  Key - Name of the Set Rule.
  * alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the alias is a field that can be changed.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
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
      alias       = optional(string)
      annotation  = optional(string)
      description = optional(string)
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
resource "aci_rest" "route_map_match_rules" {
  provider   = netascode
  for_each   = local.route_map_match_rules
  dn         = "uni/tn-${each.value.tenant}/subj-${each.key}"
  class_name = "rtctrlSubjP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr     = each.value.description
    name      = each.key
    nameAlias = each.value.alias
  }
}

resource "aci_rest" "route_map_rules_match_community" {
  provider = netascode
  depends_on = [
    aci_rest.route_map_match_rules
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

resource "aci_rest" "route_map_rules_match_regex_community" {
  provider = netascode
  depends_on = [
    aci_rest.route_map_match_rules
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

resource "aci_rest" "route_map_rules_match_prefix" {
  provider = netascode
  depends_on = [
    aci_rest.route_map_match_rules
  ]
  for_each   = { for k, v in local.match_rule_rules : k => v if v.type == "match_prefix" }
  dn         = "uni/tn-${each.value.tenant}/subj-${each.value.match_rule}/dest-[${each.value.network}]"
  class_name = "rtctrlMatchRtDest"
  content = {
    aggregate = each.value.greater_than == 0 && each.value.less_than == 0 ? "no" : "yes"
    fromPfxLen = each.value.greater_than
    ip         = each.value.network
    toPfxLen   = each.value.less_than
    # type       = "rt-dst"
  }
}
