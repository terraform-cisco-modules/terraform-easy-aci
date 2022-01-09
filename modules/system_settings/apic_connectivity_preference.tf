/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "mgmtConnectivityPrefs"
 - Distinguished Named "uni/fabric/connectivityPrefs"
GUI Location:
 - System > System Settings > APIC Connectivity Preferences
_______________________________________________________________________________________________________________________
*/
resource "aci_mgmt_preference" "example" {
  interface_pref = "inband"
  annotation     = "orchestrator:terraform"
  description    = "from terraform"
  name_alias     = "example_name_alias"
}