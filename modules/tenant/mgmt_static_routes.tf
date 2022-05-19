# resource "aci_rest_managed" "mgmt_epg_static_routes" {
#   depends_on = [
#     aci_node_mgmt_epg.mgmt_epgs
#   ]
#   for_each   = local.mgmt_epg_static_routes
#   dn         = "uni/tn-mgmt/mgmtp-default/${each.value.epg_type}-${each.value.name}/staticroute-[${each.value.static_route}]"
#   class_name = "mgmtStaticRoute"
#   content = {
#     prefix = each.value.static_route
#   }
# }

