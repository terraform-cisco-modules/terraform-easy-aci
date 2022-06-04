/*_____________________________________________________________________________________________________________________

ISIS Policy — Variables
_______________________________________________________________________________________________________________________
*/
variable "isis_policy" {
  default = {
    "default" = {
      annotation                                      = ""
      isis_mtu                                        = 1492
      isis_metric_for_redistributed_routes            = 63
      lsp_fast_flood_mode                             = "enabled"
      lsp_generation_initial_wait_interval            = 50
      lsp_generation_maximum_wait_interval            = 8000
      lsp_generation_second_wait_interval             = 50
      sfp_computation_frequency_initial_wait_interval = 50
      sfp_computation_frequency_maximum_wait_interval = 8000
      sfp_computation_frequency_second_wait_interval  = 50
    }
  }
  description = <<-EOT
    Key - This should always be default.
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * isis_mtu: (default: 1492) — The IS-IS Domain policy LSP MTU. The MTU is from 128 to 4352.
    * isis_metric_for_redistributed_routes: (default: 60) — The IS-IS metric that is used for all imported routes into IS-IS. The values available are from 1 to 63.
    * lsp_fast_flood_mode: (optional) — The IS-IS Fast-Flooding of LSPs improves Intermediate System-to-Intermediate System (IS-IS) convergence time when new link-state packets (LSPs) are generated in the network and shortest path first (SPF) is triggered by the new LSPs. The mode can be:
      - disabled
      - enabled: (default)
    * lsp_generation_initial_wait_interval: (default: 50) — The LSP generation initial wait interval. This is used in the LSP generation interval for the LSP MTU.
    * lsp_generation_maximum_wait_interval: (default: 8000) — The LSP generation maximum wait interval. This is used in the LSP generation interval for the LSP MTU. 
    * lsp_generation_second_wait_interval: (default: 50) — The LSP generation second wait interval. This is used in the LSP generation interval for the LSP MTU. 
    * sfp_computation_frequency_initial_wait_interval: (default: 50) — The SPF computation frequency initial wait interval. This is used in the SPF computations for the LSP MTU.
    * sfp_computation_frequency_maximum_wait_interval: (default: 8000) — The SPF computation frequency maximum wait interval. This is used in the SPF computations for the LSP MTU.
    * sfp_computation_frequency_second_wait_interval: (default: 50) — The SPF computation frequency second wait interval. This is used in the SPF computations for the LSP MTU.
  EOT
  type = map(object(
    {
      annotation                                      = optional(string)
      isis_mtu                                        = optional(number)
      isis_metric_for_redistributed_routes            = optional(number)
      lsp_fast_flood_mode                             = optional(string)
      lsp_generation_initial_wait_interval            = optional(number)
      lsp_generation_maximum_wait_interval            = optional(number)
      lsp_generation_second_wait_interval             = optional(number)
      sfp_computation_frequency_initial_wait_interval = optional(number)
      sfp_computation_frequency_maximum_wait_interval = optional(number)
      sfp_computation_frequency_second_wait_interval  = optional(number)
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
  annotation          = each.value.annotation != "" ? each.value.annotation : var.annotation
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