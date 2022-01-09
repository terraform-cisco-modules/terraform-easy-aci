/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "pkiExportEncryptionKey"
 - Distinguished Name: "uni/exportcryptkey"
GUI Location:
 - System > System Settings > Global AES Passphrase Ecryption Settings
_______________________________________________________________________________________________________________________
*/
resource "aci_encryption_key" "example" {
  description                       = "from terraform"
  annotation                        = "orchestrator:terraform"
  name_alias                        = "example_name_alias"
  clear_encryption_key              = "no"
  passphrase                        = "example_passphrase"
  passphrase_key_derivation_version = "v1"
  strong_encryption_enabled         = "yes"
}