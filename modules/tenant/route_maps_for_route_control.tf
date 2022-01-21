
variable "route_maps_for_route_control" {
  default = {
    "default" = {
      alias       = ""
      annotation  = ""
      description = ""
      match_rules = {
        "default" = {
          action      = "permit"
          description = ""
          name        = "default"
          order       = 0
          set_rule    = ""
        }
      }
      route_map_continue = "no"
      tenant             = "common"
    }
  }
  type = map(object(
    {
      alias       = optional(string)
      annotation  = optional(string)
      description = optional(string)
      match_rules = optional(map(object(
        {
          action      = string
          description = optional(string)
          name        = string
          order       = number
          set_rule    = optional(string)
        }
      )))
      route_map_continue = optional(string)
      tenant             = optional(string)
    }
  ))
}

resource "aci_rest" "route_maps_for_route_control" {
  provider   = netascode
  for_each   = local.route_maps_for_route_control
  dn         = "uni/tn-${each.value.tenant}/prof-${each.key}"
  class_name = "rtctrlProfile"
  content = {
    # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
    autoContinue = each.value.route_map_continue
    descr        = each.value.description
    name         = each.key
    nameAlias    = each.value.alias
  }
}

resource "aci_rest" "route_maps_contexts" {
  provider = netascode
  depends_on = [
    aci_match_rule.route_map_match_rules
  ]
  for_each   = local.route_maps_context_rules
  dn         = "uni/tn-${each.value.tenant}/prof-${each.value.route_map}/ctx-${each.value.ctx_name}"
  class_name = "rtctrlCtxP"
  content = {
    action = each.value.action
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr = each.value.description
    name  = each.value.name
    order = each.value.order
  }
  child {
    class_name = "rtctrlRsCtxPToSubjP"
    rn         = "rsctxPToSubjP-${each.value.name}"
    content = {
      tnRtctrlSubjPName = each.value.name
    }
  }
}

resource "aci_rest" "route_maps_context_set_rules" {
  provider = netascode
  depends_on = [
    aci_rest.route_map_set_rules,
    aci_rest.route_maps_contexts
  ]
  for_each   = { for k, v in local.route_maps_context_rules : k => v if v.set_rule != "" }
  dn         = "uni/tn-${each.value.tenant}/prof-${each.value.route_map}/ctx-${each.value.ctx_name}/scp"
  class_name = "rtctrlScope"
  content = {
  }
  child {
    class_name = "rtctrlRsScopeToAttrP"
    rn         = "rsScopeToAttrP"
    content = {
      tnRtctrlAttrPName = each.value.set_rule
    }
  }
}
