
/*_____________________________________________________________________________________________________________________

Tenant — Policies — Route-Maps for Route Control — Variables
_______________________________________________________________________________________________________________________
*/
variable "route_maps_for_route_control" {
  default = {
    "default" = {
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
      route_map_continue = false
      /*  If undefined the variable of local.first_tenant will be used for:
      tenant = local.folder_tenant
      */
    }
  }
  type = map(object(
    {
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
      route_map_continue = optional(bool)
      tenant             = optional(string)
    }
  ))
}

resource "aci_rest_managed" "route_maps_for_route_control" {
  for_each   = local.route_maps_for_route_control
  dn         = "uni/tn-${each.value.tenant}/prof-${each.key}"
  class_name = "rtctrlProfile"
  content = {
    # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
    autoContinue = each.value.route_map_continue == true ? "yes" : "no"
    descr        = each.value.description
    name         = each.key
  }
}

resource "aci_rest_managed" "route_maps_contexts" {
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

resource "aci_rest_managed" "route_maps_context_set_rules" {
  depends_on = [
    aci_rest_managed.route_map_set_rules,
    aci_rest_managed.route_maps_contexts
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
