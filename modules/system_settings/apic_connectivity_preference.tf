variable "apic_connectivity_preference" {
  default     = "inband"
  description = <<-EOT
  * The preferred management connectivity preference. Options are:
    - inband: Executes in-band management connectivity between the APIC server to external devices through leaf switches on the ACI fabric.
    - ooband: Executes out-of-band management connectivity between the APIC server to external devices through connections external to the ACI fabric.
  EOT
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtConnectivityPrefs"
 - Distinguished Named "uni/fabric/connectivityPrefs"
GUI Location:
 - System > System Settings > APIC Connectivity Preferences
_______________________________________________________________________________________________________________________
*/
resource "aci_mgmt_preference" "apic_connectivity_preference" {
  annotation     = each.value.tags != "" ? each.value.tags : var.tags
  interface_pref = var.apic_connectivity_preference
}