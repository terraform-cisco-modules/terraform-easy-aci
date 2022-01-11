#----------------------------------------------
# Create a Triggered Scheduler
#----------------------------------------------

/*
API Information:
 - Class: "trigSchedP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name}
*/
resource "aci_trigger_scheduler" "trigger_schedulers" {
  description = each.value.description
  name        = each.value.name
}

#----------------------------------------------------
# Assign a Recurring Window to the Trigger Scheduler
#----------------------------------------------------
/*
API Information:
 - Class: "trigRecurrWindowP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name} > Recurring Window {scheduler_name}
*/
resource "aci_rest" "recurring_windows" {
  depends_on = [
    aci_trigger_scheduler.trigger_schedulers
  ]
  path       = "/api/node/mo/uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}.json"
  class_name = "trigRecurrWindowP"
  payload    = <<EOF
{
    "trigRecurrWindowP": {
        "attributes": {
            "concurCap": "{Concurrent_Capacity}",
            "day": "{Days}",
            "dn": "uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}",
            "hour": "{Backup_Hour}",
            "minute": "{Backup_Minute}",
            "name": "{scheduler_name}",
        },
        "children": []
    }
}
    EOF
}

/*
API Information:
 - Class: "fileRemotePath"
 - Distinguished Name: "uni/fabric/path-{Remote_Host}"
GUI Location:
 - Admin > Import/Export > Remote Locations:{Remote_Host}
*/
resource "aci_file_remote_path" "export_remote_hosts" {
  name        = "example"
  annotation  = "orchestrator:terraform"
  auth_type   = "usePassword"
  host        = "cisco.com"
  protocol    = "sftp"
  remote_path = "/example_remote_path"
  remote_port = "0"
  user_name   = "example_user_name"
  user_passwd = "password"
  name_alias  = "example_name_alias"
  description = "from terraform"
}

#----------------------------------------------------
# Create Configuration Export Policy
#----------------------------------------------------

/*
API Information:
 - Class: "configExportP"
 - Distinguished Name: "uni/fabric/configexp-{Export_Name}"
GUI Location:
 - Admin > Import/Export > Export Policies > Configuration > {Export_Name}
*/
resource "aci_configuration_export_policy" "example" {
  depends_on = [
    aci_file_remote_path.export_remote_hosts,
    aci_trigger_scheduler.trigger_schedulers
  ]
  admin_st              = "untriggered"
  annotation            = "example"
  description           = "from terraform"
  format                = "json"
  include_secure_fields = "yes"
  max_snapshot_count    = "10"
  name                  = "example"
  name_alias            = "example"
  snapshot              = "yes"
  # target_dn             = "uni/tn-test"
  target_dn                             = aci_file_remote_path.export_remote_hosts[each.value.remote_host].id
  relation_config_rs_export_destination = aci_file_remote_path.export_remote_hosts[each.value.remote_host].id
  # relation_trig_rs_triggerable            = "Unsure"
  relation_config_rs_remote_path      = aci_file_remote_path.export_remote_hosts[each.value.remote_host].id
  relation_config_rs_export_scheduler = aci_trigger_scheduler.trigger_schedulers[each.value.trigger_scheduler].id
}
