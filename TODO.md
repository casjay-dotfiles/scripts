# Project TODO List

## Active Tasks

### Documentation
- [ ] Create/update man pages for ALL bin/* scripts (219 scripts total)
  - Generate man pages for every script in bin/
  - Follow standard man page format (NAME, SYNOPSIS, DESCRIPTION, OPTIONS, EXAMPLES)
  - Install to man/ directory with .1 extension
  - Automate generation where possible from script headers
- [ ] Create/update bash completion files for ALL bin/* scripts (219 scripts total)
  - Generate completions for every script in bin/
  - Match current commands and options from case statements
  - Install to completions/ directory with _{scriptname}_completions format
  - Automate generation from option parsing where possible
- [ ] Update ALL bin/* `__help()` functions (219 scripts total)
  - Ensure all commands and options are documented
  - Add usage examples for common use cases
  - Real-world examples where helpful
  - Verify help text matches actual functionality
  - Extract from existing implementations where present

### Code Quality
- [ ] **Refactor ALL bin/* scripts to be self-contained (219 scripts total)**
  - **CRITICAL**: Remove external function library dependencies
  - **Replace function library block with inline functions:**
    ```bash
    # OLD (remove this):
    if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
      . "$PWD/$SCRIPTSFUNCTFILE"
    elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
      . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
    else
      echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
      exit 1
    fi

    # NEW (replace with):
    # Inline required functions (__printf_blue, __printf_red, etc.)
    ```
  - **Function naming strategy:**
    - All functions MUST be prefixed with `__`
    - Tip: Use `_____function_name` in source, then delete first `___` → `__function_name`
    - Examples: `__printf_blue`, `__cmd_exists`, `__gen_config`
  - **Variable naming rules (modernize during refactor):**
    - Global variables: **Use SCREAMING_SNAKE_CASE** (uppercase with underscores)
      - Format: `{SCRIPTNAME}_VARIABLE_NAME`
      - Script name with `-` → replace with `_` (e.g., `check-for-updates` → `CHECK_FOR_UPDATES_`, `clean-system` → `CLEAN_SYSTEM_`)
      - Examples: `SETUPMGR_CONFIG_DIR`, `GITADMIN_CWD`, `CHECK_FOR_UPDATES_INTERVAL_HOURS`, `CLEAN_SYSTEM_DEFAULT_DAYS`
      - Standard variables (PATH, HOME, USER): Can be prefixed for script scope when needed (use best judgment)
        - Scoped: `SETUPMGR_USER_HOME`, `GITADMIN_PATH`, `DOCKERMGR_USER`
        - System: `HOME`, `USER`, `PATH`
    - Local variables: **Use snake_case** (lowercase with underscores)
      - Examples: `local exit_code`, `local config_file`, `local download_url`, `local error_msg`, `local user_name`
      - Apply consistently across ALL scripts during refactor
      - Modern bash convention for better readability
  - Remove CASJAYSDEVDIR, SCRIPTSFUNCTDIR, SCRIPTSFUNCTFILE variables
  - Remove *_install && __options "$@" pattern
  - Scripts should be fully functional without external dependencies
  - Follow gitadmin/gitcommit pattern (already self-contained)
  - Each script must be standalone and portable
- [ ] Fix remaining shellcheck warnings across all scripts
  - Run: `shellcheck bin/*`
  - Address SC* warnings systematically
- [ ] Replace remaining `&&`/`||` chains with if/else statements
  - Improves readability and error handling
  - Already improved in many scripts
- [ ] Standardize all function naming with `__` prefix
  - Internal functions must have `__` prefix
  - Verify consistency across all scripts
- [ ] Standardize all variables with `{SCRIPTNAME}_` prefix
  - Except standard variables (USER, HOME, PATH, etc.)
  - Document exceptions in CLAUDE.md
- [ ] Add proper error handling throughout
  - Validate inputs before use
  - Check command existence before execution
  - Proper exit codes on failures

### Testing
- [ ] Test all major script functions
  - Create test cases for critical functions
  - Verify error handling works
- [ ] Validate command-line argument handling
  - Test all option combinations
  - Verify help text accuracy
- [ ] Check cross-platform compatibility
  - Test on different Linux distributions
  - Verify architecture support (amd64, arm64, arm)
- [ ] Verify dependency requirements
  - Document required vs optional dependencies
  - Add dependency checks to scripts

### Security
- [ ] Review `curl | sh` patterns in scripts (not docs)
  - Scripts should avoid `curl | sh`
  - Install scripts can use it in documentation
- [ ] Audit sudo usage patterns
  - Verify proper `sudo tee` instead of redirects
  - Check `__sudoif` usage
- [ ] Validate input sanitization
  - Check user input is validated
  - Prevent command injection
- [ ] Review credential handling
  - Ensure tokens/passwords stored securely
  - No credentials in logs

### Features & Enhancements
- [ ] Improve error messages throughout
  - Clear, actionable error messages
  - Include context and solutions
- [ ] Enhance logging capabilities
  - Consistent logging patterns
  - Log levels (info, warn, error)
- [ ] Add configuration validation
  - Validate config files on load
  - Provide helpful error messages
- [ ] Improve user experience
  - Better progress indicators
  - Clear success/failure messages

### Performance
- [ ] Optimize slow operations
  - Profile scripts to find bottlenecks
  - Cache expensive operations
- [ ] Reduce startup times
  - Lazy load functions where possible
  - Minimize external command calls

### Maintenance
- [ ] Update version numbers as changes are made
  - Format: YYYYMMDDHHMM-git
  - Update both header and VERSION variable
- [ ] Clean up obsolete code
  - Remove dead code
  - Remove commented-out sections
- [ ] Remove deprecated functions
  - Identify and remove unused functions
  - Update callers to new patterns
- [ ] Update copyright headers
  - Verify year is current
  - Ensure consistent format

## Completed ✅

### November 30, 2024
- [x] **Delete directory enhancement** (gitadmin)
  - Added `--dir` flag to delete command
  - Deletes both repo and directory when `--dir` specified
  - Safety checks prevent deletion of $HOME, /, /root, /home
  - Version: 202511301007-git

- [x] **Systemd services verification** (setupmgr)
  - Verified localai.service enabled by default ✓
  - Verified ollama.service enabled by default ✓
  - Verified caddy.service created but NOT enabled ✓
  - Verified minio.service created but NOT enabled ✓
  - Verified garage.service created but NOT enabled ✓
  - Verified traefik.service created but NOT enabled ✓
  - Verified webhookd.service created but NOT enabled ✓
  - Verified gohttpserver.service created but NOT enabled ✓
  - All services properly embedded in setupmgr script

- [x] **Smart push auto-resolution** (gitadmin, gitcommit)
  - Added `__git_auto_push()` function
  - Auto-set upstream for new branches
  - Pull-before-push with auto-resolution
  - Authentication, protected branch, hooks, large files detection
  - Version: 202511300947-git

- [x] **Force update stash conflict fixes** (gitadmin, gitcommit)
  - Fixed stash restore after force update
  - Drop stash before reset --hard
  - Version: 202511300942-git

- [x] **Fork-aware remote detection** (gitadmin, gitcommit)
  - Prioritize push URL over fetch URL
  - Self-contained `__git_remote_origin()` function
  - Version: 202511300955-git

- [x] **Fixed all shellcheck warnings** (gitadmin, gitcommit)
  - SC1083: Quoted '@{u}' syntax in git rev-parse commands
  - SC2221/SC2222: Removed duplicate merge) case in gitadmin
  - SC2059: Fixed printf format string in gitcommit
  - All scripts now pass shellcheck with no warnings
  - Version: 202511301021-git

## Notes

### Development Workflow
1. **Before Starting**: Review TODO, check dependencies, plan approach
2. **During Work**: Update progress, test incrementally, document in AI.md
3. **After Completion**: Mark complete, update version, create commit message

### Priorities
- **High**: Documentation, Code Quality, Testing, Security
- **Medium**: Features, Performance
- **Low**: Maintenance (ongoing)

### Format Notes
- Use `- [ ]` for pending tasks
- Use `- [x]` for completed tasks
- Include version numbers and dates for completed items
- Add sub-bullets for details and context
