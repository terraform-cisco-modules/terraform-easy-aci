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