variable "configuration_backups" {
  default = {
    "default" = {
      annotation = ""
      configuration_export = [
        {
          authentication_type   = "usePassword"
          description           = ""
          format                = "json"
          include_secure_fields = true
          management_epg        = "default"
          management_epg_type   = "oob"
          max_snapshot_count    = 0
          password              = 1
          protocol              = "sftp"
          remote_hosts          = ["fileserver.example.com"]
          remote_path           = "/tmp"
          remote_port           = 22
          snapshot              = false
          ssh_key_contents      = 0
          ssh_key_passphrase    = 0
          start_now             = "untriggered"
          username              = "admin"
        }
      ]
      recurring_window = [
        {
          delay_between_node_upgrades = 0 # Only applicable if the maximum concurrent node count is 1.
          description                 = ""
          maximum_concurrent_nodes    = "unlimited"
          maximum_running_time        = "unlimited"
          processing_break            = "none"
          processing_size_capacity    = "unlimited"
          scheduled_days              = "every-day"
          scheduled_hour              = 23
          scheduled_minute            = 45
          window_type                 = "recurring"
        }
      ]
    }
  }
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
          ssh_key_contents      = optional(number)
          ssh_key_passphrase    = optional(number)
          start_now             = optional(string)
          username              = optional(string)
        }
      ))
      recurring_window = list(object(
        {
          delay_between_node_upgrades = optional(number)
          description                 = optional(string)
          maximum_concurrent_nodes    = optional(string)
          maximum_running_time        = optional(string)
          processing_break            = optional(string)
          processing_size_capacity    = optional(string)
          scheduled_days              = optional(string)
          scheduled_hour              = optional(number)
          scheduled_minute            = optional(number)
          window_type                 = optional(string)
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

/*
API Information:
 - Class: "trigSchedP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name}
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
/*
API Information:
 - Class: "trigRecurrWindowP"
 - Distinguished Name: "uni/fabric/schedp-{scheduler_name}/recurrwinp-{scheduler_name}"
GUI Location:
 - Admin > Schedulers > Fabric > {scheduler_name} > Recurring Window {scheduler_name}
*/
resource "aci_recurring_window" "recurring_window" {
  depends_on = [
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each   = local.recurring_window
  annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
  concur_cap = each.value.maximum_concurrent_nodes # "unlimited"
  day        = each.value.scheduled_days           # "every-day"
  hour       = each.value.scheduled_hour           # 0
  minute     = each.value.scheduled_minute         # 0
  name       = each.key
  node_upg_interval = length(regexall(
    1, each.value.maximum_concurrent_nodes)
  ) > 0 && each.value.window_type == "one-time" ? each.value.delay_between_node_upgrades : 0
  proc_break   = each.value.processing_break         # "none"
  proc_cap     = each.value.processing_size_capacity # "unlimited"
  scheduler_dn = aci_trigger_scheduler.trigger_schedulers[each.key].id
  time_cap     = each.value.maximum_running_time # "unlimited"
}


/*
API Information:
 - Class: "fileRemotePath"
 - Distinguished Name: "uni/fabric/path-{remote_host}"
GUI Location:
 - Admin > Import/Export > Remote Locations:{Remote_Host}
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

/*
API Information:
 - Class: "configExportP"
 - Distinguished Name: "uni/fabric/configexp-{Export_Name}"
GUI Location:
 - Admin > Import/Export > Export Policies > Configuration > {Export_Name}
*/
resource "aci_configuration_export_policy" "configuration_export" {
  depends_on = [
    aci_file_remote_path.export_remote_hosts,
    aci_trigger_scheduler.trigger_schedulers
  ]
  for_each                              = local.configuration_export
  admin_st                              = each.value.start_now # triggered|untriggered
  annotation                            = each.value.annotation != "" ? each.value.annotation : var.annotation
  description                           = each.value.description
  format                                = each.value.format # "json|xml"
  include_secure_fields                 = each.value.include_secure_fields == true ? "yes" : "no"
  max_snapshot_count                    = each.value.max_snapshot_count == 0 ? "global-limit" : 0 # 0-10
  name                                  = each.key
  snapshot                              = each.value.snapshot == true ? "yes" : "no"
  target_dn                             = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_destination = aci_file_remote_path.export_remote_hosts[each.key].id
  # relation_trig_rs_triggerable            = Unsure
  # relation_config_rs_remote_path      = aci_file_remote_path.export_remote_hosts[each.key].id
  relation_config_rs_export_scheduler = aci_trigger_scheduler.trigger_schedulers[each.value.key1].id
}
