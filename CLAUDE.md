# Claude Development Notes

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

### Commit Message Integration
- **gitcommit script** - Parses `.git/COMMIT_MESS` file if it exists at startup
- **Claude workflow**:
  1. Create/update `.git/COMMIT_MESS` with commit message
     - First line: Short commit message (summary) with emojis
     - Remaining lines: Long commit message (detailed description)
  2. User runs `gitcommit` or `./bin/gitcommit`
  3. Script automatically parses file, extracts messages, commits with signing
  4. Script cleans up `.git/COMMIT_MESS` file after successful commit
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
