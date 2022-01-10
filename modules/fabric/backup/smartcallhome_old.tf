# resource "aci_rest" "smart_callhome_destination_groups" {
#   for_each   = local.smart_callhome_destination_groups
#   path       = "/api/node/mo/uni/fabric/smartgroup-${each.key}.json"
#   class_name = "callhomeSmartGroup"
#   payload    = <<EOF
# {
#   "callhomeSmartGroup": {
#     "attributes": {
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/smartgroup-${each.key}",
#       "name": "${each.key}",
#     },
#     "children": [
#       {
#         "callhomeProf": {
#           "attributes": {
#             "addr": "${each.value.street_address}",
#             "contract": "${each.value.contract_id}",
#             "contact": "${each.value.contact_information}",
#             "customer": "${each.value.customer_id}",
#             "dn": "uni/fabric/smartgroup-${each.key}/prof",
#             "email": "${each.value.customer_contact_email}",
#             "from": "${each.value.from_email}",
#             "replyTo": "${each.value.reply_to_email}",
#             "phone": "${each.value.phone_contact}",
#             "port": "${each.value.port_number}",
#             "site": "${each.value.site_id}",
#             "rn": "prof"
#           },
#           "children": [
#             {
#               "callhomeSmtpServer": {
#                 "attributes": {
#                   "dn": "uni/fabric/smartgroup-${each.key}/prof/smtp",
#                   "host": "${each.value.smtp_server}",
#                   "rn": "smtp"
#                 },
#                 "children": [
#                   {
#                     "fileRsARemoteHostToEpg": {
#                       "attributes": {
#                         "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#                       },
#                       "children": []
#                     }
#                   }
#                 ]
#               }
#             }
#           ]
#         }
#       }
#     ]
#   }
# }
#   EOF
# }


# resource "aci_rest" "smart_callhome_destinations" {
#   depends_on = [
#     aci_rest.smart_callhome_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/smartgroup-${each.key}.json"
#   class_name = "callhomeSmartDest"
#   payload    = <<EOF
# {
#   "callhomeSmartDest": {
#     "attributes": {
#       "adminState": "${each.value.admin_state}"
#       "dn": "uni/fabric/smartgroup-${each.key}/smartdest-${each.value.receiver}",
#       "email": "${each.value.email}",
#       "format": "${each.value.format}",
#       "name": "${each.value.receiver}",
#       "rfcCompliant": "${each.value.rfc_compliant}",
#     },
#     "children": []
#   }
# }
#   EOF
# }


# resource "aci_rest" "smart_callhome_sources" {
#   depends_on = [
#     aci_rest.smart_callhome_destination_groups
#   ]
#   path       = "/api/node/mo/uni/infra/moninfra-default/smartchsrc.json"
#   class_name = "callhomeSmartSrc"
#   payload    = <<EOF
# {
#   "callhomeSmartSrc": {
#     "attributes": {
#       "dn": "uni/infra/moninfra-default/smartchsrc",
#     },
#     "children": [
#       {
#         "callhomeRsSmartdestGroup": {
#           "attributes": {
#             "tDn": "uni/fabric/smartgroup-{DestGrp_Name}"
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }
