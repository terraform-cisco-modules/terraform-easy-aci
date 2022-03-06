variable "filters" {
  default = {
    "default" = {
      annotation      = ""
      controller_type = "apic"
      description     = ""
      filter_entries = [
        {
          annotation            = ""
          arp_flag              = "unspecified"
          description           = ""
          ethertype             = "unspecified"
          icmpv4_type           = "unspecified"
          icmpv6_type           = "unspecified"
          ip_protocol           = "unspecified"
          match_dscp            = "unspecified"
          match_only_fragments  = false
          name                  = "default"
          name_alias            = ""
          stateful              = false
          source_port_from      = "unspecified"
          source_port_to        = "unspecified"
          destination_port_from = "unspecified"
          destination_port_to   = "unspecified"
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
      name_alias = ""
      schema     = "common"
      template   = "common"
      tenant     = "common"
    }
  }
  type = map(object(
    {
      annotation      = optional(string)
      controller_type = optional(string)
      description     = optional(string)
      filter_entries = list(object(
        {
          annotation            = optional(string)
          arp_flag              = optional(string)
          description           = optional(string)
          ethertype             = optional(string)
          icmpv4_type           = optional(string)
          icmpv6_type           = optional(string)
          ip_protocol           = optional(string)
          match_dscp            = optional(string)
          match_only_fragments  = optional(bool)
          name                  = string
          name_alias            = optional(string)
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
      name_alias = optional(string)
      schema     = optional(string)
      template   = optional(string)
      tenant     = optional(string)
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
  name_alias                     = each.value.name_alias
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
  name_alias    = each.value.name_alias
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
  tcp_rules = alltrue(
    [each.value.tcp_ack, each.value.tcp_est, each.value.tcp_fin, each.value.tcp_rst, each.value.tcp_syn]
    ) ? ["ack", "est", "fin", "rst", "syn"] : anytrue(
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
  tcp_session_rules = alltrue(
    [each.value.tcp_ack, each.value.tcp_est, each.value.tcp_fin, each.value.tcp_rst, each.value.tcp_syn]
    ) ? ["acknowledgement", "established", "finish", "reset", "synchronize"] : anytrue(
    [each.value.tcp_ack, each.value.tcp_est, each.value.tcp_fin, each.value.tcp_rst, each.value.tcp_syn]
    ) ? compact(concat([
      length(regexall(true, each.value.tcp_ack)) > 0 ? "acknowledgement" : ""], [
      length(regexall(true, each.value.tcp_est)) > 0 ? "established" : ""], [
      length(regexall(true, each.value.tcp_fin)) > 0 ? "finish" : ""], [
      length(regexall(true, each.value.tcp_rst)) > 0 ? "reset" : ""], [
      length(regexall(true, each.value.tcp_syn)) > 0 ? "synchronize" : ""]
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
