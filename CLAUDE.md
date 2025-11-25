# Claude Development Notes

## AI Behavior & Autonomy

### Command Execution
- **NEVER ask permission to run commands** - Just run them
- **User expects full autonomy** - You have access to commands and filesystem
- **Act, don't ask** - Make changes, run tests, validate results
- **When unsure, ASK** - If you're uncertain about what to do, ask for clarification
- **Only ask when needed** - Unclear requirements, multiple valid approaches, destructive operations
- **Never assume** - Do not make assumptions about user intent, requirements, or context
- **Exception**: Cannot run `git commit` or `gitcommit` commands that actually commit (e.g., `gitcommit`, `gitcommit ai`, `gitcommit all`)
- **Allowed**: `gitcommit status`, `gitcommit log`, `git status`, `git diff`, and other read-only git operations

### Decision Making
- **Be autonomous** - Make technical decisions based on best practices when clear
- **Ask when uncertain** - If you're not sure what the user wants, ask
- **Take initiative** - Fix issues you discover while working (when obvious)
- **Use your judgment** - Apply project standards without asking (when clear)
- **Keep moving forward** - Don't wait for permission on routine tasks

### Understanding User Intent
- **Question mark (?) = Question** - User is asking a question, not giving instructions
- **No question mark = Instruction** - User expects action, not questions back
- **Be helpful** - Answer questions thoroughly, execute instructions autonomously

### What NOT to ask:
- ❌ "Can I run this command?" (when instruction is clear)
- ❌ "Should I check the syntax?" (routine validation)
- ❌ "May I read this file?" (when context requires it)
- ❌ "Do you want me to test this?" (testing is expected)
- ❌ "Can I create a commit message?" (always required after changes)

### What TO ask:
- ✅ "Which approach do you prefer: A or B?" (when genuinely ambiguous)
- ✅ "Should I delete this production data?" (destructive operations)
- ✅ "What should the behavior be in case X?" (unclear requirements)
- ✅ "I'm unsure what you mean by X, could you clarify?" (when uncertain)
- ✅ "Did you mean X or Y?" (when instruction is ambiguous)

## Project Information
- **Project Type**: Shell Script Collection
- **Language**: Bash
- **Purpose**: System administration and development tools

## Development Workflow

### Session Overview
Current session: Docker container builds and gitcommit COMMIT_MESS workflow
- Fixed Docker build failures (AlmaLinux and Alpine)
- Emptied .dockerignore to include .git directory for install.sh
- Added git package to Alpine Dockerfile
- Fixed gitcommit COMMIT_MESS file handling and cleanup timing
- Updated CLAUDE.md with emoji requirements for user-facing content

Previous sessions included:
- Security improvements (fixed shellcheck errors, eliminated curl | sh)
- Function consolidation (minikube functions: 8 → 1)
- Multi-architecture support (amd64, arm64, arm)
- API integration (direct Docker Hub API calls)
- Comprehensive k3s management
- Enhanced buildx with platform detection

### Getting Started
```bash
# Docker-first testing (preferred) - build and test in container
docker build -t local-scripts-test .
docker run --rm -it local-scripts-test bash -n /usr/local/share/CasjaysDev/scripts/bin/scriptname
docker run --rm -it local-scripts-test /usr/local/share/CasjaysDev/scripts/bin/scriptname --help

# Local testing (fallback)
bash -n bin/scriptname
shellcheck bin/scriptname
./bin/scriptname --help
```

### Common Development Tasks

#### Code Quality
```bash
# Docker-first testing (preferred) - build and test in minimal container
docker build -t local-scripts-test .
docker run --rm -it local-scripts-test bash -c 'cd /usr/local/share/CasjaysDev/scripts && shellcheck bin/*'
docker run --rm -it local-scripts-test bash -c 'cd /usr/local/share/CasjaysDev/scripts && for script in bin/*; do bash -n "$script"; done'

# Local testing (fallback)  
shellcheck bin/*.sh
for script in bin/*; do bash -n "$script"; done

# Security scans
grep -r "curl.*|.*sh" bin/
grep -r "sudo.*>" .
```

#### Testing & Validation
```bash
# Docker-first testing (preferred) - test in minimal container with dependencies
docker build -t local-scripts-test .
docker run --rm -it local-scripts-test /usr/local/share/CasjaysDev/scripts/bin/scriptname --help
docker run --rm -it local-scripts-test /usr/local/share/CasjaysDev/scripts/bin/scriptname --config

# Local testing (fallback)
./bin/scriptname --version
./bin/scriptname --help
./bin/scriptname --config
```

## Script Layout Standards

### Overview
All bash scripts follow a standardized layout for consistency, maintainability, and integration with the function library system.

### Script Header (Lines 1-21)
```bash
#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202510070726-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git.io/casjay
# @@License          :  LICENSE.md
# @@ReadME           :  scriptname --help
# @@Copyright        :  Copyright (c) 2024 CasjaysDev
# @@Created          :  Monday, Oct 07, 2024 00:00 EDT
# @@File             :  scriptname
# @@Description      :  Brief description of what script does
# @@Changelog        :  New script
# @@TODO             :  TODO items if any
# @@Other            :  Other notes if any
# @@Resource         :  Resources used if any
# @@Terminal App     :  yes/no
# @@sudo/root        :  yes/no
# @@Template         :  installers/mgr-script.system
# - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC1001,SC1003,SC2001,SC2003,SC2016,SC2031,SC2090,SC2120,SC2155,SC2199,SC2317,SC2329
```

**Header Fields:**
- `##@Version` - Version in YYYYMMDDHHMM-git format (note: ## not # for Version)
- `@@Author` - Script author
- `@@Contact` - Contact information
- `@@License` - License file reference
- `@@ReadME` - Help command
- `@@Copyright` - Copyright notice
- `@@Created` - Creation date/time
- `@@File` - Script filename
- `@@Description` - Brief description
- `@@Changelog` - What changed in this version
- `@@TODO` - TODO items
- `@@Other` - Additional notes
- `@@Resource` - Resources/references used
- `@@Terminal App` - Whether requires terminal (yes/no)
- `@@sudo/root` - Whether requires root (yes/no)
- `@@Template` - Template used to create script

### Initial Setup (Lines 23-49)
```bash
APPNAME="$(basename -- "$0" 2>/dev/null)"
VERSION="202510070726-git"
USER="${SUDO_USER:-$USER}"
RUN_USER="${RUN_USER:-$USER}"
USER_HOME="${USER_HOME:-$HOME}"
SCRIPT_SRC_DIR="${BASH_SOURCE%/*}"
SCRIPTNAME_REQUIRE_SUDO="${SCRIPTNAME_REQUIRE_SUDO:-yes/no}"
SCRIPTNAME_SCRIPTS_PREFIX="${APPNAME:-scriptname}"

# Reopen in terminal (optional - uncomment if needed)
#if [ ! -t 0 ] && { [ "$1" = --term ] || [ $# = 0 ]; }; then 
#  { [ "$1" = --term ] && shift 1 || true; } && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1
#fi

# Set script title (optional - commented out by default)
# Uses more compatible BEL terminator (\007) instead of ST (\033\\)
# Sets both icon name and window title with OSC 0 sequence
#CASJAYS_DEV_TILE_FORMAT="${USER}@${HOSTNAME}:${PWD/#$HOME/~} - $APPNAME"
#CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}"
#[ -z "$CASJAYSDEV_TITLE_SET" ] && printf '\033]0;%s\007' "$CASJAYS_DEV_TILE_FORMAT" && CASJAYSDEV_TITLE_SET="$APPNAME"
export CASJAYSDEV_TITLE_PREV="${CASJAYSDEV_TITLE_PREV:-${CASJAYSDEV_TITLE_SET:-$APPNAME}}" CASJAYSDEV_TITLE_SET

# Initial debugging
[ "$1" = "--debug" ] && set -x && export SCRIPT_OPTS="--debug" && export _DEBUG="on"

# Disables colorization
[ "$1" = "--raw" ] && export SHOW_RAW="true"

# pipes fail
set -o pipefail
```

**Terminal Title Notes:**
- Uses `\033]0;` (OSC 0) - Sets both icon name and window title
- Uses `\007` (BEL) terminator - More compatible than `\033\\` (ST)
- Commented out by default - Uncomment if needed for your terminal
- Format: `user@hostname:~/path - scriptname`

### Internal Functions Section (Lines 50-560)
All internal/helper functions with `__` prefix:
- `__devnull()` - Redirect output to /dev/null
- `__devnull2()` - Redirect errors to /dev/null
- `__cmd_exists()` - Check if command exists
- `__am_i_online()` - Check internet connectivity
- Colorization functions and setup
- `__printf_head()`, `__printf_opts()`, `__printf_line()` - Formatted output
- `__gen_config()` - Generate config file
- `__help()` - Display help message
- `__trap_exit_SCRIPTNAME()` - Exit trap handler
- Additional script-specific helper functions

**Sudo Functions (for scripts requiring root):**
```bash
# Check if current user is root
__user_is_root() {
  { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; } && return 0 || return 1
}

# Check if current user is not root
__user_is_not_root() {
  if { [ $(id -u) -eq 0 ] || [ $EUID -eq 0 ] || [ "$WHOAMI" = "root" ]; }; then return 1; else return 0; fi
}

# Check if user can sudo
__can_i_sudo() {
  (sudo -vn && sudo -ln) 2>&1 | grep -vq 'may not' >/dev/null && return 0 || return 1
}

# Test if user has sudo access
__sudoif() {
  __user_is_root && return 0
  __can_i_sudo "${RUN_USER:-$USER}" && return 0
  __user_is_not_root && sudo -HE true && return 0 || return 1
}

# Execute command with sudo
__sudo() { sudo -HE "$@"; }

# Require sudo for script execution
__require_sudo() { __sudoif && __sudo "$0" "$@" && exit 0 || exit $?; }
```

**Function Naming:**
- All internal functions prefixed with `__`
- Use descriptive names: `__function_name()`
- Comments go ABOVE the function, never inline at end of line

**Note on External Dependencies:**
- Scripts are being refactored to be self-contained
- No external function library sourcing required
- All needed functions defined within each script

### Trap and Timer Setup (Lines 561-567)
```bash
# Trap handlers
trap '__trap_exit_SCRIPTNAME' EXIT
trap '__trap_ctrl_c_SCRIPTNAME' SIGINT
trap '__trap_resize_SCRIPTNAME' SIGWINCH

# Start timer
SCRIPTNAME_START_TIMER="${SCRIPTNAME_START_TIMER:-$(date +%s.%N)}"
```

**Trap Functions:**
```bash
# Exit trap - cleanup on script exit
__trap_exit_SCRIPTNAME() {
  local exitCode=${1:-${SCRIPTNAME_EXIT_STATUS:-0}}
  # Cleanup temp files
  [ -f "$SCRIPTNAME_TEMP_FILE" ] && rm -Rf "$SCRIPTNAME_TEMP_FILE" &>/dev/null
  # Additional cleanup if needed
  if builtin type -t __trap_exit_local | grep -q 'function'; then __trap_exit_local; fi
  return $exitCode
}

# Ctrl+C trap - handle user interrupt
__trap_ctrl_c_SCRIPTNAME() {
  printf_red "\n\nScript interrupted by user (Ctrl+C)\n"
  # Perform cleanup
  __trap_exit_SCRIPTNAME 130
  exit 130
}

# Window resize trap - handle terminal resize
__trap_resize_SCRIPTNAME() {
  # Update terminal dimensions if needed
  # Useful for scripts with interactive/dynamic output
  return 0
}
```

**Standard Trap Signals:**
- `EXIT` - Always trap for cleanup (temp files, restore state)
- `SIGINT` - Trap Ctrl+C for graceful interrupt handling
- `SIGWINCH` - Trap window resize for interactive scripts
- Exit code 130 for Ctrl+C (standard for SIGINT)

### User Defined Functions Section (Lines 565-567)
```bash
# User defined functions
# Add custom functions here
```

### Variable Declarations (Lines 568-638)
```bash
# Default exit code
SCRIPTNAME_EXIT_STATUS=0

# Default variables
SCRIPTNAME_USER_DIR="${SCRIPTNAME_USER_DIR:-$USRUPDATEDIR}"
SCRIPTNAME_SYSTEM_DIR="${SCRIPTNAME_SYSTEM_DIR:-$SYSUPDATEDIR}"

# Application Folders
SCRIPTNAME_LOG_DIR="${SCRIPTNAME_LOG_DIR:-$HOME/.local/log/scriptname}"
SCRIPTNAME_CACHE_DIR="${SCRIPTNAME_CACHE_DIR:-$HOME/.cache/scriptname}"
SCRIPTNAME_CONFIG_DIR="${SCRIPTNAME_CONFIG_DIR:-$HOME/.config/myscripts/scriptname}"
SCRIPTNAME_CONFIG_BACKUP_DIR="${SCRIPTNAME_CONFIG_BACKUP_DIR:-$HOME/.local/share/myscripts/scriptname/backups}"
SCRIPTNAME_RUN_DIR="${SCRIPTNAME_RUN_DIR:-$HOME/.local/run/system_scripts/scriptname}"
SCRIPTNAME_TEMP_DIR="${SCRIPTNAME_TEMP_DIR:-$HOME/.local/tmp/system_scripts/scriptname}"

# File settings
SCRIPTNAME_CONFIG_FILE="${SCRIPTNAME_CONFIG_FILE:-settings.conf}"
SCRIPTNAME_LOG_ERROR_FILE="${SCRIPTNAME_LOG_ERROR_FILE:-$SCRIPTNAME_LOG_DIR/error.log}"

# Color Settings
SCRIPTNAME_OUTPUT_COLOR_1="${SCRIPTNAME_OUTPUT_COLOR_1:-33}"
SCRIPTNAME_OUTPUT_COLOR_2="${SCRIPTNAME_OUTPUT_COLOR:-6}"
SCRIPTNAME_OUTPUT_COLOR_GOOD="${SCRIPTNAME_OUTPUT_COLOR_GOOD:-2}"
SCRIPTNAME_OUTPUT_COLOR_ERROR="${SCRIPTNAME_OUTPUT_COLOR_ERROR:-1}"

# Notification Settings
SCRIPTNAME_REMOTE_NOTIFY_ENABLED="${SCRIPTNAME_REMOTE_NOTIFY_ENABLED:-yes}"
SCRIPTNAME_SYSTEM_NOTIFY_ENABLED="${SCRIPTNAME_SYSTEM_NOTIFY_ENABLED:-yes}"
SCRIPTNAME_GOOD_NAME="${SCRIPTNAME_GOOD_NAME:-Great:}"
SCRIPTNAME_ERROR_NAME="${SCRIPTNAME_ERROR_NAME:-Error:}"

# Additional Variables (script-specific)
```

**Variable Naming:**
- All variables prefixed with `SCRIPTNAME_` (uppercase script name)
- Standard variables (USER, HOME, PATH, etc.) don't need prefix
- Group related variables together
- Use descriptive names

### Config and Directory Setup (Lines 625-638)
```bash
# Export variables
export SCRIPTS_PREFIX="$SCRIPTNAME_SCRIPTS_PREFIX"

# Generate non-existing config files
[ -f "$SCRIPTNAME_CONFIG_DIR/$SCRIPTNAME_CONFIG_FILE" ] || [ "$*" = "--config" ] || INIT_CONFIG="${INIT_CONFIG:-TRUE}" __gen_config ${SETARGS:-$@}

# Import config
[ -f "$SCRIPTNAME_CONFIG_DIR/$SCRIPTNAME_CONFIG_FILE" ] && . "$SCRIPTNAME_CONFIG_DIR/$SCRIPTNAME_CONFIG_FILE"

# Ensure Directories and files exist
[ -d "$SCRIPTNAME_RUN_DIR" ] || mkdir -p "$SCRIPTNAME_RUN_DIR" &>/dev/null
[ -d "$SCRIPTNAME_LOG_DIR" ] || mkdir -p "$SCRIPTNAME_LOG_DIR" &>/dev/null
[ -d "$SCRIPTNAME_TEMP_DIR" ] || mkdir -p "$SCRIPTNAME_TEMP_DIR" &>/dev/null
[ -d "$SCRIPTNAME_CACHE_DIR" ] || mkdir -p "$SCRIPTNAME_CACHE_DIR" &>/dev/null
SCRIPTNAME_TEMP_FILE="${SCRIPTNAME_TEMP_FILE:-$(mktemp $SCRIPTNAME_TEMP_DIR/XXXXXX 2>/dev/null)}"
```

### Option Parsing (Lines 640-767)
```bash
# Set custom actions
# Add any pre-parse actions here

# Set additional variables/Argument/Option settings
SETARGS=("$@")

SHORTOPTS="a,f"
SHORTOPTS+=""

GET_OPTIONS_NO="no-*"
GET_OPTIONS_YES="yes-*"
LONGOPTS="all,completions:,config,reset-config,debug,force,help,options,raw,version,"
LONGOPTS+=""

ARRAY="available,cron,download,install,list,remove,search,update,version"
ARRAY+=""

LIST=""
LIST+=""

# Setup application options
setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$APPNAME" -- "$@" 2>/dev/null)
eval set -- "${setopts[@]}" 2>/dev/null
while :; do
  case "$1" in
  --raw) ... ;;
  --debug) ... ;;
  --completions) ... ;;
  --options) ... ;;
  --version) ... ;;
  --help) ... ;;
  --config) ... ;;
  -f | --force) ... ;;
  --) shift 1; break ;;
  esac
done
```

### Pre-execution Setup (Lines 793-816)
```bash
# Set actions based on variables
# Add any post-parse actions here

# Check for required applications/Network check
# __sudoif && __requiresudo "$0" "${SETARGS[@]}" || exit 2
# __cmd_exists bash || exit 3
# __am_i_online "1.1.1.1" || exit 4

# APP Variables overrides
declare -a LISTARRAY=()

# Actions based on env
# Add environment-based actions

# Export variables
# Export additional variables if needed

# Execute functions
# Call initialization functions if needed

# Execute commands
# Run pre-main commands if needed
```

### Main Application Logic (Lines 818-981)
```bash
# begin main app
case "$1" in
list)
  shift 1
  # List logic
  exit ${SCRIPTNAME_EXIT_STATUS:-0}
  ;;

install)
  shift 1
  # Install logic
  exit ${SCRIPTNAME_EXIT_STATUS:-0}
  ;;

*)
  # Default action (usually show help/info)
  __help
  ;;
esac
```

### Script Footer (Lines 982-992)
```bash
# Set exit code
SCRIPTNAME_EXIT_STATUS="${SCRIPTNAME_EXIT_STATUS:-0}"

# End application
# Final cleanup if needed

# lets exit with code
exit ${SCRIPTNAME_EXIT_STATUS:-0}

# ex: ts=2 sw=2 et filetype=sh
```

### Template Types

#### mgr-script.user.sh
- **sudo/root**: no
- **Purpose**: User-level scripts (no root required)
- **Config Location**: `~/.config/myscripts/scriptname/`
- **Uses**: `USRUPDATEDIR` for package management

#### mgr-script.system.sh
- **sudo/root**: yes
- **Purpose**: System-level scripts (requires root for certain operations)
- **Config Location**: System-wide and user configs
- **Uses**: `SYSUPDATEDIR` for package management
- **Special**: Includes `__requiresudo()` logic for specific commands

### Key Layout Rules

1. **Header always at top** - Lines 1-21 with all metadata
2. **Functions before variables** - All function definitions before variable declarations
3. **Variables before options** - All variable declarations before option parsing
4. **Main logic at end** - Case statement for main application logic at end
5. **Comments above code** - Never inline comments at end of lines
6. **Consistent spacing** - Use separator lines (# - - - - -) between sections
7. **Exit codes set** - Always set `SCRIPTNAME_EXIT_STATUS` before exit
8. **Newline at EOF** - Always end file with newline character

### Version Format
- Format: `YYYYMMDDHHMM-git`
- Example: `202510070726-git`
- Update on every change
- Use in both header (`##@Version`) and `VERSION` variable

### When to Update Headers
- **Always update** when making changes to script
- **Version**: Update to current date-time
- **Changelog**: Brief description of what changed
- **Description**: Update if functionality changed
- **Keep format/layout** consistent with template

## Best Practices Implemented

### Security
- No `curl | sh` patterns - use direct downloads
- Proper sudo handling with `sudo tee` instead of redirects
- Input validation and sanitization
- Secure credential storage

### Code Quality
- Use `if/else` or `if/elif/else` instead of `&&`/`||` chains for readability
- **All functions prefixed with `__`** (internal functions)
- **All variables prefixed with `{SCRIPTNAME}_`** (except where inappropriate)
- **Always add newline at end of files** (except where not supported)
- **Comments always go ABOVE the code** - Never use inline comments at end of line
- Proper error handling and user feedback
- Multi-architecture support where applicable
- **Update script headers** (@@Version, @@Description, @@Changelog, etc.) when making changes
  - Keep same format and layout
  - Update version to current date-time format (YYYYMMDDHHMM-git)
  - Update changelog with brief description of changes
  - Update other fields as appropriate to reflect script functionality

### Architecture Support
- **amd64** (x86_64)
- **arm64** (aarch64)  
- **arm** (armv7l)

## Common Patterns

### Common Utility Functions
```bash
# These should exist in most script projects
__cmd_exists()          # Check if command exists
__user_is_root()       # Check root privileges  
__get_arch()           # Detect system architecture
__gen_config()         # Generate config files
```

### Project-Specific Function Categories
```bash
# API integration  
__api_function()       # External service integration
__download_function()  # File/package downloads

# Script-specific functions
__init()               # Initialization functions
__install_package()    # Installation helpers
```

## Debugging

### Enable Debug Mode
```bash
./bin/scriptname --debug
```

### Common Issues
1. **Permission errors** - Check sudo configuration
2. **Function not found** - Verify function library imports
3. **Syntax errors** - Use `bash -n` to check
4. **Network issues** - Test connectivity with `am_i_online`

## Configuration

### Config Locations
- User configs: `~/.config/myscripts/scriptname/`
- System configs: `/etc/scriptname/`
- Logs: `~/.local/log/scriptname/`

### Environment Variables
```bash
SCRIPTNAME_CONFIG_DIR   # Configuration directory
SCRIPTNAME_LOG_DIR      # Log directory  
SCRIPTNAME_CACHE_DIR    # Cache directory
```

### Naming Schema

#### Man Pages
- **Location**: `man/`
- **Format**: `{scriptname}.1`
- **Examples**: `dockermgr.1`, `virtmgr.1`, `setupmgr.1`

#### Completion Files  
- **Location**: `completions/`
- **Format**: `_{scriptname}_completions`
- **Examples**: `_dockermgr_completions`, `_virtmgr_completions`

## Integration

### With System Package Managers
- **pacman** (Arch/CachyOS/Manjaro)
- **apt** (Debian/Ubuntu/Mint)
- **dnf/yum** (RHEL/Fedora/CentOS)
- **zypper** (openSUSE/SLES)
- **apk** (Alpine)
- **pkg** (FreeBSD)
- **pkg_add** (OpenBSD)
- **brew** (macOS/Linux)
- **emerge** (Gentoo)
- **Windows**: Use WSL with appropriate Linux package manager

### With External APIs
- GitHub API for releases and version checking
- Docker Hub API for repository management
- Container registries for multi-architecture builds
- Various web services for functionality

### Docker Integration
- Multi-platform builds with buildx
- Platform detection and fallback support
- Container-based testing environments
- Registry authentication and management

## Environment Variable Specification

### Repository URLs (Full URLs)
- **`ENV_GIT_REPO_URL`** - Complete Git repository URL (e.g., `https://github.com/user/repo`)
- **`ENV_REGISTRY_URL`** - Complete registry URL for reference (NOT used for pushing)
  - Default: `https://hub.docker.com` for Docker Hub
  - Custom: `https://registry.company.com` for private registries

### Push Configuration
- **`ENV_IMAGE_PUSH`** - Complete push destination (this IS used for pushing)
  - Format: `{user}/{repo}` (Docker Hub) or `{registry}/{user}/{repo}` (Custom)
  - Examples: `casjaysdev/myapp` or `ghcr.io/casjaysdev/myapp`

### Tag Management
- **`ENV_IMAGE_TAG`** - Default tag (e.g., `latest`, `v1.0`)
- **`ENV_ADD_TAGS`** - Additional tags, comma-separated
  - Special: `USE_DATE` → automatically adds date as tag
  - Example: `v1.0,stable,USE_DATE`

### Pull Configuration
- **`ENV_PULL_URL`** - Source image (same format as ENV_IMAGE_PUSH)
- **`ENV_DISTRO_TAG`** - Tag for source image
- **Combined**: `$ENV_PULL_URL:$ENV_DISTRO_TAG` (e.g., `ubuntu:22.04`)

## File Management Standards

### Reading Large Files
- **Always read in chunks** (top to bottom)
- **Read multiple times** for comprehension
- Use `offset` and `limit` parameters for large files
- Never attempt to read entire large files at once

### Temporary Files
- **All temp/debug files**: `~/.local/tmp/claude/{reponame}/`
- **Keep base directory clean** - production ready state only
- **No temp files in working directory** - use proper temp locations
- **Clean up after development** - remove debugging artifacts

### AI File Management
- **AI.md** - Master context file with full AI conversation history, rules, patterns
  - Location: `<git_root>/AI.md`
  - **ALWAYS keep in sync** - Update continuously throughout session
  - **Update after completing each major task** - Never wait until end of session
  - Prevents context loss if crash or error occurs
  - Contains: Session history, lessons learned, patterns established, quick reference
  - Purpose: Complete AI context for current and future sessions
  - If doesn't exist at session start: Create by reading CLAUDE.md and repository state
  
- **AI.TODO.md** - Temporary task tracker for current session
  - **ALWAYS use when >2 instructions or >2 tasks**
  - Location: `<git_root>/AI.TODO.md`
  - Purpose: Track multiple tasks, keep AI focused and organized
  - **Keep in sync**: Update after completing each task
  - **Delete when done**: Remove AI.TODO.md when all tasks are completed
  - Format: Standard markdown checklist with clear task descriptions

**When to create AI.TODO.md:**
- ✅ More than 2 instructions given at once
- ✅ More than 2 tasks to complete
- ✅ Complex multi-step workflow
- ✅ Multiple files to modify

**What to include:**
```markdown
# AI TODO

## Current Session Tasks

- [ ] Task 1: Description
- [ ] Task 2: Description
- [ ] Task 3: Description

## Completed

- [x] Completed task 1
- [x] Completed task 2
```

**Workflow:**
1. User gives 3+ tasks → Create AI.TODO.md immediately
2. Work on tasks one at a time
3. Update AI.TODO.md after each task (move to Completed section)
4. When all tasks done → Delete AI.TODO.md
5. Update AI.md after completing each major task (continuous sync)
6. Create COMMIT_MESS with all changes

### Function and Variable Naming
- **Functions**: Prefix with `__` for internal functions
- **Variables**: Prefix with `{SCRIPTNAME}_` (uppercase script name)
- **Exceptions**: Use judgment for standard variables (PATH, HOME, etc.)
- **Examples**: 
  - `DOCKERMGR_CONFIG_DIR` ✅
  - `BUILDX_TEMP_DIR` ✅
  - `USER` ✅ (standard variable)

## Git & Version Control

### Commit Policy
- **Never commit changes** - User handles all commits with signing
- **Focus on code changes only** - Make edits, test, validate
- **User commits when ready** - Respects signed commit workflow

### AI/Claude Access
- **AI has access to ALL commands** - Including git commands for checking status, logs, diffs, etc.
- **EXCEPT: Never run `git commit`** - User handles all commits with GPG signing
- **EXCEPT: Never run `gitcommit` without subcommand** - Only read-only operations allowed
- **Can use git**: `git status`, `git diff`, `git log`, `git show`, `git branch`, etc.
- **Can use gitcommit**: `gitcommit status`, `gitcommit log`, `gitcommit log show`, `gitcommit diff`, etc.
- **Cannot use**: `git commit`, `gitcommit` (no args), `gitcommit all`, `gitcommit push`, etc. (user only)
- **ALWAYS create/update**: `.git/COMMIT_MESS` file in the git repository root for commit messages
  - Use `git rev-parse --show-toplevel` to find git root directory
  - File path: `<git_root>/.git/COMMIT_MESS`
  - Example: `/home/jason/Projects/github/casjay-dotfiles/scripts/.git/COMMIT_MESS`

### Commit Message Integration
- **gitcommit script** - Parses `.git/COMMIT_MESS` file if it exists at startup
- **AI workflow**:
  1. **ALWAYS** create/update `.git/COMMIT_MESS` with commit message after making changes
     - Find git root: `git rev-parse --show-toplevel`
     - File location: `<git_root>/.git/COMMIT_MESS`
  2. File contains complete commit message ready for user to commit
     - First line: Short commit message (summary) with emojis
     - Remaining lines: Long commit message (detailed description)
  3. User runs `gitcommit` or `./bin/gitcommit`
  4. Script automatically parses file, extracts messages, commits with signing
  5. Script cleans up `.git/COMMIT_MESS` file after successful commit
- **File format**: Plain text, first line = short message, rest = long message
- **Automatic cleanup** - gitcommit's __gitcommit_cmd() removes message file after successful commit
- **Emoji requirement** - Always add appropriate emojis to user-facing content
  - **Commit messages**: `🐛 Commit message 🐛` (emoji at start and end)
  - **All user-facing content**: Documentation, messages, appropriate file content
  - File messages bypass auto-emoji wrapping, so emojis must be added manually
  - Common emojis: 🐛 (fix), ✨ (feature), 📝 (docs), 🚀 (release), ♻️ (refactor), 🗃️ (general), 🔧 (config)
  - Use contextually appropriate emojis for the content type

**Short Commit Message Format (CRITICAL):**
- **Maximum length**: 72 characters (including emojis)
- **Format**: `🔧 Short descriptive summary 🔧`
- **Rules**:
  1. ✅ Start with emoji (no dots or text before)
  2. ✅ Concise summary - get to the point
  3. ✅ End with same emoji (no dots or text after)
  4. ✅ Capitalize first word after emoji
  5. ✅ NO period at end
  6. ✅ NO "..." truncation indicators
- **Good examples**:
  - `✨ Enhanced --create to show full commit details ✨`
  - `♻️ Removed unnecessary .log file handling ♻️`
  - `🔧 Enhanced log command with optional limit ♻️`
- **Bad examples**:
  - `...✨ Enhanced changelog generation with full commit details and updated ...` (truncated)
  - `🔧 Enhanced log command with optional limit parameter.` (has period)
  - `Enhanced log command` (missing emojis)
  - `🔧 This is a very long commit message that goes on and on and will get truncated with dots 🔧` (too long)

## Key Session Accomplishments

### Current Session: Docker Builds & gitcommit Fixes
- **Docker Container Builds**: Fixed AlmaLinux and Alpine container build failures
  - Emptied `.dockerignore` to include `.git` directory (required by install.sh)
  - Added git package to Alpine Dockerfile
  - Both containers now build and run successfully
- **gitcommit COMMIT_MESS Handling**: Fixed file management workflow
  - Removed premature deletion from `__trap_exit_local()` function
  - Added post-commit cleanup in `__gitcommit_cmd()` after successful commits
  - Fixed 'all' case to preserve message from `.git/COMMIT_MESS` file
  - Updated script version to 202510070726-git
- **Documentation**: Updated CLAUDE.md with emoji requirements and workflow details

### Previous Sessions

#### Security & Code Quality
- Fixed shellcheck SC2024 errors (sudo redirect patterns)
- Eliminated insecure `curl | sh` patterns throughout codebase
- Implemented proper multi-architecture binary downloads
- Converted complex `&&`/`||` chains to readable if/else statements

#### Docker Management Enhancements
- Enhanced dockermgr with comprehensive k3s (k3b) management
- Consolidated 8 minikube functions into single `__minikube_cmd()`
- Implemented direct Docker Hub API integration (no external containers)
- Added `__create_readme()` function for automated documentation

#### Build & Container Improvements
- Enhanced buildx script with platform detection and graceful fallback
- Fixed Dockerfile systemd issues for proper container operation
- Added comprehensive OCI labels and metadata
- Separated setupmgr (binary installation) from dockermgr (configuration)

#### Infrastructure & Templates
- Created generic CLAUDE.md and TODO.md templates for reuse
- Documented comprehensive development standards and workflows
- Added support for extensive package manager ecosystem
- Established Docker-first testing methodology

## Notes
- Always test changes in development environment first
- Use shellcheck for code quality
- Follow existing patterns and conventions
- Use `.git/COMMIT_MESS` workflow for commit message integration
