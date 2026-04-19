# AI Context & History

## 📋 Purpose

This file serves as the **complete AI context and history** for all AI interactions with this project. It contains:

- **Full conversation history** - All AI sessions and their accomplishments
- **AI-specific rules** - Behavior, autonomy, workflow requirements
- **Project context** - Current state, patterns, conventions
- **Lessons learned** - Solutions, workarounds, best practices discovered
- **Future reference** - Historical context for understanding decisions

**Status:** ✅ **ALWAYS KEEP IN SYNC** - Update after every AI session

---

## 🤖 AI Behavior & Autonomy Rules

### Command Execution
- ✅ **Execute autonomously** when instructions are clear
- ✅ **Ask when uncertain** or ambiguous
- ✅ **Never ask permission** for routine tasks (read files, run tests, check status)
- ✅ **Always ask** when unsure or before destructive operations

### Understanding User Intent
- ✅ **Question mark (?)** = User asking a question, NOT giving instructions
- ✅ **No question mark** = User giving instructions, act on them
- ✅ **Multiple tasks** = Create AI.TODO.md immediately (see below)

### What NOT to Ask
- ❌ "Should I read this file?" (just do it)
- ❌ "Can I run this command?" (just run it)
- ❌ "Would you like me to test?" (always test)
- ❌ "Permission to check status?" (always check)

### What TO Ask
- ✅ "This will delete 100 files, confirm?"
- ✅ "Ambiguous requirement, did you mean X or Y?"
- ✅ "This could break production, proceed?"
- ✅ "Multiple approaches possible, which do you prefer?"

---

## 📝 AI.TODO.md Workflow

### When to Create AI.TODO.md

**ALWAYS create when:**
- ✅ More than 2 instructions given at once
- ✅ More than 2 tasks to complete
- ✅ Complex multi-step workflow
- ✅ Multiple files to modify

### Format
```markdown
# AI TODO

## Current Session Tasks

- [ ] Task 1: Description with details
- [ ] Task 2: Description with details
- [ ] Task 3: Description with details

## Completed

- [x] Completed task 1
- [x] Completed task 2
```

### Workflow
1. User gives 3+ tasks → **Create AI.TODO.md immediately**
2. Work on first task
3. **Update AI.TODO.md** (move to Completed section)
4. Work on next task
5. **Update AI.TODO.md**
6. When all done → **Delete AI.TODO.md**
7. **Update AI.md** with session summary
8. **Create COMMIT_MESS** with all changes

### Benefits
- ✅ Keeps AI organized and focused
- ✅ User can see progress at any time
- ✅ Prevents tasks from being forgotten
- ✅ Maintains clear workflow
- ✅ Easy to resume if interrupted
- ✅ Always in sync with actual work

---

## 🔧 Git & Commit Workflow

### AI Access Rules
- ✅ **Full access to read-only git commands**
  - `git status`, `git diff`, `git log`, `git show`, `git branch`, etc.
  - `gitcommit status`, `gitcommit log`, `gitcommit log show`, `gitcommit diff`, etc.
  
- ❌ **NEVER run commit commands**
  - `git commit` - User handles all commits with GPG signing
  - `gitcommit` (no args) - Triggers commit
  - `gitcommit all` - Commits all changes
  - `gitcommit push` - Pushes changes
  - Any command that actually commits changes

### COMMIT_MESS Workflow

**ALWAYS create/update `.git/COMMIT_MESS` after making changes:**

```bash
# Find git root
git_root=$(git rev-parse --show-toplevel)

# File location
${git_root}/.git/COMMIT_MESS
```

**Format:**
```
🔧 Short commit message with emojis (max 72 chars) 🔧

Detailed description of changes with multiple paragraphs if needed.

**Changes:**
- `file1` - Description of changes
- `file2` - Description of changes

**Testing:**
✅ Syntax validated
✅ Functionality tested
✅ Follows project standards
```

**Short Message Rules (CRITICAL):**
- ✅ Maximum 72 characters (including emojis)
- ✅ Format: `🔧 Short summary 🔧`
- ✅ Start with emoji (no text before)
- ✅ End with same emoji (no text after)
- ✅ NO period at end
- ✅ NO "..." truncation
- ✅ Capitalize first word after emoji

**Common Emojis:**
- 🐛 Bug fix
- ✨ New feature
- 📝 Documentation
- 🚀 Release
- ♻️ Refactor
- 🗃️ General changes
- 🔧 Configuration

**User Workflow:**
1. AI makes changes
2. AI creates/updates `.git/COMMIT_MESS`
3. User runs `gitcommit` (or `./bin/gitcommit`)
4. Script parses file, commits with GPG signing
5. Script cleans up `.git/COMMIT_MESS`

---

## 💻 Project-Specific Rules

### Code Standards
- ✅ **Functions**: Prefix with `__` (internal functions)
- ✅ **Variables**: Prefix with `{SCRIPTNAME}_` (uppercase script name)
- ✅ **Comments**: Always above code (NEVER inline at end of line)
- ✅ **Control flow**: Use `if/else` or `if/elif/else` instead of `&&`/`||` chains
- ✅ **Newlines**: Always add newline at end of files (except where not supported)
- ✅ **Headers**: Update script headers when making changes
  - Update `@@Version` to current date-time (YYYYMMDDHHMM-git)
  - Update `@@Changelog` with brief description
  - Update other fields as appropriate

### Bash Performance: No UUOC, Minimize Forks

**Rule: Prefer bash built-ins over forked subprocesses. Never use Useless Use of Cat (UUOC).**

Every `$(...)`, pipe, and external command spawns a subprocess. In scripts
that run frequently or in tight loops, these forks add up. Use bash native
features wherever possible.

**File reading:**
```bash
# BAD
contents="$(cat file)"
cat file | grep pattern
cat file | jq '.key'
cat file | curl --data-urlencode text@-

# GOOD
contents="$(< file)"
grep pattern file
jq '.key' file
curl --data-urlencode text@file
```

**Path manipulation — use parameter expansion, not basename/dirname:**
```bash
# BAD
name="$(basename -- "$path")"
dir="$(dirname -- "$path")"
stem="$(basename "$path" .ext)"

# GOOD
name="${path##*/}"          # basename
dir="${path%/*}"            # dirname
stem="${name%.ext}"         # strip extension
ext="${name##*.}"           # extension only
```

**String matching — use `[[ ]]`, not `echo | grep`:**
```bash
# BAD
if echo "$var" | grep -q "pattern"; then ...
if echo "$line" | grep -q '^#'; then ...

# GOOD
if [[ "$var" == *"pattern"* ]]; then ...
if [[ "$line" == "#"* ]]; then ...
```

**Regex — use `=~` and `BASH_REMATCH`, not `echo | grep -E`:**
```bash
# BAD
protocol="$(echo "$url" | grep -oE '^https?')"

# GOOD
if [[ "$url" =~ ^(https?):// ]]; then
  protocol="${BASH_REMATCH[1]}"
fi
```

**Splitting — use parameter expansion, not `echo | cut`:**
```bash
# BAD
major="$(echo "$version" | cut -d. -f1)"
user="$(echo "$path" | cut -d/ -f1)"

# GOOD
major="${version%%.*}"       # everything before first .
user="${path%%/*}"           # everything before first /
tail="${path#*/}"            # everything after first /
```

**Parsing — use `read`, not `awk`/`cut` when bash suffices:**
```bash
# BAD
load1="$(cat /proc/loadavg | awk '{print $1}')"
load5="$(cat /proc/loadavg | awk '{print $2}')"

# GOOD (single read, zero forks)
read -r load1 load5 load15 _ _ < /proc/loadavg
```

**Stdin — let programs read it directly, don't `cat |` into them:**
```bash
# BAD
cat - | yad --text-info
cat - | sed 's/x/y/'

# GOOD
yad --text-info      # reads stdin by default
sed 's/x/y/'         # reads stdin by default
```

**When forking IS acceptable:**
- Tool genuinely needs a subshell (`$(...)` capturing output that can't be inlined)
- Complex text processing where `awk`/`sed` is clearly the right tool
- External data sources (APIs, databases) — no bash equivalent
- Readability wins over a micro-optimization in a non-hot-path

**Rule of thumb:** if you're writing `echo "$var" |`, `cat file |`, or
`$(basename "$x")`, stop — there's almost always a bash built-in.

### Testing Methodology
- ✅ **Docker-first** (preferred)
  ```bash
  docker build -t local-scripts-test .
  docker run --rm -it local-scripts-test bash -n /path/to/script
  docker run --rm -it local-scripts-test /path/to/script --help
  ```
- ✅ **Local testing** (fallback)
  ```bash
  bash -n bin/scriptname
  shellcheck bin/scriptname
  ./bin/scriptname --help
  ```

### Security
- ❌ No `curl | sh` patterns
- ✅ Proper sudo handling with `sudo tee` instead of redirects
- ✅ Input validation and sanitization
- ✅ Secure credential storage

### Architecture Support
- **amd64** (x86_64)
- **arm64** (aarch64)
- **arm** (armv7l)

---

## 📚 Project Structure

### Script Locations
- **Scripts**: `bin/`
- **Functions**: `functions/`
- **Completions**: `completions/_{scriptname}_completions`
- **Man pages**: `man/{scriptname}.1`
- **Helpers**: `helpers/`
- **Templates**: `templates/`
- **Tests**: `tests/`

### Configuration
- **User configs**: `~/.config/myscripts/scriptname/`
- **System configs**: `/etc/scriptname/`
- **Logs**: `~/.local/log/scriptname/`
- **Temp files**: `~/.local/tmp/claude/{reponame}/`

### Environment Variables
```bash
SCRIPTNAME_CONFIG_DIR   # Configuration directory
SCRIPTNAME_LOG_DIR      # Log directory
SCRIPTNAME_CACHE_DIR    # Cache directory
```

---

## 📖 Session History

### Session 2025-01-24: Git Log Enhancements & AI Workflow

**Objective:** Improve gitcommit and gen-changelog functionality, establish AI workflow rules

**Tasks Completed:**

1. **Enhanced `gitcommit` AI error handling**
   - Added comprehensive error handling for all AI tools
   - Capture and display API errors (rate limits, auth, network)
   - Improved user feedback with helpful error messages
   - Function: `__generate_ai_commit_message()`

2. **Fixed `__git_log` function in gitcommit**
   - Added optional limit parameter: `gitcommit log [N]`
   - Fixed shortcut handling for `gitcommit l [N]`
   - Preserved color output with grep filtering
   - Always exclude "Version bump" commits
   - Enhanced with `--color=always` and `grep --color=always`

3. **Added commit detail viewing**
   - New: `gitcommit log show` - Show most recent commit (excluding version bumps)
   - New: `gitcommit log show <sha>` - Show specific commit
   - Full commit details with diff output
   - Configurable exclusions

4. **Enhanced `gen-changelog` script**
   - New: `gen-changelog --create` - Generate full CHANGELOG.md
   - Function: `__create_new_changelog()`
   - Full commit details with date, author, SHA, body
   - Excludes "Version bump" commits automatically
   - Proper markdown formatting with sections

5. **Synced changes to `gitadmin`**
   - Updated `__git_log` function to match gitcommit
   - Same filtering, color preservation, and limit support

6. **Updated completions and man pages**
   - Updated `_gitcommit_completions` with new commands
   - Updated `_gen-changelog_completions` with --create flag
   - Updated man pages for both scripts

7. **Code quality improvements**
   - Moved all inline comments above code (project standard)
   - Added comment style rule to CLAUDE.md
   - Consistent formatting across all changes

8. **Established AI workflow rules in CLAUDE.md**
   - Added "AI Behavior & Autonomy" section
   - Added "AI TODO Management" workflow
   - Added AI/Claude Access rules for git commands
   - Clarified COMMIT_MESS workflow with git root path
   - Added short commit message format requirements

9. **Created AI.md master context file**
   - Complete AI conversation history
   - All AI-specific rules and workflows
   - Project context and conventions
   - Always kept in sync with project

**Files Modified:**
- `bin/gitcommit` - Error handling, log enhancements, commit viewing
- `bin/gitadmin` - Log function sync with gitcommit
- `bin/gen-changelog` - Added --create flag and full changelog generation
- `completions/_gitcommit_completions` - New commands
- `completions/_gen-changelog_completions` - New --create flag
- `man/gitcommit.1` - Documentation updates
- `man/gen-changelog.1` - Documentation updates
- `CLAUDE.md` - AI workflow rules, autonomy guidelines, TODO management
- `AI.md` - Created master AI context file

**Testing:**
- ✅ Syntax validation: `bash -n` on all modified scripts
- ✅ Functionality: `gitcommit log`, `gitcommit log 10`, `gitcommit log show`
- ✅ gen-changelog: `gen-changelog --create` produces proper CHANGELOG.md
- ✅ Color output preserved with grep filtering
- ✅ Exclusions working correctly
- ✅ Error handling tested with various AI tools

**Lessons Learned:**

1. **grep and color preservation**
   - Use `--color=always` on both git and grep
   - grep preserves ANSI color codes when using `--color=always`
   - Pipe works correctly: `git log --color=always | grep --color=always -v "pattern"`

2. **AI.TODO.md workflow**
   - Essential for managing multiple tasks
   - Should have been created at session start
   - Helps keep AI organized and user informed
   - Example: This session had 8+ tasks, should have used AI.TODO.md

3. **Comment placement**
   - Project standard: Comments ALWAYS above code
   - NEVER inline at end of line
   - Improves readability and consistency

4. **Git root path handling**
   - Use `git rev-parse --show-toplevel` to find git root
   - COMMIT_MESS location: `<git_root>/.git/COMMIT_MESS`
   - Important for submodules and nested repos

5. **AI autonomy expectations**
   - Act autonomously when clear
   - Ask when uncertain
   - Question mark (?) = question, not instruction
   - User expects AI to just do routine tasks

**Patterns Established:**

1. **Error handling for AI tools**
   ```bash
   error_output=$(command 2>&1)
   exit_code=$?
   if [ $exit_code -ne 0 ]; then
     printf_red "Error: $error_output"
     return 1
   fi
   ```

2. **Git log with filtering and color**
   ```bash
   local exclude_pattern="Version bump"
   git log --color=always --oneline --no-decorate ${limit_flag} | \
     grep --color=always -viE "$exclude_pattern"
   ```

3. **Changelog generation**
   ```bash
   git log --format="%H|%ad|%an|%s" --date=format:"%Y-%m-%d" | \
     while IFS='|' read -r sha date author subject; do
       # Format with full details including body
     done
   ```

**Next Session TODO:**
- ✅ AI.md created and synced
- ✅ All rules documented
- ✅ Ready for future development

---

## 🎯 Quick Reference

### AI Checklist for Every Session

**Before Starting:**
- [ ] Read AI.md for full context
- [ ] Check for AI.TODO.md (resume existing tasks)
- [ ] Understand current project state

**During Work:**
- [ ] If >2 tasks → Create AI.TODO.md immediately
- [ ] Update AI.TODO.md after each task
- [ ] Follow code standards (functions: `__`, variables: `SCRIPTNAME_`)
- [ ] Comments above code (never inline)
- [ ] Test changes (Docker-first, then local)

**After Completion:**
- [ ] Delete AI.TODO.md (if all tasks done)
- [ ] Create/update `.git/COMMIT_MESS` with proper format
- [ ] Update AI.md with session summary
- [ ] Verify all files synced and tested

**Common Commands:**
```bash
# Find git root
git rev-parse --show-toplevel

# Test syntax
bash -n bin/scriptname

# Docker test
docker build -t local-scripts-test .
docker run --rm -it local-scripts-test bash -n /path/to/script

# Check status
git status
gitcommit status
gitcommit log 10
gitcommit diff
```

---

## 📌 Important Notes

### File Management
- **AI.md** - This file, always in sync, master context
- **AI.TODO.md** - Temporary task tracker, created when needed, deleted when done
- **CLAUDE.md** - Development notes and project standards (reference)
- **TODO.md** - User's general project TODO (not AI-specific)
- **.git/COMMIT_MESS** - Commit message staging, created by AI, cleaned by gitcommit

### Keep in Sync
This AI.md file should be updated:
- ✅ After every AI session (add to Session History)
- ✅ When new patterns are established
- ✅ When lessons are learned
- ✅ When rules are added or changed
- ✅ When project structure changes

### Context for New Sessions
When starting a new AI session:
1. **Read AI.md first** - Get full context and history
2. **Check AI.TODO.md** - Resume incomplete tasks if exists
3. **Read CLAUDE.md** - Review development standards
4. **Check git status** - Understand current state
5. **Proceed with task** - Follow established patterns

---

## 🚀 Future Development

### Areas for Enhancement
- Enhanced AI error handling patterns
- Additional changelog formatting options
- More git workflow automation
- Extended testing frameworks

### Patterns to Watch
- AI API rate limiting strategies
- Error recovery mechanisms
- User feedback improvements
- Automation opportunities

---

**Last Updated:** 2026-04-19
**Status:** ✅ In Sync
**Next Update:** After next AI session


---

## Session: 2026-01-13 - setupmgr Unified Installation Refactoring

### Tasks Completed
✅ Analyzed setupmgr script (9715 lines) architecture and installation functions
✅ Fixed critical bug in __install_from_binary function
✅ Converted act tool to use unified __install_from_archive function
✅ Converted incus tool to use unified __install_from_binary function
✅ Tested both tools for install and update scenarios

### Key Discoveries

**Bug Fixed: __install_from_binary argument passing**
- Function expected 2 args: `(url, destination)`
- Was being called with 3 args: `(url, name, destination)`
- After `shift 1` in function, `$1` was `name` instead of `destination`
- Fixed by removing `$name` parameter from __download_and_move call
- Changed: `__download_and_move "$download_url" "$name" "$binFile"`
- To: `__download_and_move "$download_url" "$binFile"`

**Pattern Matching Insights**
- Auto-generated patterns from `__build_asset_pattern` work correctly
- Pattern is case-insensitive via `grep -iE`
- Handles OS variations: linux, gnu, darwin, macos, etc.
- Handles arch variations: x86_64, amd64, x64, aarch64, arm64, etc.
- For unusual naming (like incus: bin.linux.incus.x86_64), use custom arch-specific pattern

**Unified Function Architecture**
- `__install_from_binary()` - For direct binary downloads (no extraction)
- `__install_from_archive()` - For archived binaries (tar.gz, zip, etc.)
- Both functions:
  - Auto-detect architecture and OS
  - Build appropriate asset patterns
  - Find latest release from GitHub/GitLab/Gitea/etc.
  - Validate binary architecture before installation
  - Display version after installation
  - Handle system/user installation paths
  
**Tool Conversion Pattern**
```bash
# Old pattern (40+ lines):
__setup_tool() {
  local exitCode=0
  local name="tool"
  local arch="$(uname -m)"
  local binFile="$SETUPMGR_DEFAULT_BIN_DIR/$name"
  local release_url="https://api.github.com/repos/owner/repo/releases/latest"
  # ... manual version fetching
  # ... manual URL construction  
  # ... manual download/extract
  # ... manual error handling
  return $exitCode
}

# New pattern (3 lines for archives, 1 line for binaries):
__setup_tool() {
  __install_from_archive "tool" "owner/repo" "$SETUPMGR_DEFAULT_BIN_DIR"
}

# Or for direct binaries:
__setup_tool() {
  __install_from_binary "tool" "owner/repo" "$SETUPMGR_DEFAULT_BIN_DIR"
}

# Or with custom pattern:
__setup_tool() {
  __install_from_binary "tool" "owner/repo" "$SETUPMGR_DEFAULT_BIN_DIR" "custom-pattern"
}
```

### Patterns Established

**Architecture-Specific Pattern Building**
For tools with non-standard naming (like incus), build arch-specific patterns:
```bash
local arch="$(__get_system_arch)"
local arch_pattern=""
case "$arch" in
  amd64) arch_pattern="x86_64" ;;
  arm64) arch_pattern="aarch64" ;;
esac
__install_from_binary "tool" "owner/repo" "$dir" "pattern\\.${arch_pattern}\$"
```

**Custom Pattern Format**
- Use regex format: `"pattern\\.to\\.match\\.${variable}\\$"`
- Escape dots with double backslash: `\\.`
- Use `\$` for end-of-string anchor
- Pattern will be used with `grep -iE` (case-insensitive extended regex)

### Code Quality Improvements
- Reduced act from 40 lines → 3 lines (93% reduction)
- Reduced incus from 30 lines → 13 lines (57% reduction)
- Eliminated redundant code (version fetching, URL construction, error handling)
- Standardized output messages across all tools
- Consistent architecture validation
- Better error messages with context

### Testing Results
```bash
# act - Fresh install
./bin/setupmgr act
# Output: Installing act (latest release)
#         act installed to /usr/local/bin/act: 0.2.84

# act - Update/reinstall
./bin/setupmgr act
# Output: Updating act to latest release
#         act installed to /usr/local/bin/act: 0.2.84

# incus - Fresh install  
./bin/setupmgr incus
# Output: Updating incus to latest release
#         incus installed: 6.18

# incus - Update/reinstall
./bin/setupmgr incus
# Output: Updating incus to latest release
#         incus installed: 6.18
```

### Remaining Work
- 132 more tool functions to convert to unified system
- Need systematic approach to convert in batches
- Identify which tools need archive vs binary extraction
- Test converted tools for edge cases
- Update documentation

### Files Modified
- `bin/setupmgr` - Fixed __install_from_binary, converted act and incus
- `.git/COMMIT_MESS` - Created commit message
- `AI.TODO.md` - Created task tracker

### Next Session
- Continue batch conversion of remaining tool functions
- Prioritize commonly used tools (ripgrep, shellcheck, shfmt, yq, fd, bat, delta)
- Test each batch after conversion
- Update man pages and completions if needed


## Session 2026-01-14: Comprehensive Testing & Tool Removal

### Testing Phase Completed
- Systematically tested all 95 converted tools
- 89 tools working correctly (93.7%)
- Identified 6 tools with no binaries for removal
- Fixed critical issues: zoxide strip-components, tokei release fallback

### Key Discoveries
1. **Archive Extraction Bug:** Tools with binaries at root level fail with `--strip-components=1`
   - Solution: Added `do_not_strip_components` flag support
   - Fixed: zoxide

2. **Latest Release Empty:** Some projects don't upload binaries to latest release
   - Solution: `__find_release_asset()` now falls back to scanning recent releases
   - Fixed: tokei

3. **Missing Case Entries:** 31 converted tools had no case statement entries
   - Added explicit `tool)` cases for all
   - Added `--debug` warning for unmapped tools

### Tools Requiring Removal (No Binaries Available)
1. broot - Canop/broot
2. btop - aristocratos/btop  
3. mc - minio/mc
4. ncdu - rofl0r/ncdu
5. httpie - httpie/cli (Python package)
6. trivy - aquasecurity/trivy

### Tools Requiring Investigation
- mise - installation fails
- skaffold - installation fails
- tilt - installation fails

### Work Lost in Git Checkout
- All case statement entries (need to re-add)
- Debug warning in wildcard case (need to re-add)
- This is expected, continuing...

### Next Actions
1. Re-apply case entries for all 31 tools
2. Re-add debug warning
3. Remove 6 tools with no binaries
4. Fix mise/skaffold/tilt
5. Final testing
6. Documentation sync


## Session 2026-04-05: Fix dockermgr manifest command (Docker 25+ breakage)

### Problem
`dockermgr manifest` was broken — confirmed from logs in `~/.local/log/dockermgr/`:
- `'docker manifest create' requires at least 2 arguments` (wireguard, almalinux)
- `'docker buildx build' requires 1 argument` (vault)

### Root Causes & Fixes

1. **Wrong platform names** (`x86_64` → `amd64`)
   Docker uses GOARCH names (amd64, arm64) not uname names (x86_64, aarch64).
   This caused all docker builds to fail silently, leaving `$amend` empty.

2. **Empty `$amend` guard** — when builds fail, `docker manifest create $tag` (no images) 
   fails with "requires at least 2 arguments". Added guard to skip with clear error.

3. **`--amend` flag misused** — was `--amend img1 --amend img2` (per-image) instead of 
   `docker manifest create --amend TAG img1 img2` (command-level flag).

4. **`$oci_labels` word-splitting bug** — label values with spaces (e.g. `"Docker image for vault"`) 
   were split when `$oci_labels` string was unquoted in the command, consuming the `-` stdin 
   context arg. Fixed by converting `oci_labels` from a string to a bash array.

5. **BuildKit stdin compatibility** — `docker build ... -` → `docker build ... -f - .`
   Docker 25+ with BuildKit requires explicit `-f -` for stdin Dockerfile; the old `-` 
   alone no longer works as a raw Dockerfile context in BuildKit mode.

### Key Lesson: Bash array for flag accumulation
When accumulating shell flags that may have values with spaces, ALWAYS use an array:
```bash
# WRONG (word-splits on spaces in values):
local flags=""
flags+="--label key=\"value with spaces\" "
docker build $flags -

# CORRECT:
local flags=()
flags+=("--label" "key=value with spaces")
docker build "${flags[@]}" -f - .
```

### Files Modified
- `bin/dockermgr` — Fixed `__create_manifest()`: platforms, oci_labels array, --amend flag, guard, BuildKit stdin


## Session 2026-04-18: UUOC elimination & fork reduction across all 222 scripts

### Objective
Refactor all 222 scripts in `bin/` to remove Useless Use of Cat (UUOC)
anti-patterns and replace forked subprocess calls with bash built-ins.
Add a permanent rule to AI.md so future work follows the same standard.

### Universal Changes (applied across 200+ scripts)
- `APPNAME="$(basename -- "$0" 2>/dev/null)"` → `APPNAME="${0##*/}"` (220 scripts)
- `[ "$(basename -- "$SUDO" 2>/dev/null)" = "sudo" ]` → `[ "${SUDO##*/}" = "sudo" ]` (208 scripts)
- `__is_an_option()` rewritten to use `[[ "$ARRAY" == *"x"* ]]` instead of `echo | grep -q` (210 scripts)

### Script-Specific Fixes (highlights)
- `sysusage` — 3 × `cat /proc/loadavg | awk` collapsed into a single `read -r ... < /proc/loadavg` (zero forks)
- `reqpkgs` — `cat /etc/*release | grep` → `grep /etc/*release` (10 sites)
- `proxmox-cli` — `cat file | jq` → `jq file`; `echo | cut -d. -f1` → `${ver%%.*}`
- `pastebin` — `cat "$file" | curl --data-urlencode text@-` → `curl --data-urlencode text@"$file"`
- `buildx` — nested `basename $(dirname $(realpath))` → pure parameter expansion
- `shortenurl`, `gitignore` — `echo | grep -q` → `[[ == *"x"* ]]`
- `gen-nginx` — `echo | grep -qE` → `[[ =~ regex ]]` with `BASH_REMATCH`
- `calendar` — 6 consecutive `grep` calls fused into single `grep -Ev`
- `dictionary` — 7 × `cat file.out | jq` → `jq ... file.out`
- `notifications` — one-time file read instead of triple `cat`
- `urbandict`, `wikipedia`, `earthquakes`, `duckdns` — dropped `cat -|` before stdin-capable tools

### Verification
- All 222 scripts pass `bash -n` (0 syntax errors)
- `git diff --stat`: 222 files changed, 1091 insertions(+), 1012 deletions(-)
- Single remaining `cat | cmd` pattern in repo is commented-out code

### Rule Added
New **"Bash Performance: No UUOC, Minimize Forks"** section under
Project-Specific Rules → Code Standards. Documents:
- File reading (`$(< file)`, direct file arg)
- Parameter expansion (`${var##*/}` not `basename`)
- Pattern match with `[[ == *"x"* ]]` not `echo | grep`
- Regex with `=~` + `BASH_REMATCH` not `echo | grep -E`
- Split with `${var%%.*}` not `echo | cut`
- Parse with `read` not `cat | awk`
- Let tools read stdin directly (no `cat -|`)

### Lessons Learned
1. **Sed delimiter conflict** — when replacement contains `|`, switch delimiter
   to `X` or `#`: `sed -i 'sXpatternXreplacementXg'`.
2. **`replace_all` risk** — doing `replace_all` of `cat file | jq` → `jq`
   dropped the filename; had to re-add `file` as explicit arg to each `jq`.
   Always preview replace_all on at least one site first.
3. **Verify with diff, not just grep** — confirmed via `grep -c` and final
   scan that only commented-out `cat |` remained.

### Files Modified
- `AI.md` — Added "Bash Performance: No UUOC, Minimize Forks" rule + this session entry
- `bin/*` — 222 scripts refactored
- `.git/COMMIT_MESS` — Commit message staged for user


## Session 2026-04-19: UUOC elimination in templates/ (shebang-aware)

### Objective
Apply the same UUOC/fork-reduction refactor to `templates/` — but only to
files whose shebang indicates bash. Templates drive script generation, so
fixing them prevents the patterns from re-appearing in newly created scripts.

### Shebang Rule (The "Smart" Part)
Parameter expansion (`${var##*/}`), `[[ =~ ]]`, and `[[ == *"x"* ]]` are
**bashisms**. They don't exist in POSIX sh, fish, or zsh. Before touching
any template:
1. Check the file with `file <path>` or `head -1 <path>`
2. Only apply fixes when shebang is `#!/usr/bin/env bash` (or `#!/bin/bash`)
3. Skip sh/fish/zsh templates entirely — they need different (or no) fixes

### Inventory
- 37 bash templates (`#!/usr/bin/env bash`) — eligible
- 15 `.tmpl.sh` heredoc generators — eligible (they produce bash)
- 3 non-bash (`templates/scripts/shell/{sh,fish,zsh}`) — skipped

### Changes Applied (23 template files modified)

**Core bash templates** (`templates/scripts/bash/*`) — these are the source
that `gen-script` copies from to produce the scripts in `bin/`:
- `user`, `system`, `terminal`, `simple`, `mgr-script.user.sh`,
  `mgr-script.system.sh` — universal APPNAME, SUDO basename, `__is_an_option`
  fixes; `echo | awk '{print $1}'` → `${VAR%% *}`

**Installers** (`templates/scripts/installers/*.sh`):
- `dfmgr.sh`, `systemmgr.sh`, `devenvmgr.sh`, `hakmgr.sh`, `desktopmgr.sh` —
  `basename` fixes
- `dockermgr.sh` — many `echo | grep -q` → `[[ == *"x"* ]]` / `[[ =~ ]]`,
  `cat file | grep` → `grep file`, `cat file | tee` → `tee < file`,
  complex pipeline simplifications (TYPE extraction, CONTAINER_HOSTNAME)

**OS bootstrap** (`templates/scripts/os/*.sh`):
- `centos.sh` — 6-branch `echo | grep -qE '^pattern'` chain → `[[ == pat* ]]`
- `arch.sh` — basename fix

**Shared scripts** (`templates/scripts/other/`, `templates/scripts/functions/`,
`templates/scripts/shell/`):
- `other/build`, `other/docker-entrypoint`, `other/start-service`,
  `functions/docker-entrypoint`, `shell/bash` — basename/grep/sed fixes;
  `cat /dev/urandom | tr` → `tr < /dev/urandom`; `$(basename "$x")` →
  `"${x##*/}"` (8 sites in functions/docker-entrypoint)

**gen-script heredoc generators** (`templates/gen-script/`):
- `script/user.tmpl.sh`, `script/system.tmpl.sh`, `header/raw.tmpl.sh` —
  escaped `\$(basename -- "\$0")` → `\${0##*/}`. This ensures every NEW
  script generated via `gen-script` starts with the correct pattern.

### Pre-existing Bug Left Alone
`templates/scripts/installers/dockermgr.sh:1009-1011` has a pre-existing
bug where `DOCKER_HUB_IMAGE_URL` is stripped of its tag first, then field 2
is extracted from the (now tag-less) URL — so `DOCKER_HUB_IMAGE_TAG` is
always empty. Did NOT fix this — behavior preservation was the contract.
Flagged in commit message only so the user can see it on the next pass.

### Dirname Pattern Not Converted
`"$(dirname "$path")"` → `"${path%/*}"` has divergent behavior when the path
has no `/`: `dirname` returns `.`, parameter expansion returns the string
unchanged. Left these 5–6 sites alone — not worth a subtle behavior change.

### Verification
- 37 bash templates: `bash -n` passes (0 failures)
- 15 tmpl.sh generators: `bash -n` passes (they're heredocs, so syntax
  check is partial but confirms no quoting regressions)
- 23 files changed, 86 insertions, 86 deletions

### Lessons Learned
1. **Templates drive generated code** — fixing templates is how you stop a
   pattern from coming back. The 200+ `APPNAME=$(basename...)` in `bin/`
   existed because `gen-script/script/*.tmpl.sh` emitted them. Fixed the
   tmpl.sh files too so future generations start clean.
2. **Shebang is the contract** — checked shebang before every fix. 3 shell
   templates (sh/fish/zsh) untouched. This is a permanent rule: always
   scope bash-only rewrites to files with a bash shebang.
3. **`dirname` has subtle semantics** — don't blindly convert to `${x%/*}`;
   they diverge when the path has no `/`.
4. **Sed delimiter with `/`** — when the replacement text contains `/`
   (like `${0##*/}`), use a different delimiter (`X`, `#`) or escape. The
   `for-file-with-sed` one-liner approach broke on the first `/` in
   `EXEC_CMD_BIN`.

### Files Modified
- `AI.md` — This session entry
- `templates/scripts/bash/*` — 6 core templates
- `templates/scripts/installers/*.sh` — 6 installers
- `templates/scripts/os/{arch,centos}.sh` — 2 OS bootstraps
- `templates/scripts/other/{build,docker-entrypoint,start-service}` — 3 scripts
- `templates/scripts/functions/docker-entrypoint` — shared functions
- `templates/scripts/shell/bash` — shell template
- `templates/gen-script/{script,header}/*.tmpl.sh` — 3 heredoc generators
- `.git/COMMIT_MESS` — Amended with template fixes

