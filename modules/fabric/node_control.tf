resource "aci_fabric_node_control" "example" {
  name  = "example"
  annotation = "orchestrator:terraform"
  control = "Dom"
  feature_sel = "telemetry"
  name_alias = "example_name_alias"
  description = "from terraform"
}