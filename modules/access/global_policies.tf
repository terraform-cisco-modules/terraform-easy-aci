terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
      version = ">= 1.2.0"
    }
  }
}

provider "aci" {
	cert_name   = var.aciCertName
	password    = var.aciPass
	private_key = var.aciPrivateKey
    url         = var.aciUrl
	username    = var.aciUser
	insecure    = true
}
