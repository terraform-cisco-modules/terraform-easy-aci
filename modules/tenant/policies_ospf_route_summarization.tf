variable "ospf_route_summarization_policies" {
  default = {
    "default" = {
      alias              = ""
      annotation         = ""
      cost               = 0
      description        = ""
      inter_area_enabled = false
      tenant             = "common"
    }
  }
  description = <<-EOT
  Key - Name of the OSPF Route Summarization Policy.
  * alias - (Optional) Name alias for object OSPF route summarization.
  * annotation - (Optional) Annotation for object OSPF route summarization.
  * cost - (Optional) The OSPF Area cost for the default summary LSAs. The Area cost is used with NSSA and stub area types only. Range of allowed values is "0" to "16777215". Default value: "unspecified".
  * description - Description for for object OSPF route summarization.
  * inter_area_enabled - (Optional) Inter area enabled flag for object OSPF route summarization. Allowed values: "no", "yes". Default value: "no".
  * tag - (Optional) The color of a policy label. Default value: "0".
  * tenant - (Required) Distinguished name of parent tenant object.
  EOT
  type = map(object(
    {
      alias              = optional(string)
      annotation         = optional(string)
      cost               = optional(number)
      description        = optional(string)
      inter_area_enabled = optional(bool)
      tenant             = optional(string)
    }
  ))
}


resource "aci_ospf_route_summarization" "ospf_route_summarization_policies" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each = local.ospf_route_summarization_policies
  # annotation         = each.value.annotation != "" ? each.value.annotation : var.annotation
  cost               = each.value.cost == 0 ? "unspecified" : each.value.cost # 0 to 16777215
  description        = each.value.description
  inter_area_enabled = each.value.inter_area_enabled == true ? "yes" : "no"
  name               = each.key
  name_alias         = each.value.alias
  tag                = 0
  tenant_dn          = aci_tenant.tenants[each.value.tenant].id
}
