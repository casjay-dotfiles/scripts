# Claude Development Notes

## Project Information
- **Project Type**: Shell Script Collection
- **Language**: Bash
- **Purpose**: System administration and development tools

## Development Workflow

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
- GitHub API for releases
- Docker Hub API for repositories
- Various web services for functionality

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

## Notes
- Always test changes in development environment first
- Use shellcheck for code quality
- Follow existing patterns and conventions
- Document significant changes in git commits
