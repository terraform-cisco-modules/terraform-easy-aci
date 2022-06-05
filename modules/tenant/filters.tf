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
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
      alias           = ""
      annotation      = ""
      annotations     = []
      controller_type = "apic"
      description     = ""
      filter_entries = [
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
              acknowledgement = false
              established     = false
              finish          = false
              reset           = false
              synchronize     = false
      global_alias = ""
      /* If undefined the variable of local.first_tenant will be used
      schema              = local.first_tenant
      template            = local.first_tenant
      tenant              = local.first_tenant
      */
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
    [each.value.tcp_ack, each.value.tcp_est, each.value.tcp_fin, each.value.tcp_rst, each.value.tcp_syn]
    ) ? compact(concat([
      length(regexall(true, each.value.tcp_ack)) > 0 ? "ack" : ""], [
      length(regexall(true, each.value.tcp_est)) > 0 ? "est" : ""], [
      length(regexall(true, each.value.tcp_fin)) > 0 ? "fin" : ""], [
      length(regexall(true, each.value.tcp_rst)) > 0 ? "rst" : ""], [
      length(regexall(true, each.value.tcp_syn)) > 0 ? "syn" : ""]
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
