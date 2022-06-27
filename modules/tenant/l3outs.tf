/*_____________________________________________________________________________________________________________________

L3Out - Variables
_______________________________________________________________________________________________________________________
*/
variable "l3outs" {
  default = {
    "default" = {
      alias           = ""
      annotation      = ""
      annotations     = []
      consumer_label  = ""
      controller_type = "apic"
      description     = ""
      enable_bgp      = false
      external_epgs = [
        {
          alias                  = ""
          contract_exception_tag = 0
          contracts              = []
          /* Example Contract
          contracts = [
            {
              name          = "default"
              contract_type = "consumed" # consumed|interface|intra_epg|provided|taboo
              qos_class     = "unspecified"
              schema        = ""
              template      = ""
              tenant        = local.first_tenant
            }
          ]
          */
          description            = ""
          epg_type               = "standard" # standard or oob
          flood_on_encapsulation = "disabled"
          label_match_criteria   = "AtleastOne"
          name                   = "default"
          preferred_group_member = false
          qos_class              = "unspecified"
          subnets = [
            {
              aggregate = [{
                aggregate_export        = false
                aggregate_import        = false
                aggregate_shared_routes = false
              }]
              description = ""
              external_epg_classification = [{
                external_subnets_for_external_epg = true
                shared_security_import_subnet     = false
              }]
              route_control = [{
                export_route_control_subnet = false
                import_route_control_subnet = false
                shared_route_control_subnet = false
              }]
              route_control_profiles = []
              # Example
              # route_control_profiles = [{
              #   direction = "export" # export/import
              #   route_map = "default"
              #   tenant = "**l3out_tenant**"
              # }]
              route_summarization_policy = ""
              subnets                    = ["0.0.0.0/1", "128.0.0.0/1"]
            }
          ]
          route_control_profiles = []
          /* Example
          route_control_profiles = [{
            direction = "export" # export/import
            route_map = "default"
          }]
          */
          target_dscp = "unspecified"
        }
      ]
      global_alias          = ""
      l3_domain             = ""
      pim                   = false
      pimv6                 = false
      provider_label        = ""
      ospf_external_profile = []
      /* Example
      ospf_external_profile = [
        {
          ospf_area_cost = 1
          ospf_area_control = [{
            send_redistribution_lsas_into_nssa_area = true
            originate_summary_lsa                   = true
            suppress_forwarding_address             = false
          }]
          ospf_area_id   = "0.0.0.0"
          ospf_area_type = "regular" # nssa, regular, stub
        }
      ]
      */
      route_control_enforcement = [
        {
          export = true
          import = false
        }
      ]
      route_control_for_dampening = []
      /* Example
      route_control_for_dampening = [
        {
          address_family = "ipv4"
          route_map      = "**REQUIRED**"
        }
      ]
      */
      route_profile_for_interleak       = ""
      route_profiles_for_redistribution = []
      target_dscp                       = "unspecified"
      sites                             = []
      vrf                               = "default"
      /* If undefined the variable of local.first_tenant will be used
      policy_source_tenant = local.first_tenant
      schema               = local.first_tenant
      template             = local.first_tenant
      tenant               = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key: Name of the L3Out.
    * alias: (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
    * consumer_label: (optional) — The optional contract consumer label that allows non-infra tenants to consume any Layer 3 EVPN routed policy that is assigned a provider label.  This field specifies the provider label of the Layer 3 EVPN routed policy that this policy wants to use.
      - value must be "hcloudGolfLabel" if assigned.
      - Note:  Not applicable to L3 outside policies belonging to Tenant infra.
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * enable_bgp: (optional) — Flag to enable BGP for the L3Out.  Options are:
      - false: (default)
      - true
    * external_epgs: (optional) — List of External EPG(s) with their attributes for the L3Out.
      - alias: (optional) —  — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
      - contract_exception_tag: (optional) — Contracts between EPGs are enhanced to include exceptions to subjects or contracts. This enables a subset of EPGs to be excluded in contract filtering. For example, a provider EPG can communicate with all consumer EPGs except those that match criteria configured in a Subject Exception in the contract governing their communication.  Assign a Tag Attribute to the EPG.
      - contracts: (optional) — List of Contracts & Attributes to assign to the External EPG.
        * contract_type: (optional) — The Type of Contract to apply.  Options are:
          - consumed: (default)
          - contract_interface
          - intra_epg
          - provided
          - taboo
        * name: (required) — The name for the Contract to assign to the External EPG.
        * qos_class: (optional) — The priority class identifier. Allowed values are:
          - level1
          - level2
          - level3
          - level4
          - level5
          - level6
          - unspecified: (default)
        * schema: (optional) — The Schema name that contains the Contract.  If Undefined then the L3Out Schema will be used.
        * template: (optional) — The Template name that contains the Contract.  If Undefined then the L3Out Template will be used.
        * tenant: (optional) — The Name of the Tenant for the Contract.  If Undefined then the L3Out Tenant will be used.
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - epg_type: (optional) — The type of External EPG to create.  Options are:
        * oob
        * standard: (default)
      - flood_on_encapsulation: (optional) — Specifies whether flooding is enabled for the EPG or not. If flooding is disabled, the value specified in the BD mode is considered.  Options are:
        * disabled: (default)
        * enabled
      - label_match_criteria: (optional) — The provider label match criteria.  Options are:
        * All
        * AtleastOne: (default)
        * AtmostOne
        * None
      - name: (required) — The Name of the External EPG.
      - preferred_group_member: (optional) — If an External EPG is marked as a Preferred Group Member, it is put into an internally created contract group where all members of the group can communicate with each other without requiring a contract between them.  The options are:
        * exclude: (default) — The External EPG is not included in the subgroup.
        * include — The External EPG is included in the subgroup.
      - qos_class: (optional) — The priority class identifier. Allowed values are:
        * level1
        * level2
        * level3
        * level4
        * level5
        * level6
        * unspecified: (default)
      - subnets: (required) — List of Subnets to add to the External EPG.  Note each Subnet List of Object can contain multiple Subnets when the same settings will apply.
        * aggregate: (optional) — When aggregation is not set, the subnets are matched exactly. For example, if 11.1.0.0/16 is the subnet, then the policy will not apply to a 11.1.1.0/24 route but it will apply only if the route is 11.1.0.0/16. However, to avoid a tedious and error prone task of defining all the subnets one by one, aggregation can be used aggregate a set of subnets into one export, import or shared routes policy. At this time, only 0/0 subnets can be aggregated. When 0/0 is specified with aggregation, all the routes are imported, exported, or shared with (leaked to) a different VRF based on one of the following:
          - aggregate_export: (optional) — Exports all routes of a subnet (0/0 subnets).  Options are:
            * false: (default)
            * true
          - aggregate_import: (optional) — Imports all routes of a subnet (0/0 subnets).  Options are:
            * false: (default)
            * true
          - aggregate_shared_routes: (optional) — When a route is learned in one VRF that needs to be leaked into another VRF, the routes can be leaked by matching the subnet exactly, or can be leaked aggregated according to a subnet mask.
            * false: (default)
            * true
        * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
        * external_epg_classification: (optional) — 
          - external_subnets_for_external_epg: (optional) — A classifier for the external EPG, similar to an Access Control List (ACL). The rules and contracts in the external EPG apply at the VRF level to networks matching this subnet.  Options are:
            * false
            * true: (default)
          - shared_security_import_subnet: (optional) — Configures the classifier for the subnets in the VRF where the routes are leaked.  Options are:
            * false: (default)
            * true
        * route_control: (optional) — 
          - export_route_control_subnet: (optional) — Controls which external networks are advertised out of the fabric using route-maps and IP prefix lists. An IP prefix list is created on the border leaf switch for each subnet that is defined. The export control policy is enabled by default and is supported for BGP, EIGRP, and OSPF.  Options are:
            * false: (default)
            * true
          - import_route_control_subnet: (optional) — Controls the subnets allowed into the fabric, and can include set and match rules to filter routes. Supported for BGP and OSPF, but not for EIGRP; if the user enables the import control policy for an unsupported protocol, it will be automatically ignored. The import control policy is not enabled by default, but you can enable it by navigating to the configured L3Out. Click the Policy/Main tabs to display the Properties window for the configured L3Out, then check the box next to Route Control Enforcement: Import.  Options are:
            * false: (default)
            * true
          - shared_route_control_subnet: (optional) — Controls which external prefixes are advertised to other VRFs, which have a contract interface for shared L3Out services.  Options are:
            * false: (default)
            * true
        * route_control_profiles: (optional) — Enter the name and direction of the route control profile.
          - direction: (required) — The direction of control.  Options are:
            * export
            * import
          - route_map: (required) — The Name of a Route Map for import and export route control
        * route_summarization_policy: (optional) — Available if you set export_route_control_subnet to true.  The Name of the BGP Route Summarization Policy.
        * subnets: (required) — List of Subnets to add to the External EPG.  In example: ["0.0.0.0/1","128.0.0.0/1"]
      - route_control_profiles: (optional) — Enter the name and direction of the route control profile.
        * direction: (required) — The direction of control.  Options are:
          - export
          - import
        * route_map: (required) — The Name of a Route Map for import and export route control
      - target_dscp: (optional) — The target differentiated services code point (DSCP). The options are as follows:
        * AF11 — low drop Priority
        * AF12 — medium drop Priority
        * AF13 — high drop Priority
        * AF21 — low drop Immediate
        * AF22 — medium drop Immediate
        * AF23 — high drop Immediate
        * AF31 — low drop Flash
        * AF32 — medium drop Flash
        * AF33 — high drop Flash
        * AF41 — low drop—Flash Override
        * AF42 — medium drop Flash Override
        * AF43 — high drop Flash Override
        * CS0 — class of service level 0
        * CS1 — class of service level 1
        * CS2 — class of service level 2
        * CS3 — class of service level 3
        * CS4 — class of service level 4
        * CS5 — class of service level 5
        * CS6 — class of service level 6
        * CS7 — class of service level 7
        * EF — Expedited Forwarding Critical
        * VA — Voice Admit
        * unspecified: (default)
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    * l3_domain: (optional) — Name of the L3 Domain Policy.
    * pim: (optional) — ** Not supported with VPC L3Out Node Profiles.  Enables or disables PIM (multicast) on the L3Out.  Enabling PIM is the equivalent of navigating to tenant > Networking > VRFs > vrf > Multicast and selecting this L3Out in the Multicast window.
      - false: (default)
      - true
    * pimv6: (optional) — ** Not supported with VPC L3Out Node Profiles.  Enables or disables PIMv6 (multicast) on the L3Out.  Enabling PIMv6 is the equivalent of navigating to tenant > Networking > VRFs > vrf > Multicast IPv6 and selecting this L3Out in the Multicast IPv6 window.
      - false: (default)
      - true
    * provider_label: (optional) — The contract provider label for this policy. Any tenant that uses this Layer 3 EVPN routed connection must specify this label as its consumer label.
    * policy_source_tenant: (default: l3out tenant) — Name of a source tenant for policies.
    * ospf_external_profile: (optional) — 
      - ospf_area_cost: (default: 1) — The OSPF area cost. The range is from 0 to 16777215.
      - ospf_area_control: (optional) — OSPF uses link-state advertisements (LSAs) to build its routing table. The area controls are:
        * send_redistribution_lsas_into_nssa_area: (optional) — LSA generated by the ASBR within a not-so-stubby area (NSSA). This LSA includes the link cost to an external autonomous system destination. NSSA External LSAs are flooded only within the local NSSA.  Options are:
          - false: (default)
          - true
        * originate_summary_lsa: (optional) — LSA sent by the area border router to an external area.
          - false: (default)
          - true
        * suppress_forwarding_address: (optional) — LSA generated by the ASBR within a not-so-stubby area (NSSA). This LSA does not include the link cost to an external autonomous system destination.  Options are:
          - false: (default)
          - true
      - ospf_area_id: (optional) — The OSPF area identifier.  This can be dotted notation, 0.0.0.0, or a digit 0.
      - ospf_area_type: (optional) — Sets the area type on the external routers in order to bring up OSPF adjacency. The type can be:
        * nssa — Allows AS external routes within an NSSA.
        * regular: (default) — Allows AS external routes within the area.
        * stub — Does not allow AS External LSAs.
    * route_control_enforcement: (optional) — The enforce route control type. The control can be:
        - export
          * false
          * true: (default)
        - import
          * false: (default)
          * true
        Note1: The default is export set to true. Export control is supported with BGP, OSPF, and EIGRP. import control is supported only with BGP and OSPF.
        Note2: Enabling import enables the import_route_control_subnet option on the Create Subnet dialog box under the Create External EPG panel.
    * route_control_for_dampening: (optional) — Dampening minimizes propagation into the fabric of flapping e-BGP routes received from external routers connected to border leaf switches (BLs). Frequently flapping routes from external routers are suppressed on BLs based on configured criteria and prohibited from redistribution to iBGP peers (ACI spine switches). Suppressed routes are reused after a configured time criteria.
      - address_family: (optional) — Address Family for the dampening policy.  Options are:
        * ipv4: (default)
        * ipv6
      - route_map: (required) — Name of the Route Map to assign.
    * route_profile_for_interleak: (optional) — Assign a Route Map/Profile. A route profile allows the user to set attributes, such as community, preference, and metric for route leaking from OSPF to BGP.
    * target_dscp: (optional) — The target differentiated services code point (DSCP). The options are as follows:
      - AF11 — low drop Priority
      - AF12 — medium drop Priority
      - AF13 — high drop Priority
      - AF21 — low drop Immediate
      - AF22 — medium drop Immediate
      - AF23 — high drop Immediate
      - AF31 — low drop Flash
      - AF32 — medium drop Flash
      - AF33 — high drop Flash
      - AF41 — low drop—Flash Override
      - AF42 — medium drop Flash Override
      - AF43 — high drop Flash Override
      - CS0 — class of service level 0
      - CS1 — class of service level 1
      - CS2 — class of service level 2
      - CS3 — class of service level 3
      - CS4 — class of service level 4
      - CS5 — class of service level 5
      - CS6 — class of service level 6
      - CS7 — class of service level 7
      - EF — Expedited Forwarding Critical
      - VA — Voice Admit
      - unspecified: (default)
    * tenant: (default: local.first_tenant) — The name of the tenant for the L3Out.
    * vrf: (default: default) — The name of the VRF for the L3Out.
    Nexus Dashboard Orchestrator Specific Attributes:
    * schema: (default: local.first_tenant) — Schema Name.
    * sites: (default: local.first_tenant) — List of Site Names to assign site specific attributes.
    * template: (default: local.first_tenant) — The Template name to create the object within.
  EOT
  type = map(object(
    {
      alias      = optional(string)
      annotation = optional(string)
      annotations = optional(list(object(
        {
          key   = string
          value = string
        }
      )))
      consumer_label  = optional(string)
      controller_type = optional(string)
      description     = optional(string)
      enable_bgp      = optional(bool)
      external_epgs = optional(list(object(
        {
          alias                  = optional(string)
          contract_exception_tag = optional(number)
          contracts = optional(list(object(
            {
              contract_type = optional(string)
              name          = string
              qos_class     = optional(string)
              schema        = optional(string)
              template      = optional(string)
              tenant        = optional(string)
            }
          )))
          description            = optional(string)
          epg_type               = optional(string)
          flood_on_encapsulation = optional(string)
          l3out_contract_masters = optional(list(object(
            {
              external_epg = string
              l3out        = string
            }
          )))
          label_match_criteria   = optional(string)
          name                   = string
          preferred_group_member = optional(bool)
          qos_class              = optional(string)
          subnets = list(object(
            {
              aggregate = optional(list(object(
                {
                  aggregate_export        = optional(bool)
                  aggregate_import        = optional(bool)
                  aggregate_shared_routes = optional(bool)
                }
              )))
              description = optional(string)
              external_epg_classification = optional(list(object(
                {
                  external_subnets_for_external_epg = optional(bool)
                  shared_security_import_subnet     = optional(bool)
                }
              )))
              route_control = optional(list(object(
                {
                  export_route_control_subnet = optional(bool)
                  import_route_control_subnet = optional(bool)
                  shared_route_control_subnet = optional(bool)
                }
              )))
              route_control_profiles = optional(list(object(
                {
                  direction = string
                  route_map = string
                }
              )))
              route_summarization_policy = optional(string)
              subnets                    = list(string)
            }
          ))
          route_control_profiles = optional(list(object(
            {
              direction = string
              route_map = string
            }
          )))
          target_dscp = optional(string)
        }
      )))
      global_alias         = optional(string)
      l3_domain            = optional(string)
      pim                  = optional(bool)
      pimv6                = optional(bool)
      policy_source_tenant = optional(string)
      provider_label        = optional(string)
      ospf_external_profile = optional(list(object(
        {
          ospf_area_cost = optional(number)
          ospf_area_control = optional(list(object(
            {
              send_redistribution_lsas_into_nssa_area = optional(bool)
              originate_summary_lsa                   = optional(bool)
              suppress_forwarding_address             = optional(bool)
            }
          )))
          ospf_area_id   = optional(string)
          ospf_area_type = optional(string)
        }
      )))
      route_control_enforcement = optional(list(object(
        {
          export = optional(bool)
          import = optional(bool)
        }
      )))
      route_control_for_dampening = optional(list(object(
        {
          address_family = optional(string)
          route_map      = string
        }
      )))
      route_profile_for_interleak = optional(string)
      route_profiles_for_redistribution = optional(list(object(
        {
          l3out     = optional(string)
          route_map = string
          source    = optional(string)
        }
      )))
      target_dscp = optional(string)
      schema      = optional(string)
      sites       = optional(list(string))
      template    = optional(string)
      tenant      = optional(string)
      vrf         = optional(string)
    }
  ))
}



/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extOut"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_outside" "l3outs" {
  depends_on = [
    aci_tenant.tenants,
    aci_vrf.vrfs
  ]
  for_each               = { for k, v in local.l3outs : k => v if v.controller_type == "apic" }
  annotation             = each.value.annotation != "" ? each.value.annotation : var.annotation
  description            = each.value.description
  enforce_rtctrl         = each.value.import == true ? ["export", "import"] : ["export"]
  name                   = each.key
  name_alias             = each.value.alias
  target_dscp            = each.value.target_dscp
  tenant_dn              = aci_tenant.tenants[each.value.tenant].id
  relation_l3ext_rs_ectx = aci_vrf.vrfs[each.value.vrf].id
  relation_l3ext_rs_l3_dom_att = length(regexall(
    "[[:alnum:]]+", each.value.l3_domain)
  ) > 0 ? "uni/l3dom-${each.value.l3_domain}" : ""
  dynamic "relation_l3ext_rs_dampening_pol" {
    for_each = each.value.route_control_for_dampening
    content {
      af                     = "${relation_l3ext_rs_dampening_pol.value.address_family}-ucast"
      tn_rtctrl_profile_name = "uni/tn-${each.value.policy_source_tenant}/prof-${relation_l3ext_rs_dampening_pol.value.route_map}"
    }
  }
  # Class l3extRsInterleakPol
  relation_l3ext_rs_interleak_pol = length(compact([each.value.route_profile_for_interleak])
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/prof-${each.value.route_profile_for_interleak}" : ""
  # relation_l3ext_rs_out_to_bd_public_subnet_holder = ["{fvBDPublicSubnetHolder}"]
}

resource "aci_l3out_bgp_external_policy" "external_bgp" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each      = { for k, v in local.l3outs : k => v if v.controller_type == "apic" && v.enable_bgp == true }
  l3_outside_dn = aci_l3_outside.l3outs[each.key].id
  annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extRsRedistributePol"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/pimextp"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "l3out_route_profiles_for_redistribution" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = local.l3out_route_profiles_for_redistribution
  dn         = "uni/tn-${each.value.tenant}/out-${each.value.l3out}/rsredistributePol-[${each.value.route_map}]-${each.value.source}"
  class_name = "l3extRsRedistributePol"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    src        = each.value.source
    tDn = length(compact([each.value.rm_l3out])
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.rm_l3out}/prof-${each.value.route_map}" : "uni/tn-${each.value.tenant}/prof-${each.value.route_map}"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "pimExtP"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/pimextp"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "l3out_multicast" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = { for k, v in local.l3outs : k => v if v.controller_type == "apic" && (v.pim == true || v.pimv6 == true) }
  dn         = "uni/tn-${each.value.tenant}/out-${each.key}/pimextp"
  class_name = "pimExtP"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    enableAf = anytrue(
      [each.value.pim, each.value.pimv6]
      ) ? replace(trim(join(",", concat([
        length(regexall(true, each.value.pim)) > 0 ? "ipv4-mcast" : ""], [
        length(regexall(true, each.value.pimv6)) > 0 ? "ipv6-mcast" : ""]
    )), ","), ",,", ",") : "none"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extConsLbl"
 - Distinguished Name: "uni/tn-{tenant}/out-{l3out}/conslbl-hcloudGolfLabel"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "l3out_consumer_label" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = { for k, v in local.l3outs : k => v if v.controller_type == "apic" && v.consumer_label == "hcloudGolfLabel" }
  dn         = "uni/tn-${each.value.tenant}/out-${each.key}/conslbl-hcloudGolfLabel"
  class_name = "l3extConsLbl"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name       = "hcloudGolfLabel"
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extInstP"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{Ext_EPG}"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {Ext_EPG}
_______________________________________________________________________________________________________________________
*/
output "ext_epgs" {
  value = local.l3out_external_epgs
}
resource "aci_external_network_instance_profile" "l3out_external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each       = { for k, v in local.l3out_external_epgs : k => v if v.epg_type != "oob" }
  l3_outside_dn  = aci_l3_outside.l3outs[each.value.l3out].id
  annotation     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description    = each.value.description
  exception_tag  = each.value.contract_exception_tag
  flood_on_encap = each.value.flood_on_encapsulation
  match_t        = each.value.label_match_criteria
  name_alias     = each.value.alias
  name           = each.value.name
  pref_gr_memb   = each.value.preferred_group_member == true ? "include" : "exclude"
  prio           = each.value.qos_class
  target_dscp    = each.value.target_dscp
  relation_fv_rs_sec_inherited = length(each.value.l3out_contract_masters) > 0 ? [
    for s in each.value.l3out_contract_masters : "uni/tn-${each.value.tenant}/out-${s.l3out}/intP-${s.external_epg}"
  ] : []
  dynamic "relation_l3ext_rs_inst_p_to_profile" {
    for_each = each.value.route_control_profiles
    content {
      direction              = each.value.direction
      tn_rtctrl_profile_name = "uni/tn-${each.value.policy_source_tenant}/prof-${relation_l3ext_rs_inst_p_to_profile.value.route_map}"
    }
  }
  # relation_l3ext_rs_l3_inst_p_to_dom_p        = each.value.l3_domain
  # relation_fv_rs_cust_qos_pol = each.value.custom_qos_policy
  # relation_fv_rs_sec_inherited                = [each.value.l3out_contract_masters]
  # relation_l3ext_rs_inst_p_to_nat_mapping_epg = "aci_bridge_domain.{NAT_fvEPg}.id"
}

#------------------------------------------
# Create an Out-of-Band External EPG
#------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtInstP"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{name}"
GUI Location:
 - tenants > mgmt > External Management Network Instance Profiles > {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_external_epgs" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = { for k, v in local.l3out_external_epgs : k => v if v.epg_type == "oob" }
  dn         = "uni/tn-mgmt/extmgmt-default/instp-{name}"
  class_name = "mgmtInstP"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    name       = each.value.name
  }
}

#------------------------------------------------
# Assign Contracts to an External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fvRsIntraEpg"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsintraEpg-{contract}"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}: Contracts
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "external_epg_intra_epg_contracts" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs,
    aci_rest_managed.oob_external_epgs
  ]
  for_each   = { for k, v in local.l3out_ext_epg_contracts : k => v if v.controller_type == "apic" && v.contract_type == "intra_epg" }
  dn         = "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsintraEpg-${each.value.contract}"
  class_name = "fvRsIntraEpg"
  content = {
    tnVzBrCPName = each.value.contract
  }
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Consumer Class: "fvRsCons"
 - Interface Class: "vzRsAnyToConsIf"
 - Provider Class: "fvRsProv"
 - Taboo Class: "fvRsProtBy"
 - Consumer Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsintraEpg-{contract}"
 - Interface Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsconsIf-{contract}"
 - Provider Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsprov-{contract}"
 - Taboo Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/rsprotBy-{contract}"
GUI Location:
 - All Contracts: tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}: Contracts
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "external_epg_contracts" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs,
    aci_rest_managed.oob_external_epgs
  ]
  for_each = { for k, v in local.l3out_ext_epg_contracts : k => v if v.controller_type == "apic" && v.contract_type != "intra_epg" }
  dn = length(regexall(
    "consumed", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rscons-${each.value.contract}" : length(regexall(
    "interface", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsconsIf-${each.value.contract}" : length(regexall(
    "provided", each.value.contract_type)
    ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsprov-${each.value.contract}" : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? "uni/tn-${each.value.tenant}/out-${each.value.l3out}/instP-${each.value.epg}/rsprotBy-${each.value.contract}" : ""
  class_name = length(regexall(
    "consumed", each.value.contract_type)
    ) > 0 ? "fvRsCons" : length(regexall(
    "interface", each.value.contract_type)
    ) > 0 ? "vzRsAnyToConsIf" : length(regexall(
    "provided", each.value.contract_type)
    ) > 0 ? "fvRsProv" : length(regexall(
    "taboo", each.value.contract_type)
  ) > 0 ? "fvRsProtBy" : ""
  content = {
    tnVzBrCPName = each.value.contract
    prio         = each.value.qos_class
  }
}


#------------------------------------------------
# Assign a Subnet to an External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l3extSubnet"
 - Distinguised Name: "/uni/tn-{tenant}/out-{l3out}/instP-{ext_epg}/extsubnet-[{subnet}]"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out} > External EPGs > {ext_epg}
_______________________________________________________________________________________________________________________
*/
resource "aci_l3_ext_subnet" "external_epg_subnets" {
  depends_on = [
    aci_external_network_instance_profile.l3out_external_epgs
  ]
  for_each = { for k, v in local.l3out_external_epg_subnets : k => v if v.epg_type != "oob" }
  aggregate = anytrue(
    [
      each.value.aggregate_export,
      each.value.aggregate_import,
      each.value.aggregate_shared_routes
    ]
    ) ? replace(trim(join(",", concat([
      length(regexall(true, each.value.aggregate_export)) > 0 ? "export-rtctrl" : ""], [
      length(regexall(true, each.value.aggregate_import)) > 0 ? "import-rtctrl" : ""], [
      length(regexall(true, each.value.aggregate_shared_routes)) > 0 ? "shared-rtctrl" : ""]
  )), ","), ",,", ",") : "none"
  annotation                           = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                          = each.value.description
  external_network_instance_profile_dn = aci_external_network_instance_profile.l3out_external_epgs[each.value.ext_epg].id
  ip                                   = each.value.subnet
  scope = anytrue(
    [
      each.value.export_route_control_subnet,
      each.value.external_subnets_for_external_epg,
      each.value.import_route_control_subnet,
      each.value.shared_security_import_subnet,
      each.value.shared_route_control_subnet
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.export_route_control_subnet)) > 0 ? "export-rtctrl" : ""], [
      length(regexall(true, each.value.external_subnets_for_external_epg)) > 0 ? "import-security" : ""], [
      length(regexall(true, each.value.import_route_control_subnet)) > 0 ? "import-rtctrl" : ""], [
      length(regexall(true, each.value.shared_security_import_subnet)) > 0 ? "shared-security" : ""], [
      length(regexall(true, each.value.shared_route_control_subnet)) > 0 ? "shared-rtctrl" : ""]
  )) : ["import-security"]
  dynamic "relation_l3ext_rs_subnet_to_profile" {
    for_each = each.value.route_control_profiles
    content {
      direction            = relation_l3ext_rs_subnet_to_profile.value.direction
      tn_rtctrl_profile_dn = "uni/tn-${relation_l3ext_rs_subnet_to_profile.value.tenant}/prof-${relation_l3ext_rs_subnet_to_profile.value.route_map}"
    }
  }
  relation_l3ext_rs_subnet_to_rt_summ = length(
    regexall("[:alnum:]", each.value.route_summarization_policy)) > 0 && length(
    regexall(true, each.value.export_route_control_subnet)
  ) > 0 ? "uni/tn-${each.value.policy_source_tenant}/bgprtsum-${each.value.route_summarization_policy}" : ""
}


#------------------------------------------------
# Assign a Subnet to an Out-of-Band External EPG
#------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtSubnet"
 - Distinguished Name: "uni/tn-mgmt/extmgmt-default/instp-{ext_epg}/subnet-[{subnet}]"
GUI Location:
 - tenants > mgmt > External Management Network Instance Profiles > {ext_epg}: Subnets:{subnet}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "oob_external_epg_subnets" {
  depends_on = [
    aci_rest_managed.oob_external_epgs
  ]
  for_each   = { for k, v in local.l3out_external_epg_subnets : k => v if v.epg_type == "oob" }
  dn         = "uni/tn-mgmt/extmgmt-default/instp-${each.value.epg}/subnet-[${each.value.subnet}]"
  class_name = "mgmtSubnet"
  content = {
    ip = each.value.subnet
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "ospfExtP"
 - Distinguished Name: "/uni/tn-{tenant}/out-{l3out}/ospfExtP"
GUI Location:
 - tenants > {tenant} > Networking > L3Outs > {l3out}: OSPF
_______________________________________________________________________________________________________________________
*/
#------------------------------------------------
# Assign a OSPF Routing Policy to the L3Out
#------------------------------------------------
resource "aci_l3out_ospf_external_policy" "l3out_ospf_external_policies" {
  depends_on = [
    aci_l3_outside.l3outs
  ]
  for_each   = local.l3out_ospf_external_policies
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  area_cost  = each.value.ospf_area_cost
  area_ctrl = anytrue([
    each.value.send_redistribution_lsas_into_nssa_area,
    each.value.originate_summary_lsa,
    each.value.suppress_forwarding_address
    ]) ? compact(concat([
      length(regexall(true, each.value.send_redistribution_lsas_into_nssa_area)) > 0 ? "redistribute" : ""], [
      length(regexall(true, each.value.originate_summary_lsa)) > 0 ? "summary" : ""], [
    length(regexall(true, each.value.suppress_forwarding_address)) > 0 ? "suppress-fa" : ""]
  )) : ["redistribute", "summary"]
  area_id       = each.value.ospf_area_id
  area_type     = each.value.ospf_area_type
  l3_outside_dn = aci_l3_outside.l3outs[each.value.l3out].id
  # multipod_internal = "no"
}
