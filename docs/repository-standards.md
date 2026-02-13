# Repository Standards

## Table of Contents

- [Pre-flight checklist](#pre-flight-checklist)
- [AI co-authors](#ai-co-authors)
- [Repository profile](#repository-profile)
- [Local validation](#local-validation)
- [Tooling requirement](#tooling-requirement)
- [Merge strategy override](#merge-strategy-override)

## Pre-flight checklist

- Before modifying any files, check the current branch with `git status -sb`.
- If on `develop`, create a short-lived `feature/*` branch or ask
  for explicit approval to proceed on `develop`.
- If approval is granted to work on `develop`, call it out in the
  response and proceed only for that user-approved scope.
- Enable repository git hooks before committing: `git config core.hooksPath scripts/git-hooks`.

## AI co-authors

```text
Co-Authored-By: wphillipmoore-codex <255923655+wphillipmoore-codex@users.noreply.github.com>
Co-Authored-By: wphillipmoore-claude <255925739+wphillipmoore-claude@users.noreply.github.com>
```

## Repository profile

- repository_type: infrastructure
- versioning_scheme: none (not published as a package)
- branching_model: library-release
- release_model: none (consumed via git reference)
- supported_release_lines: current only

## Local validation

```bash
# Validate the MQ environment is running and seeded correctly
scripts/mq_verify.sh

# Lint documentation
markdownlint '**/*.md' --ignore node_modules
```

## Tooling requirement

Required for daily workflow:

- Docker and Docker Compose (for running the MQ containers)
- `curl` (for REST API health checks and verification)
- `markdownlint` (required for docs validation and PR pre-submission)

## Merge strategy override

- Feature, bugfix, and chore PRs targeting `develop` use squash merges (`--squash`).
- Release PRs targeting `main` use regular merges (`--merge`) to preserve shared
  ancestry between `main` and `develop`.
- Auto-merge commands:
  - Feature PRs: `gh pr merge --auto --squash --delete-branch`
  - Release PRs: `gh pr merge --auto --merge --delete-branch`
