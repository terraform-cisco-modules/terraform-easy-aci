# resource "aci_rest" "date_and_time" {
#   for_each   = local.date_and_time
#   path       = "/api/node/mo/uni/fabric/time-${each.key}.json"
#   class_name = "datetimePol"
#   payload    = <<EOF
# {
#   "datetimePol": {
#     "attributes": {
#       "adminSt": "${each.value.administrative_state}",
#       "authSt": "${each.value.authentication_state}",
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/time-${each.key}",
#       "masterMode": "${each.value.master_mode}",
#       "name": "${each.key}",
#       "serverState": "${each.value.server_state}",
#       "StratumValue": "${each.value.stratum_value}"
#     }
#   }
# }
#   EOF
# }

# resource "aci_rest" "ntp_authentication_keys" {
#   depends_on = [
#     aci_rest.date_and_time
#   ]
#   for_each   = local.ntp_authentication_keys
#   path       = "/api/node/mo/uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}.json"
#   class_name = "datetimeNtpAuthKey"
#   payload    = <<EOF
# {
#   "datetimeNtpAuthKey": {
#     "attributes": {
#       "dn": "uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}",
#       "id": "${each.value.key_id}",
#       "key": "${var.sensitive_var}",
#       "keyType": "${each.value.authentication_type}"
#     },
#   }
# }
#   EOF
# }

# resource "aci_rest" "ntp_servers" {
#   depends_on = [
#     aci_rest.date_and_time
#   ]
#   for_each   = local.ntp_servers
#   path       = "/api/node/mo/uni/fabric/time-${each.value.key1}/ntpprov-${each.value.ntp_server}.json"
#   class_name = "datetimeNtpProv"
#   payload    = <<EOF
# {
#   "datetimeNtpProv": {
#     "attributes": {
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/time-${each.value.key1}/ntpprov-${each.value.ntp_server}",
#       "keyId": "${each.value.authentication_key}",
#       "maxPoll": "${each.value.maximum_polling_interval}",
#       "minPoll": "${each.value.minimum_polling_interval}",
#       "name": "${each.value.ntp_server}",
#       "preferred": "${each.value.preferred}",
#       "trueChimer": "disabled",
#     },
#     "children": [
#       {
#         "datetimeRsNtpProvToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#     EOF
# }
