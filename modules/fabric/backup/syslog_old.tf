# resource "aci_rest" "syslog_destination_groups" {
#   path       = "/api/node/mo/uni/fabric/slgroup-${each.key}.json"
#   class_name = "syslogGroup"
#   payload    = <<EOF
# {
#   "syslogGroup": {
#     "attributes": {
#       "adminState": "${each.value.admin_state}",
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/slgroup-${each.key}",
#       "format": "${each.value.format}",
#       "includeMilliSeconds": "${each.value.show_milliseconds_in_timestamp}",
#       "includeTimeZone": "${each.value.show_time_zone_in_timestamp}",
#       "name": "${each.key}",
#       "rn": "slgroup-${each.key}"
#     },
#     "children": [
#       {
#         "syslogConsole": {
#           "attributes": {
#             "dn": "uni/fabric/slgroup-${each.key}/console",
#             "adminState": "${each.value.console_admin_state}",
#             "severity": "${each.value.console_severity}",
#             "rn": "console"
#           },
#           "children": []
#         }
#       },
#       {
#         "syslogFile": {
#           "attributes": {
#             "dn": "uni/fabric/slgroup-${each.key}/file",
#             "adminState": "${each.value.local_admin_state}",
#             "severity": "${each.value.local_severity}",
#             "rn": "file"
#           },
#           "children": []
#         }
#       },
#       {
#         "syslogProf": {
#           "attributes": {
#             "dn": "uni/fabric/slgroup-${each.key}/prof",
#             "rn": "prof"
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }

# resource "aci_rest" "syslog_remote_destinations" {
#   depends_on = [
#     aci_rest.syslog_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/slgroup-${each.key}/rdst-{syslog_server}.json"
#   class_name = "syslogRemoteDest"
#   payload    = <<EOF
# {
#   "syslogRemoteDest": {
#     "attributes": {
#       "dn": "uni/fabric/slgroup-${each.key}/rdst-${each.value.syslog_server}",
#       "forwardingFacility": "${each.value.forwarding_facility}",
#       "host": "${each.value.syslog_server}",
#       "name": "${each.value.syslog_server}",
#       "port": "${each.value.port}",
#       "severity": "${each.value.severity}",
#     },
#     "children": [
#       {
#         "fileRsARemoteHostToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#     EOF
# }


# resource "aci_rest" "syslog_sources" {
#   depends_on = [
#     aci_rest.syslog_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/moncommon/slsrc-${each.value.key1}.json"
#   class_name = "syslogSrc"
#   payload    = <<EOF
# {
#   "syslogSrc": {
#     "attributes": {
#       "dn": "uni/fabric/moncommon/slsrc-${each.value.key1}",
#       "name": "${each.value.key1}",
#       "incl": "${each.value.included_types}",
#       "minSev": "${each.value.min_severity}",
#       "rn": "slsrc-${each.value.key1}",
#     },
#     "children": [
#       {
#         "syslogRsDestGroup": {
#           "attributes": {
#             "tDn": "uni/fabric/slgroup-${each.value.key1}",
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }
