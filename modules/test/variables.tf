terraform {
  experiments = [module_variable_optional_attrs]
}

variable "annotation" {
  default     = ""
  description = "workspace tag value."
  type        = string
}

variable "apicHostname" {
  default     = "apic.example.com"
  description = "Cisco APIC Hostname"
  type        = string
}

variable "apicPass" {
  default     = ""
  description = "Password for User based Authentication."
  sensitive   = true
  type        = string
}

variable "apicUser" {
  default     = "admin"
  description = "Username for User based Authentication."
  type        = string
}

variable "apic_version" {
  default     = "5.2(1g)"
  description = "The Version of ACI Running in the Environment."
  type        = string
}

