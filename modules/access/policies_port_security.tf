/*_____________________________________________________________________________________________________________________

Policies — Port Security — Variables
_______________________________________________________________________________________________________________________
*/
variable "policies_port_security" {
  default = {
    "default" = {
      annotation            = ""
      description           = ""
      maximum_endpoints     = 0
      port_security_timeout = 60
    }
  }
  description = <<-EOT
    Key — Name of the Port Security Policy.
    * annotation — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * description — Description to add to the Object.  The description can be up to 128 characters.
    * maximum_endpoints — (Default value is 0).  The maximum number of endpoints that can be learned on the interface. The current supported range for the maximum endpoints configured value is from 0 to 12000. If the maximum endpoints value is 0, the port security policy is disabled on that port.
    * port_security_timeout — (Default value is 60).  The delay time before MAC learning is re-enabled. The current supported range for the timeout value is from 60 to 3600.
  EOT
  type = map(object(
    {
      annotation            = optional(string)
      description           = optional(string)
      maximum_endpoints     = optional(number)
      port_security_timeout = optional(number)
    }
  ))
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "l2PortSecurityPol"
 - Distinguished Name: "uni/infra/portsecurityP-{name}"
GUI Location:
 - Fabric > Access Policies > Policies > Interface > Port Security : {name}
_______________________________________________________________________________________________________________________
*/
resource "aci_port_security_policy" "policies_port_security" {
  for_each    = local.policies_port_security
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  maximum     = each.value.maximum_endpoints
  name        = each.key
  timeout     = each.value.port_security_timeout
  violation   = "protect"
}
