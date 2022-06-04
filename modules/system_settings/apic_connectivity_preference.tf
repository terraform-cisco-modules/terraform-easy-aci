/*_____________________________________________________________________________________________________________________

APIC Connectivity Preference — Variables
_______________________________________________________________________________________________________________________
*/
variable "apic_connectivity_preference" {
  default     = "ooband"
  description = <<-EOT
  * The preferred management connectivity preference. Options are:
    - inband — Executes in-band management connectivity between the APIC server to external devices through leaf switches on the ACI fabric.
    - ooband: (default) — Executes out-of-band management connectivity between the APIC server to external devices through connections external to the ACI fabric.
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
  annotation     = var.annotation
  interface_pref = var.apic_connectivity_preference
}