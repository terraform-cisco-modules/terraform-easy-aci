# aci_bgp_route_control_profile
# Manages ACI BGP Route Control Profile
# 
# Example Usage
resource "aci_bgp_route_control_profile" "example" {
  parent_dn                  = aci_l3_outside.example.id
  name                       = "bgp_route_control_profile_1"
  annotation                 = "bgp_route_control_profile_tag"
  description                = "from terraform"
  name_alias                 = "example"
  route_control_profile_type = "global"
}
# Argument Reference
# parent_dn - (Required) Distinguished name of the parent object.
# name - (Required) Name of router control profile object.
# annotation - (Optional) Annotation for router control profile object.
# description - (Optional) Description for router control profile object.
# name_alias - (Optional) Name name_alias for router control profile object.
# route_control_profile_type - (Optional) Component type for router control profile object. Allowed values are "combinable" and "global". Default value is "combinable".


# Manages ACI Route Control Context
# 
# API Information
# Class - rtctrlCtxP
# Distinguished Named - uni/tn-{name}/prof-{name}/ctx-{name}
# GUI Information
# Location - Tenant -> Policies -> Protocol -> Route Maps for Route Control
# Example Usage
resource "aci_route_control_context" "control" {
  route_control_profile_dn           = aci_bgp_route_control_profile.bgp.id
  name                               = "control"
  action                             = "permit"
  annotation                         = "orchestrator:terraform"
  order                              = "0"
  set_rule                           = aci_action_rule_profile.set_rule1.id
  relation_rtctrl_rs_ctx_p_to_subj_p = [aci_match_rule.rule.id]
}
# Argument Reference
# route_control_profile_dn - (Required) Distinguished name of parent Route Control Profile object.
# name - (Required) Name of object Route Control Context.
# annotation - (Optional) Annotation of object Route Control Context.
# action - (Optional) Action. The action required when the condition is met. Allowed values are "deny", "permit", and default value is "permit". Type: String.
# order - (Optional) Local Order.The order of the policy context. Allowed range is 0-9 and default value is "0".
# set_rule - (Optional) Represents the relation to an Attribute Profile (class rtctrlAttrP). Type: String.
# relation_rtctrl_rs_ctx_p_to_subj_p - (Optional) Represents the relation to a Subject Profile (class rtctrlSubjP). Type: List.