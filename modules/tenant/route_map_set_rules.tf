/*_____________________________________________________________________________________________________________________

Tenant — Policies — Route-Map Set Rules — Variables
_______________________________________________________________________________________________________________________
*/
variable "route_map_set_rules" {
  default = {
    "default" = {
      annotation  = ""
      description = ""
      name_alias  = ""
      rules = [
        {
          address = "198.18.0.1"
          asns    = []
          communities = {
            "default" = {
              community    = ""
              description  = ""
              set_criteria = "append" # append|none|replace
            }
          }
          criteria          = "prepend" # prepend|prepend-last-as
          half_life         = 15
          last_as_count     = 0
          max_suprress_time = 60
          metric            = 100
          metric_type       = "ospf-type1" # ospf-type1|ospf-type2
          preference        = 100
          reuse_limit       = 750
          suppress_limit    = 2000
          route_tag         = 1
          type              = "set_metric"
          weight            = 0
        },
      ]
      tenant = "common"
    }
  }
  description = <<-EOT
  Key - Name of the Set Rule.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  * rules: These are the Set Rules and their Attributes.  Details about attributes for each type are below:
    - type: Type of Set Rule.  Options are:
      * additional_communities or set_communities: These Rule(s) Attributes as follows:
        - **Note: Only one community can be added to the set_community type.
        - communities = [
            {
              community    = "<community_value>" # **Required
              description  = ""                  # Optional with type additional_communities
              set_criteria = "append"            # options are append, none, replace
            }
          ]
      * multipath: The multipath type doesn't have any attributes but you must also add set_next_hop_unchanged.
      * set_as_path: Attributes as follows:
        - asns          = [1, 2, 3]     # List of ASN's to add when criteria is set to "prepend"
        - criteria      = "prepend"     # Options are prepend or prepend-last-as
        - last_as_count = 0             # The number of times to prepend the last-asn when criteria is set to prepend-last-as
      * set_dampening: Attributes as follows:
        - half-life         = 15   # Range is 1-60
        - max_suppress_time = 60   # Range is 1-255
        - reuse_limit       = 750  # Range is 1-20000
        - suppress_limit    = 2000 # Range is 1-20000
      * set_metric: Attributes as follows:
        - metric = 1 # The Minimum Metric is 1
      * set_metric_type: Attributes as follows:
        - metric_type = "ospf-type1" # Options are ospf-type1 and ospf-type2
      * set_next_hop: Attributes as follows:
        - address = "198.18.0.1" # The Next Hop IP Address
      * set_next_hop_unchanged: This rule doesn't have any attributes.
      * set_preference: Attributes as follows:
        - preference = 100 # Assign Route Preference to the Rule
      * set_route_tag: Attributes as follows:
        - route_tag = 1 # Tag to Assign to Routes
      * weight: Attributes as follows:
        - address = 0 # Weight to assign to routes
  * tenant: Name of the Tenant to configure the rules in.
  EOT
  type = map(object(
    {
      annotation  = optional(string)
      description = optional(string)
      name_alias  = optional(string)
      rules = list(object(
        {
          address = optional(string)
          asns    = optional(list(string))
          communities = optional(map(object(
            {
              community    = string
              description  = optional(string)
              set_criteria = optional(string)
            }
          )))
          criteria          = optional(string)
          half_life         = optional(number)
          last_as_count     = optional(number)
          max_suprress_time = optional(number)
          metric            = optional(number)
          metric_type       = optional(string)
          preference        = optional(number)
          reuse_limit       = optional(number)
          route_tag         = optional(number)
          suppress_limit    = optional(number)
          type              = string
          weight            = optional(number)
        },
      ))
      tenant = optional(string)
    }
  ))
}
resource "aci_rest_managed" "route_map_set_rules" {
  for_each   = local.route_map_set_rules
  dn         = "uni/tn-${each.value.tenant}/attr-${each.key}"
  class_name = "rtctrlAttrP"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr     = each.value.description
    name      = each.key
    nameAlias = each.value.name_alias
  }
}

resource "aci_rest_managed" "route_map_rules_additional_communities" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_communities : k => v if v.type == "additional_communities" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/saddcomm-${each.value.community}"
  class_name = "rtctrlSetAddComm"
  content = {
    community   = each.value.community
    descr       = each.value.description
    setCriteria = each.value.set_criteria # append|none|replace
    type        = "community"
  }
}

resource "aci_rest_managed" "route_map_rules_multipath" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "multipath" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/redistmpath"
  class_name = "rtctrlSetRedistMultipath"
  content = {
    type = "redist-multipath"
  }
}

resource "aci_rest_managed" "route_map_rules_set_as_path" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_asn_rules : k => v if v.type == "set_as_path" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/saspath-${each.value.set_criteria}"
  class_name = "rtctrlSetASPath"
  content = {
    criteria = each.value.criteria # prepend|prepend-last-as
    lastnum  = each.value.criteria == "prepend-last-as" ? each.value.last_as_count : 0
    type     = "as-path"
  }
  dynamic "child" {
    for_each = each.value.autonomous_systems
    content {
      class_name = "rtctrlSetASPathASN"
      rn         = "asn-${child.value.order}"
      content = {
        asn   = child.value.asn
        order = child.value.order
      }
    }
  }
}

resource "aci_rest_managed" "route_map_rules_set_communities" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_communities : k => v if v.type == "set_communities" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/scomm"
  class_name = "rtctrlSetComm"
  content = {
    community   = each.value.community
    setCriteria = each.value.set_criteria # append|none|replace
    type        = "community"
  }
}

resource "aci_rest_managed" "route_map_rules_set_dampening" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_dampening" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/sdamp"
  class_name = "rtctrlSetDamp"
  content = {
    halfLife        = each.value.half_life         # 15 1-60
    maxSuppressTime = each.value.max_suppress_time # 60 1-255
    reuse           = each.value.reuse_limit       # 750 1-20000
    suppress        = each.value.suppress_limit    # 2000 1-20000
    type            = "dampening-pol"
  }
}

resource "aci_rest_managed" "route_map_rules_set_metric" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_metric" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/smetric"
  class_name = "rtctrlSetRtMetric"
  content = {
    metric = each.value.metric # 1 minimum
    type   = "metric"
  }
}

resource "aci_rest_managed" "route_map_rules_set_metric_type" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_metric_type" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/smetrict"
  class_name = "rtctrlSetRtMetricType"
  content = {
    metricType = each.value.metric_type # ospf-type1|ospf-type2
    type       = "metric-type"
  }
}

resource "aci_rest_managed" "route_map_rules_set_next_hop" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_next_hop" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/nh"
  class_name = "rtctrlSetNh"
  content = {
    addr = each.value.address
    type = "ip-nh"
  }
}

resource "aci_rest_managed" "route_map_rules_set_next_hop_unchanged" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_next_hop_unchanged" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/nhunchanged"
  class_name = "rtctrlSetNhUnchanged"
  content = {
    type = "nh-unchanged"
  }
}

resource "aci_rest_managed" "route_map_rules_set_preference" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_preference" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/spref"
  class_name = "rtctrlSetPref"
  content = {
    localPref = each.value.preference # 
    type      = "local-pref"
  }
}

# resource "aci_l3out_route_tag_policy" "example" {
#   depends_on = [
#     aci_rest_managed.route_map_set_rules
#   ]
#   for_each = { for k, v in local.set_rule_rules : k => v }
#   # for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_route_tag" }
#   tenant_dn   = aci_tenant.tenants[each.value.tenant].id
#   annotation  = "example"
#   description = "from terraform"
#   name        = "example"
#   name_alias  = "example"
#   tag         = 1
# }

resource "aci_rest_managed" "route_map_rules_set_route_tag" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_route_tag" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/srttag"
  class_name = "rtctrlSetTag"
  content = {
    tag  = each.value.route_tag
    type = "rt-tag"
  }
}

resource "aci_rest_managed" "route_map_set_weight" {
  depends_on = [
    aci_rest_managed.route_map_set_rules
  ]
  for_each   = { for k, v in local.set_rule_rules : k => v if v.type == "set_weight" }
  dn         = "uni/tn-${each.value.tenant}/attr-${each.value.set_rule}/sweight"
  class_name = "rtctrlSetWeight"
  content = {
    weight = each.value.weight
    type   = "rt-weight"
  }
}
