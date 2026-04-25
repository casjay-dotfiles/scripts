#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @Author            :  Jason Hempstead
# @Contact           :  jason@casjaysdev.pro
# @License           :  WTFPL
# @ReadME            :  timeis --help
# @Copyright         :  Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created           :  Friday, Dec 17, 2021 17:04 EST
# @File              :  timeis
# @Description       :  get current time for any timezone
# @TODO              :
# @Other             :
# @Resource          :
# - - - - - - - - - - - - - - - - - - - - - - - - -'
_timeis() {
  ___findcmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | sed 's#'${1:-$CONFDIR}'##g' | grep '^' || return 1; }
  local CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  local cur prev words cword opts split
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  local CONFFILE="settings.conf"
  local CONFDIR="$HOME/.config/myscripts/timeis"
  local SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/timeis}"
  #local SEARCHCMD="$(___findcmd "$SEARCHDIR/" "d" "1" | sort -u)"
  local SHOW_COMP_OPTS=""
  local FILEDIR=""
  local OPTS=""
  local LONGOPTS="--completions --debug --raw --options --config --version --help --silent --dir"
  local SHORTOPTS=""
  local ARRAY="get convert"
  local TZ_OPTS="Africa/Abidjan
    America/Indiana/Marengo
    Antarctica/Rothera
    Asia/Yangon
    Europe/Malta
    Africa/Accra
    America/Indiana/Petersburg
    Antarctica/Syowa
    Asia/Yekaterinburg
    Europe/Minsk
    Africa/Algiers
    America/Indiana/Tell_City
    Antarctica/Troll
    Asia/Yerevan
    Europe/Monaco
    Africa/Bissau
    America/Indiana/Vevay
    Antarctica/Vostok
    Atlantic/Azores
    Europe/Moscow
    Africa/Cairo
    America/Indiana/Vincennes
    Asia/Almaty
    Atlantic/Bermuda
    Europe/Oslo
    Africa/Casablanca
    America/Indiana/Winamac
    Asia/Amman
    Atlantic/Canary
    Europe/Paris
    Africa/Ceuta
    America/Inuvik
    Asia/Anadyr
    Atlantic/Cape_Verde
    Europe/Prague
    Africa/El_Aaiun
    America/Iqaluit
    Asia/Aqtau
    Atlantic/Faroe
    Europe/Riga
    Africa/Johannesburg
    America/Jamaica
    Asia/Aqtobe
    Atlantic/Madeira
    Europe/Rome
    Africa/Juba
    America/Juneau
    Asia/Ashgabat
    Atlantic/Reykjavik
    Europe/Samara
    Africa/Khartoum
    America/Kentucky/Louisville
    Asia/Atyrau
    Atlantic/South_Georgia
    Europe/Saratov
    Africa/Lagos
    America/Kentucky/Monticello
    Asia/Baghdad
    Atlantic/Stanley
    Europe/Simferopol
    Africa/Maputo
    America/La_Paz
    Asia/Baku
    Australia/Adelaide
    Europe/Sofia
    Africa/Monrovia
    America/Lima
    Asia/Bangkok
    Australia/Brisbane
    Europe/Stockholm
    Africa/Nairobi
    America/Los_Angeles
    Asia/Barnaul
    Australia/Broken_Hill
    Europe/Tallinn
    Africa/Ndjamena
    America/Maceio
    Asia/Beirut
    Australia/Darwin
    Europe/Tirane
    Africa/Sao_Tome
    America/Managua
    Asia/Bishkek
    Australia/Eucla
    Europe/Ulyanovsk
    Africa/Tripoli
    America/Manaus
    Asia/Brunei
    Australia/Hobart
    Europe/Uzhgorod
    Africa/Tunis
    America/Martinique
    Asia/Chita
    Australia/Lindeman
    Europe/Vienna
    Africa/Windhoek
    America/Matamoros
    Asia/Choibalsan
    Australia/Lord_Howe
    Europe/Vilnius
    America/Adak
    America/Mazatlan
    Asia/Colombo
    Australia/Melbourne
    Europe/Volgograd
    America/Anchorage
    America/Menominee
    Asia/Damascus
    Australia/Perth
    Europe/Warsaw
    America/Araguaina
    America/Merida
    Asia/Dhaka
    Australia/Sydney
    Europe/Zaporozhye
    America/Argentina/Buenos_Aires
    America/Metlakatla
    Asia/Dili
    CET
    Europe/Zurich
    America/Argentina/Catamarca
    America/Mexico_City
    Asia/Dubai
    CST6CDT
    HST
    America/Argentina/Cordoba
    America/Miquelon
    Asia/Dushanbe
    EET
    Indian/Chagos
    America/Argentina/Jujuy
    America/Moncton
    Asia/Famagusta
    EST
    Indian/Christmas
    America/Argentina/La_Rioja
    America/Monterrey
    Asia/Gaza
    EST5EDT
    Indian/Cocos
    America/Argentina/Mendoza
    America/Montevideo
    Asia/Hebron
    Etc/GMT
    Indian/Kerguelen
    America/Argentina/Rio_Gallegos
    America/Nassau
    Asia/Ho_Chi_Minh
    Etc/GMT+1
    Indian/Mahe
    America/Argentina/Salta
    America/New_York
    Asia/Hong_Kong
    Etc/GMT-1
    Indian/Maldives
    America/Argentina/San_Juan
    America/Nipigon
    Asia/Hovd
    Etc/GMT+10
    Indian/Mauritius
    America/Argentina/San_Luis
    America/Nome
    Asia/Irkutsk
    Etc/GMT-10
    Indian/Reunion
    America/Argentina/Tucuman
    America/Noronha
    Asia/Jakarta
    Etc/GMT+11
    MET
    America/Argentina/Ushuaia
    America/North_Dakota/Beulah
    Asia/Jayapura
    Etc/GMT-11
    MST
    America/Asuncion
    America/North_Dakota/Center
    Asia/Jerusalem
    Etc/GMT+12
    MST7MDT
    America/Atikokan
    America/North_Dakota/New_Salem
    Asia/Kabul
    Etc/GMT-12
    Pacific/Apia
    America/Bahia
    America/Nuuk
    Asia/Kamchatka
    Etc/GMT-13
    Pacific/Auckland
    America/Bahia_Banderas
    America/Ojinaga
    Asia/Karachi
    Etc/GMT-14
    Pacific/Bougainville
    America/Barbados
    America/Panama
    Asia/Kathmandu
    Etc/GMT+2
    Pacific/Chatham
    America/Belem
    America/Pangnirtung
    Asia/Khandyga
    Etc/GMT-2
    Pacific/Chuuk
    America/Belize
    America/Paramaribo
    Asia/Kolkata
    Etc/GMT+3
    Pacific/Easter
    America/Blanc-Sablon
    America/Phoenix
    Asia/Krasnoyarsk
    Etc/GMT-3
    Pacific/Efate
    America/Boa_Vista
    America/Port-au-Prince
    Asia/Kuala_Lumpur
    Etc/GMT+4
    Pacific/Enderbury
    America/Bogota
    America/Port_of_Spain
    Asia/Kuching
    Etc/GMT-4
    Pacific/Fakaofo
    America/Boise
    America/Porto_Velho
    Asia/Macau
    Etc/GMT+5
    Pacific/Fiji
    America/Cambridge_Bay
    America/Puerto_Rico
    Asia/Magadan
    Etc/GMT-5
    Pacific/Funafuti
    America/Campo_Grande
    America/Punta_Arenas
    Asia/Makassar
    Etc/GMT+6
    Pacific/Galapagos
    America/Cancun
    America/Rainy_River
    Asia/Manila
    Etc/GMT-6
    Pacific/Gambier
    America/Caracas
    America/Rankin_Inlet
    Asia/Nicosia
    Etc/GMT+7
    Pacific/Guadalcanal
    America/Cayenne
    America/Recife
    Asia/Novokuznetsk
    Etc/GMT-7
    Pacific/Guam
    America/Chicago
    America/Regina
    Asia/Novosibirsk
    Etc/GMT+8
    Pacific/Honolulu
    America/Chihuahua
    America/Resolute
    Asia/Omsk
    Etc/GMT-8
    Pacific/Kiritimati
    America/Costa_Rica
    America/Rio_Branco
    Asia/Oral
    Etc/GMT+9
    Pacific/Kosrae
    America/Creston
    America/Santarem
    Asia/Pontianak
    Etc/GMT-9
    Pacific/Kwajalein
    America/Cuiaba
    America/Santiago
    Asia/Pyongyang
    Etc/UTC
    Pacific/Majuro
    America/Curacao
    America/Santo_Domingo
    Asia/Qatar
    Europe/Amsterdam
    Pacific/Marquesas
    America/Danmarkshavn
    America/Sao_Paulo
    Asia/Qostanay
    Europe/Andorra
    Pacific/Nauru
    America/Dawson
    America/Scoresbysund
    Asia/Qyzylorda
    Europe/Astrakhan
    Pacific/Niue
    America/Dawson_Creek
    America/Sitka
    Asia/Riyadh
    Europe/Athens
    Pacific/Norfolk
    America/Denver
    America/St_Johns
    Asia/Sakhalin
    Europe/Belgrade
    Pacific/Noumea
    America/Detroit
    America/Swift_Current
    Asia/Samarkand
    Europe/Berlin
    Pacific/Pago_Pago
    America/Edmonton
    America/Tegucigalpa
    Asia/Seoul
    Europe/Brussels
    Pacific/Palau
    America/Eirunepe
    America/Thule
    Asia/Shanghai
    Europe/Bucharest
    Pacific/Pitcairn
    America/El_Salvador
    America/Thunder_Bay
    Asia/Singapore
    Europe/Budapest
    Pacific/Pohnpei
    America/Fortaleza
    America/Tijuana
    Asia/Srednekolymsk
    Europe/Chisinau
    Pacific/Port_Moresby
    America/Fort_Nelson
    America/Toronto
    Asia/Taipei
    Europe/Copenhagen
    Pacific/Rarotonga
    America/Glace_Bay
    America/Vancouver
    Asia/Tashkent
    Europe/Dublin
    Pacific/Tahiti
    America/Goose_Bay
    America/Whitehorse
    Asia/Tbilisi
    Europe/Gibraltar
    Pacific/Tarawa
    America/Grand_Turk
    America/Winnipeg
    Asia/Tehran
    Europe/Helsinki
    Pacific/Tongatapu
    America/Guatemala
    America/Yakutat
    Asia/Thimphu
    Europe/Istanbul
    Pacific/Wake
    America/Guayaquil
    America/Yellowknife
    Asia/Tokyo
    Europe/Kaliningrad
    Pacific/Wallis
    America/Guyana
    Antarctica/Casey
    Asia/Tomsk
    Europe/Kiev
    PST8PDT
    America/Halifax
    Antarctica/Davis
    Asia/Ulaanbaatar
    Europe/Kirov
    WET
    America/Havana
    Antarctica/DumontDUrville
    Asia/Urumqi
    Europe/Lisbon
    America/Hermosillo
    Antarctica/Macquarie
    Asia/Ust-Nera
    Europe/London
    America/Indiana/Indianapolis
    Antarctica/Mawson
    Asia/Vladivostok
    Europe/Luxembourg
    America/Indiana/Knox
    Antarctica/Palmer
    Asia/Yakutsk
    Europe/Madrid"

  _init_completion || return

  if [[ "$SHOW_COMP_OPTS" != "" ]]; then
    local SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi

  if [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    return
  elif [[ ${cur} == -* ]]; then
    COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    return
  else
    case "${COMP_WORDS[1]:-$prev}" in
    --options)
      local prev="--options"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --config)
      local prev="--config"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --help)
      prev="--help"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --version)
      local prev="--version"
      COMPREPLY=($(compgen -W '' -- "${cur}"))
      ;;

    --dir)
      local prev="dir"
      _filedir
      return
      ;;

    convert)
      local prev="convert"
      if [[ $cword = 2 ]]; then
        COMPREPLY=($(compgen -W '${TZ_OPTS}' -- "${cur}"))
      elif [[ $cword = 3 ]]; then
        COMPREPLY=($(compgen -W '$(date +'%Y-%m-%d')' -- "${cur}"))
      elif [[ $cword = 4 ]]; then
        COMPREPLY=($(compgen -W '$(date +'%H:%M:%S')' -- "${cur}"))
      else
        return
      fi
      ;;

    get)
      local prev="get"
      compopt -o nospace
      [[ $cword -lt 3 ]] && COMPREPLY=($(compgen -W '${TZ_OPTS}' -- "${cur}"))
      ;;

    *)
      if [[ -n "$FILEDIR" ]]; then _filedir; fi
      # elif [[ $cword == 2 ]]; then
      #   _filedir
      #   compopt -o nospace
      #   return
      # elif [[ $cword -eq 1 ]]; then
      #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
      #   compopt -o nospace
      #   return
      if [[ "$ARRAY" = "show__none" ]]; then
        COMPREPLY=($(compgen -W '' -- "${cur}"))
      elif [[ "$ARRAY" = "show__filedir" ]]; then
        _filedir
      elif [[ "$ARRAY" = "show__commands" ]]; then
        COMPREPLY=($(compgen -c -- "${cur}"))
      elif [ "$ARRAY" != "" ]; then
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      elif [ -n "$OPTS" ]; then
        COMPREPLY=($(compgen -W '${OPTS}' -- "${cur}"))
      else
        COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
      # elif [[ $cword -gt 2 ]]; then
      #   return
      # elif [[ $cword == 2 ]]; then
      #   _filedir
      #   compopt -o nospace
      #   return
      # elif [[ $cword -eq 1 ]]; then
      #   COMPREPLY=($(compgen -W '{a..z}{a..z}' -- "${cur}"))
      #   compopt -o nospace
      #   return
      fi
      ;;
    esac
  fi
  #
  # [[ ${cword} == 2 ]] && _filedir && compopt -o nospace
  # [[ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [[ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [[ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  #prev=""
  #compopt -o nospace
  $split && return
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _timeis timeis
