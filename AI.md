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

**Last Updated:** 2025-01-24
**Status:** ✅ In Sync
**Next Update:** After next AI session

