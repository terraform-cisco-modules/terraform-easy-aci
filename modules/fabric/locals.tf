locals {
  #__________________________________________________________
  #
  # Date and Time Variables (NTP and Time Format)
  #__________________________________________________________

  date_and_time = {
    for k, v in var.date_and_time : k => {
      administrative_state = v.administrative_state != null ? v.administrative_state : "enabled"
      authentication_keys  = v.authentication_keys != null ? v.authentication_keys : []
      description          = v.description != null ? v.description : ""
      display_format       = v.display_format != null ? v.display_format : "local"
      master_mode          = v.master_mode != null ? v.master_mode : "disabled"
      ntp_servers          = v.ntp_servers != null ? v.ntp_servers : []
      offset_state         = v.offset_state != null ? v.offset_state : "enabled"
      server_state         = v.server_state != null ? v.server_state : "enabled"
      stratum_value        = v.stratum_value != null ? v.stratum_value : 8
      time_zone = v.time_zone == length(regexall(
        "Africa/Abidjan", v.time_zone)) > 0 ? "p0_Africa-Abidjan" : length(regexall(
        "Africa/Accra", v.time_zone)) > 0 ? "p0_Africa-Accra" : length(regexall(
        "Africa/Addis_Ababa", v.time_zone)) > 0 ? "p180_Africa-Addis_Ababa" : length(regexall(
        "Africa/Algiers", v.time_zone)) > 0 ? "p60_Africa-Algiers" : length(regexall(
        "Africa/Asmara", v.time_zone)) > 0 ? "p180_Africa-Asmara" : length(regexall(
        "Africa/Bamako", v.time_zone)) > 0 ? "p0_Africa-Bamako" : length(regexall(
        "Africa/Bangui", v.time_zone)) > 0 ? "p60_Africa-Bangui" : length(regexall(
        "Africa/Banjul", v.time_zone)) > 0 ? "p0_Africa-Banjul" : length(regexall(
        "Africa/Bissau", v.time_zone)) > 0 ? "p0_Africa-Bissau" : length(regexall(
        "Africa/Blantyre", v.time_zone)) > 0 ? "p120_Africa-Blantyre" : length(regexall(
        "Africa/Brazzaville", v.time_zone)) > 0 ? "p60_Africa-Brazzaville" : length(regexall(
        "Africa/Bujumbura", v.time_zone)) > 0 ? "p120_Africa-Bujumbura" : length(regexall(
        "Africa/Cairo", v.time_zone)) > 0 ? "p120_Africa-Cairo" : length(regexall(
        "Africa/Casablanca", v.time_zone)) > 0 ? "p60_Africa-Casablanca" : length(regexall(
        "Africa/Ceuta", v.time_zone)) > 0 ? "p120_Africa-Ceuta" : length(regexall(
        "Africa/Conakry", v.time_zone)) > 0 ? "p0_Africa-Conakry" : length(regexall(
        "Africa/Dakar", v.time_zone)) > 0 ? "p0_Africa-Dakar" : length(regexall(
        "Africa/Dar_es_Salaam", v.time_zone)) > 0 ? "p180_Africa-Dar_es_Salaam" : length(regexall(
        "Africa/Djibouti", v.time_zone)) > 0 ? "p180_Africa-Djibouti" : length(regexall(
        "Africa/Douala", v.time_zone)) > 0 ? "p60_Africa-Douala" : length(regexall(
        "Africa/El_Aaiun", v.time_zone)) > 0 ? "p0_Africa-El_Aaiun" : length(regexall(
        "Africa/Freetown", v.time_zone)) > 0 ? "p0_Africa-Freetown" : length(regexall(
        "Africa/Gaborone", v.time_zone)) > 0 ? "p120_Africa-Gaborone" : length(regexall(
        "Africa/Harare", v.time_zone)) > 0 ? "p120_Africa-Harare" : length(regexall(
        "Africa/Johannesburg", v.time_zone)) > 0 ? "p120_Africa-Johannesburg" : length(regexall(
        "Africa/Juba", v.time_zone)) > 0 ? "p180_Africa-Juba" : length(regexall(
        "Africa/Kampala", v.time_zone)) > 0 ? "p180_Africa-Kampala" : length(regexall(
        "Africa/Khartoum", v.time_zone)) > 0 ? "p180_Africa-Khartoum" : length(regexall(
        "Africa/Kigali", v.time_zone)) > 0 ? "p120_Africa-Kigali" : length(regexall(
        "Africa/Kinshasa", v.time_zone)) > 0 ? "p60_Africa-Kinshasa" : length(regexall(
        "Africa/Lagos", v.time_zone)) > 0 ? "p60_Africa-Lagos" : length(regexall(
        "Africa/Libreville", v.time_zone)) > 0 ? "p60_Africa-Libreville" : length(regexall(
        "Africa/Lome", v.time_zone)) > 0 ? "p0_Africa-Lome" : length(regexall(
        "Africa/Luanda", v.time_zone)) > 0 ? "p60_Africa-Luanda" : length(regexall(
        "Africa/Lubumbashi", v.time_zone)) > 0 ? "p120_Africa-Lubumbashi" : length(regexall(
        "Africa/Lusaka", v.time_zone)) > 0 ? "p120_Africa-Lusaka" : length(regexall(
        "Africa/Malabo", v.time_zone)) > 0 ? "p60_Africa-Malabo" : length(regexall(
        "Africa/Maputo", v.time_zone)) > 0 ? "p120_Africa-Maputo" : length(regexall(
        "Africa/Maseru", v.time_zone)) > 0 ? "p120_Africa-Maseru" : length(regexall(
        "Africa/Mbabane", v.time_zone)) > 0 ? "p120_Africa-Mbabane" : length(regexall(
        "Africa/Mogadishu", v.time_zone)) > 0 ? "p180_Africa-Mogadishu" : length(regexall(
        "Africa/Monrovia", v.time_zone)) > 0 ? "p0_Africa-Monrovia" : length(regexall(
        "Africa/Nairobi", v.time_zone)) > 0 ? "p180_Africa-Nairobi" : length(regexall(
        "Africa/Ndjamena", v.time_zone)) > 0 ? "p60_Africa-Ndjamena" : length(regexall(
        "Africa/Niamey", v.time_zone)) > 0 ? "p60_Africa-Niamey" : length(regexall(
        "Africa/Nouakchott", v.time_zone)) > 0 ? "p0_Africa-Nouakchott" : length(regexall(
        "Africa/Ouagadougou", v.time_zone)) > 0 ? "p0_Africa-Ouagadougou" : length(regexall(
        "Africa/Porto-Novo", v.time_zone)) > 0 ? "p60_Africa-Porto_Novo" : length(regexall(
        "Africa/Sao_Tome", v.time_zone)) > 0 ? "p0_Africa-Sao_Tome" : length(regexall(
        "Africa/Tripoli", v.time_zone)) > 0 ? "p120_Africa-Tripoli" : length(regexall(
        "Africa/Tunis", v.time_zone)) > 0 ? "p60_Africa-Tunis" : length(regexall(
        "Africa/Windhoek", v.time_zone)) > 0 ? "p120_Africa-Windhoek" : length(regexall(
        "America/Adak", v.time_zone)) > 0 ? "n540_America-Adak" : length(regexall(
        "America/Anchorage", v.time_zone)) > 0 ? "n480_America-Anchorage" : length(regexall(
        "America/Anguilla", v.time_zone)) > 0 ? "n240_America-Anguilla" : length(regexall(
        "America/Antigua", v.time_zone)) > 0 ? "n240_America-Antigua" : length(regexall(
        "America/Araguaina", v.time_zone)) > 0 ? "n180_America-Araguaina" : length(regexall(
        "America/Argentina/Buenos_Aires", v.time_zone)) > 0 ? "n180_America-Argentina-Buenos_Aires" : length(regexall(
        "America/Argentina/Catamarca", v.time_zone)) > 0 ? "n180_America-Argentina-Catamarca" : length(regexall(
        "America/Argentina/Cordoba", v.time_zone)) > 0 ? "n180_America-Argentina-Cordoba" : length(regexall(
        "America/Argentina/Jujuy", v.time_zone)) > 0 ? "n180_America-Argentina-Jujuy" : length(regexall(
        "America/Argentina/La_Rioja", v.time_zone)) > 0 ? "n180_America-Argentina-La_Rioja" : length(regexall(
        "America/Argentina/Mendoza", v.time_zone)) > 0 ? "n180_America-Argentina-Mendoza" : length(regexall(
        "America/Argentina/Rio_Gallegos", v.time_zone)) > 0 ? "n180_America-Argentina-Rio_Gallegos" : length(regexall(
        "America/Argentina/Salta", v.time_zone)) > 0 ? "n180_America-Argentina-Salta" : length(regexall(
        "America/Argentina/San_Juan", v.time_zone)) > 0 ? "n180_America-Argentina-San_Juan" : length(regexall(
        "America/Argentina/San_Luis", v.time_zone)) > 0 ? "n180_America-Argentina-San_Luis" : length(regexall(
        "America/Argentina/Tucuman", v.time_zone)) > 0 ? "n180_America-Argentina-Tucuman" : length(regexall(
        "America/Argentina/Ushuaia", v.time_zone)) > 0 ? "n180_America-Argentina-Ushuaia" : length(regexall(
        "America/Aruba", v.time_zone)) > 0 ? "n240_America-Aruba" : length(regexall(
        "America/Asuncion", v.time_zone)) > 0 ? "n180_America-Asuncion" : length(regexall(
        "America/Atikokan", v.time_zone)) > 0 ? "n300_America-Atikokan" : length(regexall(
        "America/Bahia_Banderas", v.time_zone)) > 0 ? "n300_America-Bahia_Banderas" : length(regexall(
        "America/Barbados", v.time_zone)) > 0 ? "n240_America-Barbados" : length(regexall(
        "America/Belem", v.time_zone)) > 0 ? "n180_America-Belem" : length(regexall(
        "America/Belize", v.time_zone)) > 0 ? "n360_America-Belize" : length(regexall(
        "America/Blanc-Sablon", v.time_zone)) > 0 ? "n240_America-Blanc_Sablon" : length(regexall(
        "America/Boa_Vista", v.time_zone)) > 0 ? "n240_America-Boa_Vista" : length(regexall(
        "America/Bogota", v.time_zone)) > 0 ? "n300_America-Bogota" : length(regexall(
        "America/Boise", v.time_zone)) > 0 ? "n360_America-Boise" : length(regexall(
        "America/Cambridge_Bay", v.time_zone)) > 0 ? "n360_America-Cambridge_Bay" : length(regexall(
        "America/Campo_Grande", v.time_zone)) > 0 ? "n180_America-Campo_Grande" : length(regexall(
        "America/Cancun", v.time_zone)) > 0 ? "n300_America-Cancun" : length(regexall(
        "America/Caracas", v.time_zone)) > 0 ? "n270_America-Caracas" : length(regexall(
        "America/Cayenne", v.time_zone)) > 0 ? "n180_America-Cayenne" : length(regexall(
        "America/Cayman", v.time_zone)) > 0 ? "n300_America-Cayman" : length(regexall(
        "America/Chicago", v.time_zone)) > 0 ? "n300_America-Chicago" : length(regexall(
        "America/Chihuahua", v.time_zone)) > 0 ? "n360_America-Chihuahua" : length(regexall(
        "America/Costa_Rica", v.time_zone)) > 0 ? "n360_America-Costa_Rica" : length(regexall(
        "America/Creston", v.time_zone)) > 0 ? "n420_America-Creston" : length(regexall(
        "America/Cuiaba", v.time_zone)) > 0 ? "n180_America-Cuiaba" : length(regexall(
        "America/Curacao", v.time_zone)) > 0 ? "n240_America-Curacao" : length(regexall(
        "America/Danmarkshavn", v.time_zone)) > 0 ? "p0_America-Danmarkshavn" : length(regexall(
        "America/Dawson", v.time_zone)) > 0 ? "n420_America-Dawson" : length(regexall(
        "America/Dawson_Creek", v.time_zone)) > 0 ? "n420_America-Dawson_Creek" : length(regexall(
        "America/Denver", v.time_zone)) > 0 ? "n360_America-Denver" : length(regexall(
        "America/Detroit", v.time_zone)) > 0 ? "n240_America-Detroit" : length(regexall(
        "America/Dominica", v.time_zone)) > 0 ? "n240_America-Dominica" : length(regexall(
        "America/Edmonton", v.time_zone)) > 0 ? "n360_America-Edmonton" : length(regexall(
        "America/Eirunepe", v.time_zone)) > 0 ? "n240_America-Eirunepe" : length(regexall(
        "America/El_Salvador", v.time_zone)) > 0 ? "n360_America-El_Salvador" : length(regexall(
        "America/Fortaleza", v.time_zone)) > 0 ? "n180_America-Fortaleza" : length(regexall(
        "America/Glace_Bay", v.time_zone)) > 0 ? "n180_America-Glace_Bay" : length(regexall(
        "America/Godthab", v.time_zone)) > 0 ? "n120_America-Godthab" : length(regexall(
        "America/Goose_Bay", v.time_zone)) > 0 ? "n180_America-Goose_Bay" : length(regexall(
        "America/Grand_Turk", v.time_zone)) > 0 ? "n240_America-Grand_Turk" : length(regexall(
        "America/Grenada", v.time_zone)) > 0 ? "n240_America-Grenada" : length(regexall(
        "America/Guadeloupe", v.time_zone)) > 0 ? "n240_America-Guadeloupe" : length(regexall(
        "America/Guatemala", v.time_zone)) > 0 ? "n360_America-Guatemala" : length(regexall(
        "America/Guayaquil", v.time_zone)) > 0 ? "n300_America-Guayaquil" : length(regexall(
        "America/Guyana", v.time_zone)) > 0 ? "n240_America-Guyana" : length(regexall(
        "America/Halifax", v.time_zone)) > 0 ? "n180_America-Halifax" : length(regexall(
        "America/Havana", v.time_zone)) > 0 ? "n240_America-Havana" : length(regexall(
        "America/Hermosillo", v.time_zone)) > 0 ? "n420_America-Hermosillo" : length(regexall(
        "America/Indiana/Indianapolis", v.time_zone)) > 0 ? "n240_America-Indiana-Indianapolis" : length(regexall(
        "America/Indiana/Knox", v.time_zone)) > 0 ? "n300_America-Indiana-Knox" : length(regexall(
        "America/Indiana/Marengo", v.time_zone)) > 0 ? "n240_America-Indiana-Marengo" : length(regexall(
        "America/Indiana/Petersburg", v.time_zone)) > 0 ? "n240_America-Indiana-Petersburg" : length(regexall(
        "America/Indiana/Tell_City", v.time_zone)) > 0 ? "n300_America-Indiana-Tell_City" : length(regexall(
        "America/Indiana/Vevay", v.time_zone)) > 0 ? "n240_America-Indiana-Vevay" : length(regexall(
        "America/Indiana/Vincennes", v.time_zone)) > 0 ? "n240_America-Indiana-Vincennes" : length(regexall(
        "America/Indiana/Winamac", v.time_zone)) > 0 ? "n240_America-Indiana-Winamac" : length(regexall(
        "America/Inuvik", v.time_zone)) > 0 ? "n360_America-Inuvik" : length(regexall(
        "America/Iqaluit", v.time_zone)) > 0 ? "n240_America-Iqaluit" : length(regexall(
        "America/Jamaica", v.time_zone)) > 0 ? "n300_America-Jamaica" : length(regexall(
        "America/Juneau", v.time_zone)) > 0 ? "n480_America-Juneau" : length(regexall(
        "America/Kentucky/Louisville", v.time_zone)) > 0 ? "n240_America-Kentucky-Louisville" : length(regexall(
        "America/Kentucky/Monticello", v.time_zone)) > 0 ? "n240_America-Kentucky-Monticello" : length(regexall(
        "America/Kralendijk", v.time_zone)) > 0 ? "n240_America-Kralendijk" : length(regexall(
        "America/La_Paz", v.time_zone)) > 0 ? "n240_America-La_Paz" : length(regexall(
        "America/Lima", v.time_zone)) > 0 ? "n300_America-Lima" : length(regexall(
        "America/Los_Angeles", v.time_zone)) > 0 ? "n420_America-Los_Angeles" : length(regexall(
        "America/Lower_Princes", v.time_zone)) > 0 ? "n240_America-Lower_Princes" : length(regexall(
        "America/Maceio", v.time_zone)) > 0 ? "n180_America-Maceio" : length(regexall(
        "America/Managua", v.time_zone)) > 0 ? "n360_America-Managua" : length(regexall(
        "America/Manaus", v.time_zone)) > 0 ? "n240_America-Manaus" : length(regexall(
        "America/Marigot", v.time_zone)) > 0 ? "n240_America-Marigot" : length(regexall(
        "America/Martinique", v.time_zone)) > 0 ? "n240_America-Martinique" : length(regexall(
        "America/Matamoros", v.time_zone)) > 0 ? "n300_America-Matamoros" : length(regexall(
        "America/Mazatlan", v.time_zone)) > 0 ? "n360_America-Mazatlan" : length(regexall(
        "America/Menominee", v.time_zone)) > 0 ? "n300_America-Menominee" : length(regexall(
        "America/Merida", v.time_zone)) > 0 ? "n300_America-Merida" : length(regexall(
        "America/Metlakatla", v.time_zone)) > 0 ? "n480_America-Metlakatla" : length(regexall(
        "America/Mexico_City", v.time_zone)) > 0 ? "n300_America-Mexico_City" : length(regexall(
        "America/Miquelon", v.time_zone)) > 0 ? "n120_America-Miquelon" : length(regexall(
        "America/Moncton", v.time_zone)) > 0 ? "n180_America-Moncton" : length(regexall(
        "America/Monterrey", v.time_zone)) > 0 ? "n300_America-Monterrey" : length(regexall(
        "America/Montevideo", v.time_zone)) > 0 ? "n120_America-Montevideo" : length(regexall(
        "America/Montreal", v.time_zone)) > 0 ? "n240_America-Montreal" : length(regexall(
        "America/Montserrat", v.time_zone)) > 0 ? "n240_America-Montserrat" : length(regexall(
        "America/Nassau", v.time_zone)) > 0 ? "n240_America-Nassau" : length(regexall(
        "America/New_York", v.time_zone)) > 0 ? "n240_America-New_York" : length(regexall(
        "America/Nipigon", v.time_zone)) > 0 ? "n240_America-Nipigon" : length(regexall(
        "America/Nome", v.time_zone)) > 0 ? "n480_America-Nome" : length(regexall(
        "America/Noronha", v.time_zone)) > 0 ? "n120_America-Noronha" : length(regexall(
        "America/North_Dakota/Beulah", v.time_zone)) > 0 ? "n300_America-North_Dakota-Beulah" : length(regexall(
        "America/North_Dakota/Center", v.time_zone)) > 0 ? "n300_America-North_Dakota-Center" : length(regexall(
        "America/North_Dakota/New_Salem", v.time_zone)) > 0 ? "n300_America-North_Dakota-New_Salem" : length(regexall(
        "America/Ojinaga", v.time_zone)) > 0 ? "n360_America-Ojinaga" : length(regexall(
        "America/Panama", v.time_zone)) > 0 ? "n300_America-Panama" : length(regexall(
        "America/Pangnirtung", v.time_zone)) > 0 ? "n240_America-Pangnirtung" : length(regexall(
        "America/Paramaribo", v.time_zone)) > 0 ? "n180_America-Paramaribo" : length(regexall(
        "America/Phoenix", v.time_zone)) > 0 ? "n420_America-Phoenix" : length(regexall(
        "America/Port-au-Prince", v.time_zone)) > 0 ? "n240_America-Port_au_Prince" : length(regexall(
        "America/Port_of_Spain", v.time_zone)) > 0 ? "n240_America-Port_of_Spain" : length(regexall(
        "America/Porto_Velho", v.time_zone)) > 0 ? "n240_America-Porto_Velho" : length(regexall(
        "America/Puerto_Rico", v.time_zone)) > 0 ? "n240_America-Puerto_Rico" : length(regexall(
        "America/Rainy_River", v.time_zone)) > 0 ? "n300_America-Rainy_River" : length(regexall(
        "America/Rankin_Inlet", v.time_zone)) > 0 ? "n300_America-Rankin_Inlet" : length(regexall(
        "America/Recife", v.time_zone)) > 0 ? "n180_America-Recife" : length(regexall(
        "America/Regina", v.time_zone)) > 0 ? "n360_America-Regina" : length(regexall(
        "America/Resolute", v.time_zone)) > 0 ? "n300_America-Resolute" : length(regexall(
        "America/Rio_Branco", v.time_zone)) > 0 ? "n240_America-Rio_Branco" : length(regexall(
        "America/Santa_Isabel", v.time_zone)) > 0 ? "n420_America-Santa_Isabel" : length(regexall(
        "America/Santarem", v.time_zone)) > 0 ? "n180_America-Santarem" : length(regexall(
        "America/Santiago", v.time_zone)) > 0 ? "n180_America-Santiago" : length(regexall(
        "America/Santo_Domingo", v.time_zone)) > 0 ? "n240_America-Santo_Domingo" : length(regexall(
        "America/Sao_Paulo", v.time_zone)) > 0 ? "n120_America-Sao_Paulo" : length(regexall(
        "America/Scoresbysund", v.time_zone)) > 0 ? "p0_America-Scoresbysund" : length(regexall(
        "America/Shiprock", v.time_zone)) > 0 ? "n360_America-Shiprock" : length(regexall(
        "America/Sitka", v.time_zone)) > 0 ? "n480_America-Sitka" : length(regexall(
        "America/St_Barthelemy", v.time_zone)) > 0 ? "n240_America-St_Barthelemy" : length(regexall(
        "America/St_Johns", v.time_zone)) > 0 ? "n150_America-St_Johns" : length(regexall(
        "America/St_Kitts", v.time_zone)) > 0 ? "n240_America-St_Kitts" : length(regexall(
        "America/St_Lucia", v.time_zone)) > 0 ? "n240_America-St_Lucia" : length(regexall(
        "America/St_Thomas", v.time_zone)) > 0 ? "n240_America-St_Thomas" : length(regexall(
        "America/St_Vincent", v.time_zone)) > 0 ? "n240_America-St_Vincent" : length(regexall(
        "America/Swift_Current", v.time_zone)) > 0 ? "n360_America-Swift_Current" : length(regexall(
        "America/Tegucigalpa", v.time_zone)) > 0 ? "n360_America-Tegucigalpa" : length(regexall(
        "America/Thule", v.time_zone)) > 0 ? "n180_America-Thule" : length(regexall(
        "America/Thunder_Bay", v.time_zone)) > 0 ? "n240_America-Thunder_Bay" : length(regexall(
        "America/Tijuana", v.time_zone)) > 0 ? "n420_America-Tijuana" : length(regexall(
        "America/Toronto", v.time_zone)) > 0 ? "n240_America-Toronto" : length(regexall(
        "America/Tortola", v.time_zone)) > 0 ? "n240_America-Tortola" : length(regexall(
        "America/Vancouver", v.time_zone)) > 0 ? "n420_America-Vancouver" : length(regexall(
        "America/Whitehorse", v.time_zone)) > 0 ? "n420_America-Whitehorse" : length(regexall(
        "America/Winnipeg", v.time_zone)) > 0 ? "n300_America-Winnipeg" : length(regexall(
        "America/Yakutat", v.time_zone)) > 0 ? "n480_America-Yakutat" : length(regexall(
        "America/Yellowknife", v.time_zone)) > 0 ? "n360_America-Yellowknife" : length(regexall(
        "Antarctica/Casey", v.time_zone)) > 0 ? "p480_Antarctica-Casey" : length(regexall(
        "Antarctica/Davis", v.time_zone)) > 0 ? "p420_Antarctica-Davis" : length(regexall(
        "Antarctica/DumontDUrville", v.time_zone)) > 0 ? "p600_Antarctica-DumontDUrville" : length(regexall(
        "Antarctica/Macquarie", v.time_zone)) > 0 ? "p660_Antarctica-Macquarie" : length(regexall(
        "Antarctica/Mawson", v.time_zone)) > 0 ? "p300_Antarctica-Mawson" : length(regexall(
        "Antarctica/McMurdo", v.time_zone)) > 0 ? "p780_Antarctica-McMurdo" : length(regexall(
        "Antarctica/Palmer", v.time_zone)) > 0 ? "n180_Antarctica-Palmer" : length(regexall(
        "Antarctica/Rothera", v.time_zone)) > 0 ? "n180_Antarctica-Rothera" : length(regexall(
        "Antarctica/South_Pole", v.time_zone)) > 0 ? "p780_Antarctica-South_Pole" : length(regexall(
        "Antarctica/Syowa", v.time_zone)) > 0 ? "p180_Antarctica-Syowa" : length(regexall(
        "Antarctica/Vostok", v.time_zone)) > 0 ? "p360_Antarctica-Vostok" : length(regexall(
        "Arctic/Longyearbyen", v.time_zone)) > 0 ? "p120_Arctic-Longyearbyen" : length(regexall(
        "Asia/Aden", v.time_zone)) > 0 ? "p180_Asia-Aden" : length(regexall(
        "Asia/Almaty", v.time_zone)) > 0 ? "p360_Asia-Almaty" : length(regexall(
        "Asia/Amman", v.time_zone)) > 0 ? "p180_Asia-Amman" : length(regexall(
        "Asia/Anadyr", v.time_zone)) > 0 ? "p720_Asia-Anadyr" : length(regexall(
        "Asia/Aqtau", v.time_zone)) > 0 ? "p300_Asia-Aqtau" : length(regexall(
        "Asia/Aqtobe", v.time_zone)) > 0 ? "p300_Asia-Aqtobe" : length(regexall(
        "Asia/Ashgabat", v.time_zone)) > 0 ? "p300_Asia-Ashgabat" : length(regexall(
        "Asia/Baghdad", v.time_zone)) > 0 ? "p180_Asia-Baghdad" : length(regexall(
        "Asia/Bahrain", v.time_zone)) > 0 ? "p180_Asia-Bahrain" : length(regexall(
        "Asia/Baku", v.time_zone)) > 0 ? "p300_Asia-Baku" : length(regexall(
        "Asia/Bangkok", v.time_zone)) > 0 ? "p420_Asia-Bangkok" : length(regexall(
        "Asia/Beirut", v.time_zone)) > 0 ? "p180_Asia-Beirut" : length(regexall(
        "Asia/Bishkek", v.time_zone)) > 0 ? "p360_Asia-Bishkek" : length(regexall(
        "Asia/Brunei", v.time_zone)) > 0 ? "p480_Asia-Brunei" : length(regexall(
        "Asia/Choibalsan", v.time_zone)) > 0 ? "p480_Asia-Choibalsan" : length(regexall(
        "Asia/Chongqing", v.time_zone)) > 0 ? "p480_Asia-Chongqing" : length(regexall(
        "Asia/Colombo", v.time_zone)) > 0 ? "p330_Asia-Colombo" : length(regexall(
        "Asia/Damascus", v.time_zone)) > 0 ? "p180_Asia-Damascus" : length(regexall(
        "Asia/Dhaka", v.time_zone)) > 0 ? "p360_Asia-Dhaka" : length(regexall(
        "Asia/Dili", v.time_zone)) > 0 ? "p540_Asia-Dili" : length(regexall(
        "Asia/Dubai", v.time_zone)) > 0 ? "p240_Asia-Dubai" : length(regexall(
        "Asia/Dushanbe", v.time_zone)) > 0 ? "p300_Asia-Dushanbe" : length(regexall(
        "Asia/Gaza", v.time_zone)) > 0 ? "p180_Asia-Gaza" : length(regexall(
        "Asia/Harbin", v.time_zone)) > 0 ? "p480_Asia-Harbin" : length(regexall(
        "Asia/Hebron", v.time_zone)) > 0 ? "p180_Asia-Hebron" : length(regexall(
        "Asia/Ho_Chi_Minh", v.time_zone)) > 0 ? "p420_Asia-Ho_Chi_Minh" : length(regexall(
        "Asia/Hong_Kong", v.time_zone)) > 0 ? "p480_Asia-Hong_Kong" : length(regexall(
        "Asia/Hovd", v.time_zone)) > 0 ? "p420_Asia-Hovd" : length(regexall(
        "Asia/Irkutsk", v.time_zone)) > 0 ? "p540_Asia-Irkutsk" : length(regexall(
        "Asia/Jakarta", v.time_zone)) > 0 ? "p420_Asia-Jakarta" : length(regexall(
        "Asia/Jayapura", v.time_zone)) > 0 ? "p540_Asia-Jayapura" : length(regexall(
        "Asia/Jerusalem", v.time_zone)) > 0 ? "p180_Asia-Jerusalem" : length(regexall(
        "Asia/Kabul", v.time_zone)) > 0 ? "p270_Asia-Kabul" : length(regexall(
        "Asia/Kamchatka", v.time_zone)) > 0 ? "p720_Asia-Kamchatka" : length(regexall(
        "Asia/Karachi", v.time_zone)) > 0 ? "p300_Asia-Karachi" : length(regexall(
        "Asia/Kashgar", v.time_zone)) > 0 ? "p480_Asia-Kashgar" : length(regexall(
        "Asia/Kathmandu", v.time_zone)) > 0 ? "p345_Asia-Kathmandu" : length(regexall(
        "Asia/Kolkata", v.time_zone)) > 0 ? "p330_Asia-Kolkata" : length(regexall(
        "Asia/Krasnoyarsk", v.time_zone)) > 0 ? "p480_Asia-Krasnoyarsk" : length(regexall(
        "Asia/Kuala_Lumpur", v.time_zone)) > 0 ? "p480_Asia-Kuala_Lumpur" : length(regexall(
        "Asia/Kuching", v.time_zone)) > 0 ? "p480_Asia-Kuching" : length(regexall(
        "Asia/Kuwait", v.time_zone)) > 0 ? "p180_Asia-Kuwait" : length(regexall(
        "Asia/Macau", v.time_zone)) > 0 ? "p480_Asia-Macau" : length(regexall(
        "Asia/Magadan", v.time_zone)) > 0 ? "p720_Asia-Magadan" : length(regexall(
        "Asia/Makassar", v.time_zone)) > 0 ? "p480_Asia-Makassar" : length(regexall(
        "Asia/Manila", v.time_zone)) > 0 ? "p480_Asia-Manila" : length(regexall(
        "Asia/Muscat", v.time_zone)) > 0 ? "p240_Asia-Muscat" : length(regexall(
        "Asia/Nicosia", v.time_zone)) > 0 ? "p180_Asia-Nicosia" : length(regexall(
        "Asia/Novokuznetsk", v.time_zone)) > 0 ? "p420_Asia-Novokuznetsk" : length(regexall(
        "Asia/Novosibirsk", v.time_zone)) > 0 ? "p420_Asia-Novosibirsk" : length(regexall(
        "Asia/Omsk", v.time_zone)) > 0 ? "p420_Asia-Omsk" : length(regexall(
        "Asia/Oral", v.time_zone)) > 0 ? "p300_Asia-Oral" : length(regexall(
        "Asia/Phnom_Penh", v.time_zone)) > 0 ? "p420_Asia-Phnom_Penh" : length(regexall(
        "Asia/Pontianak", v.time_zone)) > 0 ? "p420_Asia-Pontianak" : length(regexall(
        "Asia/Pyongyang", v.time_zone)) > 0 ? "p540_Asia-Pyongyang" : length(regexall(
        "Asia/Qatar", v.time_zone)) > 0 ? "p180_Asia-Qatar" : length(regexall(
        "Asia/Qyzylorda", v.time_zone)) > 0 ? "p360_Asia-Qyzylorda" : length(regexall(
        "Asia/Rangoon", v.time_zone)) > 0 ? "p390_Asia-Rangoon" : length(regexall(
        "Asia/Riyadh", v.time_zone)) > 0 ? "p180_Asia-Riyadh" : length(regexall(
        "Asia/Sakhalin", v.time_zone)) > 0 ? "p660_Asia-Sakhalin" : length(regexall(
        "Asia/Samarkand", v.time_zone)) > 0 ? "p300_Asia-Samarkand" : length(regexall(
        "Asia/Seoul", v.time_zone)) > 0 ? "p540_Asia-Seoul" : length(regexall(
        "Asia/Shanghai", v.time_zone)) > 0 ? "p480_Asia-Shanghai" : length(regexall(
        "Asia/Singapore", v.time_zone)) > 0 ? "p480_Asia-Singapore" : length(regexall(
        "Asia/Taipei", v.time_zone)) > 0 ? "p480_Asia-Taipei" : length(regexall(
        "Asia/Tashkent", v.time_zone)) > 0 ? "p300_Asia-Tashkent" : length(regexall(
        "Asia/Tbilisi", v.time_zone)) > 0 ? "p240_Asia-Tbilisi" : length(regexall(
        "Asia/Tehran", v.time_zone)) > 0 ? "p270_Asia-Tehran" : length(regexall(
        "Asia/Thimphu", v.time_zone)) > 0 ? "p360_Asia-Thimphu" : length(regexall(
        "Asia/Tokyo", v.time_zone)) > 0 ? "p540_Asia-Tokyo" : length(regexall(
        "Asia/Ulaanbaatar", v.time_zone)) > 0 ? "p480_Asia-Ulaanbaatar" : length(regexall(
        "Asia/Urumqi", v.time_zone)) > 0 ? "p480_Asia-Urumqi" : length(regexall(
        "Asia/Vientiane", v.time_zone)) > 0 ? "p420_Asia-Vientiane" : length(regexall(
        "Asia/Vladivostok", v.time_zone)) > 0 ? "p660_Asia-Vladivostok" : length(regexall(
        "Asia/Yakutsk", v.time_zone)) > 0 ? "p600_Asia-Yakutsk" : length(regexall(
        "Asia/Yekaterinburg", v.time_zone)) > 0 ? "p360_Asia-Yekaterinburg" : length(regexall(
        "Asia/Yerevan", v.time_zone)) > 0 ? "p240_Asia-Yerevan" : length(regexall(
        "Atlantic/Azores", v.time_zone)) > 0 ? "p0_Atlantic-Azores" : length(regexall(
        "Atlantic/Bermuda", v.time_zone)) > 0 ? "n180_Atlantic-Bermuda" : length(regexall(
        "Atlantic/Canary", v.time_zone)) > 0 ? "p60_Atlantic-Canary" : length(regexall(
        "Atlantic/Cape_Verde", v.time_zone)) > 0 ? "n60_Atlantic-Cape_Verde" : length(regexall(
        "Atlantic/Faroe", v.time_zone)) > 0 ? "p60_Atlantic-Faroe" : length(regexall(
        "Atlantic/Madeira", v.time_zone)) > 0 ? "p60_Atlantic-Madeira" : length(regexall(
        "Atlantic/Reykjavik", v.time_zone)) > 0 ? "p0_Atlantic-Reykjavik" : length(regexall(
        "Atlantic/South_Georgia", v.time_zone)) > 0 ? "n120_Atlantic-South_Georgia" : length(regexall(
        "Atlantic/St_Helena", v.time_zone)) > 0 ? "p0_Atlantic-St_Helena" : length(regexall(
        "Atlantic/Stanley", v.time_zone)) > 0 ? "n180_Atlantic-Stanley" : length(regexall(
        "Australia/Adelaide", v.time_zone)) > 0 ? "p630_Australia-Adelaide" : length(regexall(
        "Australia/Brisbane", v.time_zone)) > 0 ? "p600_Australia-Brisbane" : length(regexall(
        "Australia/Broken_Hill", v.time_zone)) > 0 ? "p630_Australia-Broken_Hill" : length(regexall(
        "Australia/Currie", v.time_zone)) > 0 ? "p660_Australia-Currie" : length(regexall(
        "Australia/Darwin", v.time_zone)) > 0 ? "p570_Australia-Darwin" : length(regexall(
        "Australia/Eucla", v.time_zone)) > 0 ? "p525_Australia-Eucla" : length(regexall(
        "Australia/Hobart", v.time_zone)) > 0 ? "p660_Australia-Hobart" : length(regexall(
        "Australia/Lindeman", v.time_zone)) > 0 ? "p600_Australia-Lindeman" : length(regexall(
        "Australia/Lord_Howe", v.time_zone)) > 0 ? "p660_Australia-Lord_Howe" : length(regexall(
        "Australia/Melbourne", v.time_zone)) > 0 ? "p660_Australia-Melbourne" : length(regexall(
        "Australia/Perth", v.time_zone)) > 0 ? "p480_Australia-Perth" : length(regexall(
        "Australia/Sydney", v.time_zone)) > 0 ? "p660_Australia-Sydney" : length(regexall(
        "Coordinated Universal Time", v.time_zone)) > 0 ? "p0_UTC" : length(regexall(
        "Europe/Amsterdam", v.time_zone)) > 0 ? "p120_Europe-Amsterdam" : length(regexall(
        "Europe/Andorra", v.time_zone)) > 0 ? "p120_Europe-Andorra" : length(regexall(
        "Europe/Athens", v.time_zone)) > 0 ? "p180_Europe-Athens" : length(regexall(
        "Europe/Belgrade", v.time_zone)) > 0 ? "p120_Europe-Belgrade" : length(regexall(
        "Europe/Berlin", v.time_zone)) > 0 ? "p120_Europe-Berlin" : length(regexall(
        "Europe/Bratislava", v.time_zone)) > 0 ? "p120_Europe-Bratislava" : length(regexall(
        "Europe/Brussels", v.time_zone)) > 0 ? "p120_Europe-Brussels" : length(regexall(
        "Europe/Bucharest", v.time_zone)) > 0 ? "p180_Europe-Bucharest" : length(regexall(
        "Europe/Budapest", v.time_zone)) > 0 ? "p120_Europe-Budapest" : length(regexall(
        "Europe/Chisinau", v.time_zone)) > 0 ? "p180_Europe-Chisinau" : length(regexall(
        "Europe/Copenhagen", v.time_zone)) > 0 ? "p120_Europe-Copenhagen" : length(regexall(
        "Europe/Dublin", v.time_zone)) > 0 ? "p60_Europe-Dublin" : length(regexall(
        "Europe/Gibraltar", v.time_zone)) > 0 ? "p120_Europe-Gibraltar" : length(regexall(
        "Europe/Guernsey", v.time_zone)) > 0 ? "p60_Europe-Guernsey" : length(regexall(
        "Europe/Helsinki", v.time_zone)) > 0 ? "p180_Europe-Helsinki" : length(regexall(
        "Europe/Isle_of_Man", v.time_zone)) > 0 ? "p60_Europe-Isle_of_Man" : length(regexall(
        "Europe/Istanbul", v.time_zone)) > 0 ? "p180_Europe-Istanbul" : length(regexall(
        "Europe/Jersey", v.time_zone)) > 0 ? "p60_Europe-Jersey" : length(regexall(
        "Europe/Kaliningrad", v.time_zone)) > 0 ? "p180_Europe-Kaliningrad" : length(regexall(
        "Europe/Kiev", v.time_zone)) > 0 ? "p180_Europe-Kiev" : length(regexall(
        "Europe/Lisbon", v.time_zone)) > 0 ? "p60_Europe-Lisbon" : length(regexall(
        "Europe/Ljubljana", v.time_zone)) > 0 ? "p120_Europe-Ljubljana" : length(regexall(
        "Europe/London", v.time_zone)) > 0 ? "p60_Europe-London" : length(regexall(
        "Europe/Luxembourg", v.time_zone)) > 0 ? "p120_Europe-Luxembourg" : length(regexall(
        "Europe/Madrid", v.time_zone)) > 0 ? "p120_Europe-Madrid" : length(regexall(
        "Europe/Malta", v.time_zone)) > 0 ? "p120_Europe-Malta" : length(regexall(
        "Europe/Mariehamn", v.time_zone)) > 0 ? "p180_Europe-Mariehamn" : length(regexall(
        "Europe/Minsk", v.time_zone)) > 0 ? "p180_Europe-Minsk" : length(regexall(
        "Europe/Monaco", v.time_zone)) > 0 ? "p120_Europe-Monaco" : length(regexall(
        "Europe/Moscow", v.time_zone)) > 0 ? "p240_Europe-Moscow" : length(regexall(
        "Europe/Oslo", v.time_zone)) > 0 ? "p120_Europe-Oslo" : length(regexall(
        "Europe/Paris", v.time_zone)) > 0 ? "p120_Europe-Paris" : length(regexall(
        "Europe/Podgorica", v.time_zone)) > 0 ? "p120_Europe-Podgorica" : length(regexall(
        "Europe/Prague", v.time_zone)) > 0 ? "p120_Europe-Prague" : length(regexall(
        "Europe/Riga", v.time_zone)) > 0 ? "p180_Europe-Riga" : length(regexall(
        "Europe/Rome", v.time_zone)) > 0 ? "p120_Europe-Rome" : length(regexall(
        "Europe/Samara", v.time_zone)) > 0 ? "p240_Europe-Samara" : length(regexall(
        "Europe/San_Marino", v.time_zone)) > 0 ? "p120_Europe-San_Marino" : length(regexall(
        "Europe/Sarajevo", v.time_zone)) > 0 ? "p120_Europe-Sarajevo" : length(regexall(
        "Europe/Simferopol", v.time_zone)) > 0 ? "p180_Europe-Simferopol" : length(regexall(
        "Europe/Skopje", v.time_zone)) > 0 ? "p120_Europe-Skopje" : length(regexall(
        "Europe/Sofia", v.time_zone)) > 0 ? "p180_Europe-Sofia" : length(regexall(
        "Europe/Stockholm", v.time_zone)) > 0 ? "p120_Europe-Stockholm" : length(regexall(
        "Europe/Tallinn", v.time_zone)) > 0 ? "p180_Europe-Tallinn" : length(regexall(
        "Europe/Tirane", v.time_zone)) > 0 ? "p120_Europe-Tirane" : length(regexall(
        "Europe/Uzhgorod", v.time_zone)) > 0 ? "p180_Europe-Uzhgorod" : length(regexall(
        "Europe/Vaduz", v.time_zone)) > 0 ? "p120_Europe-Vaduz" : length(regexall(
        "Europe/Vatican", v.time_zone)) > 0 ? "p120_Europe-Vatican" : length(regexall(
        "Europe/Vienna", v.time_zone)) > 0 ? "p120_Europe-Vienna" : length(regexall(
        "Europe/Vilnius", v.time_zone)) > 0 ? "p180_Europe-Vilnius" : length(regexall(
        "Europe/Volgograd", v.time_zone)) > 0 ? "p240_Europe-Volgograd" : length(regexall(
        "Europe/Warsaw", v.time_zone)) > 0 ? "p120_Europe-Warsaw" : length(regexall(
        "Europe/Zagreb", v.time_zone)) > 0 ? "p120_Europe-Zagreb" : length(regexall(
        "Europe/Zaporozhye", v.time_zone)) > 0 ? "p180_Europe-Zaporozhye" : length(regexall(
        "Europe/Zurich", v.time_zone)) > 0 ? "p120_Europe-Zurich" : length(regexall(
        "Indian/Antananarivo", v.time_zone)) > 0 ? "p180_Indian-Antananarivo" : length(regexall(
        "Indian/Chagos", v.time_zone)) > 0 ? "p360_Indian-Chagos" : length(regexall(
        "Indian/Christmas", v.time_zone)) > 0 ? "p420_Indian-Christmas" : length(regexall(
        "Indian/Cocos", v.time_zone)) > 0 ? "p390_Indian-Cocos" : length(regexall(
        "Indian/Comoro", v.time_zone)) > 0 ? "p180_Indian-Comoro" : length(regexall(
        "Indian/Kerguelen", v.time_zone)) > 0 ? "p300_Indian-Kerguelen" : length(regexall(
        "Indian/Mahe", v.time_zone)) > 0 ? "p240_Indian-Mahe" : length(regexall(
        "Indian/Maldives", v.time_zone)) > 0 ? "p300_Indian-Maldives" : length(regexall(
        "Indian/Mauritius", v.time_zone)) > 0 ? "p240_Indian-Mauritius" : length(regexall(
        "Indian/Mayotte", v.time_zone)) > 0 ? "p180_Indian-Mayotte" : length(regexall(
        "Indian/Reunion", v.time_zone)) > 0 ? "p240_Indian-Reunion" : length(regexall(
        "Pacific/Apia", v.time_zone)) > 0 ? "p840_Pacific-Apia" : length(regexall(
        "Pacific/Auckland", v.time_zone)) > 0 ? "p780_Pacific-Auckland" : length(regexall(
        "Pacific/Chatham", v.time_zone)) > 0 ? "p825_Pacific-Chatham" : length(regexall(
        "Pacific/Chuuk", v.time_zone)) > 0 ? "p600_Pacific-Chuuk" : length(regexall(
        "Pacific/Easter", v.time_zone)) > 0 ? "n300_Pacific-Easter" : length(regexall(
        "Pacific/Efate", v.time_zone)) > 0 ? "p660_Pacific-Efate" : length(regexall(
        "Pacific/Enderbury", v.time_zone)) > 0 ? "p780_Pacific-Enderbury" : length(regexall(
        "Pacific/Fakaofo", v.time_zone)) > 0 ? "p780_Pacific-Fakaofo" : length(regexall(
        "Pacific/Fiji", v.time_zone)) > 0 ? "p780_Pacific-Fiji" : length(regexall(
        "Pacific/Funafuti", v.time_zone)) > 0 ? "p720_Pacific-Funafuti" : length(regexall(
        "Pacific/Galapagos", v.time_zone)) > 0 ? "n360_Pacific-Galapagos" : length(regexall(
        "Pacific/Gambier", v.time_zone)) > 0 ? "n540_Pacific-Gambier" : length(regexall(
        "Pacific/Guadalcanal", v.time_zone)) > 0 ? "p660_Pacific-Guadalcanal" : length(regexall(
        "Pacific/Guam", v.time_zone)) > 0 ? "p600_Pacific-Guam" : length(regexall(
        "Pacific/Honolulu", v.time_zone)) > 0 ? "n600_Pacific-Honolulu" : length(regexall(
        "Pacific/Johnston", v.time_zone)) > 0 ? "n600_Pacific-Johnston" : length(regexall(
        "Pacific/Kiritimati", v.time_zone)) > 0 ? "p840_Pacific-Kiritimati" : length(regexall(
        "Pacific/Kosrae", v.time_zone)) > 0 ? "p660_Pacific-Kosrae" : length(regexall(
        "Pacific/Kwajalein", v.time_zone)) > 0 ? "p720_Pacific-Kwajalein" : length(regexall(
        "Pacific/Majuro", v.time_zone)) > 0 ? "p720_Pacific-Majuro" : length(regexall(
        "Pacific/Marquesas", v.time_zone)) > 0 ? "n570_Pacific-Marquesas" : length(regexall(
        "Pacific/Midway", v.time_zone)) > 0 ? "n660_Pacific-Midway" : length(regexall(
        "Pacific/Nauru", v.time_zone)) > 0 ? "p720_Pacific-Nauru" : length(regexall(
        "Pacific/Niue", v.time_zone)) > 0 ? "n660_Pacific-Niue" : length(regexall(
        "Pacific/Norfolk", v.time_zone)) > 0 ? "p690_Pacific-Norfolk" : length(regexall(
        "Pacific/Noumea", v.time_zone)) > 0 ? "p660_Pacific-Noumea" : length(regexall(
        "Pacific/Pago_Pago", v.time_zone)) > 0 ? "n660_Pacific-Pago_Pago" : length(regexall(
        "Pacific/Palau", v.time_zone)) > 0 ? "p540_Pacific-Palau" : length(regexall(
        "Pacific/Pitcairn", v.time_zone)) > 0 ? "n480_Pacific-Pitcairn" : length(regexall(
        "Pacific/Pohnpei", v.time_zone)) > 0 ? "p660_Pacific-Pohnpei" : length(regexall(
        "Pacific/Port_Moresby", v.time_zone)) > 0 ? "p600_Pacific-Port_Moresby" : length(regexall(
        "Pacific/Rarotonga", v.time_zone)) > 0 ? "n600_Pacific-Rarotonga" : length(regexall(
        "Pacific/Saipan", v.time_zone)) > 0 ? "p600_Pacific-Saipan" : length(regexall(
        "Pacific/Tahiti", v.time_zone)) > 0 ? "n600_Pacific-Tahiti" : length(regexall(
        "Pacific/Tarawa", v.time_zone)) > 0 ? "p720_Pacific-Tarawa" : length(regexall(
        "Pacific/Tongatapu", v.time_zone)) > 0 ? "p780_Pacific-Tongatapu" : length(regexall(
        "Pacific/Wake", v.time_zone)) > 0 ? "p720_Pacific-Wake" : length(regexall(
        "Pacific/Wallis", v.time_zone)) > 0 ? "p720_Pacific-Wallis" : length(regexall(
      "UTC", v.time_zone)) > 0 ? "p0_UTC" : "p0_UTC"
    }
  }

  ntp_authentication_keys_loop = flatten([
    for key, value in local.date_and_time : [
      for k, v in value.authentication_keys : {
        authentication_type = v.authentication_type != null ? v.authentication_type : "sha1"
        key_id              = v.key_id
        key1                = key
        trusted             = v.trusted != null ? v.trusted : "yes"
      }
    ]
  ])

  ntp_authentication_keys = { for k, v in local.ntp_authentication_keys_loop : "${v.key1}_${v.key_id}" => v }

  ntp_servers_loop = flatten([
    for key, value in local.date_and_time : [
      for k, v in value.ntp_servers : {
        authentication_key       = v.authentication_key != null ? v.authentication_key : 0
        authentication_keys      = value.authentication_keys
        description              = v.description != null ? v.description : ""
        management_epg           = v.management_epg != null ? v.management_epg : "default"
        management_epg_type      = v.management_epg_type != null ? v.management_epg_type : "oob"
        maximum_polling_interval = v.maximum_polling_interval != null ? v.maximum_polling_interval : 6
        minimum_polling_interval = v.minimum_polling_interval != null ? v.minimum_polling_interval : 4
        key1                     = key
        ntp_server               = v.ntp_server
        preferred                = v.preferred != null ? v.preferred : "no"
      }
    ]
  ])

  ntp_servers = { for k, v in local.ntp_servers_loop : "${v.key1}_${v.ntp_server}" => v }

  #__________________________________________________________
  #
  # DNS Profile Variables
  #__________________________________________________________

  dns_profiles = {
    for k, v in var.dns_profiles : k => {
      description           = v.description != null ? v.description : ""
      dns_domains           = v.dns_domains != null ? v.dns_domains : []
      dns_providers         = v.dns_providers != null ? v.dns_providers : []
      ip_version_preference = v.ip_version_preference != null ? v.ip_version_preference : "IPv4"
      management_epg        = v.management_epg != null ? v.management_epg : "default"
      management_epg_type   = v.management_epg_type != null ? v.management_epg_type : "oob"
    }
  }

  dns_domains_loop = flatten([
    for key, value in local.dns_profiles : [
      for k, v in value.dns_domains : {
        domain         = v.domain
        default_domain = v.default_domain != null ? v.default_domain : "no"
        description    = v.description != null ? v.description : ""
        key1           = key
      }
    ]
  ])

  dns_domains = { for k, v in local.dns_domains_loop : "${v.key1}_${v.domain}" => v }

  dns_providers_loop = flatten([
    for key, value in local.dns_profiles : [
      for k, v in value.dns_providers : {
        description  = v.description != null ? v.description : ""
        dns_provider = v.dns_provider
        preferred    = v.preferred != null ? v.preferred : "no"
        key1         = key
      }
    ]
  ])

  dns_providers = { for k, v in local.dns_providers_loop : "${v.key1}_${v.dns_provider}" => v }

  #__________________________________________________________
  #
  # Fabric Node Controls Variables
  #__________________________________________________________

  fabric_node_controls = {
    for k, v in var.fabric_node_controls : k => {
      alias              = v.alias != null ? v.alias : ""
      description        = v.description != null ? v.description : ""
      enable_dom         = v.enable_dom != null ? v.enable_dom : "Dom"
      feature_selections = v.feature_selections != null ? v.feature_selections : "telemetry"
      tags               = v.tags != null ? v.tags : ""
    }
  }

  #__________________________________________________________
  #
  # L3 Interface Variables
  #__________________________________________________________

  l3_interface = {
    for k, v in var.l3_interface : k => {
      alias                         = v.alias != null ? v.alias : ""
      description                   = v.description != null ? v.description : ""
      bfd_isis_policy_configuration = v.bfd_isis_policy_configuration != null ? v.bfd_isis_policy_configuration : "enabled"
      tags                          = v.tags != null ? v.tags : ""
    }
  }

  #__________________________________________________________
  #
  # Pod Profiles Variables
  #__________________________________________________________

  pod_policy_groups = {
    for k, v in var.pod_policy_groups : k => {
      alias                      = v.alias != null ? v.alias : ""
      bgp_route_reflector_policy = v.bgp_route_reflector_policy != null ? v.bgp_route_reflector_policy : "default"
      coop_group_policy          = v.coop_group_policy != null ? v.coop_group_policy : "default"
      date_time_policy           = v.date_time_policy != null ? v.date_time_policy : "default"
      description                = v.description != null ? v.description : ""
      isis_policy                = v.isis_policy != null ? v.isis_policy : "default"
      macsec_policy              = v.macsec_policy != null ? v.macsec_policy : "default"
      management_access_policy   = v.management_access_policy != null ? v.management_access_policy : "default"
      snmp_policy                = v.snmp_policy != null ? v.snmp_policy : "default"
      tags                       = v.tags != null ? v.tags : ""
    }
  }

  pod_profiles = {
    for k, v in var.pod_profiles : k => {
      alias         = v.alias != null ? v.alias : ""
      description   = v.description != null ? v.description : ""
      pod_selectors = v.pod_selectors
      tags          = v.tags != null ? v.tags : ""
    }
  }

  pod_profile_selectors_loop = flatten([
    for key, value in local.pod_profiles : [
      for k, v in value.pod_selectors : {
        key1              = key
        name              = v.name != null ? v.name : "default"
        pod_selector_type = v.pod_selector_type != null ? v.pod_selector_type : "ALL"
        pods              = v.pods != null ? v.pods : []
        policy_group      = v.policy_group != null ? v.policy_group : "default"
      }
    ]
  ])

  pod_profile_selectors = { for k, v in local.pod_profile_selectors_loop : "${v.key1}_${v.name}" => v }

  #__________________________________________________________
  #
  # Smart CallHome Variables
  #__________________________________________________________

  smart_callhome = {
    for k, v in var.smart_callhome : k => {
      admin_state            = v.admin_state != null ? v.admin_state : "enabled"
      contact_information    = v.contact_information != null ? v.contact_information : ""
      contract_id            = v.contract_id != null ? v.contract_id : ""
      customer_contact_email = v.customer_contact_email != null ? v.customer_contact_email : ""
      customer_id            = v.customer_id != null ? v.customer_id : ""
      description            = v.description != null ? v.description : ""
      destinations           = v.destinations
      from_email             = v.from_email != null ? v.from_email : ""
      phone_contact          = v.phone_contact != null ? v.phone_contact : ""
      port_number            = v.port_number != null ? v.port_number : 25
      reply_to_email         = v.reply_to_email != null ? v.reply_to_email : ""
      secure_smtp            = v.smtp_server[0]["secure_smtp"]
      site_id                = v.site_id != null ? v.site_id : ""
      street_address         = v.street_address != null ? v.street_address : ""
      smtp_server            = v.smtp_server
      username               = v.smtp_server[0]["username"]
    }
  }

  smart_callhome_smtp_servers_loop = flatten([
    for key, value in local.smart_callhome : [
      for k, v in value.smtp_server : {
        key1                = key
        management_epg      = v.management_epg != null ? v.management_epg : "default"
        management_epg_type = v.management_epg_type != null ? v.management_epg_type : "oob"
        smtp_server         = v.smtp_server != null ? v.smtp_server : "relay.example.com"
      }
    ]
  ])

  smart_callhome_smtp_servers = { for k, v in local.smart_callhome_smtp_servers_loop : "${v.key1}_${v.smtp_server}" => v }

  smart_callhome_destinations_loop = flatten([
    for key, value in local.smart_callhome : [
      for k, v in value.destinations : {
        admin_state   = v.admin_state != null ? v.admin_state : "enabled"
        email         = v.email != null ? v.email : "admin@example.com"
        format        = v.format != null ? v.format : "short-txt"
        key1          = key
        name          = element(split("@", v.email), 0)
        rfc_compliant = v.rfc_compliant != null ? v.rfc_compliant : "no"
      }
    ]
  ])

  smart_callhome_destinations = { for k, v in local.smart_callhome_destinations_loop : "${v.key1}_${v.name}" => v }

  #__________________________________________________________
  #
  # SNMP Policy Variables
  #__________________________________________________________

  snmp_policies = {
    for k, v in var.snmp_policies : k => {
      admin_state        = v.admin_state != null ? v.admin_state : "enabled"
      communities        = v.communities != null ? v.communities : []
      contact            = v.contact != null ? v.contact : ""
      description        = v.description != null ? v.description : ""
      location           = v.location != null ? v.location : ""
      snmp_client_groups = v.snmp_client_groups
      trap_destinations  = v.trap_destinations != null ? v.trap_destinations : []
      users              = v.users != null ? v.users : []
    }
  }

  snmp_client_groups_loop = flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.snmp_client_groups : {
        clients             = v.clients != null ? v.clients : []
        description         = v.description != null ? v.description : ""
        management_epg      = v.management_epg != null ? v.management_epg : "default"
        management_epg_type = v.management_epg_type != null ? v.management_epg_type : "oob"
        name                = v.name != null ? v.name : "default"
        key1                = key
      }
    ]
  ])

  snmp_client_groups = { for k, v in local.snmp_client_groups_loop : "${v.key1}_${v.name}" => v }

  snmp_client_group_clients_loop = flatten([
    for key, value in local.snmp_client_groups : [
      for k, v in value.clients : {
        address = v.address
        name    = v.name != null ? v.name : ""
        key1    = key
      }
    ]
  ])

  snmp_client_group_clients = { for k, v in local.snmp_client_group_clients_loop : "${v.key1}_${v.address}" => v }

  snmp_policies_communities_loop = flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.communities : {
        community          = v.community
        community_variable = v.community_variable != null ? v.community_variable : 1
        description        = v.description != null ? v.description : ""
        key1               = key
      }
    ]
  ])

  snmp_policies_communities = { for k, v in local.snmp_policies_communities_loop : "${v.key1}_${v.community}" => v }

  snmp_policies_users_loop = flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.users : {
        authorization_key  = v.authorization_key
        authorization_type = v.authorization_type != null ? v.authorization_type : "hmac-sha1-96"
        privacy_key        = v.privacy_key != null ? v.privacy_key : 0
        privacy_type       = v.privacy_type != null ? v.privacy_type : "none"
        key1               = key
        username           = v.username
      }
    ]
  ])

  snmp_policies_users = { for k, v in local.snmp_policies_users_loop : "${v.key1}_${v.username}" => v }

  snmp_trap_destinations_loop = flatten([
    for key, value in local.snmp_policies : [
      for k, v in value.trap_destinations : {
        community           = v.community != null ? v.community : 0
        host                = v.host
        management_epg      = v.management_epg != null ? v.management_epg : "default"
        management_epg_type = v.management_epg_type != null ? v.management_epg_type : "oob"
        port                = v.port != null ? v.port : 162
        username            = v.username != null ? v.username : ""
        key1                = key
        version             = length(regexall("[\\dA-Za-z]+", coalesce(v.username, "##"))) ? "v3" : "v2c"
      }
    ]
  ])

  snmp_trap_destinations = { for k, v in local.snmp_trap_destinations_loop : "${v.key1}_${v.host}" => v }

  #__________________________________________________________
  #
  # Syslog Variables
  #__________________________________________________________

  syslog = {
    for k, v in var.syslog : k => {
      description                    = v.description != null ? v.description : ""
      console_admin_state            = v.console_destination[0]["admin_state"] != null ? v.console_destination[0]["admin_state"] : "enabled"
      console_severity               = v.console_destination[0]["severity"] != null ? v.console_destination[0]["severity"] : "warnings"
      format                         = v.format != null ? v.format : "aci"
      include_a                      = v.include_types[0]["audit_logs"]
      include_e                      = v.include_types[0]["events"]
      include_f                      = v.include_types[0]["faults"]
      include_s                      = v.include_types[0]["session_logs"]
      local_admin_state              = v.local_file_destination[0]["admin_state"] != null ? v.local_file_destination[0]["admin_state"] : "enabled"
      local_severity                 = v.local_file_destination[0]["severity"] != null ? v.local_file_destination[0]["severity"] : "warnings"
      min_severity                   = v.min_severity != null ? v.min_severity : "warnings"
      remote_destinations            = v.remote_destinations != null ? v.remote_destinations : []
      show_milliseconds_in_timestamp = v.show_milliseconds_in_timestamp != null ? v.show_milliseconds_in_timestamp : "no"
      show_time_zone_in_timestamp    = v.show_time_zone_in_timestamp != null ? v.show_time_zone_in_timestamp : "no"
    }
  }

  syslog_remote_destinations_loop = flatten([
    for key, value in local.syslog : [
      for k, v in value.remote_destinations : {
        admin_state         = v.admin_state != null ? v.admin_state : "enabled"
        forwarding_facility = v.forwarding_facility != null ? v.forwarding_facility : "local7"
        host                = v.host != null ? v.host : "host.example.com"
        key1                = key
        management_epg      = v.management_epg != null ? v.management_epg : "default"
        management_epg_type = v.management_epg_type != null ? v.management_epg_type : "oob"
        port                = v.port != null ? v.port : 514
        severity            = v.severity != null ? v.severity : "warnings"
        transport           = v.transport != null ? v.transport : "udp"
      }
    ]
  ])

  syslog_remote_destinations = { for k, v in local.syslog_remote_destinations_loop : "${v.key1}_${v.host}" => v }

}