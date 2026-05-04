# PLAN.AI.md — apimgr refactor

**Owner:** AI
**Scope:** `bin/apimgr`, `man/apimgr.1`, `completions/_apimgr_completions.bash`
**Status:** queued — design captured, code not yet started

When this plan is executed and committed, **empty this file** (don't delete it).

---

## Goal

Relax apimgr's auth model so public-API endpoints work without a token, and add full internal pagination so a single `list` returns everything that matches without exposing page numbers to the user.

## Design

### 1. Anonymous-first auth (option 1 from session discussion)

Three states for any API call:

| State | URL set? | Token set? | Behavior |
|---|---|---|---|
| **Configured** | yes | yes | Full access — private + public, mutations OK, higher rate limits |
| **Anonymous** | yes | no | Public reads work; mutations fast-fail with friendly setup hint |
| **Unconfigured** | no | — | Hard fail with explicit "set `<P>_API_URL` or `APIMGR_<P>_URL`" |

Replace `__apimgr_require_creds` (currently demands both URL and token) with two helpers:

- `__apimgr_require_url <provider>` — mandatory always. Returns 0 if URL resolves; calls `__apimgr_die` otherwise with the env-var hint.
- `__apimgr_require_token <provider>` — for mutations only. Calls `__apimgr_die` with the missing-token UX (see §3) when no token resolves.

Per-provider curl wrapper composes the auth header conditionally:

```sh
__github_curl() {
  local token auth=()
  token="$(__apimgr_provider_token github 2>/dev/null)"
  [ -n "$token" ] && auth=(-H "Authorization: Bearer $token")
  __apimgr_curl "${auth[@]}" -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "$@"
}
```

Apply the same pattern to all 18 provider curl wrappers (mostly mechanical — drop the `|| return 1` from the token resolve, build an auth args array conditionally).

**Action-level audit** — which actions require a token (call `__apimgr_require_token`):
- All `*_create` (repo, issue, pr, release, tag)
- All `*_delete` (repo, issue, pr, release, tag)
- `pr merge`, `pr close` (and bitbucket's `decline`)
- `issue close`, `issue comment`
- `verify` (definitionally — "are my creds valid?" is meaningless without creds)
- `user` without `--user` (current authed user — needs auth to know who you are)

Everything else (`*_list`, `*_get`, `org get`, public `user --user X`, `tag list`, raw `api`) drops the require-token check and lets the server return 401 if the resource is private.

### 2. Standard-env-var fallback chains

Extend `__apimgr_provider_token` to fall through to community-standard names so a fresh user with their normal shell rc Just Works:

| Provider | Extra token env vars (priority order, after the existing chain) |
|---|---|
| github | `GITHUB_TOKEN`, `GH_TOKEN`, `GITHUB_PAT` |
| gitlab | `GITLAB_TOKEN`, `CI_JOB_TOKEN` |
| gitea | `GITEA_TOKEN` |
| docker | `DOCKER_HUB_API_KEY` *(already)*, `DOCKER_PASSWORD` |
| bitbucket | `BITBUCKET_APP_PASSWORD` |
| cloudsmith | `CLOUDSMITH_API_KEY` *(already)* |
| artifactory | `JFROG_ACCESS_TOKEN`, `JFROG_TOKEN` |

Same idea for username (where applicable):
- docker → `DOCKER_USERNAME`
- harbor → `HARBOR_USERNAME`
- nexus → `NEXUS_USERNAME`

### 3. Missing-token UX — friendly setup hint

When `__apimgr_require_token` fires, the error must:

1. State which action requires the token
2. Provide the **token-generation URL** for that provider
3. List the env vars that resolve (canonical + standard alias)
4. Mention `~/.config/myscripts/apimgr/settings.conf` and `--token` as alternatives

Token-generation URL table (script must include the right one for each provider — keep updated when providers change their settings UI):

| Provider | URL to generate token |
|---|---|
| github | `https://github.com/settings/personal-access-tokens` (fine-grained) or `/settings/tokens` (classic) |
| gitlab | `https://gitlab.com/-/user_settings/personal_access_tokens` (or `<host>/-/user_settings/...` for self-host) |
| gitea / forgejo | `<host>/user/settings/applications` |
| codeberg | `https://codeberg.org/user/settings/applications` |
| gitee | `https://gitee.com/profile/personal_access_tokens` |
| pagure | `<host>/settings#nav-api-tab` |
| sourcehut | `https://meta.sr.ht/oauth2/personal-token` (or self-host meta service `/oauth2/personal-token`) |
| onedev | `<host>/~administration/access-tokens` |
| bitbucket | `https://bitbucket.org/account/settings/app-passwords/` |
| docker | `https://hub.docker.com/settings/security` |
| ghcr | `https://github.com/settings/tokens` (needs `read:packages` / `write:packages` / `delete:packages`) |
| glcr | `https://gitlab.com/-/user_settings/personal_access_tokens` (needs `read_registry` / `write_registry`) |
| harbor | `<host>/account` |
| quay | `https://quay.io/user/<user>?tab=settings` |
| cloudsmith | `https://cloudsmith.io/user/settings/api/` |
| artifactory | `<host>/ui/admin/security/access-tokens` (admin) or User Profile (self) |
| nexus | `<host>/#user/usertoken` |

**Friendly error template:**

```
github: 'repo create' requires a token (mutations always need auth).
  → Generate one at: https://github.com/settings/personal-access-tokens
  → Set GITHUB_ACCESS_TOKEN, APIMGR_GITHUB_TOKEN, or GITHUB_TOKEN in your shell rc
  → Or add APIMGR_GITHUB_TOKEN="..." to ~/.config/myscripts/apimgr/settings.conf
  → Or pass --token <X> for one invocation
```

Implementation: a `__apimgr_token_help <provider>` helper that returns the URL string; `__apimgr_require_token` formats the four-line error using it.

### 4. Internal pagination loop

User-facing API never exposes page numbers. `list` returns **everything** that matches, capped by `--limit N` (default 30 per `APIMGR_DEFAULT_LIMIT`). The `--limit` is the **total** cap, not per-page. Internal `per_page` (or equivalent) is set as high as the provider allows (typically 100) to minimize API calls.

Pagination dialects per provider (use the right helper per family):

| Dialect | Providers |
|---|---|
| `?per_page=100&page=N` (1-indexed) | github, gitea/forgejo/codeberg, gitee, gitlab, glcr |
| `?pagelen=100&page=N` | bitbucket |
| `?page_size=100&page=N` | cloudsmith, harbor |
| `?count=100&offset=O` | onedev |
| RFC 5988 Link header (`rel="next"`) | sourcehut (git.sr.ht) |
| Server returns `next: URL` in response body | docker hub |
| Flat (no pagination needed) | artifactory `/repositories`, nexus `/repositories`, pagure (uses `?per_page` natively) |

**Reference helper** (page+per_page family — adapt the others):

```sh
__github_paginated_get() {
  local path="$1" per_page=100 page=1 collected="[]"
  while :; do
    local sep="?"; [[ "$path" == *"?"* ]] && sep="&"
    local resp; resp="$(__github_api GET "${path}${sep}per_page=${per_page}&page=${page}")" || return 1
    local count; count="$(__apimgr_jq 'length' <<<"$resp")"
    [ "${count:-0}" -gt 0 ] || break
    collected="$(__apimgr_jq -s 'add' <<<"$collected $resp")"
    [ "$count" -lt "$per_page" ] && break
    page=$((page + 1))
    [ "$(__apimgr_jq 'length' <<<"$collected")" -ge "${APIMGR_LIMIT:-${APIMGR_DEFAULT_LIMIT:-30}}" ] && break
  done
  __apimgr_jq --argjson n "${APIMGR_LIMIT:-${APIMGR_DEFAULT_LIMIT:-30}}" '.[0:$n]' <<<"$collected"
}
```

Wire each `*_list` action to use the right dialect's helper. Single-record `*_get` calls don't paginate.

## Implementation order

1. Add `__apimgr_require_url` and `__apimgr_require_token` helpers; keep `__apimgr_require_creds` as a thin wrapper that calls both (so existing call sites don't break mid-refactor).
2. Add `__apimgr_token_help <provider>` returning the per-provider token-generation URL.
3. Refactor every `__<provider>_curl` to compose the auth header conditionally.
4. Audit every action function and replace `__apimgr_require_creds` with the right helper (URL-only for reads, both for mutations) — keep `verify` as an outlier since it's literally an auth check.
5. Extend `__apimgr_provider_token` with the standard-env-var aliases per provider.
6. Add per-dialect `__<p>_paginated_get` helpers; rewrite `*_list` actions to call them.
7. Update the `__help` section, man page, and completion to mention anon-mode and the new env-var fallbacks.
8. Live-test the most-common paths anonymously: `apimgr github user --user octocat`, `apimgr github repo get --repo octocat/Hello-World`, `apimgr docker repo get --repo library/alpine`, `apimgr gitlab api /projects?per_page=1`. All should work with no token in env.
9. Live-test pagination: `apimgr github repo all --org casjay-dotfiles --limit 200` should make ~2 API calls (per_page=100, looped) and return up to 200 records.
10. Bump versions; commit.

## Testing notes

- Negative paths must be explicit: anonymous + mutation = "this action requires a token" with the four-line setup hint.
- Verify standard aliases by setting just `GITHUB_TOKEN=...` (no `APIMGR_*`, no `GITHUB_ACCESS_TOKEN`) and confirming `apimgr github verify` works.
- For each pagination dialect, find a target with >100 results and confirm `apimgr <p> repo list --limit 250` returns 250 records (not 100).
- Don't `bash -x` an auth-header code path — leaks tokens. Use `APIMGR_TOKEN_OVERRIDE=fake apimgr ...` for trace runs that need to fail before the real token is sent.

## Out of scope (for this refactor)

- OAuth flows
- Output-format JSON-vs-table polish
- New providers
- Caching
