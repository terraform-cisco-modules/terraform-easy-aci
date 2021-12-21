#------------------------------------------
# Create Attachable Access Entity Profiles
#------------------------------------------

/*
API Information:
 - Class: "infraAttEntityP"
 - Distinguished Name: "uni/infra/attentp-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Attachable Access Entity Profiles : {name}
*/
resource "aci_attachable_access_entity_profile" "attachable_access_entity_profiles" {
  depends_on = [
    aci_l3_domain_profile.layer3_domains,
    aci_physical_domain.physical_domains,
    aci_vmm_domain.vmm_domains
  ]
  for_each    = local.attachable_access_entity_profiles
  description = each.value.description
  name        = each.key
  relation_infra_rs_dom_p = [each.value.domains]
}

/*
API Information:
 - Class: "edrErrDisRecoverPol"
 - Distinguished Named "uni/infra/edrErrDisRecoverPol-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > Error Disabled Recovery Policy
*/
resource "aci_rest" "Error_Disable_Recovery" {
  path       = "/api/node/mo/uni/infra/edrErrDisRecoverPol-default.json"
  class_name = "edrErrDisRecoverPol"
  payload    = <<EOF
{
    "edrErrDisRecoverPol": {
        "attributes": {
            "dn": "uni/infra/edrErrDisRecoverPol-default",
            "errDisRecovIntvl": "{{Recovery_Interval}}"
        },
        "children": [
            {
                "edrEventP": {
                    "attributes": {
                        "event": "event-bpduguard",
                        "recover": "{{BPDU_Guard}}"
                    }
                }
            },
            {
                "edrEventP": {
                    "attributes": {
                        "event": "event-ep-move",
                        "recover": "{{EP_Move}}"
                    }
                }
            },
            {
                "edrEventP": {
                    "attributes": {
                        "event": "event-mcp-loop",
                        "recover": "{{MCP_Loop}}"
                    }
                }
            }
        ]
    }
}
    EOF
}
resource "aci_error_disable_recovery" "example" {
  annotation          = "orchestrator:terraform"
  err_dis_recov_intvl = "300"
  name_alias          = "error_disable_recovery_alias"
  description         = "From Terraform"
  edr_event {
    event             = "event-mcp-loop"
    recover           = "yes"
    description       = "From Terraform"
    name_alias        = "event_alias"
    name              = "example"
    annotation        = "orchestrator:terraform"
  }
}

/*
- This Resource File will create Recommended Default Policies Based on the Best Practice Wizard and additional Best Practices
*/

/*
API Information:
 - Class: "mcpInstPol"
 - Distinguished Named "uni/infra/mcpInstP-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > MCP Instance Policy Default
*/
resource "aci_rest" "MCP_Instance_Policy_Default" {
  path       = "/api/node/mo/uni/infra/mcpInstP-default.json"
  class_name = "mcpInstPol"
  payload    = <<EOF
{
    "mcpInstPol": {
        "attributes": {
            "adminSt": "{{Admin_State}}",
            "ctrl": "{{Control}}",
            "descr": "{{Description}}",
            "dn": "uni/infra/mcpInstP-default",
            "initDelayTime": "{{Initial_Delay}}",
            "key": "${var.mcp_instance_password}",
            "loopDetectMult": "{{Detect_Multiplier}}",
            "loopProtectAct": "{{Loop_Action}}",
            "txFreq": "{{Frequency_Seconds}}",
            "txFreqMsec": "{{Frequency_msec}}",
        },
        "children": []
    }
},
    EOF
}
resource "aci_mcp_instance_policy" "example" {
  admin_st         = "disabled"
  annotation       = "orchestrator:terraform"
  name_alias       = "mcp_instance_alias"
  description      = "From Terraform"
  ctrl             = []
  init_delay_time  = "180"
  key              = "example"
  loop_detect_mult = "3"
  loop_protect_act = "port-disable"
  tx_freq          = "2"
  tx_freq_msec     = "0"
}
/*
API Information:
 - Class: "qosInstPol"
 - Distinguished Name: "uni/infra/qosinst-default"
GUI Location:
 - Fabric > Access Policies > Policies > Global > QOS Class

*/
resource "aci_rest" "Preserve_CoS" {
  path       = "/api/node/mo/uni/infra/qosinst-default.json"
  class_name = "qosInstPol"
  payload    = <<EOF
{
    "qosInstPol": {
        "attributes": {
            "dn": "uni/infra/qosinst-default",
            "ctrl": "{{Preserve_CoS}}"
        }
    }
}
    EOF
}
resource "aci_qos_instance_policy" "example" {
  name_alias            = "qos_instance_alias"
  description           = "From Terraform"
  etrap_age_timer       = "0" 
  etrap_bw_thresh       = "0"
  etrap_byte_ct         = "0"
  etrap_st              = "no"
  fabric_flush_interval = "500"
  fabric_flush_st       = "no"
  annotation            = "orchestrator:terraform"
  ctrl                  = "none"
  uburst_spine_queues   = "10"
  uburst_tor_queues     = "10"
}