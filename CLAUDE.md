# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

## Auto-memory policy

**Do NOT use MEMORY.md.** Claude Code's auto-memory feature stores behavioral
rules outside of version control, making them invisible to code review,
inconsistent across repos, and unreliable across sessions. All behavioral rules,
conventions, and workflow instructions belong in managed, version-controlled
documentation (CLAUDE.md, AGENTS.md, skills, or docs/).

If you identify a pattern, convention, or rule worth preserving:

1. **Stop.** Do not write to MEMORY.md.
2. **Discuss with the user** what you want to capture and why.
3. **Together, decide** the correct managed location (CLAUDE.md, a skill file,
   standards docs, or a new issue to track the gap).

This policy exists because MEMORY.md is per-directory and per-machine — it
creates divergent agent behavior across the multi-repo environment this project
operates in. Consistency requires all guidance to live in shared, reviewable
documentation.

## Documentation Strategy

This repository uses two complementary approaches for AI agent
guidance:

- **AGENTS.md**: Generic AI agent instructions using include
  directives to force documentation indexing. Contains canonical
  standards references, shared skills loading, and user override
  support.
- **CLAUDE.md** (this file): Claude Code-specific guidance with
  prescriptive commands, architecture details, and development
  workflows optimized for `/init`.

### Integration Approach

**For Claude Code** (`/init` command):

1. Read CLAUDE.md (this file) first for optimized quick-start guidance
2. Process include directives to load repository standards
3. Reference AGENTS.md for shared skills and canonical standards
   location
4. Apply layered standards: canonical -> project-specific -> user
   overrides

**For other AI agents** (Codex, generic LLMs):

1. Read AGENTS.md first as the primary entry point
2. Process include directives to load all referenced documentation
3. Resolve canonical standards repo path (local or GitHub)
4. Load shared skills from standards repo
5. Apply user overrides from `~/AGENTS.md` if present

<!-- include: docs/standards-and-conventions.md -->
<!-- include: docs/repository-standards.md -->

## Project Overview

Shared dockerized IBM MQ test environment for use across multiple
repositories. Provides container lifecycle scripts, seed data, and
a reusable GitHub Actions workflow for integration testing against
a real MQ queue manager.

**Project name**: mq-rest-admin-dev-environment

**Status**: Pre-alpha (initial setup)

**Consuming repositories**:

- `pymqrest` — Python wrapper for the MQ administrative REST API
- `mq-rest-admin` — Java port of pymqrest
- `pymqpcf` — Python wrapper for the MQ PCF API (planned)

**Canonical Standards**: This repository follows standards at
<https://github.com/wphillipmoore/standards-and-conventions>
(local path: `../standards-and-conventions` if available)

## Development Commands

### Environment Setup

- **Docker**: Docker Desktop or equivalent with Docker Compose v2
- **curl**: For REST API health checks (typically pre-installed on
  macOS/Linux)

### Container Lifecycle

```bash
scripts/mq_start.sh         # Start QM1 + QM2, wait for REST API readiness
scripts/mq_seed.sh           # Run MQSC seed commands on both queue managers
scripts/mq_verify.sh         # Verify seed objects exist via REST API
scripts/mq_reset.sh          # Stop + start + re-seed (full reset)
scripts/mq_stop.sh           # Stop and remove containers
```

### Validation

```bash
scripts/mq_verify.sh         # Verify MQ environment is correctly seeded
markdownlint '**/*.md' --ignore node_modules   # Lint documentation
```

## Architecture

### Environment Contract

Consuming repositories depend on these stable details:

| Property | Value |
| --- | --- |
| Queue manager 1 | QM1 |
| Queue manager 2 | QM2 |
| QM1 REST API | `https://localhost:9443/ibmmq/rest/v2` |
| QM2 REST API | `https://localhost:9444/ibmmq/rest/v2` |
| QM1 MQ listener | `localhost:1414` |
| QM2 MQ listener | `localhost:1415` |
| Admin user | `mqadmin` / `mqadmin` |
| Reader user | `mqreader` / `mqreader` |
| Docker image | `icr.io/ibm-messaging/mq:latest` (IBM MQ for Developers) |
| Docker network | `mq-dev-net` |

### Seed Data Strategy

- **Shared base**: This repository owns all common seed objects
  (queues, channels, topics, namelists, etc.) used across consuming
  repos
- **Repo-specific overlays**: Consuming repos may provide additional
  MQSC files when they need specialized objects beyond the shared
  base (deferred until needed)

### Consumption Model

- **Local development**: Consuming repos reference this repo as a
  sibling directory (`../mq-rest-admin-dev-environment`) — same pattern as
  `../standards-and-conventions`
- **CI**: Reusable GitHub Actions workflow (or composite action) that
  starts the MQ containers, seeds them, and makes them available to
  the calling workflow's test jobs

### Repository Structure

```text
scripts/
    mq_start.sh          # Start containers + wait for readiness
    mq_seed.sh           # Run MQSC seed scripts
    mq_verify.sh         # Verify seed objects via REST API
    mq_reset.sh          # Full reset (stop + start + seed)
    mq_stop.sh           # Stop and remove containers
config/
    docker-compose.yml   # Container definitions (QM1, QM2)
    mqwebuser.xml        # REST API user/role configuration
seed/
    base-qm1.mqsc        # Shared seed objects for QM1
    base-qm2.mqsc        # Shared seed objects for QM2
docs/
    plans/               # Decision documents
    repository-standards.md
    standards-and-conventions.md
```

## Repository Standards Quick Reference

The include directives at the top of this file load the full
repository standards. Key highlights for quick reference:

**Pre-flight Checklist**:

- Check current branch: `git status -sb`
- If on `develop`, create `feature/*` branch or get explicit approval
- Enable git hooks: `git config core.hooksPath scripts/git-hooks`

See `docs/repository-standards.md` for complete details.

## Documentation Indexing Strategy

This repository uses `<!-- include: path/to/file.md -->` directives
to force documentation indexing. When you encounter these directives:

1. **Read the referenced files** to understand the full context
2. **Apply layered standards** in order:
   - Canonical standards (from `standards-and-conventions` repo)
   - Project-specific standards (`docs/repository-standards.md`)
   - User overrides (`~/AGENTS.md` if present)
3. **Load shared skills** from
   `<standards-repo-path>/skills/**/SKILL.md`

## Documentation Structure

- `README.md` - Project overview and quick start
- `AGENTS.md` - Generic AI agent instructions with include directives
- `CLAUDE.md` - This file, Claude Code-specific guidance
- `docs/repository-standards.md` - Project-specific standards
  (included from AGENTS.md)
- `docs/standards-and-conventions.md` - Canonical standards reference
  (includes external repo)

## Commit and PR Scripts

**NEVER use raw `git commit`** — always use `scripts/dev/commit.sh`.
**NEVER use raw `gh pr create`** — always use `scripts/dev/submit-pr.sh`.

### Committing

```bash
scripts/dev/commit.sh --type feat --message "add new seed data" --agent claude
scripts/dev/commit.sh --type fix --message "correct container startup" --agent claude
```

- `--type` (required): `feat|fix|docs|style|refactor|test|chore|ci|build`
- `--message` (required): commit description
- `--agent` (required): `claude` or `codex` — resolves the correct `Co-Authored-By` identity
- `--scope` (optional): conventional commit scope
- `--body` (optional): detailed commit body

### Submitting PRs

```bash
scripts/dev/submit-pr.sh --issue 42 --summary "Add new seed data for testing"
scripts/dev/submit-pr.sh --issue 42 --linkage Ref --summary "Update docs" --docs-only
```

- `--issue` (required): GitHub issue number (just the number)
- `--summary` (required): one-line PR summary
- `--linkage` (optional, default: `Fixes`): `Fixes|Closes|Resolves|Ref`
- `--title` (optional): PR title (default: most recent commit subject)
- `--notes` (optional): additional notes
- `--docs-only` (optional): applies docs-only testing exception
- `--dry-run` (optional): print generated PR without executing

## Key References

**Canonical Standards**:
<https://github.com/wphillipmoore/standards-and-conventions>

- Local path (preferred): `../standards-and-conventions`
- Load all skills from: `<standards-repo-path>/skills/**/SKILL.md`

**Consuming repositories**:

- `../pymqrest` (Python MQ REST wrapper)
- `../mq-rest-admin` (Java MQ REST wrapper)

**External Documentation**:

- IBM MQ 9.4 administrative REST API
- IBM MQ for Developers container image documentation

**User Overrides**: `~/AGENTS.md` (optional, applied if present and
readable)
