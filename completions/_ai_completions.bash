#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202602020740-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  ai --help
# @@Copyright        :  Copyright: (c) 2025 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Nov 24, 2025 14:13 EST
# @@File             :  ai
# @@Description      :  
# @@Changelog        :  
# @@TODO             :
# @@Other            :  
# @@Resource         :  
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  completions/system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2120,SC2155,SC2199,SC2317,SC2329
# - - - - - - - - - - - - - - - - - - - - - - - - -
_ai_completion() {
  #####################################################################
  local cur prev words cword opts split CONFDIR="" CONFFILE="" SEARCHDIR=""
  local SHOW_COMP_OPTS="" NOOPTS="" SHORTOPTS="" LONGOPTS="" ARRAY="" LIST="" SHOW_COMP_OPTS_SEP=""
  #####################################################################
  _init_completion || return
  #####################################################################
  ___jq() { jq -rc "$@" 2>/dev/null; }
  ___sed_env() { sed 's|"||g;s|.*=||g' 2>/dev/null || false; }
  ___ls() { ls -A "$1" 2>/dev/null | grep -v '^$' | grep '^' || false; }
  ___curl() { curl -q -LSsf --max-time 1 --retry 0 "$@" 2>/dev/null || return 1; }
  ___grep_file() { grep --no-filename -vsR '#' "$@" 2>/dev/null | grep '^' || return 1; }
  ___find_cmd() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} 2>/dev/null | grep '^' || return 1; }
  ___find_rel() { find -L "${1:-$CONFDIR/}" -maxdepth ${3:-3} -type ${2:-f} -printf "%P\n" 2>/dev/null | grep '^' || return 1; }
  ___grep_env() { GREP_COLORS="" grep -shE '^.*=*..*$' "$1" 2>/dev/null | grep -v '^#' | grep "${2:-^}" | sed 's|"||g' 2>/dev/null | grep '^' || false; }
  #####################################################################
  cur="${COMP_WORDS[$COMP_CWORD]}"
  prev="${COMP_WORDS[$COMP_CWORD - 1]}"
  #####################################################################
  CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
  #####################################################################
  CONFFILE="settings.conf"
  CONFDIR="$HOME/.config/myscripts/ai"
  SEARCHDIR="${CONFDIR:-$HOME/.config/myscripts/ai}"
  #####################################################################
  SHOW_COMP_OPTS=""
  #####################################################################
  SHORTOPTS=""
  SHORTOPTS+=""
  #####################################################################
  LONGOPTS="--completions --config --reset-config --debug --dir --help --options --raw --version --silent --force --no- --yes-"
  LONGOPTS+=" --model --provider --list --check"
  #####################################################################
  # Subcommands
  ARRAY="changelog commit pr release branch diff issue squash"
  ARRAY+=" review security complexity deps perf"
  ARRAY+=" explain fix debug refactor optimize convert types modernize"
  ARRAY+=" test e2e bench doc mock example implement"
  ARRAY+=" summarize translate rewrite grammar email bullet outline tldr"
  ARRAY+=" shell cmd shellx docker compose k8s ci nginx systemd cron makefile terraform ansible helm"
  ARRAY+=" json yaml csv sql regex schema migration model seed"
  ARRAY+=" readme gitignore env license api-doc comment"
  ARRAY+=" api curl http"
  ARRAY+=" learn compare eli5 how why"
  ARRAY+=" name style pros-cons ideas brainstorm critique improve"
  ARRAY+=" create build scaffold edit component validate trace error"
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
    --options)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --help | --version | --config)
      COMPREPLY=($(compgen -W '' -- ${cur}))
      return 0
      ;;
    --debug | --raw)
      COMPREPLY=($(compgen -W '${ARRAY} ${LONGOPTS} ${SHORTOPTS}' -- ${cur}))
      return 0
      ;;
    --model)
      # Get models from various providers
      local models=""
      # Ollama models
      if command -v ollama &>/dev/null; then
        models+=" $(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')"
      fi
      # LM Studio models
      if command -v lms &>/dev/null; then
        models+=" $(lms ls 2>/dev/null | tail -n +2 | awk '{print $1}')"
      fi
      # llm models
      if command -v llm &>/dev/null; then
        models+=" $(llm models list 2>/dev/null | awk '{print $1}')"
      fi
      # Common model names as fallback
      models+=" llama2 llama3 mistral codellama phi gemma qwen deepseek"
      COMPREPLY=($(compgen -W '${models}' -- ${cur}))
      return 0
      ;;
    --provider)
      # Provider types and all known providers
      local providers="local cloud"
      # Local providers (use local models)
      providers+=" ollama llama-cli llama llamafile localai lmstudio gpt4all llm mlx koboldcpp jan mods fabric aichat tgpt"
      # Cloud providers (use cloud APIs)
      providers+=" claude copilot gh-copilot amazonq cody gemini bito aider sgpt openai chatgpt codex plandex mentat goose openhands opencode gpte"
      COMPREPLY=($(compgen -W '${providers}' -- ${cur}))
      return 0
      ;;
    # After provider/model value, show subcommands
    local|cloud|ollama|llama-cli|llama|llamafile|localai|lmstudio|gpt4all|llm|mlx|koboldcpp|jan|mods|fabric|aichat|tgpt|claude|copilot|gh-copilot|amazonq|cody|gemini|bito|aider|sgpt|openai|chatgpt|codex|plandex|mentat|goose|openhands|opencode|gpte)
      COMPREPLY=($(compgen -W '${ARRAY}' -- ${cur}))
      return 0
      ;;
    # Subcommands that take language argument
    convert|translate)
      local langs="Python JavaScript TypeScript Go Rust Java C C++ Ruby PHP Swift Kotlin Bash Shell Perl R Scala Haskell Lua"
      langs+=" English Spanish French German Italian Portuguese Chinese Japanese Korean Russian Arabic Hindi"
      COMPREPLY=($(compgen -W '${langs}' -- ${cur}))
      return 0
      ;;
    # License types
    license)
      local licenses="MIT Apache-2.0 GPL-3.0 BSD-3-Clause ISC MPL-2.0 LGPL-3.0 AGPL-3.0 Unlicense WTFPL CC0"
      COMPREPLY=($(compgen -W '${licenses}' -- ${cur}))
      return 0
      ;;
    # CI platforms
    ci)
      local platforms="github-actions gitlab-ci jenkins travis circleci azure-pipelines bitbucket"
      COMPREPLY=($(compgen -W '${platforms}' -- ${cur}))
      return 0
      ;;
    # Test frameworks
    test)
      local frameworks="pytest jest mocha vitest junit go-test rspec phpunit unittest tap ava jasmine karma cypress playwright"
      COMPREPLY=($(compgen -W '${frameworks}' -- ${cur}))
      return 0
      ;;
    # Docker types
    docker)
      local docker_types="dockerfile docker-compose multi-stage slim alpine distroless"
      COMPREPLY=($(compgen -W '${docker_types}' -- ${cur}))
      return 0
      ;;
    # Kubernetes resources
    k8s)
      local k8s_resources="deployment service configmap secret ingress statefulset daemonset job cronjob pvc namespace hpa"
      COMPREPLY=($(compgen -W '${k8s_resources}' -- ${cur}))
      return 0
      ;;
    # Schema types
    schema)
      local schema_types="json-schema openapi graphql protobuf avro typescript zod prisma mongoose sql"
      COMPREPLY=($(compgen -W '${schema_types}' -- ${cur}))
      return 0
      ;;
    # SQL dialects
    sql)
      local sql_dialects="postgresql mysql sqlite mssql oracle mariadb"
      COMPREPLY=($(compgen -W '${sql_dialects}' -- ${cur}))
      return 0
      ;;
    # Systemd unit types
    systemd)
      local unit_types="service timer socket path mount automount"
      COMPREPLY=($(compgen -W '${unit_types}' -- ${cur}))
      return 0
      ;;
    # Git commands with branch completion
    branch|diff|pr)
      # Try to get git branches
      local branches=""
      if git rev-parse --git-dir &>/dev/null; then
        branches="$(git branch --format='%(refname:short)' 2>/dev/null)"
      fi
      COMPREPLY=($(compgen -W '${branches}' -- ${cur}))
      return 0
      ;;
    # Release with version suggestion
    release|changelog)
      # Try to get git tags
      local tags=""
      if git rev-parse --git-dir &>/dev/null; then
        tags="$(git tag -l 2>/dev/null | tail -10)"
      fi
      tags+=" v0.1.0 v1.0.0 v2.0.0"
      COMPREPLY=($(compgen -W '${tags}' -- ${cur}))
      return 0
      ;;
    # Edit command - show files in current directory
    edit)
      _filedir
      return 0
      ;;
    # Create/build/scaffold - show common project types
    create|build|scaffold)
      local project_types="nodejs express react nextjs vue angular svelte python flask django fastapi go rust java spring android ios flutter"
      COMPREPLY=($(compgen -W '${project_types}' -- ${cur}))
      return 0
      ;;
    # E2E test frameworks
    e2e)
      local e2e_frameworks="cypress playwright selenium puppeteer testcafe nightwatch webdriverio codeceptjs"
      COMPREPLY=($(compgen -W '${e2e_frameworks}' -- ${cur}))
      return 0
      ;;
    # Benchmark frameworks
    bench)
      local bench_frameworks="criterion hyperfine pytest-benchmark go-bench jmh artillery k6 locust wrk ab"
      COMPREPLY=($(compgen -W '${bench_frameworks}' -- ${cur}))
      return 0
      ;;
    # Terraform resources
    terraform)
      local tf_resources="aws azure gcp digitalocean linode vultr cloudflare kubernetes docker null local"
      COMPREPLY=($(compgen -W '${tf_resources}' -- ${cur}))
      return 0
      ;;
    # Ansible types
    ansible)
      local ansible_types="playbook role task handler template vars inventory galaxy collection"
      COMPREPLY=($(compgen -W '${ansible_types}' -- ${cur}))
      return 0
      ;;
    # Helm chart types
    helm)
      local helm_types="chart values deployment service ingress configmap secret hpa pdb"
      COMPREPLY=($(compgen -W '${helm_types}' -- ${cur}))
      return 0
      ;;
    # Database migration types
    migration)
      local migration_types="alembic flyway liquibase prisma knex sequelize typeorm django-migrations goose sql"
      COMPREPLY=($(compgen -W '${migration_types}' -- ${cur}))
      return 0
      ;;
    # ORM/Model types
    model)
      local model_types="sqlalchemy django-orm sequelize prisma typeorm mongoose gorm ecto activerecord"
      COMPREPLY=($(compgen -W '${model_types}' -- ${cur}))
      return 0
      ;;
    # UI component frameworks
    component)
      local component_types="react vue angular svelte solid preact lit web-component"
      COMPREPLY=($(compgen -W '${component_types}' -- ${cur}))
      return 0
      ;;
    --no-*)
      COMPREPLY=($(compgen -W '${OPTS_NO}' -- "$cur"))
      return 0
      ;;
    --yes-*)
      COMPREPLY=($(compgen -W '${OPTS_YES}' -- "$cur"))
      return 0
      ;;
    --all)
      COMPREPLY=($(compgen -W '' -- "$cur"))
      ;;
    *)
      [ $cword -gt 2 ] && COMPREPLY=($(compgen -W '${LIST}' -- "$cur")) ||
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
  complete -F _ai_completion -o default ai

# ex: ts=2 sw=2 et filetype=sh
