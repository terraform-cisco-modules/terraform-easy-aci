terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.0.0"
    }
  }
}

provider "aci" {
  cert_name   = var.certName
  password    = var.apicPass
  private_key = var.privateKey
  url         = "https://${var.apicHostname}"
  username    = var.apicUser
  insecure    = true
}
