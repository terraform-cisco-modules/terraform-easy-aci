terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aci = {
      source  = "ciscodevnet/aci"
      version = ">= 1.2.0"
    }
  }
}

provider "aci" {
  cert_name   = var.certName
  password    = var.apicPass
  private_key = var.privateKey
  url         = var.apicUrl
  username    = var.apicUser
  insecure    = true
}
