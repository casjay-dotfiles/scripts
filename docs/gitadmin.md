# gitadmin - Git Repository Management Tool

Version: 202510101547-git

## Overview

gitadmin is a comprehensive git repository management tool that supports multiple git hosting providers including GitHub, GitLab, Bitbucket, Codeberg, Forgejo, Gitea, Gogs, Azure DevOps, AWS CodeCommit, and self-hosted solutions.

## Command Structure

### Global Commands (Provider-Agnostic)
- `org)` - GitHub organization management (standalone, stays as-is)
- `user)` - GitHub user management (standalone, stays as-is)

### Provider-Specific Commands
Each provider has its own command section with consistent subcommands:
- `github)` - GitHub operations
- `gitlab)` - GitLab operations
- `private)` - Private/self-hosted Gitea operations
- `bitbucket)` - Bitbucket operations
- `codeberg)` - Codeberg operations
- `forgejo)` - Forgejo operations
- `gitea)` - Gitea operations
- `gogs)` - Gogs operations
- `azure)` - Azure DevOps operations
- `aws)` - AWS CodeCommit operations

## org) Command Pattern (GitHub-specific, keep as-is)

**Purpose**: Manage GitHub organizations

**Subcommands**:
1. `repos [orgName]` - List all repositories in an organization
2. `all [userName]` - Clone all organizations owned by userName, then clone all repos from each org
3. `push [orgName]` - Push all repos from an org
4. `pull [orgName]` - Pull all repos from an org
5. `clone [orgName]` - Clone all repos from an org
6. `*` (default) - Process comma-separated list of orgs

**Helper Functions**:
- `__git_retrieve_orgs()` - Get list of orgs for a user
- `__git_all_orgs_clone()` - Clone all orgs and their repos
- `__github_org_list_repos()` - List repos in an org
- `__github_org_push_repos()` - Push all repos in an org
- `__clone_orgs()` - Clone org repos
- `__main()` - Main cloning function

**Workflow**:
```
org repos myorg          -> Lists all repos in myorg
org all myusername       -> Gets all orgs for myusername, clones all repos from each
org push myorg           -> Pushes all local repos for myorg
org pull myorg           -> Pulls all repos for myorg
org clone myorg          -> Clones all repos from myorg
org org1,org2,org3       -> Clones all repos from multiple orgs
```

## user) Command Pattern (GitHub-specific, keep as-is)

**Purpose**: Manage GitHub user repositories

**Subcommands**:
1. `orgs [userName]` - List all organizations the user belongs to
2. `clone [userName]` - Clone all repos owned by the user
3. `*` (default) - Clone all repos owned by the user

**Helper Functions**:
- `__github_user_clone_repos()` - Clone all repos owned by a user
- `__git_retrieve_orgs()` - Get list of orgs for a user

**Workflow**:
```
user orgs myusername     -> Lists all orgs myusername belongs to
user clone myusername    -> Clones all repos owned by myusername
user myusername          -> Clones all repos owned by myusername (default)
```

## Provider-Specific Implementation Plan

### Current Status
Each provider currently has:
- `create` - Create a new repository
- `delete` - Delete a repository
- `modify` - Modify repository settings (where supported)
- `repos` - List repositories for workspace/org/owner

### Needed Implementation
Each provider needs full org/user-like functionality:

1. **List Operations** ✓ (completed)
   - `repos [workspace|owner|project]` - List all repos

2. **Clone Operations** (to implement)
   - `clone [workspace|owner]` - Clone all repos
   - `all [workspace|owner]` - Clone all repos with full sync

3. **Push/Pull Operations** (to implement)
   - `push [workspace|owner]` - Push all local repos
   - `pull [workspace|owner]` - Pull all repos

4. **User Operations** (to implement, if provider supports)
   - List user's repos
   - Clone user's repos

### Provider-Specific Considerations

#### Bitbucket
- Uses "workspaces" instead of orgs
- API: v2.0 REST API
- Pagination: Link header with "next" field

#### Codeberg
- Uses Forgejo API (Gitea-compatible)
- Standard owner/repo model
- Pagination: Standard page/limit params

#### Forgejo
- Self-hosted, requires FORGEJO_HOST
- Gitea-compatible API
- Standard owner/repo model

#### Gitea
- Self-hosted, requires GITEA_HOST
- Standard owner/repo model
- Pagination: page/limit params

#### Gogs
- Self-hosted, requires GOGS_HOST
- Gitea-compatible API (mostly)
- Limited pagination support

#### Azure DevOps
- Uses "projects" instead of orgs
- Requires organization name
- Different repo structure

#### AWS CodeCommit
- Region-based
- No org/user concept
- Uses AWS CLI

## Directory Structure

Provider-specific repos are stored in:
```
$GITADMIN_DEFAULT_PROJECT_DIR/{provider}/{owner|workspace}/{repo}
```

Examples:
```
~/Projects/github/myuser/myrepo
~/Projects/bitbucket/myworkspace/myrepo
~/Projects/codeberg/myuser/myrepo
~/Projects/forgejo/myuser/myrepo
~/Projects/gitea/myuser/myrepo
~/Projects/gogs/myuser/myrepo
~/Projects/azure/myproject/myrepo
~/Projects/aws/myrepo
```

## Required Helper Functions Per Provider

Each provider needs:

1. **API Functions**
   - `__curl_{provider}_api()` - API authentication wrapper ✓

2. **CRUD Functions**
   - `__{provider}_create_repo()` - Create repository ✓
   - `__{provider}_delete_repo()` - Delete repository ✓
   - `__{provider}_modify_repo()` - Modify repository ✓ (where supported)
   - `__{provider}_list_repos()` - List repositories ✓

3. **Clone/Pull/Push Functions** (to implement)
   - `__{provider}_user_clone_repos()` - Clone all user repos
   - `__{provider}_org_clone_repos()` - Clone all org/workspace repos
   - `__{provider}_org_push_repos()` - Push all org/workspace repos
   - `__{provider}_org_pull_repos()` - Pull all org/workspace repos

4. **Supporting Functions** (to implement)
   - `__{provider}_retrieve_orgs()` - Get list of orgs/workspaces for user
   - `__{provider}_all_orgs_clone()` - Clone all orgs and their repos

## Environment Variables

### Existing
- `GITADMIN_GITHUB_AUTH_TOKEN` - GitHub token
- `GITADMIN_GITLAB_AUTH_TOKEN` - GitLab token
- `GITADMIN_PRIVATE_AUTH_TOKEN` - Private Gitea token
- `GITADMIN_BITBUCKET_TOKEN` - Bitbucket app password
- `GITADMIN_CODEBERG_TOKEN` - Codeberg token
- `GITADMIN_FORGEJO_TOKEN` - Forgejo token
- `GITADMIN_FORGEJO_HOST` - Forgejo instance URL
- `GITADMIN_GITEA_TOKEN` - Gitea token
- `GITADMIN_GITEA_HOST` - Gitea instance URL
- `GITADMIN_GOGS_TOKEN` - Gogs token
- `GITADMIN_GOGS_HOST` - Gogs instance URL
- `GITADMIN_AZURE_TOKEN` - Azure DevOps PAT
- `GITADMIN_AZURE_ORGANIZATION` - Azure DevOps org name
- `GITADMIN_AWS_ACCESS_KEY` - AWS access key
- `GITADMIN_AWS_SECRET_KEY` - AWS secret key
- `GITADMIN_AWS_REGION` - AWS region

### To Add (for directory structure)
- `GITADMIN_DEFAULT_GIT_DIR_BITBUCKET`
- `GITADMIN_DEFAULT_GIT_DIR_CODEBERG`
- `GITADMIN_DEFAULT_GIT_DIR_FORGEJO`
- `GITADMIN_DEFAULT_GIT_DIR_GITEA`
- `GITADMIN_DEFAULT_GIT_DIR_GOGS`
- `GITADMIN_DEFAULT_GIT_DIR_AZURE`
- `GITADMIN_DEFAULT_GIT_DIR_AWS`

## Implementation Priority

1. ✓ Basic CRUD operations (completed)
2. ✓ List/repos operations (completed)
3. Clone operations (in progress)
4. Push/Pull operations
5. User/org aggregation operations
6. Documentation and help text updates

## Notes

- The main `org)` and `user)` commands remain GitHub-specific
- Each provider gets its own complete set of commands
- All functions use `__` prefix to avoid collisions
- Follow existing patterns for consistency
- Token creation links shown when credentials not set
