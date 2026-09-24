#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202609241759-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  setupmgr --help
# @@Copyright        :  Copyright: (c) 2024 Jason Hempstead, Casjays Developments
# @@Created          :  Saturday, Sep 14, 2024 14:03 EDT
# @@File             :  setupmgr
# @@Description      :  Bash completion for setupmgr - cross-platform package manager
# @@Changelog        :  Add missing grep -- separators for script-lint compliance
# @@TODO             :  Better documentation
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2115,SC2120,SC2155,SC2199,SC2229,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
_setupmgr() {
  #####################################################################
  local cur prev words cword opts split CONFDIR="" CONFFILE="" SEARCHDIR=""
  local SHOW_COMP_OPTS="" NOOPTS="" SHORTOPTS="" LONGOPTS="" ARRAY="" LIST="" SHOW_COMP_OPTS_SEP=""
  local CASJAYSDEVDIR="" OPTS_NO="" OPTS_YES=""
  #####################################################################
  _init_completion || return
  #####################################################################
  ___jq() { jq -rc "$@" 2>/dev/null; }
  ___sed_env() { sed 's|"||g;s|.*=||g' 2>/dev/null || false; }
  ___ls() { ls -A "$1" 2>/dev/null | grep -v -- '^$' | grep -- '^' || false; }
  ___curl() { curl -q -LSsf --max-time 1 --retry 0 "$@" 2>/dev/null || return 1; }
  ___grep_file() { grep --no-filename -vsR -- '#' "$@" 2>/dev/null | grep -- '^' || return 1; }
  ___find_cmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | grep -- '^' || return 1; }
  ___find_rel() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} -printf "%P\n" 2>/dev/null | grep -- '^' || return 1; }
  ___grep_env() { GREP_COLORS="" grep -shE -- '^.*=*..*$' "$1" 2>/dev/null | grep -v -- '^#' | grep -- "${2:-^}" | sed 's|"||g' 2>/dev/null | grep -- '^' || false; }
  #####################################################################
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  CONFFILE="settings.conf"
  CONFDIR="$HOME/.config/myscripts/setupmgr"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/setupmgr}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS=""
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --config --reset-config --configure --debug --dir --help --options --color --no-color --version --silent --force --system --all "
  #####################################################################
  ARRAY="9router act age aichat aider ali antigravity asdf atuin bandwhich bat bob bombardier bottom broot btop buf bun caddy coder cody continue cosign crush charm ctlptl ctop curlie dasel delta deno devbox difftastic direnv dive dnsglobe dotnet droast dua duf dust earthly evans eza fabric fastfetch fd fnm fx fzf garage gh ghz git-cliff gitleaks gitui glow go gohttpserver gpt grex gron grpcurl grype gvm hadolint helix helm httpie hyperfine incus jekyll jless jnv jq just k6 k9s kimchi kind kompose kubectl kubectx kubens lapce lazydocker lazygit lf lima llama-cpp llm localai lsd lua mc miller minikube mise mods nix nodejs nushell nvm oha ollama opencode opentofu packer pi pipx plandex powershell procs rbenv ripgrep ruff rustfs rustup rvm sd shellcheck shfmt skaffold sops speedtest sq starship stern syft tabby task terminal-browser tgpt tilt tldr tokei traefik trivy trufflehog uv vagrant vale vegeta vfox viddy watchexec webhookd xcaddy xh yq zed zellij zig zoxide"
  ARRAY+="remove all system update"
  #####################################################################
  LIST=""
  LIST+=""
  #####################################################################
  OPTS_NO="--no-* "
  OPTS_YES="--yes-* "
  #####################################################################
  if [ "$SHOW_COMP_OPTS" != "" ]; then
    SHOW_COMP_OPTS_SEP="${SHOW_COMP_OPTS//,/ }"
    compopt -o $SHOW_COMP_OPTS_SEP
  fi
  #####################################################################
  if [[ ${cur} == --no* ]]; then
    COMPREPLY=($(compgen -W '${OPTS_NO}' -- ${cur}))
  elif [[ ${cur} == --yes* ]]; then
    COMPREPLY=($(compgen -W '${OPTS_YES}' -- ${cur}))
  elif [[ ${cur} == --* ]]; then
    COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
  elif [[ ${cur} == -* ]]; then
    if [ -n "$SHORTOPTS" ]; then
      COMPREPLY=($(compgen -W '${SHORTOPTS}' -- ${cur}))
    else
      COMPREPLY=($(compgen -W '${LONGOPTS}' -- ${cur}))
    fi
  else
    case "${prev:-${COMP_WORDS[1]}}" in
    --completions)
      prev=""
      COMPREPLY=($(compgen -W 'long short list array' -- "$cur"))
      ;;
    --config | --debug | --help | --options | --color | --no-color | --version)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --no-*)
      COMPREPLY=($(compgen -W '${NOOPTS}' -- "$cur"))
      return 0
      ;;
    --dir)
      prev="dir"
      [ "$cword" -le 2 ] && _filedir -d || COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      ;;
    *)
      COMPREPLY=($(compgen -W '${ARRAY}' -- "$cur"))
      return 0
      ;;
    esac
  fi
  #
  # [ "${ARRAY}" = "show__filedir" ] && _filedir
  # [ ${cword} = 2 ] && _filedir && compopt -o nospace
  # [ "${ARRAY}" != "" ] && COMPREPLY=($(compgen -W '${ARRAY}' -- "${cur}"))
  # [ "${ARRAY}" = "show__none" ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # [ "${ARRAY}" = "show__commands" ] && COMPREPLY=($(compgen -c -- "${cur}"))
  # [ $COMP_CWORD -eq 2 ] && COMPREPLY=($(compgen -W '{a..z} {A..Z} {0..9}' -o nospace -- "${cur}"))
  # [ $COMP_CWORD -eq 3 ] && COMPREPLY=($(compgen -W '$(_filedir)' -o filenames -o dirnames -- "${cur}"))
  # [ $COMP_CWORD -gt 3 ] && COMPREPLY=($(compgen -W '' -- "${cur}"))
  # compopt -o nospace
} &&
  # - - - - - - - - - - - - - - - - - - - - - - - - -
  # enable completions
  complete -F _setupmgr -o default setupmgr

# ex: ts=2 sw=2 et filetype=sh
