/*_____________________________________________________________________________________________________________________

Tenant — Filter — Variables
_______________________________________________________________________________________________________________________
*/
variable "filters" {
  default = {
    "default" = {
      alias           = ""
      annotation      = ""
      annotations     = []
      controller_type = "apic"
      description     = ""
      filter_entries = [
        {
          alias                 = ""
          annotation            = ""
          annotations           = []
          arp_flag              = "unspecified"
          description           = ""
          destination_port_from = "unspecified"
          destination_port_to   = "unspecified"
          ethertype             = "unspecified"
          icmpv4_type           = "unspecified"
          icmpv6_type           = "unspecified"
          ip_protocol           = "unspecified"
          global_alias          = ""
          match_dscp            = "unspecified"
          match_only_fragments  = false
          name                  = "default"
          source_port_from      = "unspecified"
          source_port_to        = "unspecified"
          stateful              = false
          tcp_session_rules = [
            {
              acknowledgement = false
              established     = false
              finish          = false
              reset           = false
              synchronize     = false
            }
          ]
        }
      ]
      global_alias = ""
      /* If undefined the variable of local.first_tenant will be used for:
      schema              = local.first_tenant
      template            = local.first_tenant
      tenant              = local.first_tenant
      */
    }
  }
  description = <<-EOT
    Key - Name for the DNS Profile
    * controller_type: (optional) — The type of controller.  Options are:
      - apic: (default)
      - ndo
    * description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
    * filter_entries: (optional) — List of Filter Entries to assign to the Filter.
      - alias: (APIC Only - optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
      - annotation: (APIC Only - optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
      - annotations: (APIC Only - optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
      - arp_flag: (optional) — If the EtherType is not arp then this should be unspecified.  Options are:
        * req
        * reply
        * unspecified: (default)
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - destination_port_from: (optional) — The start of the destination port range. The start of the port range is determined by the server type. You can define a single port by specifying the same value in the From and To fields, or you can define a range of ports from 0 to 65535 by specifying different values in the From and To fields. Instead of specifying a number, you can instead choose one of the following server types to use the pre-defined port of that type:
        * 1-65535
        * dns
        * ftpData
        * http
        * https
        * pop3
        * rtsp
        * smtp
        * unspecified: (default)
      - destination_port_to: (optional) — The end of the destination port range. The end of the port range is determined by the server type. You can define a single port by specifying the same value in the From and To fields, or you can define a range of ports from 0 to 65535 by specifying different values in the From and To fields. Instead of specifying a number, you can instead choose one of the following server types to use the pre-defined port of that type:
        * 1-65535
        * dns
        * ftpData
        * http
        * https
        * pop3
        * rtsp
        * smtp
        * unspecified: (default)
      - ethertype: (optional) — Option to set the ethertype to match with the Filter Entry.  Options are:
        * arp
        * fcoe
        * ip
        * ipv4
        * ipv6
        * trill
        * mac_security
        * mpls_ucast
        * unspecified: (default)
      - icmpv4_type: (optional) — If the IP Protocol is icmp you can select the ICMPv4 Type.  Options are:
        * dst-unreach
        * echo
        * echo-rep
        * src-quench
        * time-exceeded
        * unspecified: (default)
      - icmpv6_type: (optional) — If the IP Protocol is icmp you can select the ICMPv6 Type.  Options are:
        * dst-unreach
        * echo-req
        * echo-rep
        * nbr-solicit
        * nbr-advert
        * redirect
        * time-exceeded
        * unspecified: (default)
      - ip_protocol: (optional) — The IP Protocol type for the filter entry.  Options are:
        * egp
        * eigrp
        * igp
        * icmp
        * icmpv6
        * igmp
        * l2tp
        * ospfigp
        * pim
        * tcp
        * udp
        * unspecified: (default)
      - global_alias: (APIC Only - optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
      - match_dscp: (optional) — Match only traffic marked with the specified Differentiated Services Code Point (DSCP) value. Enter the DSCP value to match.
        * Note: Contracts using filters matching DSCP values are only supported on cloud scale switches  “EX/FX/FX2/FXP/GX” etc. For example, N9K-93108TC-EX.
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
      - match_only_fragments: (optional) — Match only packet fragments. When enabled, the rule applies to any IP fragment with an offset that is greater than 0 (all IP fragments except the first). When disabled, the rule will not apply to IP fragments with an offset greater than 0 because TCP/UDP port information can only be checked in initial fragments.
        * false: (default)
        * true
      - name: (required) — The Name for the Filter Entry.
      - source_port_from: (optional) — The start of the source port range. The start of the port range is determined by the server type. You can define a single port by specifying the same value in the From and To fields, or you can define a range of ports from 0 to 65535 by specifying different values in the From and To fields. Instead of specifying a number, you can instead choose one of the following server types to use the pre-defined port of that type:
        * 1-65535
        * dns
        * ftpData
        * http
        * https
        * pop3
        * rtsp
        * smtp
        * unspecified: (default)
      - source_port_to: (optional) — The end of the source port range. The end of the port range is determined by the server type. You can define a single port by specifying the same value in the From and To fields, or you can define a range of ports from 0 to 65535 by specifying different values in the From and To fields. Instead of specifying a number, you can instead choose one of the following server types to use the pre-defined port of that type:
        * 1-65535
        * dns
        * ftpData
        * http
        * https
        * pop3
        * rtsp
        * smtp
        * unspecified: (default)
      - stateful: (optional) — Specifies if the entry is stateful. This applies to the TCP protocol only. The stateful options can be set as follows:
        * false: (default)
        * true
      - tcp_session_rules: (optional) — The TCP session rules of the filter entry. The TCP session rules are:
        * acknowledgement
          - false: (default)
          - true
        * established
          - false: (default)
          - true
        * finish
          - false: (default)
          - true
        * reset
          - false: (default)
          - true
        * synchronize
          - false: (default)
          - true
    * tenant: (default: local.first_tenant) — The name of the tenant to for the Application EPG.
    APIC Specific Attributes:
    * alias: (optional) — The Name Alias feature (or simply "Alias" where the setting appears in the GUI) changes the displayed name of objects in the APIC GUI. While the underlying object name cannot be changed, the administrator can override the displayed name by entering the desired name in the Alias field of the object properties menu. In the GUI, the alias name then appears along with the actual object name in parentheses, as name_alias (object_name).
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * annotations: (optional) — You can add arbitrary key:value pairs of metadata to an object as annotations (tagAnnotation). Annotations are provided for the user's custom purposes, such as descriptions, markers for personal scripting or API calls, or flags for monitoring tools or orchestration applications such as Cisco Multi-Site Orchestrator (MSO). Because APIC ignores these annotations and merely stores them with other object data, there are no format or content restrictions imposed by APIC.
    * global_alias: (optional) — The Global Alias feature simplifies querying a specific object in the API. When querying an object, you must specify a unique object identifier, which is typically the object's DN. As an alternative, this feature allows you to assign to an object a label that is unique within the fabric.
    * monitoring_policy: (optional) — Name of a Monitoring Policy to assign to the EPG.
    * qos_class: (optional) — The priority class identifier. Allowed values are:
      - level1
      - level2
      - level3
      - level4
      - level5
      - level6
      - unspecified: (default)
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
      controller_type = optional(string)
      description     = optional(string)
      filter_entries = list(object(
        {
          alias      = optional(string)
          annotation = optional(string)
          annotations = optional(list(object(
            {
              key   = string
              value = string
            }
          )))
          arp_flag              = optional(string)
          description           = optional(string)
          ethertype             = optional(string)
          global_alias          = optional(string)
          icmpv4_type           = optional(string)
          icmpv6_type           = optional(string)
          ip_protocol           = optional(string)
          match_dscp            = optional(string)
          match_only_fragments  = optional(bool)
          name                  = string
          stateful              = optional(bool)
          source_port_from      = optional(string)
          source_port_to        = optional(string)
          destination_port_from = optional(string)
          destination_port_to   = optional(string)
          tcp_session_rules = optional(list(object(
            {
              acknowledgement = bool
              established     = bool
              finish          = bool
              reset           = bool
              synchronize     = bool
            }
          )))
        }
      ))
      global_alias = optional(string)
      schema       = optional(string)
      template     = optional(string)
      tenant       = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzFilter"
 - Distinguished Name: "uni/tn-{Tenant}/flt{filter}"
GUI Location:
 - Tenants > {tenant} > Contracts > Filters: {filter}
_______________________________________________________________________________________________________________________
*/
resource "aci_filter" "filters" {
  depends_on = [
    aci_tenant.tenants
  ]
  for_each                       = { for k, v in local.filters : k => v if v.controller_type == "apic" }
  tenant_dn                      = aci_tenant.tenants[each.value.tenant].id
  annotation                     = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                    = each.value.description
  name                           = each.key
  name_alias                     = each.value.alias
  relation_vz_rs_filt_graph_att  = ""
  relation_vz_rs_fwd_r_flt_p_att = ""
  relation_vz_rs_rev_r_flt_p_att = ""
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "vzEntry"
 - Distinguished Name: "uni/tn-{tenant}/flt{filter}/e-{filter_entry}"
GUI Location:
 - Tenants > {tenant} > Contracts > Filters: {filter} > Filter Entry: {filter_entry}
_______________________________________________________________________________________________________________________
*/
resource "aci_filter_entry" "filter_entries" {
  depends_on = [
    aci_tenant.tenants,
    aci_filter.filters
  ]
  for_each      = { for k, v in local.filter_entries : k => v if v.controller_type == "apic" }
  filter_dn     = aci_filter.filters[each.value.filter_name].id
  description   = each.value.description
  name          = each.key
  name_alias    = each.value.alias
  ether_t       = each.value.ethertype
  prot          = each.value.ip_protocol
  arp_opc       = each.value.arp_flag == "request" ? "req" : each.value.arp_flag
  icmpv4_t      = each.value.icmpv4_type
  icmpv6_t      = each.value.icmpv6_type
  match_dscp    = each.value.match_dscp
  apply_to_frag = each.value.match_only_fragments == true ? "yes" : "no"
  s_from_port   = each.value.source_port_from
  s_to_port     = each.value.source_port_to
  d_from_port   = each.value.destination_port_from
  d_to_port     = each.value.destination_port_to
  stateful      = each.value.stateful == true ? "yes" : "no"
  tcp_rules = anytrue(
    [
      each.value.tcp_session_rules[0].acknowledgement,
      each.value.tcp_session_rules[0].established,
      each.value.tcp_session_rules[0].finish,
      each.value.tcp_session_rules[0].reset,
      each.value.tcp_session_rules[0].synchronize
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.tcp_session_rules[0].acknowledgement)) > 0 ? "acknowledgement" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].established)) > 0 ? "established" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].finish)) > 0 ? "finish" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].reset)) > 0 ? "reset" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].synchronize)) > 0 ? "synchronize" : ""]
  )) : ["unspecified"]
}

resource "mso_schema_template_filter_entry" "filter_entries" {
  provider = mso
  depends_on = [
    mso_schema.schemas
  ]
  for_each             = { for k, v in local.filter_entries : k => v if v.controller_type == "ndo" }
  schema_id            = mso_schema.schemas[each.value.schema].id
  template_name        = each.value.template
  display_name         = each.value.filter_name
  entry_name           = each.value.name
  name                 = each.value.filter_name
  entry_display_name   = each.value.name
  ether_type           = each.value.ethertype
  arp_flag             = each.value.arp_flag
  ip_protocol          = each.value.ip_protocol
  match_only_fragments = each.value.match_only_fragments
  source_from          = each.value.source_port_from
  source_to            = each.value.source_port_to
  destination_from     = each.value.destination_port_from
  destination_to       = each.value.destination_port_to
  stateful             = each.value.stateful
  tcp_session_rules = anytrue(
    [
      each.value.tcp_session_rules[0].acknowledgement,
      each.value.tcp_session_rules[0].established,
      each.value.tcp_session_rules[0].finish,
      each.value.tcp_session_rules[0].reset,
      each.value.tcp_session_rules[0].synchronize
    ]
    ) ? compact(concat([
      length(regexall(true, each.value.tcp_session_rules[0].acknowledgement)) > 0 ? "acknowledgement" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].established)) > 0 ? "established" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].finish)) > 0 ? "finish" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].reset)) > 0 ? "reset" : ""], [
      length(regexall(true, each.value.tcp_session_rules[0].synchronize)) > 0 ? "synchronize" : ""]
  )) : ["unspecified"]
}

output "filters" {
  value = {
    filters = var.filters != {} ? { for v in sort(
      keys(aci_filter.filters)
    ) : v => aci_filter.filters[v].id } : {}
    apic_filter_entries = var.filters != {} ? { for v in sort(
      keys(aci_filter_entry.filter_entries)
    ) : v => aci_filter_entry.filter_entries[v].id } : {}
    ndo_filter_entries = var.filters != {} ? { for v in sort(
      keys(mso_schema_template_filter_entry.filter_entries)
    ) : v => mso_schema_template_filter_entry.filter_entries[v].id } : {}
  }
}
