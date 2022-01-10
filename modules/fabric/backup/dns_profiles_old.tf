# resource "aci_rest" "dns_profiles" {
#   for_each   = local.dns_profiles
#   path       = "/api/node/mo/uni/fabric/dnsp-${each.key}.json"
#   class_name = "dnsProfile"
#   payload    = <<EOF
# {
#   "dnsProfile": {
#     "attributes": {
#       "IPVerPreference": "${each.value.ip_version_preference}",
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/dnsp-${each.key}",
#       "name": "${each.key}"
#     },
#     "children": [
#       {
#         "dnsRsProfileToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       },
#     ]
#   }
# }
#   EOF
# }
# resource "aci_rest" "dns_providers" {
#   depends_on = [
#     aci_rest.dns_profiles
#   ]
#   for_each   = local.dns_providers
#   path       = "/api/node/mo/uni/fabric/dnsp-${each.value.key1}/prov-[${each.value.dns_provider}].json"
#   class_name = "dnsProv"
#   payload    = <<EOF
# {
#   "dnsProv": {
#     "attributes": {
#       "addr": "${each.value.dns_provider}",
#       "dn": "uni/fabric/dnsp-${each.value.key1}/prov-[${each.value.dns_provider}]",
#       "preferred": "${each.value.preferred}",
#     },
#     "children": []
#   }
# }
#   EOF
# }
# resource "aci_rest" "dns_domains" {
#   depends_on = [
#     aci_rest.dns_profiles
#   ]
#   for_each   = local.dns_domains
#   path       = "/api/node/mo/uni/fabric/dnsp-${each.value.key1}/dom-[${each.value.domain}].json"
#   class_name = "dnsDomain"
#   payload    = <<EOF
# {
#   "dnsDomain": {
#     "attributes": {
#       "descr": "${each.value.description}"
#       "dn": "uni/fabric/dnsp-${each.value.key1}/dom-[${each.value.domain}]",
#       "isDefault": "${each.value.default}",
#       "name": "${each.value.domain}"
#     },
#     "children": []
#   }
# }
#     EOF
# }
