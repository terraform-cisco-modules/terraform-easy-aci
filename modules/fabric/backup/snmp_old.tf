
# resource "aci_rest" "snmp" {
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}.json"
#   class_name = "snmpPol"
#   payload    = <<EOF
# {
#   "snmpPol": {
#     "attributes": {
#       "adminSt": "{admin_state}",
#       "contact": "{contact}",
#       "descr": "{description}",
#       "dn": "uni/fabric/snmppol-{snmp_policy}",
#       "loc": "{location}",
#       "name": "{snmp_policy}"
#     },
#     "children": []
#   }
# }
#   EOF
# }

# resource "aci_rest" "snmp_client_groups" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}.json"
#   class_name = "snmpClientGrpP"
#   payload    = <<EOF
# {
#   "snmpClientGrpP": {
#     "attributes": {
#       "descr": "{description}",
#       "dn": "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}",
#       "name": "{client_group}",
#     },
#     "children": [
#       {
#         "snmpRsEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#   EOF
# }

# resource "aci_rest" "snmp_policy_{snmp_policy}_client_group_{client_group}_Client_{SNMP_Client_}" {
#   depends_on = [
#     aci_rest.snmp_policies,
#     aci_rest.snmp_client_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}/client-[{SNMP_Client}].json"
#   class_name = "snmpClientP"
#   payload    = <<EOF
# {
#   "snmpClientP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/clgrp-{client_group}/client-[{SNMP_Client}]",
#       "name": "{SNMP_Client_Name}",
#       "addr": "{SNMP_Client}",
#     },
#     "children": []
#   }
# }
#   EOF
# }

# resource "aci_rest" "snmp_policies_communities" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-${each.value.key1}/community-${var.sensitive_var}.json"
#   class_name = "snmpCommunityP"
#   payload    = <<EOF
# {
#   "snmpCommunityP": {
#     "attributes": {
#       "descr": "{Description}"
#       "dn": "uni/fabric/snmppol-{snmp_policy}/community-${var.sensitive_var}",
#       "name": "${var.sensitive_var}",
#     },
#     "children": []
#   }
# }
#   EOF
# }

# resource "aci_rest" "snmp_policy_{snmp_policy}_V3_User_{snmp_user}" {
#   depends_on = [
#     aci_rest.snmp_policies
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}.json"
#   class_name = "snmpUserP"
#   payload    = <<EOF
# {
#   "snmpUserP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/user-{snmp_user}",
#       "name": "{snmp_user}",
#       "privType": "{Privacy_Type}",
#       "privKey": "${var.sensitive_var1}",
#       "authType": "{Authorization_Type}",
#       "authKey": "${var.sensitive_var2}"
#     },
#     "children": []
#   }
# }
#   EOF
# }

# resource "aci_rest" "snmp_trap_destination_groups" {
#   path       = "/api/node/mo/uni/fabric/snmpgroup-${each.key}.json"
#   class_name = "snmpGroup"
#   payload    = <<EOF
# {
#   "snmpGroup": {
#     "attributes": {
#       "dn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}",
#       "descr": "{Description}",
#       "name": "{SNMP_Trap_DG}"
#     }
#   }
# }
#   EOF
# }

# resource "aci_rest" "SNMP_Trap_DestGrp_{SNMP_Trap_DG}_Receiver_{Trap_Server_}" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmpgroup-{SNMP_Trap_DG}/trapdest-{Trap_Server}-port-{Destination_Port}.json"
#   class_name = "snmpTrapDest"
#   payload    = <<EOF
# {
#   "snmpTrapDest": {
#     "attributes": {
#       "dn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}/trapdest-{Trap_Server}-port-{Destination_Port}",
#       "host": "{Trap_Server}",
#       "port": "{Destination_Port}",
#       "secName": "{Community_or_Username}",
#       "v3SecLvl": "{Security_Level}",
#       "ver": "{Version}",
#     },
#     "children": [
#       {
#         "fileRsARemoteHostToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#   EOF
# }


# resource "aci_rest" "snmp_policy_{snmp_policy}_Trap_Server_{Trap_Server_}" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}].json"
#   class_name = "snmpTrapFwdServerP"
#   payload    = <<EOF
# {
#   "snmpTrapFwdServerP": {
#     "attributes": {
#       "dn": "uni/fabric/snmppol-{snmp_policy}/trapfwdserver-[{Trap_Server}]",
#       "addr": "{Trap_Server}",
#       "port": "{Destination_Port}"
#     },
#     "children": []
#   }
# }
#   EOF
# }


# resource "aci_rest" "SNMP_Trap_Source" {
#   depends_on = [
#     aci_rest.snmp_trap_destination_groups
#   ]
#   path       = "/api/node/mo/uni/fabric/moncommon/snmpsrc-{SNMP_Source}.json"
#   class_name = "snmpSrc"
#   payload    = <<EOF
# {
#   "snmpSrc": {
#     "attributes": {
#       "dn": "uni/fabric/moncommon/snmpsrc-{SNMP_Source}",
#       "incl": "{Included_Types}",
#       "name": "{SNMP_Source}",
#     },
#     "children": [
#       {
#         "snmpRsDestGroup": {
#           "attributes": {
#             "tDn": "uni/fabric/snmpgroup-{SNMP_Trap_DG}",
#           },
#           "children": []
#         }
#       }
#     ]
#   }
# }
#   EOF
# }
