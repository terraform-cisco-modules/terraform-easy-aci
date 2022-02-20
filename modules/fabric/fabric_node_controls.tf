variable "fabric_node_controls" {
  default = {
    "default" = {
      annotation         = ""
      description        = ""
      enable_dom         = "Dom"
      feature_selections = "telemetry"
      name_alias         = ""
    }
  }
  description = <<-EOT
  Key: Name of the Fabric Node Control Policy - **This should always be default.
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * enable_dom: A check box that enables or disables digital optical monitoring (DOM) for the fabric node control.
    - Dom: Enables digital optical monitoring.
    - None: Disables digital optical monitoring.
  * feature_selections: ACI switch hardware supports either NetFlow or Cisco Tetration Analytics, but not both. If the APIC pushes both Cisco Tetration Analytics and NetFlow configurations to a particular node, the chosen priority flag alerts the switch as to which feature should be given priority. The other feature’s configuration is ignored.
    - analytics: Analytic priority downloads the Cisco Tetration Analytics sensor software for installation on the switches.
    - netflow: Netflow priority downloads and installs the Cisco Netflow configuration on the switches to analyze network traffic.
    - telemetry: Telemetry priority is used in conjunction with the Network Insight Resources APIC App. This policy enables Cisco Telemetry configuration on the switches to analyze network traffic.
  * name_alias: A changeable name for a given object. While the name of an object, once created, cannot be changed, the name_alias is a field that can be changed.
  EOT
  type = map(object(
    {
      annotation         = optional(string)
      description        = optional(string)
      enable_dom         = optional(string)
      feature_selections = optional(string)
      name_alias         = optional(string)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fabricNodeControl"
 - Distinguished Named "uni/fabric/nodecontrol-default"
GUI Location:
 - Fabric > Fabric Policies > Policies > Monitoring > Fabric Node Controls > default
_______________________________________________________________________________________________________________________
*/
resource "aci_fabric_node_control" "fabric_node_controls" {
  for_each    = local.fabric_node_controls
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  control     = each.value.enable_dom
  description = each.value.description
  feature_sel = each.value.feature_selections
  name        = "default"
  name_alias  = each.value.name_alias
}