# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

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

## Development Commands

### Standard Tooling

```bash
cd ../standard-tooling && uv sync                                                # Install standard-tooling
export PATH="../standard-tooling/.venv/bin:../standard-tooling/scripts/bin:$PATH" # Put tools on PATH
git config core.hooksPath ../standard-tooling/scripts/lib/git-hooks               # Enable git hooks
```

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
markdownlint . --ignore node_modules            # Lint documentation
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

## Key References

**Consuming repositories**:

- `../pymqrest` (Python MQ REST wrapper)
- `../mq-rest-admin` (Java MQ REST wrapper)

**External Documentation**:

- IBM MQ 9.4 administrative REST API
- IBM MQ for Developers container image documentation
