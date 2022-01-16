variable "coop_group_policy" {
  default     = "strict"
  description = <<-EOT
  COOP protocol is enhanced to support two ZMQ authentication modes:
  - compatible Type: COOP accepts both MD5 authenticated and non-authenticated ZMQ connections for message transportation.
  - strict: COOP allows MD5 authenticated ZMQ connections only.
  Note: The APIC provides a managed object (fabric:SecurityToken), that includes an attribute to be used for the MD5 password. An attribute in this managed object, called "token", is a string that changes every hour. COOP obtains the notification from the DME to update the password for ZMQ authentication. The attribute token value is not displayed.
  EOT
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "coopPol"
 - Distinguished Named "uni/fabric/pol-default"
GUI Location:
 - System > System Settings > Coop Group > Type
_______________________________________________________________________________________________________________________
*/
resource "aci_coop_policy" "coop_group_policy" {
  annotation = var.annotation
  type       = var.coop_group_policy
}