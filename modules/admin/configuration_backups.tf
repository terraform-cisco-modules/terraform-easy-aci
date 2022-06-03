/*_____________________________________________________________________________________________________________________

Configuration Backups - Admin > Import/Export Policies
_______________________________________________________________________________________________________________________
*/
variable "configuration_backups" {
  default = {
    "default" = {
      annotation = ""
      configuration_export = [
        {
          authentication_type   = "usePassword"
          description           = ""
          format                = "json"
          include_secure_fields = false
          management_epg        = "default"
          management_epg_type   = "oob"
          max_snapshot_count    = 0
          password              = 1
          protocol              = "sftp"
          remote_hosts          = ["fileserver.example.com"]
          remote_path           = "/tmp"
          remote_port           = 22
          snapshot              = false
          start_now             = false
          username              = "admin"
        }
      ]
      recurring_window = [
        {
          delay_between_node_upgrades = 0 # Only applicable if the maximum concurrent node count is 1.
          description                 = ""
          maximum_concurrent_nodes    = 0
          maximum_running_time        = 0
          processing_break            = "none"
          processing_size_capacity    = 0
          schedule = [
            {
              days   = "every-day"
              hour   = 23
              minute = 45
            }
          ]
          window_type = "recurring"
        }
      ]
    }
  }
  description = <<-EOT
    Key — Name of your Configuration Backup Policy
    * annotation: (optional) — An annotation will mark an Object in the GUI with a small blue circle, signifying that it has been modified by  an external source/tool.  Like Nexus Dashboard Orchestrator or in this instance Terraform.
    * configuration_export: (required) — Configuration Export Map.
      - authentication_type: (optional) — Authentication Type Choice. Allowed values are:
        * usePassword: (default)
        * useSshKeyContents
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - format: (optional) — The data format to be used when exporting the configuration export policy. The format can be:
        * json: (default)
        * xml
      - include_secure_fields: (default: false) — This required the Global AES Settings to be enabled for this to be set to true.
      - management_epg: (required) — Name of the Management EPG
      - management_epg_type: (optional) — Type of Management EPG.  Options are:
        * inb
        * oob: (default)
      - max_snapshot_count: (default: 0) — A value between 0-10.
      - password: (required if UsePassword) — Password Key "remote_password_{key}" when authentication_type is set to "usePassword".
      - protocol: (optional) — Transfer protocol to be used for data export of object File Remote Path .  Allowed values are:
        * ftp
        * scp
        * sftp: (default)
        Note: Value "ftp" cannot be set if authentication_type is equal to "useSshKeyContents"
      - remote_hosts — List of Remote Hosts to Export the Policy to.
      - remote_path — Remote Path on the Hosts.
      - remote_port — Remote Protocol Port 0-65535.  Default is port 22.
      - snapshot — Flag to set Snapshot for object configuration export policy. 
      - start_now — Flag to start the export now.  Options are true or false
      - username: (required if UsePassword) — Username for the Remote Host when authentication_type is set to "usePassword".
    * recurring_window: (required) — Recuring Window Map.
      - delay_between_node_upgrades: (default: 0) — Delay between node upgrades. Delay between node upgrades in seconds. Range: "0" - "18000".
      - description: (optional) — Description to add to the Object.  The description can be up to 128 characters.
      - maximum_concurrent_nodes: (default: 0) — The concurrency capacity limit. This is the maximum number of tasks that can be processed concurrently.
      - maximum_running_time: (default: 0) — The processing time capacity limit. This is the maximum duration of the window. The range is 0 to (2^64 - 1) milliseconds. The default value of 0 indicates unlimited, meaning there is no time limit enforced on the scheduler window.
      - processing_break: (default: none) — A period of time taken between processing of items within the concurrency cap. Allowed Min Value: "00:00:00:00.001"(Format is DD:HH:MM:SS.Milliseconds). 
        * NOTE: (If user sets "00:00:00:00.000" as a value, provider will accept it but it'll set it as "none").
      - processing_size_capacity: (default: 0) — Processing size capacity limitation specification. Indicates the limit of items to be processed within this window. Range: "1" - "65535".
      - schedule: (optional)
        * days — Recurring Window Schedule Day(s). Options are:
          - every-day: (default)
          - even-day
          - odd-day
          - Sunday
          - Monday
          - Tuesday
          - Wednesday
          - Thursday
          - Friday
          - Saturday
          - Sunday
        * hour: (default: 23) — The hour that the recurring window begins. Specify the hour as 0 to 24.
        * minute: (default: 45) — The minute that the recurring window begins. Specify the minute as 0 to 59.
      - window_type: (default: recurring) — Currently this will always be "recurring"
  EOT
  type = map(object(
    {
      annotation = optional(string)
      configuration_export = list(object(
        {
          authentication_type   = optional(string)
          description           = optional(string)
          format                = optional(string)
          include_secure_fields = optional(bool)
          management_epg        = optional(string)
          management_epg_type   = optional(string)
          max_snapshot_count    = optional(number)
          password              = optional(number)
          protocol              = optional(string)
          remote_hosts          = list(string)
          remote_path           = optional(string)
          remote_port           = optional(number)
          snapshot              = optional(bool)
          start_now             = optional(bool)
          username              = optional(string)
        }
      ))
      recurring_window = list(object(
        {
          delay_between_node_upgrades = optional(number)
          description                 = optional(string)
          maximum_concurrent_nodes    = optional(number)
          maximum_running_time        = optional(string)
          processing_break            = optional(string)
          processing_size_capacity    = optional(number)
          schedule = optional(list(object(
            {
              days   = optional(string)
              hour   = optional(number)
              minute = optional(number)
            }
          )))
          window_type = optional(string)
        }
      ))
    }
  ))
}

variable "remote_password_1" {
  default     = ""
  description = "Remote Host Password 1."
  sensitive   = true
  type        = string
}

variable "remote_password_2" {
  default     = ""
  description = "Remote Host Password 2."
  sensitive   = true
  type        = string
}

variable "remote_password_3" {
  default     = ""
  description = "Remote Host Password 3."
  sensitive   = true
  type        = string
}

variable "remote_password_4" {
  default     = ""
  description = "Remote Host Password 4."
  sensitive   = true
  type        = string
}

variable "remote_password_5" {
  default     = ""
  description = "Remote Host Password 5."
  sensitive   = true
  type        = string
}

variable "ssh_key_contents" {
  default     = ""
  description = "SSH Private Key Based Authentication Contents."
  sensitive   = true
  type        = string
}

variable "ssh_key_passphrase" {
  default     = ""
  description = "SSH Private Key Based Authentication Passphrase."
  sensitive   = true
  type        = string
}


#----------------------------------------------
# Create a Triggered Scheduler
#----------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "trigSchedP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_trigger_scheduler" "trigger_schedulers" {
  for_each    = local.trigger_schedulers
  annotation  = each.value.annotation != "" ? each.value.annotation : var.annotation
  description = each.value.description
  name        = each.key
}

#----------------------------------------------------
# Assign a Recurring Window to the Trigger Scheduler
#----------------------------------------------------
/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "trigRecurrWindowP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name} > Recurring Window {scheduler_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_recurring_window" "recurring_window" {
  depends_on = [
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each   = local.recurring_window
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  concur_cap = each.value.maximum_concurrent_nodes == 0 ? "unlimited" : each.value.maximum_concurrent_nodes
  day        = each.value.schedule[0].days   # "every-day"
  hour       = each.value.schedule[0].hour   # 0
  minute     = each.value.schedule[0].minute # 0
  name       = each.key
  node_upg_interval = length(regexall(
    1, each.value.maximum_concurrent_nodes)
  ) > 0 && each.value.window_type == "one-time" ? each.value.delay_between_node_upgrades : 0
  proc_break   = each.value.processing_break # "none"
  proc_cap     = each.value.processing_size_capacity == 0 ? "unlimited" : each.value.processing_size_capacity
  scheduler_dn = aci_trigger_scheduler.trigger_schedulers[each.key].id
  time_cap     = each.value.maximum_running_time == 0 ? "unlimited" : each.value.processing_size_capacity
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "fileRemotePath"
 - Distinguished Name: "uni/fabric/path-{remote_host}"
GUI Location:
 - Admin > Import/Export > Remote Locations:{remote_host}
_______________________________________________________________________________________________________________________
*/
resource "aci_file_remote_path" "export_remote_hosts" {
  for_each                        = local.configuration_export
  annotation                      = each.value.annotation != "" ? each.value.annotation : var.annotation
  auth_type                       = each.value.authentication_type
  description                     = each.value.description
  host                            = each.value.remote_host
  identity_private_key_contents   = each.value.authentication_type == "useSshKeyContents" ? var.ssh_key_contents : ""
  identity_private_key_passphrase = each.value.authentication_type == "useSshKeyContents" ? var.ssh_key_passphrase : ""
  name                            = each.key
  protocol                        = each.value.protocol
  remote_path                     = each.value.remote_path
  remote_port                     = each.value.remote_port
  user_name                       = each.value.authentication_type == "usePassword" ? each.value.username : ""
  user_passwd = length(regexall(
    5, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_5 : length(regexall(
    4, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_4 : length(regexall(
    3, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_3 : length(regexall(
    2, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_2 : length(regexall(
  1, each.value.password)) > 0 && each.value.authentication_type == "usePassword" ? var.remote_password_1 : ""
  relation_file_rs_a_remote_host_to_epg = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
}

#----------------------------------------------------
# Create Configuration Export Policy
#----------------------------------------------------

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "configExportP"
 - Distinguished Name: "uni/fabric/configexp-{export_name}"
GUI Location:
 - Admin > Import/Export > Export Policies > Configuration > {export_name}
_______________________________________________________________________________________________________________________
*/
resource "aci_configuration_export_policy" "configuration_export" {
  depends_on = [
    aci_file_remote_path.export_remote_hosts,
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each                              = local.configuration_export
  admin_st                              = each.value.start_now == true ? "triggered" : "untriggered"
  annotation                            = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                           = each.value.description
  format                                = each.value.format # "json|xml"
  include_secure_fields                 = each.value.include_secure_fields == true ? "yes" : "no"
  max_snapshot_count                    = each.value.max_snapshot_count == 0 ? "global-limit" : 0 # 0-10
  name                                  = each.key
  snapshot                              = each.value.snapshot == true ? "yes" : "no"
  target_dn                             = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_destination = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_scheduler   = aci_trigger_scheduler.trigger_schedulers[each.value.key1].id
}
