variable "isis_policy" {
  default = {
    "default" = {
      isis_mtu                                        = 1492
      isis_metric_for_redistributed_routes            = 63
      lsp_fast_flood_mode                             = "enabled"
      lsp_generation_initial_wait_interval            = 50
      lsp_generation_maximum_wait_interval            = 8000
      lsp_generation_second_wait_interval             = 50
      sfp_computation_frequency_initial_wait_interval = 50
      sfp_computation_frequency_maximum_wait_interval = 50
      sfp_computation_frequency_second_wait_interval  = 50
      tags                                            = ""
    }
  }
  type = map(object(
    {
      isis_mtu                                        = optional(number)
      isis_metric_for_redistributed_routes            = optional(number)
      lsp_fast_flood_mode                             = optional(string)
      lsp_generation_initial_wait_interval            = optional(number)
      lsp_generation_maximum_wait_interval            = optional(number)
      lsp_generation_second_wait_interval             = optional(number)
      sfp_computation_frequency_initial_wait_interval = optional(number)
      sfp_computation_frequency_maximum_wait_interval = optional(number)
      sfp_computation_frequency_second_wait_interval  = optional(number)
      tags                                            = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "isisDomPol"
 - Distinguished Name: "uni/fabric/isisDomP-default"
GUI Location:
 - System > System Settings > ISIS Policy
_______________________________________________________________________________________________________________________
*/
resource "aci_isis_domain_policy" "isis_policy" {
  for_each            = local.isis_policy
  annotation          = each.value.tags != "" ? each.value.tags : var.tags
  lsp_fast_flood      = each.value.lsp_fast_flood_mode
  lsp_gen_init_intvl  = each.value.lsp_generation_initial_wait_interval
  lsp_gen_max_intvl   = each.value.lsp_generation_maximum_wait_interval
  lsp_gen_sec_intvl   = each.value.lsp_generation_second_wait_interval
  mtu                 = each.value.isis_mtu
  redistrib_metric    = each.value.isis_metric_for_redistributed_routes
  spf_comp_init_intvl = each.value.sfp_computation_frequency_initial_wait_interval
  spf_comp_max_intvl  = each.value.sfp_computation_frequency_maximum_wait_interval
  spf_comp_sec_intvl  = each.value.sfp_computation_frequency_second_wait_interval
}