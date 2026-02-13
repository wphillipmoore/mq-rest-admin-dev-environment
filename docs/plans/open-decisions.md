# Open decisions

## Table of Contents

- [Purpose](#purpose)
- [Repository identity](#repository-identity)
- [Environment contract](#environment-contract)
- [Seed data](#seed-data)
- [Consumption model](#consumption-model)
- [CI integration](#ci-integration)

## Purpose

Track decisions for the shared MQ test environment repository.

## Repository identity

- **Repository name**: `mq-dev-environment` (decided 2026-02-13, see
  `docs/plans/2026-02-13-repository-design.md`).
- **License**: GPLv3.

## Environment contract

- **Queue managers**: QM1 and QM2 (decided 2026-02-13).
- **QM1 REST API**: `https://localhost:9443/ibmmq/rest/v2` (decided
  2026-02-13).
- **QM2 REST API**: `https://localhost:9444/ibmmq/rest/v2` (decided
  2026-02-13).
- **Admin credentials**: `mqadmin` / `mqadmin` (decided 2026-02-13).
- **Reader credentials**: `mqreader` / `mqreader` (decided 2026-02-13).
- **Container image**: `icr.io/ibm-messaging/mq:latest` (decided 2026-02-13).

## Seed data

- **Strategy**: Shared base owned by this repository (decided 2026-02-13, see
  `docs/plans/2026-02-13-repository-design.md`).
- **Object naming prefix**: `DEV.*` (decided 2026-02-13, replaced
  `PYMQREST.*`).
- **Repo-specific overlay mechanism**: Deferred until a consumer needs it.

## Consumption model

- **Local development**: Sibling directory `../mq-dev-environment` (decided
  2026-02-13, see `docs/plans/2026-02-13-repository-design.md`).
- **CI**: TBD -- reusable workflow vs. composite action (composite action
  likely preferred).

## CI integration

- **Workflow type**: TBD (reusable workflow vs. composite action).
- **Container image caching**: TBD.
- **pymqrest migration**: TBD (update pymqrest to consume from this repo).
- **mq-rest-admin integration**: TBD (add integration test support).
