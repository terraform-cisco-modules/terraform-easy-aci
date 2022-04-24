variable "date_and_time" {
  default = {
    default = {
      annotation           = ""
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
  * annotation: A search keyword or term that is assigned to the Object. Tags allow you to group multiple objects by descriptive names. You can assign the same tag name to multiple objects and you can assign one or more tag names to a single object.
  * administrative_state: The NTP protocol can be enabled or disabled. If enabled, the system uses the NTP protocol. The NTP protocol can be either of the following:
    - enabled: NTP protocol is enabled.
    - disabled: NTP protocol is disabled.
  * authentication_keys: List of NTP Authentication keys; when performing NTP Authentication.
    - authentication_type: The authentication key type can be:
      * md5: Use HMAC MD5 algorithm for authentication
      * sha1: (Default) Use HMAC SHA1 algorithm for authentication
    - key_id: The user-configured NTP client authentication key name. The NTP client authentication key is for authenticating time synchronization. This name can be between 1 and 65335. Note that you cannot change this name after the object has been saved.
    - trusted: The trust status of the authentication key. This indicates if the NTP authentication key is trusted. The trust states of the NTP authentication key follows:
      * no: The authentication key is not trusted.
      * yes: (Default) The authentication key is trusted.
  * description:  Description to add to the Object.  The description can be up to 128 alphanumeric characters.
  * display_format: The date/time display format selector. The display format can be UTC or local. The date/time display format can be either of the following:
    - utc: Date/time is displayed in UTC.
    - local: Date/time is displayed in local time.
  * master_mode: Enables the designated NTP server to provide undisciplined local clock time to downstream clients with a configured stratum number. For example, a leaf switch that is acting as the NTP server can provide undisciplined local clock time to leaf switches acting as clients.  The options are:
    - enabled: The designated NTP server provides undisciplined local clock time
    - disabled: The designated NTP server does not provide undisciplined local clock time (default)
    Notes:
    - Master Mode is only applicable when the server clock is undisciplined.
    - The default master mode stratum number is 8.
  * ntp_servers: List of NTP Servers.
    - description: Description to add to the Object.  The description can be up to 128 alphanumeric characters.
    - hostname: Hostname/IP Address of the NTP Server
    - key_id: key_id of the Authentication key.
    - management_epg: Name of the Management EPG
    - management_epg_type: Type of EPG.  Options are:
      * inb: for Inband EPGs.
      * oob: For Out-of-Band EPGs.
    - maximum_polling_interval: Default is 6.  The maximum NTP default polling value. This default is set in terms of seconds. The maximum interval range is from 4 to 16.
    - minimum_polling_interval: Default is 4.  The minimum NTP default polling value. This default is set in terms of seconds. The minimum interval range is from 4 to 16.
    - preferred: Indicates if the NTP server is preferred. Multiple preferred servers can be configured. The NTP server preference states include the following:
      * no: The NTP server is not preferred.
      * yes: The NTP server is preferred.
  * offset_state: The display of the offset can be enabled or disabled. This enables you to view the difference between the local time and the reference time. 
  * server_state: Enables switches to act as NTP servers to provide NTP time information to downstream clients. The options are:
   - enabled: Switch, while being acting as a client, serves the time as server to other clients.
   - disabled: Switch acts as a client to an NTP server
    Notes: To support the server functionality, it is always recommended to have a peer setup for the server. This enables the server to provide a consistent time to the clients.
    - Do not configure the node in the same fabric as the peer of the server.
    - The NTP server sends time info with a stratum number, an increment to the system peer's stratum number, to switches that are synched to the upstream server.
    - The server sends time info with stratum 16 if the switch clock is not synched to the upstream server. Clients are not able to sync to this server.
  * stratum_value: Specifies the stratum level from which NTP clients get their time synchronized. The range is from 1 to 15.  The default master mode stratum number is 8.
  * time_zone: The time zone selection. This enables you to select a time zone for your fabric.  Valid Timezones:
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
      annotation           = optional(string)
      administrative_state = optional(string)
      authentication_keys = optional(list(object(
        {
          authentication_type = optional(string)
          key_id              = string
          trusted             = optional(bool)
        }
      )))
      description    = optional(string)
      display_format = optional(string)
      master_mode    = optional(string)
      ntp_servers = optional(list(object(
        {
          description              = optional(string)
          hostname                 = string
          key_id                   = optional(number)
          management_epg           = optional(string)
          management_epg_type      = optional(string)
          maximum_polling_interval = optional(number)
          minimum_polling_interval = optional(number)
          preferred                = optional(bool)
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
resource "aci_rest_managed" "date_and_time" {
  for_each   = local.date_and_time
  dn         = "uni/fabric/time-${each.key}"
  class_name = "datetimePol"
  content = {
    # annotation   = each.value.annotation != "" ? each.value.annotation : var.annotation
    adminSt      = each.value.administrative_state
    authSt       = length(each.value.authentication_keys) > 0 ? "enabled" : "disabled"
    descr        = each.value.description
    name         = each.key
    serverState  = each.value.server_state
    StratumValue = each.value.stratum_value
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpAuthKey"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpauth-{key_id}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: Authentication Keys: {key_id}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ntp_authentication_keys" {
  depends_on = [
    aci_rest_managed.date_and_time
  ]
  for_each   = local.ntp_authentication_keys
  dn         = "uni/fabric/time-${each.value.key1}/ntpauth-${each.value.key_id}"
  class_name = "datetimeNtpAuthKey"
  content = {
    annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    id         = each.value.key_id
    key = length(regexall(
      5, each.value.key_id)) > 0 ? var.ntp_key_5 : length(regexall(
      4, each.value.key_id)) > 0 ? var.ntp_key_4 : length(regexall(
      3, each.value.key_id)) > 0 ? var.ntp_key_3 : length(regexall(
    2, each.value.key_id)) > 0 ? var.ntp_key_2 : var.ntp_key_1
    keyType = each.value.authentication_type
  }
}


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeNtpProv"
 - Distinguished Name: "uni/fabric/time-{date_policy}/ntpprov-{ntp_server}"
GUI Location:
 - Fabric > Fabric Policies > Policies > Pod > Date and Time > Policy {date_policy}: NTP Servers
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "ntp_servers" {
  for_each   = local.ntp_servers
  dn         = "uni/fabric/time-${each.value.key1}/ntpprov-${each.value.hostname}"
  class_name = "datetimeNtpProv"
  content = {
    # annotation = each.value.annotation != "" ? each.value.annotation : var.annotation
    descr      = each.value.description
    keyId      = length(each.value.authentication_keys) > 0 ? each.value.authentication_key : 0
    maxPoll    = each.value.maximum_polling_interval
    minPoll    = each.value.minimum_polling_interval
    name       = each.value.hostname
    preferred  = each.value.preferred == true ? "yes" : "no"
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


/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "datetimeFormat"
 - Distinguished Name: "uni/fabric/format-default"
GUI Location:
 - System Settings > Data and Time
_______________________________________________________________________________________________________________________
*/
resource "aci_rest_managed" "date_and_time_format" {
  for_each   = { for k, v in local.date_and_time : k => v if k == "default" }
  dn         = "uni/fabric/format-default"
  class_name = "datetimeFormat"
  content = {
    # annotation    = each.value.annotation != "" ? each.value.annotation : var.annotation
    displayFormat = each.value.display_format
    showOffset    = each.value.offset_state
    tz            = each.value.time_zone
  }
}
