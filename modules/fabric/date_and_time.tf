variable "date_and_time" {
  default = {
    default = {
      administrative_state = "enabled"
      authentication_keys  = []
      description          = ""
      display_format       = "local"
      master_mode          = "disabled"
      ntp_servers          = []
      offset_state         = "enabled"
      server_state         = "enabled"
      stratum_value        = 8
      time_zone            = "UTC"
    }
  }
  description = <<-EOT
  * time_zone: Valid Timezones:
    - Africa/Abidjan
    - Africa/Accra
    - Africa/Addis_Ababa
    - Africa/Algiers
    - Africa/Asmara
    - Africa/Bamako
    - Africa/Bangui
    - Africa/Banjul
    - Africa/Bissau
    - Africa/Blantyre
    - Africa/Brazzaville
    - Africa/Bujumbura
    - Africa/Cairo
    - Africa/Casablanca
    - Africa/Ceuta
    - Africa/Conakry
    - Africa/Dakar
    - Africa/Dar_es_Salaam
    - Africa/Djibouti
    - Africa/Douala
    - Africa/El_Aaiun
    - Africa/Freetown
    - Africa/Gaborone
    - Africa/Harare
    - Africa/Johannesburg
    - Africa/Juba
    - Africa/Kampala
    - Africa/Khartoum
    - Africa/Kigali
    - Africa/Kinshasa
    - Africa/Lagos
    - Africa/Libreville
    - Africa/Lome
    - Africa/Luanda
    - Africa/Lubumbashi
    - Africa/Lusaka
    - Africa/Malabo
    - Africa/Maputo
    - Africa/Maseru
    - Africa/Mbabane
    - Africa/Mogadishu
    - Africa/Monrovia
    - Africa/Nairobi
    - Africa/Ndjamena
    - Africa/Niamey
    - Africa/Nouakchott
    - Africa/Ouagadougou
    - Africa/Porto-Novo
    - Africa/Sao_Tome
    - Africa/Tripoli
    - Africa/Tunis
    - Africa/Windhoek
    - America/Adak
    - America/Anchorage
    - America/Anguilla
    - America/Antigua
    - America/Araguaina
    - America/Argentina/Buenos_Aires
    - America/Argentina/Catamarca
    - America/Argentina/Cordoba
    - America/Argentina/Jujuy
    - America/Argentina/La_Rioja
    - America/Argentina/Mendoza
    - America/Argentina/Rio_Gallegos
    - America/Argentina/Salta
    - America/Argentina/San_Juan
    - America/Argentina/San_Luis
    - America/Argentina/Tucuman
    - America/Argentina/Ushuaia
    - America/Aruba
    - America/Asuncion
    - America/Atikokan
    - America/Bahia_Banderas
    - America/Barbados
    - America/Belem
    - America/Belize
    - America/Blanc-Sablon
    - America/Boa_Vista
    - America/Bogota
    - America/Boise
    - America/Cambridge_Bay
    - America/Campo_Grande
    - America/Cancun
    - America/Caracas
    - America/Cayenne
    - America/Cayman
    - America/Chicago
    - America/Chihuahua
    - America/Costa_Rica
    - America/Creston
    - America/Cuiaba
    - America/Curacao
    - America/Danmarkshavn
    - America/Dawson
    - America/Dawson_Creek
    - America/Denver
    - America/Detroit
    - America/Dominica
    - America/Edmonton
    - America/Eirunepe
    - America/El_Salvador
    - America/Fortaleza
    - America/Glace_Bay
    - America/Godthab
    - America/Goose_Bay
    - America/Grand_Turk
    - America/Grenada
    - America/Guadeloupe
    - America/Guatemala
    - America/Guayaquil
    - America/Guyana
    - America/Halifax
    - America/Havana
    - America/Hermosillo
    - America/Indiana/Indianapolis
    - America/Indiana/Knox
    - America/Indiana/Marengo
    - America/Indiana/Petersburg
    - America/Indiana/Tell_City
    - America/Indiana/Vevay
    - America/Indiana/Vincennes
    - America/Indiana/Winamac
    - America/Inuvik
    - America/Iqaluit
    - America/Jamaica
    - America/Juneau
    - America/Kentucky/Louisville
    - America/Kentucky/Monticello
    - America/Kralendijk
    - America/La_Paz
    - America/Lima
    - America/Los_Angeles
    - America/Lower_Princes
    - America/Maceio
    - America/Managua
    - America/Manaus
    - America/Marigot
    - America/Martinique
    - America/Matamoros
    - America/Mazatlan
    - America/Menominee
    - America/Merida
    - America/Metlakatla
    - America/Mexico_City
    - America/Miquelon
    - America/Moncton
    - America/Monterrey
    - America/Montevideo
    - America/Montreal
    - America/Montserrat
    - America/Nassau
    - America/New_York
    - America/Nipigon
    - America/Nome
    - America/Noronha
    - America/North_Dakota/Beulah
    - America/North_Dakota/Center
    - America/North_Dakota/New_Salem
    - America/Ojinaga
    - America/Panama
    - America/Pangnirtung
    - America/Paramaribo
    - America/Phoenix
    - America/Port-au-Prince
    - America/Port_of_Spain
    - America/Porto_Velho
    - America/Puerto_Rico
    - America/Rainy_River
    - America/Rankin_Inlet
    - America/Recife
    - America/Regina
    - America/Resolute
    - America/Rio_Branco
    - America/Santa_Isabel
    - America/Santarem
    - America/Santiago
    - America/Santo_Domingo
    - America/Sao_Paulo
    - America/Scoresbysund
    - America/Shiprock
    - America/Sitka
    - America/St_Barthelemy
    - America/St_Johns
    - America/St_Kitts
    - America/St_Lucia
    - America/St_Thomas
    - America/St_Vincent
    - America/Swift_Current
    - America/Tegucigalpa
    - America/Thule
    - America/Thunder_Bay
    - America/Tijuana
    - America/Toronto
    - America/Tortola
    - America/Vancouver
    - America/Whitehorse
    - America/Winnipeg
    - America/Yakutat
    - America/Yellowknife
    - Antarctica/Casey
    - Antarctica/Davis
    - Antarctica/DumontDUrville
    - Antarctica/Macquarie
    - Antarctica/Mawson
    - Antarctica/McMurdo
    - Antarctica/Palmer
    - Antarctica/Rothera
    - Antarctica/South_Pole
    - Antarctica/Syowa
    - Antarctica/Vostok
    - Arctic/Longyearbyen
    - Asia/Aden
    - Asia/Almaty
    - Asia/Amman
    - Asia/Anadyr
    - Asia/Aqtau
    - Asia/Aqtobe
    - Asia/Ashgabat
    - Asia/Baghdad
    - Asia/Bahrain
    - Asia/Baku
    - Asia/Bangkok
    - Asia/Beirut
    - Asia/Bishkek
    - Asia/Brunei
    - Asia/Choibalsan
    - Asia/Chongqing
    - Asia/Colombo
    - Asia/Damascus
    - Asia/Dhaka
    - Asia/Dili
    - Asia/Dubai
    - Asia/Dushanbe
    - Asia/Gaza
    - Asia/Harbin
    - Asia/Hebron
    - Asia/Ho_Chi_Minh
    - Asia/Hong_Kong
    - Asia/Hovd
    - Asia/Irkutsk
    - Asia/Jakarta
    - Asia/Jayapura
    - Asia/Jerusalem
    - Asia/Kabul
    - Asia/Kamchatka
    - Asia/Karachi
    - Asia/Kashgar
    - Asia/Kathmandu
    - Asia/Kolkata
    - Asia/Krasnoyarsk
    - Asia/Kuala_Lumpur
    - Asia/Kuching
    - Asia/Kuwait
    - Asia/Macau
    - Asia/Magadan
    - Asia/Makassar
    - Asia/Manila
    - Asia/Muscat
    - Asia/Nicosia
    - Asia/Novokuznetsk
    - Asia/Novosibirsk
    - Asia/Omsk
    - Asia/Oral
    - Asia/Phnom_Penh
    - Asia/Pontianak
    - Asia/Pyongyang
    - Asia/Qatar
    - Asia/Qyzylorda
    - Asia/Rangoon
    - Asia/Riyadh
    - Asia/Sakhalin
    - Asia/Samarkand
    - Asia/Seoul
    - Asia/Shanghai
    - Asia/Singapore
    - Asia/Taipei
    - Asia/Tashkent
    - Asia/Tbilisi
    - Asia/Tehran
    - Asia/Thimphu
    - Asia/Tokyo
    - Asia/Ulaanbaatar
    - Asia/Urumqi
    - Asia/Vientiane
    - Asia/Vladivostok
    - Asia/Yakutsk
    - Asia/Yekaterinburg
    - Asia/Yerevan
    - Atlantic/Azores
    - Atlantic/Bermuda
    - Atlantic/Canary
    - Atlantic/Cape_Verde
    - Atlantic/Faroe
    - Atlantic/Madeira
    - Atlantic/Reykjavik
    - Atlantic/South_Georgia
    - Atlantic/St_Helena
    - Atlantic/Stanley
    - Australia/Adelaide
    - Australia/Brisbane
    - Australia/Broken_Hill
    - Australia/Currie
    - Australia/Darwin
    - Australia/Eucla
    - Australia/Hobart
    - Australia/Lindeman
    - Australia/Lord_Howe
    - Australia/Melbourne
    - Australia/Perth
    - Australia/Sydney
    - Coordinated Universal Time
    - Europe/Amsterdam
    - Europe/Andorra
    - Europe/Athens
    - Europe/Belgrade
    - Europe/Berlin
    - Europe/Bratislava
    - Europe/Brussels
    - Europe/Bucharest
    - Europe/Budapest
    - Europe/Chisinau
    - Europe/Copenhagen
    - Europe/Dublin
    - Europe/Gibraltar
    - Europe/Guernsey
    - Europe/Helsinki
    - Europe/Isle_of_Man
    - Europe/Istanbul
    - Europe/Jersey
    - Europe/Kaliningrad
    - Europe/Kiev
    - Europe/Lisbon
    - Europe/Ljubljana
    - Europe/London
    - Europe/Luxembourg
    - Europe/Madrid
    - Europe/Malta
    - Europe/Mariehamn
    - Europe/Minsk
    - Europe/Monaco
    - Europe/Moscow
    - Europe/Oslo
    - Europe/Paris
    - Europe/Podgorica
    - Europe/Prague
    - Europe/Riga
    - Europe/Rome
    - Europe/Samara
    - Europe/San_Marino
    - Europe/Sarajevo
    - Europe/Simferopol
    - Europe/Skopje
    - Europe/Sofia
    - Europe/Stockholm
    - Europe/Tallinn
    - Europe/Tirane
    - Europe/Uzhgorod
    - Europe/Vaduz
    - Europe/Vatican
    - Europe/Vienna
    - Europe/Vilnius
    - Europe/Volgograd
    - Europe/Warsaw
    - Europe/Zagreb
    - Europe/Zaporozhye
    - Europe/Zurich
    - Indian/Antananarivo
    - Indian/Chagos
    - Indian/Christmas
    - Indian/Cocos
    - Indian/Comoro
    - Indian/Kerguelen
    - Indian/Mahe
    - Indian/Maldives
    - Indian/Mauritius
    - Indian/Mayotte
    - Indian/Reunion
    - Pacific/Apia
    - Pacific/Auckland
    - Pacific/Chatham
    - Pacific/Chuuk
    - Pacific/Easter
    - Pacific/Efate
    - Pacific/Enderbury
    - Pacific/Fakaofo
    - Pacific/Fiji
    - Pacific/Funafuti
    - Pacific/Galapagos
    - Pacific/Gambier
    - Pacific/Guadalcanal
    - Pacific/Guam
    - Pacific/Honolulu
    - Pacific/Johnston
    - Pacific/Kiritimati
    - Pacific/Kosrae
    - Pacific/Kwajalein
    - Pacific/Majuro
    - Pacific/Marquesas
    - Pacific/Midway
    - Pacific/Nauru
    - Pacific/Niue
    - Pacific/Norfolk
    - Pacific/Noumea
    - Pacific/Pago_Pago
    - Pacific/Palau
    - Pacific/Pitcairn
    - Pacific/Pohnpei
    - Pacific/Port_Moresby
    - Pacific/Rarotonga
    - Pacific/Saipan
    - Pacific/Tahiti
    - Pacific/Tarawa
    - Pacific/Tongatapu
    - Pacific/Wake
    - Pacific/Wallis
    - UTC
  EOT
  type = map(object(
    {
      administrative_state = optional(string)
      authentication_keys = optional(list(object(
        {
          authentication_type = optional(string)
          key_id              = string
          trusted             = optional(string)
        }
      )))
      description    = optional(string)
      display_format = optional(string)
      master_mode    = optional(string)
      ntp_servers = optional(list(object(
        {
          authentication_key       = optional(number)
          description              = optional(string)
          management_epg           = optional(string)
          management_epg_type      = optional(string)
          maximum_polling_interval = optional(number)
          minimum_polling_interval = optional(number)
          ntp_server               = string
          preferred                = optional(string)
        }
      )))
      offset_state  = optional(string)
      server_state  = optional(string)
      stratum_value = optional(number)
      time_zone     = optional(string)
    }
  ))
}

variable "ntp_key_1" {
  default     = ""
  description = "Key Assigned to NTP id 1."
  sensitive   = true
  type        = string
}

variable "ntp_key_2" {
  default     = ""
  description = "Key Assigned to NTP id 2."
  sensitive   = true
  type        = string
}

variable "ntp_key_3" {
  default     = ""
  description = "Key Assigned to NTP id 3."
  sensitive   = true
  type        = string
}

variable "ntp_key_4" {
  default     = ""
  description = "Key Assigned to NTP id 4."
  sensitive   = true
  type        = string
}

variable "ntp_key_5" {
  default     = ""
  description = "Key Assigned to NTP id 5."
  sensitive   = true
  type        = string
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimePol"
 - Distinguished Name: "uni/fabric/time-{{name}}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {{name}}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "date_and_time" {
  provider   = netascode
  for_each   = local.date_and_time
  dn         = "/api/node/mo/uni/fabric/time-${each.key}"
  class_name = "datetimePol"
  content = {
    adminSt      = each.value.administrative_state
    authSt       = length(each.value.authentication_keys) > 0 ? "enabled" : "disabled"
    descr        = each.value.description
    name         = each.key
    serverState  = each.value.server_state
    StratumValue = each.value.stratum_value
  }
}
# resource "aci_rest" "date_and_time" {
#   for_each   = local.date_and_time
#   path       = "/api/node/mo/uni/fabric/time-${each.key}.json"
#   class_name = "datetimePol"
#   payload    = <<EOF
# {
#   "datetimePol": {
#     "attributes": {
#       "adminSt": "${each.value.administrative_state}",
#       "authSt": "${each.value.authentication_state}",
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/time-${each.key}",
#       "masterMode": "${each.value.master_mode}",
#       "name": "${each.key}",
#       "serverState": "${each.value.server_state}",
#       "StratumValue": "${each.value.stratum_value}"
#     }
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpAuthKey"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpauth-{key_id}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: Authentication Keys: {key_id}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "ntp_authentication_keys" {
  provider = netascode
  depends_on = [
    aci_rest.date_and_time
  ]
  for_each   = local.ntp_authentication_keys
  dn         = "uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}"
  class_name = "datetimeNtpAuthKey"
  content = {
    id = each.value.key_id
    key = length(regexall(
      5, each.value.key_id)) > 0 ? var.ntp_key_5 : length(regexall(
      4, each.value.key_id)) > 0 ? var.ntp_key_4 : length(regexall(
      3, each.value.key_id)) > 0 ? var.ntp_key_3 : length(regexall(
    2, each.value.key_id)) > 0 ? var.ntp_key_2 : var.ntp_key_1
    keyType = each.value.authentication_type
  }
}
# resource "aci_rest" "ntp_authentication_keys" {
#   depends_on = [
#     aci_rest.date_and_time
#   ]
#   for_each   = local.ntp_authentication_keys
#   path       = "/api/node/mo/uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}.json"
#   class_name = "datetimeNtpAuthKey"
#   payload    = <<EOF
# {
#   "datetimeNtpAuthKey": {
#     "attributes": {
#       "dn": "uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}",
#       "id": "${each.value.key_id}",
#       "key": "${var.sensitive_var}",
#       "keyType": "${each.value.authentication_type}"
#     },
#   }
# }
#   EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpProv"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpprov-{ntp_server}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: NTP Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "ntp_servers" {
  provider   = netascode
  for_each   = local.ntp_servers
  dn         = "uni/fabric/time-${each.value.key1}/ntpprov-${each.value.ntp_server}"
  class_name = "datetimeNtpProv"
  content = {
    descr      = each.value.description
    keyId      = length(each.value.authentication_keys) > 0 ? each.value.authentication_key : 0
    maxPoll    = each.value.maximum_polling_interval
    minPoll    = each.value.minimum_polling_interval
    name       = each.value.ntp_server
    preferred  = each.value.preferred
    trueChimer = "disabled"
  }
  child {
    rn         = "rsNtpProvToEpg"
    class_name = "datetimeRsNtpProvToEpg"
    content = {
      tDn = "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
    }
  }
}

# resource "aci_rest" "ntp_servers" {
#   depends_on = [
#     aci_rest.date_and_time
#   ]
#   for_each   = local.ntp_servers
#   path       = "/api/node/mo/uni/fabric/time-${each.value.key1}/ntpprov-${each.value.ntp_server}.json"
#   class_name = "datetimeNtpProv"
#   payload    = <<EOF
# {
#   "datetimeNtpProv": {
#     "attributes": {
#       "descr": "${each.value.description}",
#       "dn": "uni/fabric/time-${each.value.key1}/ntpprov-${each.value.ntp_server}",
#       "keyId": "${each.value.authentication_key}",
#       "maxPoll": "${each.value.maximum_polling_interval}",
#       "minPoll": "${each.value.minimum_polling_interval}",
#       "name": "${each.value.ntp_server}",
#       "preferred": "${each.value.preferred}",
#       "trueChimer": "disabled",
#     },
#     "children": [
#       {
#         "datetimeRsNtpProvToEpg": {
#           "attributes": {
#             "tDn": "uni/tn-mgmt/mgmtp-default/${each.value.management_epg_type}-${each.value.management_epg}"
#           }
#         }
#       }
#     ]
#   }
# }
#     EOF
# }

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeFormat"
 - Distinguished Name: "uni/fabric/format-default"
GUI Location:
 - System Settings > Data and Time
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "date_and_time_format" {
  provider   = netascode
  for_each   = { for k, v in local.date_and_time : k => v if k == "default" }
  dn         = "uni/fabric/format-default"
  class_name = "datetimeFormat"
  content = {
    displayFormat = each.value.display_format
    showOffset    = each.value.offset_state
    tz            = each.value.time_zone
  }
}
