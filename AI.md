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

**Read-only — always allowed:**
- `git status`, `git diff`, `git log`, `git show`, `git branch`, etc.
- `gitcommit status`, `gitcommit log`, `gitcommit log show`, `gitcommit diff`, etc.

**`gitcommit {command}` to commit — allowed after confirming `.git/COMMIT_MESS`:**
- The AI may run `gitcommit all` (or another file-selection sub) **after** writing `.git/COMMIT_MESS` and verifying it accurately reflects the staged changes (no missing files, no stale content from a previous task)
- The message file is **canonical** — never pass an inline `{message}` argument; let `gitcommit` read from the file
- A successful `gitcommit` **also pushes** (no separate review step) — so the diff and message must be right *before* invocation
- See `gitcommit --help` for the full sub list. Typical choices:
  - File-selection: `all` (one combined commit), `modified` (one commit per file), `added`, `deleted`, `renamed`, `changed`
  - Semantic types: `new`, `improved`, `fixes`, `bugs`, `docs`, `refactor`, `performance`, `breaking`

**Off-limits subcommands** (each with the reason):
- `ai` — generates a message via AI; redundant since the AI just wrote one in the message file
- `random` — random message; bypasses the canonical file
- `custom` — prompts for an inline message; bypasses the canonical file

**Never run `git commit` directly** — use `gitcommit {command}` so signing and message-file integration are honored.

**Pick the command carefully:**
- `gitcommit all` — single combined commit using the message file. Use when you have one logical changeset.
- `gitcommit modified` — **per-file** commits with auto-generated titles, ignores `.git/COMMIT_MESS`. Don't use when you wrote a unified message.
- The subcommand picks the file subset; the message file must describe exactly that subset. If you wrote a single message but the working tree has unrelated changes, stash or split before committing.

**Commit frequently** — run `gitcommit {cmd}` as soon as a logical unit of work (a fix, a refactor, a feature) is complete and verified. Don't batch unrelated tasks into one commit; small focused commits are preferred.

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

## 📦 apimgr — Multi-Provider API Client (SPEC)

`bin/apimgr` is a single-binary REST client across 18 git forges and container/artifact registries. Think of it as `gh` but for everything. This SPEC is **the contract** — implementation details may move, but these rules don't change without explicit user approval.

### Mission

Provide a uniform `apimgr <provider> <action> [sub] [flags]` surface across:
- Git forges (where the conceptual model is repo / issue / pr / release / tag)
- Container & artifact registries (where the conceptual model is repo / tag)

When the provider is omitted (`apimgr <action> ...`), auto-detect from the cwd's `git remote get-url origin`, falling back to `APIMGR_DEFAULT_PROVIDER`.

### Architecture Principles

1. **No hardcoded endpoints.** URLs come from the user's environment. The script knows the *shape* of each provider's API; the user supplies the *where*.
2. **Functions for every reusable bit.** Auth, formatting, pagination, URL building — each in a named helper. No copy-paste.
3. **No UUOC, minimize forks.** Every external command call has to justify itself; bash builtins win when the result is the same. (See "Bash Performance" section above for the full rule list.)
4. **Single curl wrapper.** Every API call goes through a thin `__<provider>_curl` that composes the right auth header and delegates to the shared `__apimgr_curl` for timeouts/retries:
   ```
   __apimgr_curl() { curl -q -LSsf --max-time "${APIMGR_API_TIMEOUT:-10}" --retry "${APIMGR_API_RETRY:-1}" "$@"; }
   ```
5. **Anonymous-first.** Public reads work without a token; auth is unlocked behavior, not the gatekeeper.
6. **Pagination is invisible.** A user-facing `list` returns *all* matching records (capped by `--limit`). The script loops `?page=N` (or cursor / Link-header) internally.

### Resolver Chains (env-var-only mapping)

**URL** — default mode:
```
APIMGR_<P>_URL  →  <P>_API_URL
```

**URL** — with `--official`:
```
APIMGR_<P>_OFFICIAL_URL  →  <P>_OFFICIAL_API_URL  →  default-mode chain
```

If only `<P>_API_URL` is set, both modes use it. Add `<P>_OFFICIAL_API_URL` only when self-host and public differ.

**Token** — base chain:
```
--token  →  APIMGR_<P>_TOKEN  →  <P>_ACCESS_TOKEN  →  <P>_TOKEN
```

**Token** — provider-specific aliases (matches established community env-var conventions, so a fresh user with a normal shell rc Just Works):

| Provider | Extra token env vars (in priority order) |
|---|---|
| github | `GITHUB_TOKEN`, `GH_TOKEN`, `GITHUB_PAT` |
| gitlab | `GITLAB_TOKEN`, `CI_JOB_TOKEN` |
| gitea | `GITEA_TOKEN` |
| docker | `DOCKER_HUB_API_KEY`, `DOCKER_PASSWORD` |
| bitbucket | `BITBUCKET_APP_PASSWORD` |
| cloudsmith | `CLOUDSMITH_API_KEY` |
| artifactory | `JFROG_ACCESS_TOKEN`, `JFROG_TOKEN` |
| nexus | (Basic auth — needs `NEXUS_USERNAME` too) |

**Username** — for self-listing fallbacks and Basic auth:
```
APIMGR_<P>_USERNAME  →  <P>_USERNAME
```

### Auth Model — Anonymous First, Token Unlocks

Three states for any API call:

| State | URL set? | Token set? | Behavior |
|---|---|---|---|
| **Configured** | yes | yes | Full access — private + public, mutations OK, higher rate limits |
| **Anonymous** | yes | no | Public reads work; mutations error with friendly token-setup hint |
| **Unconfigured** | no | — | Hard fail with explicit "set `<P>_API_URL` or `APIMGR_<P>_URL`" message |

`__apimgr_require_url` (mandatory always) and `__apimgr_provider_token` (optional, returns empty if unset) replace the old `__apimgr_require_creds`. Per-provider curl wrappers conditionally include the auth header:
```
__github_curl() {
  local token auth=()
  token="$(__apimgr_provider_token github 2>/dev/null)"
  [ -n "$token" ] && auth=(-H "Authorization: Bearer $token")
  __apimgr_curl "${auth[@]}" -H "Accept: application/vnd.github+json" "$@"
}
```

**Mutations always require a token.** `repo create`, `repo delete`, `issue create`, `pr merge`, `tag delete`, etc. call a new `__apimgr_require_token <provider>` helper that fast-fails with the missing-token UX (see below) before any socket opens.

**Token-set behavior** — when the token resolves, listings show **everything the token can see**: private repos in `repo list`, draft issues, member-only orgs, etc. No flag needed; auth carries the access.

### Missing-Token UX

When a token is required but not set, the error message must:
1. Name the missing env var (the canonical one + standard alias)
2. Provide the **token-generation URL** for that provider
3. Tell the user where to put the token (env var or `settings.conf`)

Token-generation URLs (the script must include the right one for each provider — keep this table updated when providers change their settings UI):

| Provider | URL to generate token |
|---|---|
| github | `https://github.com/settings/personal-access-tokens` (fine-grained) or `/settings/tokens` (classic) |
| gitlab | `https://gitlab.com/-/user_settings/personal_access_tokens` (or `<host>/-/user_settings/...` for self-host) |
| gitea / forgejo | `<host>/user/settings/applications` |
| codeberg | `https://codeberg.org/user/settings/applications` |
| gitee | `https://gitee.com/profile/personal_access_tokens` |
| pagure | `<host>/settings#nav-api-tab` |
| sourcehut | `https://meta.sr.ht/oauth2/personal-token` (or `<meta-host>/oauth2/personal-token`) |
| onedev | `<host>/~administration/access-tokens` |
| bitbucket | `https://bitbucket.org/account/settings/app-passwords/` |
| docker | `https://hub.docker.com/settings/security` |
| ghcr | `https://github.com/settings/tokens` (needs `read:packages` / `write:packages` / `delete:packages` scopes) |
| glcr | `https://gitlab.com/-/user_settings/personal_access_tokens` (needs `read_registry` / `write_registry` scopes) |
| harbor | `<host>/account` |
| quay | `https://quay.io/user/<user>?tab=settings` |
| cloudsmith | `https://cloudsmith.io/user/settings/api/` |
| artifactory | `<host>/ui/admin/security/access-tokens` (admin) or User Profile (self) |
| nexus | `<host>/#user/usertoken` |

Friendly error template:
```
github: 'repo create' requires a token (mutations always need auth).
  → Generate one at: https://github.com/settings/personal-access-tokens
  → Set GITHUB_ACCESS_TOKEN, APIMGR_GITHUB_TOKEN, or GITHUB_TOKEN in your shell rc
  → Or add APIMGR_GITHUB_TOKEN="..." to ~/.config/myscripts/apimgr/settings.conf
  → Or pass --token <X> for one invocation
```

### Pagination — Internal Loop, Single User-Facing Call

The user-facing API never exposes page numbers. `list` returns **everything** that matches, capped by `--limit N` (default 30 per `APIMGR_DEFAULT_LIMIT`).

Implementation pattern (per-provider helper since pagination dialects differ):
```
# github / gitea / gitlab (page+per_page style):
__<p>_paginated_get() {
  local path="$1" per_page=100 page=1 collected="[]"
  while :; do
    local sep="?"; [[ "$path" == *"?"* ]] && sep="&"
    local resp; resp="$(__<p>_api GET "${path}${sep}per_page=${per_page}&page=${page}")" || return 1
    local count; count="$(__apimgr_jq 'length' <<<"$resp")"
    [ "${count:-0}" -gt 0 ] || break
    collected="$(__apimgr_jq -s 'add' <<<"$collected $resp")"
    [ "$count" -lt "$per_page" ] && break
    page=$((page + 1))
    # Honor --limit as a global cap to avoid unbounded loops on huge repos.
    [ "$(__apimgr_jq 'length' <<<"$collected")" -ge "${APIMGR_LIMIT:-${APIMGR_DEFAULT_LIMIT:-30}}" ] && break
  done
  __apimgr_jq --argjson n "${APIMGR_LIMIT:-${APIMGR_DEFAULT_LIMIT:-30}}" '.[0:$n]' <<<"$collected"
}
```

Pagination dialects per provider (use the right helper per family):
- **page + per_page**: github, gitea/forgejo/codeberg, gitee, gitlab, glcr
- **pagelen + page**: bitbucket
- **page_size + page**: cloudsmith, harbor, docker (Hub returns `next` URL)
- **count + offset**: onedev
- **next URL in response**: docker Hub, sourcehut (RFC 5988 Link header on git.sr.ht)
- **flat (no pagination needed)**: artifactory `/repositories`, nexus `/repositories`, pagure `/projects` (uses `?per_page` natively)

`--limit N` is a hard cap on the total returned count, not a per-page setting. The internal `per_page` is set as high as the provider allows (typically 100) to minimize API calls.

### Provider Matrix (18)

**Forges** — git-style surface (verify/user/org/repo/issue/pr/release/tag/api):

| Provider | Aliases | Auth | URL pattern | Notes |
|---|---|---|---|---|
| github | — | Bearer | `api.github.com` or Enterprise | reference impl |
| gitlab | — | PRIVATE-TOKEN | `gitlab.com/api/v4` or self-host | URL-encoded paths |
| gitea | — | `Authorization: token X` | self-host `/api/v1` | base for forgejo/codeberg |
| forgejo | — | (gitea code path) | self-host | |
| codeberg | — | (gitea code path) | `codeberg.org/api/v1` | |
| gitee | — | `Authorization: token X` | `gitee.com/api/v5` | github-shaped, create-issue quirk |
| pagure | — | `Authorization: token X` | `pagure.io/api/0` | form-encoded creates, capitalized states |
| sourcehut | sr.ht, srht | Bearer | `meta.sr.ht/api` | multi-service (meta/git/todo/lists) |
| onedev | — | Bearer | self-host `/~api` | numeric project IDs, name→id resolver |
| bitbucket | — | Bearer | `api.bitbucket.org/2.0` | no release API; pr close = decline |

**Registries** — registry-style surface (verify/user/org/repo/tag/api):

| Provider | Aliases | Auth | URL pattern | Notes |
|---|---|---|---|---|
| docker | — | JWT login | `hub.docker.com/v2` | login flow → JWT cached per invocation |
| ghcr | — | Bearer | `api.github.com` | rides on github's API; `/packages/container/*` |
| glcr | — | PRIVATE-TOKEN | (gitlab API URL) | rides on gitlab; falls back to GITLAB_* creds |
| harbor | — | Basic / Bearer | self-host `/api/v2.0` | project + repo_name model, slash encoding |
| quay | — | Bearer | `quay.io/api/v1` | namespace + repo |
| cloudsmith | — | `X-Api-Key` | `api.cloudsmith.io/v1` | multi-format SaaS, slug_perm tags |
| artifactory | jfrog | Bearer | self-host `/artifactory/api` | flat repo keys, dual /api+root paths |
| nexus | sonatype | Basic / Bearer | self-host `/service/rest/v1` | components = tags, flat repo names |

### Action Surface

**Common (all providers where applicable):**
- `verify` — confirm the token works (or, when anon-only, confirm the URL is reachable)
- `user [get]` — current user (or `--user NAME` for another)
- `org [get|all]` — org info / list every repo in the org
- `repo [list|get|create|delete|all]` — primary CRUD
- `api PATH` — raw GET against an arbitrary path (escape hatch)

**Forge-only:**
- `issue [list|get N|create|close N|comment N]` — `--state open|closed|all`, `--title`, `--body`
- `pr [list|get N|create|merge N|close N]` — `--branch SOURCE`, `--base TARGET`, `--title`, `--body`. Aliases: `pull`, `pulls`, `mr`
- `release [list|get TAG|create|delete TAG]` — `--tag NAME`, `--title`, `--body`, `--branch` (target ref)
- `tag [list|get TAG|create|delete TAG]` — git tags. `--tag NAME`, `--branch SHA-or-branch`, `--body`

**Registry-only:**
- `tag [list|get TAG|delete TAG]` — image tags. `--repo NAMESPACE/NAME`, `--tag NAME`. (No `create` — tags are made on `docker push`.)

When an action doesn't apply to a provider (e.g. `release` on bitbucket, `issue` on docker), the dispatcher prints a friendly platform-explanation message rather than a generic "not implemented" — see existing per-provider examples in the script.

### Auto-Detect from `git remote`

`__apimgr_detect_provider_from_git` parses `git remote get-url origin` and matches the host:

```
github.com   → github     pagure.io   → pagure
gitlab.com   → gitlab     sr.ht       → sourcehut
codeberg.org → codeberg   sourcehut.* → sourcehut
bitbucket.org→ bitbucket  *gitea*     → gitea
gitee.com    → gitee      *forgejo*   → forgejo
```

Self-host hostnames map via `APIMGR_GIT_HOST_<host>_PROVIDER` (dots → underscores), e.g. `APIMGR_GIT_HOST_git_corp_example_PROVIDER=gitea`.

### Adding a New Provider

To add provider `foo`:

1. Add `__foo_curl` (auth header composition), `__foo_api` (method/path/data), provider-specific formatters as needed.
2. Add action functions: `__foo_verify`, `__foo_user_get`, `__foo_repo_list`, etc.
3. Add `foo` to `ARRAY=` and `LONGOPTS` if it adds any new flags.
4. Add `foo` to the top-level `case "$1"` (so the dispatcher recognizes it).
5. Add a `foo)` branch to `__apimgr_dispatch_provider`.
6. Add a line to the `__help` providers list with the env var names.
7. If the provider has a recognizable host pattern, extend `__apimgr_detect_provider_from_git`.
8. Add the provider to the resolver chain documentation in this SPEC, including its token-generation URL.
9. Update `man/apimgr.1` and `completions/_apimgr_completions.bash` to match.
10. Bump version in all three files (`bin`, `man`, `completion`).

Use `__github_*` (full surface) and `__docker_*` (registry-only with auth flow) as templates.

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

**Last Updated:** 2026-05-04
**Status:** ✅ In Sync (updated git/commit policy + added apimgr SPEC)
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

---

## Session 2026-04-24: Completion extensions + setupmgr AI installer fixes

### Tasks Completed
1. Renamed all 242 files in `completions/` to add `.bash` extension. Confirmed
   every file was bash (all had `#!/usr/bin/env bash`); no zsh/fish files
   existed anywhere in the repo. `git mv` used to preserve history.
2. Updated references across the tree:
   - `install.sh:223` — glob now `*.bash`, output file `_my_scripts_completions.bash`,
     and `rm -f` of stale pre-`.bash` file added before writing the new one so
     upgrades don't leave duplicates.
   - `README.md:40` — one-liner mirrors the install.sh change.
   - `bin/gen-script` — 5 refs updated so future `gen-script completions` creates
     `.bash` files and the duplicate-check looks for `.bash`.
   - `man/gen-script.1` — 2 example refs updated.
   - `CLAUDE.md` — naming-convention section now documents `.bash`/`.zsh`/`.fish`.
3. `bin/setupmgr` fixes:
   - **copilot** switched from npm (`@github/copilot` — now unmaintained) to a
     native binary installer `__setup_copilot`, modeled on `__setup_claude`.
     Downloads `copilot-${platform}.tar.gz` from github/copilot-cli releases,
     verifies SHA256 against `SHA256SUMS.txt`, installs to `/usr/local/bin`
     (root) or `~/.local/bin` (user). Reference: `gh.io/copilot-install`.
   - **claude** output aligned with the rest of setupmgr: dropped
     `(native binary)` and `to latest version` suffixes; every failure path
     now calls `__message_installed_failed "$name"` in addition to the
     diagnostic `printf_red`.
   - **ollama** install was failing with `rm: refusing to remove '.' or '..'`.
     Four fixes layered:
     1. Ollama's release asset format changed from `.tgz` to `.tar.zst`; the
        grep pattern was looking for the old name, so `download_url` came back
        empty. Now prefers `.tar.zst`, falls back to `.tgz`.
     2. Added `.tar.zst` extraction to `__extract` via a new
        `_tar_zst_extract` helper (prefers `tar --zstd`, falls back to
        `zstd -dc | tar -xf -`).
     3. Fixed the aarch64 branch's `__curl ""$release_url` quoting typo that
        ran curl with an empty URL arg.
     4. **Root cause of the rm error**: `__basename ""` returned `.` due to
        the `${1:-.}` default, so `SETUPMGR_TEMP_EXTRACT_FILE=$dir/.`, and the
        EXIT trap tried `rm -rf $dir/.`. Fixed `__basename` to return empty
        on empty input, and reordered every `__download_*` wrapper
        (`__download_extract_install`, `__download_extract_all`,
        `__download_extract_move`, `__download_and_execute`, `__download_and_move`)
        to validate url/name *before* assigning the global temp-file vars.
   - **openclaw** added (npm package `openclaw`, steipete's personal AI
     assistant CLI). Wasn't previously present under any name. Wired into
     dispatcher, help listing, `ARRAY`, completion ARRAY, and man page.
4. Version sync: `bin/setupmgr`, `man/setupmgr.1`, and
   `completions/_setupmgr_completions.bash` all bumped to `202604240910-git`.
5. Man page got a new "AI and Coding Assistants" section listing claude,
   codex, copilot, cortex, gemini, openclaw.

### Key Discoveries
- **Ollama's release layout change**: `.tgz` → `.tar.zst` is a quiet breaking
  change for any installer that hardcoded `linux-amd64.tgz$`. Their official
  install.sh handles both with a HEAD-check fallback; we mirrored that logic.
- **`__basename` fallback footgun**: `basename -- "${1:-.}"` returning `.`
  for empty input looks harmless in isolation, but the returned value flows
  into global `SETUPMGR_TEMP_EXTRACT_FILE` paths that an EXIT trap later tries
  to rm. Silent url-lookup failures (like the ollama asset regex miss) became
  visible only via this downstream rm error.
- **Every `__download_*` wrapper had the same bug shape**: assigned
  `SETUPMGR_TEMP_*_FILE=$dir/$name` *before* validating url was non-empty.
  Fixed the whole family, not just the one ollama hit.
- **GitHub's `gh.io/copilot-install` redirects to the official install.sh**
  (raw.githubusercontent.com/github/copilot-cli/…/install.sh). Fetched and
  read it rather than piping to bash, per the user's standing rule against
  `curl | sh`.

### Rule Compliance Gaps (fixed in-session after user prompted)
- AI.md not updated continuously — now caught up with this entry.
- AI.TODO.md never created — the harness's TaskCreate/TaskUpdate was used
  instead. Noted as a tool-vs-file convention divergence.
- Commit short line started with lowercase proper noun (`setupmgr:`) —
  recapitalized to `Setupmgr:`.
- Man page content wasn't expanded for the new/changed installers —
  added the "AI and Coding Assistants" section.

### Files Modified
- 242 files in `completions/` renamed to `.bash` via `git mv`
- `install.sh`, `README.md`, `CLAUDE.md`, `bin/gen-script`, `man/gen-script.1`
- `bin/setupmgr` (major — __setup_copilot added, claude/ollama reworked,
  __basename guard, 5 __download_* wrappers hardened, _tar_zst_extract added)
- `man/setupmgr.1` (.TH bump + new AI/Coding Assistants section)
- `completions/_setupmgr_completions.bash` (version bump + openclaw in ARRAY)
- `.git/COMMIT_MESS`
- `AI.md` (this entry)

---

## Session 2026-04-24 (cont): 13-package test → 5 more bugs found and fixed

User asked to test install/update/remove on 13 packages: claude, copilot,
openclaw, ollama, bat, fd, ripgrep, jless, delta, yq, zoxide, act,
hyperfine. The test exposed five real bugs in setupmgr that were latent
without exercising the full lifecycle.

### Bugs uncovered by the test

1. **ollama .tar.zst extraction failed** — tar's `--zstd` flag is a wrapper
   that calls the external `zstd` binary; it's not built-in. My pre-flight
   check accepted "tar --help mentions --zstd" as sufficient, but on a
   system without the zstd binary the install still fails at extraction
   time. Fix: pre-flight requires the `zstd` binary outright (and prints
   per-distro install hints). `_tar_zst_extract` also requires zstd.

2. **claude failed: "Invalid channel: copilot"** — dispatcher case
   `claude) shift 1; __setup_claude "$@"` passed all remaining argv to
   `__setup_claude`, which uses `${1:-stable}` as the install channel.
   So `setupmgr claude copilot openclaw` made claude try `claude install copilot`.
   Fix: dispatcher calls `__setup_claude` / `__setup_copilot` with no args.

3. **Output format inconsistency** — three different "Installing/Updating"
   formats coexisted: plain (`Installing X`), archive (`Installing X
   (latest release)`), npm (`Installing X (latest version)`). The user
   originally complained claude "didn't match rest of scripts"; my first
   fix aligned it to the *minority* plain format. After running 13 tools
   through, the archive format was clearly the majority. User confirmed
   "archive style". Updated claude / copilot / ollama to match. Left
   `__execute_npm` on "(latest version)" — semantically correct for npm.

4. **`setupmgr remove ripgrep` says "not found"** — the package name is
   `ripgrep` but the installed binary is `rg`. `__is_package_installed`
   was checking for a binary named after the package. Fix: added a
   name→binary map (ripgrep→rg, llama-cpp→llama).

5. **`setupmgr remove claude` / `ollama` / `openclaw` left state behind** —
   - claude binary lives at `~/.claude/bin/`, not `/usr/local/bin/`
   - ollama: only the `/usr/local/bin/ollama` symlink was removed; the
     `/usr/local/share/ollama` directory (5 GB!) and the systemd unit
     stayed.
   - openclaw is an npm global package, the default rm path doesn't know
     about npm.
   Fix: explicit `__remove_package` cases:
   - ripgrep removes `rg` binary
   - claude runs `claude uninstall` then drops `~/.claude/bin/` and the
     `~/.local/bin/claude` launcher
   - ollama stops + disables the systemd service (system + user variants),
     drops the unit file, removes `/usr/local/share/ollama` and the bin
     symlink
   - openclaw + codex + cortex + gemini + vercel + prettier + eslint +
     npm-check-updates + markdownlint route through a new
     `__remove_npm_global` helper that calls `npm uninstall -g`.

### Test results after all fixes

| Phase | Pass | Fail |
|---|---|---|
| Install (13) | 13/13 | 0 (after zstd installed + arg-leak fixed) |
| Update (13)  | 13/13 | 0 (consistent "Updating X to latest release/version") |
| Remove (13)  | 13/13 | 0 (after the 5 cases added) |

### Lessons Learned

- **Test the multi-arg path for dispatchers.** Single-tool invocations of
  `setupmgr claude` would never hit the arg-leak. It only surfaces when
  the user passes more than one tool. Same pattern likely exists in other
  case branches that pass `"$@"` to a single-tool installer — worth a
  global review.
- **`tar --zstd` ≠ "tar can extract zst on its own".** It just exec's
  zstd. Always require the underlying binary, not just the convenience
  flag.
- **`__is_package_installed` and `__remove_package` are two halves of the
  same contract.** When you add a non-standard install path (claude's
  `~/.claude/bin`, ollama's `/usr/local/share/ollama`, an npm global),
  both functions need to know about it. Otherwise install reports success
  but remove silently no-ops.
- **Format consistency questions are easier to answer with data.**
  Asking "what's the standard format" before running the test got
  ambiguous answers; running 13 tools revealed the archive style was
  the de-facto majority and the user agreed once they could see them
  side by side.

### Files Modified (this continuation)

- `bin/setupmgr` — `__is_package_installed` map, `__remove_npm_global`
  helper, 4 new explicit `__remove_package` cases, claude/copilot/ollama
  output format alignment, claude/copilot dispatcher cleanup, ollama zstd
  pre-flight tightened, `_tar_zst_extract` zstd-binary requirement.
- `man/setupmgr.1` — `.TH` version bump.
- `completions/_setupmgr_completions.bash` — version bump.
- `.git/COMMIT_MESS` — full rewrite covering this session.
- `AI.md` — this entry.

### Audit pass — same bug pattern in other tools

After the user asked "any similar issues?", swept setupmgr for the same
two patterns (name→binary mismatch and share-dir leak on remove) across
the rest of the tool list. Found and fixed:

- name→binary mismatches missed in the first pass:
  - `llama-cpp` was mapped to `llama` but the real binary is `llama-cli`
    (and llama.cpp installs several `llama-*` binaries, so the explicit
    remove case loops over the lot).
  - `bottom → btm`
  - `opentofu → tofu`
  - `powershell → pwsh`
  - `minio_server → minio`
- share-dir leak: the default `__remove_package *)` case only cleaned the
  `/usr/local/bin/<name>` symlink, leaving `$SETUPMGR_DEFAULT_SHARE_DIR/<name>`
  intact for zig, helix, lima, pipx, podman-desktop. Extended the default
  to `__sudo rm -rf` the share dir when present (using sudo for `/usr/*`
  or `/opt/*`, plain `__rm` otherwise). go/zed/powershell/ollama keep
  their explicit cases since they have additional state (extra binaries,
  systemd units, custom install dir vars).
- `__is_package_installed` extended to recognize:
  - `zed` install dir (`$ZED_INSTALL_DIR`),
  - `go` install dir (`$GO_INSTALL_DIR`),
  - `powershell` install dir (`$POWERSHELL_INSTALL_DIR`),
  - any tool with `$SETUPMGR_DEFAULT_SHARE_DIR/<name>` present,
  - npm-installed packages via `npm ls -g --depth=0` (catches
    openclaw/codex/cortex/gemini/etc. even when the binary is gone but
    the npm registration remains).

### Lessons (audit pass)

- **A bug pattern rarely lives alone.** Once we found ripgrep→rg, the
  same shape existed for bottom, opentofu, powershell, minio_server.
  Once we found ollama leaving its share dir, the same shape existed for
  zig, helix, lima, pipx, podman-desktop. Worth doing a sweep instead
  of only fixing the reported instance.
- **The default `*)` case is leverage.** Per-tool explicit cases for
  every share-dir tool would balloon the function. Instead, extending
  the default to also clean `$SETUPMGR_DEFAULT_SHARE_DIR/<name>` covers
  the long tail in one place. Per-tool cases are reserved for tools with
  *additional* state: extra binaries, systemd units, custom install dir
  variables.
- **Install detection and removal must agree on the binary name.** When
  the install map says ripgrep→rg, the remove case has to look for `rg`
  too, not the package name. I had this for ripgrep but the matching
  remove case for llama-cpp was missing — caught only by the audit
  sweep, not by testing.

### Files Modified (audit pass)

- `bin/setupmgr` — install map extended, share-dir-presence detection,
  npm `npm ls -g` fallback, 6 new explicit remove cases (bottom,
  opentofu, llama-cpp/llama_cpp, powershell, zed, go), default `*)` case
  extended with share-dir cleanup. Version bumped to 202604241958-git.
- `man/setupmgr.1`, `completions/_setupmgr_completions.bash` — version sync.
- `.git/COMMIT_MESS` — extended with audit-pass notes.
- `AI.md` — this section.

---

## Session 2026-05-01 → 2026-05-04: Cloudflare hardening + apimgr build (v1 → v18)

### Cloudflare hardening (early in session)

Multiple sessions of fixes against `bin/cloudflare`:

- **Auth + DNS bug fixes**: `--record CNAME` parser was wired to HOSTNAME (not DNS_TYPE); FQDN resolver missed wildcards; AAAA path mis-set ADDR_IPv4 from ADDR_IPv6; multi-record delete only deleted one.
- **Stop hangs**: every API curl now goes through `__cf_curl` with `--connect-timeout 5 --max-time 15` (env-tunable). IP-detect helpers `__curl_ip4/6` get `--connect-timeout 2 --max-time 3`. Pre-flight `__cf_require_creds` and `__cf_require_zone` fast-fail with explicit messages naming the env vars.
- **Removed `--silent`**: was wired to a `CLOUDFLARE_SILENT="true"` variable nothing ever consulted. Use `>/dev/null` instead.
- **`__cf_fqdn` short-wildcard fix**: `*.code` was matching `*.*)` glob and passing through unexpanded; now expands to `*.code.tunnels.work`. Reported via pkmgr/centos `min.sh`.
- **IPv6 reconciliation**: `__has_ipv6` skips v6 probes on v4-only hosts; `__cf_purge_records_by_type` removes stale AAAA on update so DNS reflects the host's current network state. Explicit `--record AAAA` on a v4-only host returns rc=0 silently (installer-friendly).

### apimgr build — multi-provider API client (the big one)

User brief: "think gh but for everything." Built `bin/apimgr` from a stub
to a 3000+ line script covering 18 providers. **Pure env-var mapping —
zero hardcoded provider URLs.**

Provider matrix (alphabetical):
- artifactory (jfrog), bitbucket, cloudsmith, codeberg, docker, forgejo,
  gitea, gitee, ghcr, github, gitlab, glcr, harbor, nexus (sonatype),
  onedev, pagure, quay, sourcehut

Action surface — `verify | user | org | repo | issue | pr | release |
tag | api` (per-provider applicability documented in the new SPEC
section in this file).

**Architecture decisions (now codified in the SPEC section above):**

1. **Env-var-only mapping.** No `https://api.github.com` literal in the
   script. Resolver chain: `APIMGR_<P>_URL → <P>_API_URL` for default,
   plus `APIMGR_<P>_OFFICIAL_URL → <P>_OFFICIAL_API_URL` when `--official`
   is passed.
2. **Per-provider auth wrapper.** `__github_curl`, `__gitlab_curl`,
   `__gitea_curl`, `__docker_curl`, etc. — each composes the right auth
   header (Bearer, PRIVATE-TOKEN, JWT, X-Api-Key, Basic). All call
   `__apimgr_curl` underneath which sets timeouts.
3. **`__apimgr_curl` is the single curl source.** `curl -q -LSsf
   --max-time "${APIMGR_API_TIMEOUT:-10}" --retry "${APIMGR_API_RETRY:-1}"
   "$@"`. Per the user's bash-perf rule.
4. **Top-level shortcut + provider dispatch.** `apimgr <provider>
   <action>` is explicit; `apimgr <action>` auto-detects provider via
   `__apimgr_detect_provider_from_git` (parses `git remote get-url
   origin`). Unknown providers and unknown actions both have explicit
   error messages.
5. **Friendly platform-explanation messages** rather than silent
   stubs: `apimgr bitbucket release` → "bitbucket has no release API
   (releases are plain git tags). Use 'apimgr bitbucket tag list'
   instead." Many similar examples for sourcehut, pagure, ghcr, etc.

**Per-provider quirks captured:**

- github: Bearer + `X-GitHub-Api-Version: 2022-11-28`
- gitlab: PRIVATE-TOKEN header (not Bearer); URL-encoded project paths
- gitea/forgejo/codeberg: shared code path, `Authorization: token X`
- gitee: github-shaped paths but issue-create has the repo name in the
  JSON body (not URL); `Authorization: token X`
- pagure: form-encoded creates (not JSON); singular `/issue/{id}` and
  `/pull-request/{id}`; capitalized `Open|Closed|Merged` states; no
  `/repos/` URL prefix
- sourcehut: multi-service architecture (meta/git/todo/lists at
  separate subdomains). `__sourcehut_service_url` swaps the leftmost
  subdomain via pure bash param-expansion. Per-service env vars
  (`SOURCEHUT_GIT_URL`, etc.) override when self-host doesn't follow
  the `<service>.<host>` pattern.
- onedev: numeric project IDs everywhere. Name → id resolved once via
  `__onedev_project_id`, cached in `$APIMGR_ONEDEV_PROJECT_ID`.
- bitbucket: workspaces (= orgs); UPPERCASE PR states; PR close = decline;
  no release API; paginated `{values: []}` wrappers
- docker: JWT login flow — POST `/users/login` with username+token,
  cache JWT in `$APIMGR_DOCKER_JWT`
- ghcr: rides on GitHub API at `/packages/container/*`; tags addressed by
  name but resolved internally to numeric version-id for delete/get
- glcr: rides on GitLab API at `/projects/<id>/registry/repositories/*`;
  falls back to `GITLAB_API_URL` / `GITLAB_ACCESS_TOKEN` when GLCR_*
  vars aren't set
- harbor: Basic auth from username+token (falls back to Bearer);
  project + repo_name model with subgroups URL-encoded
- quay: Bearer; `/repository/...` (singular), `/tag/...` (singular)
- cloudsmith: `X-Api-Key` (not Bearer/Token). New token-resolver
  fallback added for `CLOUDSMITH_API_KEY` (alongside the existing
  `DOCKER_HUB_API_KEY` special case)
- artifactory: Bearer; flat repo keys (no namespace); dual-path
  pattern — generic `/api/...` but docker tags at root `/<repo>/v2/...`
- nexus: Basic auth; uses "components" terminology (= tags for our
  purposes); flat repo names; per-format create endpoint

### Lessons learned (saved to AI memory under feedback_*)

1. **`gitcommit modified` makes per-file commits, ignoring
   `.git/COMMIT_MESS`.** Use `gitcommit all` for one combined commit
   with the prepared message.
2. **Never `bash -x` an auth-header code path.** `set -x` expands
   `Authorization: Bearer $TOKEN` into the trace, leaking credentials.
   Two real leaks happened during this session (Cloudflare + GitHub
   tokens). Both required rotation; saved a strong rule to memory.
3. **GitGuardian flags `--token VALUE` patterns** in committed test
   commands even when the value is fake. The harness records permission
   grants (Bash() entries) literally, including argv. Use
   env-var injection (`APIMGR_TOKEN_OVERRIDE=bogus apimgr ...`)
   instead of `--token bogus123` to keep the value out of argv.

### Pending (not yet implemented — for next session)

The user wants the auth model relaxed:
- **Anonymous-first**: public reads work without a token; mutations
  still require one.
- **Friendly missing-token UX**: name the env var, give the
  token-generation URL, point at `settings.conf`.
- **Standard env-var aliases**: `GITHUB_TOKEN`, `GH_TOKEN`,
  `DOCKER_PASSWORD`, etc. so a fresh user with normal shell rc Just
  Works.
- **Full pagination loop**: `list` returns all matching records (capped
  by `--limit`); script handles pagination internally.

The new SPEC section (added to this AI.md in this commit) is the
contract for that next-session work. Implementation patterns are
sketched out there — the work is mostly mechanical edits to per-provider
curl wrappers and a new shared `__<p>_paginated_get` helper.

### Files Modified
- `bin/cloudflare`, `man/cloudflare.1`,
  `completions/_cloudflare_completions.bash` — version `202605012356-git`
  to `202605020006-git`. Live-tested against tunnels.work zone.
- `bin/apimgr`, `man/apimgr.1`,
  `completions/_apimgr_completions.bash` — built from stub through
  v1 → v18.
- `bin/gitcommit` — fix `local: can only be used in a function` at
  line 4027 in the `ai)` branch (top-level `local` is a hard error
  in stricter shells); also dropped a UUOC `$(cat …)` → `$(<…)`,
  and plugged a temp-file leak on the failure path.
- `AI.md` — git/commit policy refresh, apimgr SPEC section added,
  this session entry.

### Memory entries written

- `feedback_gitcommit_command_choice.md` — `all` vs `modified`
  semantics
- `feedback_test_commands_cli_secret_pattern.md` — GitGuardian
  `--token VALUE` rule
- `feedback_never_bash_x_on_auth_paths.md` — `set -x` exposes tokens



