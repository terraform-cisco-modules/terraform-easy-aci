/*_____________________________________________________________________________________________________________________

Global AES Encryption Setting — Variables
_______________________________________________________________________________________________________________________
*/
variable "global_aes_encryption_settings" {
  default = {
    "default" = {
      clear_passphrase                  = false
      enable_encryption                 = true
      passphrase_key_derivation_version = "v1"
    }
  }
  description = <<-EOT
    Key - This should always be default.
    * clear_passphrase: (optional) — Flag to clear the passphrase when disabling Global AES Encryption.
      - false: (default)
      - true
    * enable_encryption: (optional) — Enables strong encryption on the import or export policy.
      - false
      - true: (default)
    * passphrase_key_derivation_version: (default: v1) — v1 is the only option today.
  EOT
  type = map(object(
    {
      clear_passphrase                  = optional(bool)
      enable_encryption                 = optional(bool)
      passphrase_key_derivation_version = optional(string)
    }
  ))
}

variable "aes_passphrase" {
  description = "Global AES Passphrase."
  sensitive   = true
  type        = string
}
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "pkiExportEncryptionKey"
 - Distinguished Name: "uni/exportcryptkey"
GUI Location:
 - System > System Settings > Global AES Passphrase Encryption Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_encryption_key" "global_aes_passphrase" {
  for_each                          = local.global_aes_encryption_settings
  clear_encryption_key              = each.value.clear_passphrase == true ? "yes" : "no"
  passphrase                        = var.aes_passphrase
  passphrase_key_derivation_version = each.value.passphrase_key_derivation_version # "v1"
  strong_encryption_enabled         = each.value.enable_encryption == true ? "yes" : "no"
}