# resource "aci_rest" "pod_policy_groups" {
#   for_each = local.pod_profiles
#   path       = "/api/node/mo/uni/fabric/funcprof/podpgrp-${each.key}.json"
#   class_name = "fabricPodPGrp"
#   payload    = <<EOF
# {
#   "fabricPodPGrp": {
#     "attributes": {
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/funcprof/podpgrp-${each.key}",
#       "name": "${each.key}"
#     },
#     "children": [
#       {
#         "fabricRsTimePol": {
#           "attributes": {
#             "tnDatetimePolName": "${each.value.date_time_policy}"
#           },
#           "children": []
#         }
#       },
#       {
#         "fabricRsPodPGrpIsisDomP": {
#           "attributes": {
#             "tnIsisDomPolName": "${each.value.isis_policy}"
#           },
#           "children": []
#         }
#       },
#       {
#         "fabricRsPodPGrpCoopP": {
#           "attributes": {
#             "tnCoopPolName": "${each.value.coop_group_policy}"
#           },
#           "children": []
#         }
#       },
#       {
#       "fabricRsPodPGrpBGPRRP": {
#       "attributes": {
#         "tnBgpInstPolName": "${each.value.bgp_route_reflector_policy}"
#       },
#       "children": []
#       }
#       },
#       {
#         "fabricRsCommPol": {
#           "attributes": {
#             "tnCommPolName": "${each.value.management_access_policy}"
#           },
#           "children": []
#         }
#       },
#       {
#         "fabricRsSnmpPol": {
#           "attributes": {
#             "tnSnmpPolName": "${each.value.snmp_policy}"
#           },
#           "children": []
#         }
#       },
#       {
#         "fabricRsMacsecPol": {
#           "attributes": {
#             "tnMacsecFabIfPolName": "${each.value.macsec_policy}"
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }

# resource "aci_rest" "pod_profiles" {
#   depends_on = [
#     aci_rest.pod_policy_groups
#   ]
#   for_each   = local.pod_profiles
#   path       = "/api/node/mo/uni/fabric/podprof-${each.key}/pods-default-typ-ALL/rspodPGrp.json"
#   class_name = "fabricRsPodPGrp"
#   payload    = <<EOF
# {
#   "fabricRsPodPGrp": {
#     "attributes": {
#       "tDn": "uni/fabric/funcprof/podpgrp-${each.key}",
#     },
#     "children": []
#   }
# }
#     EOF
# }
