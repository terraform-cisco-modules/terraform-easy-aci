terraform {
  experiments = [module_variable_optional_attrs]
}

variable "certName" {
  default     = ""
  description = "Cisco ACI Certificate Name for SSL Based Authentication"
  sensitive   = true
  type        = string
}

variable "apicPass" {
  default     = ""
  description = "Password for User based Authentication."
  sensitive   = true
  type        = string
}

variable "privateKey" {
  default     = ""
  description = "Cisco ACI Private Key for SSL Based Authentication."
  sensitive   = true
  type        = string
}

variable "apicUrl" {
  description = "Cisco APIC URL.  In Example http://apic.example.com"
  type        = string
}

variable "apicUser" {
  default     = ""
  description = "Username for User based Authentication."
  type        = string
}

variable "mcp_instance_key" {
  description = "The key or password to uniquely identify the MCP packets within this fabric."
  sensitive   = true
  type        = string
}

variable "apic_version" {
  default     = "5"
  description = "The Version of ACI Running in the Environment."
  type        = string
}

variable "two_slot_leafs" {
  default     = true
  description = <<-EOT
  Flag to Tell the Switch to Account for Leaf Switches in the Fabric with More than 99 Ports.
  It will Name Leaf Selectors as Eth1-001 instead of Eth1-01.
  EOT
  type        = bool
}