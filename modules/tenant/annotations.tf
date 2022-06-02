# I will have to think how I want to accomplish this.
resource "aci_rest_managed" "annotations" {
  depends_on = [
  ]
  for_each   = local.annotations
  dn         = each.value.distinguished_name
  class_name = "tagAliasInst"
  content = {
    name = each.value.alias
  }
}

