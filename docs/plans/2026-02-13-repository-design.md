# Repository design decisions

## Table of Contents

- [Results](#results)
- [Reasoning](#reasoning)
- [Options not chosen](#options-not-chosen)
- [Dependencies and external constraints](#dependencies-and-external-constraints)
- [References](#references)

## Results

### Decisions made

- **Repository purpose**: Standalone shared repository for the dockerized IBM
  MQ test environment, consumed by multiple projects (pymqrest, mq-rest-admin,
  pymqpcf).
- **Repository name**: `mq-rest-admin-dev-environment`.
- **Consumption model (local)**: Sibling directory (`../mq-rest-admin-dev-environment`),
  same pattern as `../standards-and-conventions`.
- **Consumption model (CI)**: Reusable GitHub Actions workflow or composite
  action (to be finalized during CI implementation).
- **Seed data strategy**: Shared base owned by this repository. All common
  test objects (queues, channels, topics, namelists, processes, listeners,
  cross-QM plumbing) live here. Repo-specific overlays deferred until needed.
- **Object naming**: Shared prefix (replacing `PYMQREST.*` from pymqrest) to
  be determined during migration. The prefix should be repo-neutral since
  multiple consumers share the same objects.
- **Environment contract**: Stable, documented properties (queue manager
  names, ports, credentials, REST base URLs) that consuming repos depend on.
- **License**: GPLv3 (consistent with pymqrest and mq-rest-admin).

### Implicitly converged decisions

- **Not a published package**: This repository is never published to a package
  registry. It is consumed via git clone/checkout as a sibling directory or
  via GitHub Actions workflow references. This simplifies the repository
  significantly -- no build system, no versioning scheme, no release process.
- **Shell scripts as the interface**: The lifecycle scripts (start, seed,
  verify, reset, stop) are plain bash. This is the natural lowest common
  denominator for consuming repos that use different build tools (Maven for
  Java, uv/pip for Python). No build-tool-specific plugins needed.
- **Docker Compose for container orchestration**: The existing pymqrest setup
  uses Docker Compose and it works well. No reason to change.
- **Two queue managers (QM1, QM2)**: The existing pymqrest setup provides two
  queue managers with cross-QM channels for gateway routing tests. This is
  sufficient for all known consuming repos.
- **IBM MQ for Developers image**: The `icr.io/ibm-messaging/mq:latest` image
  is the free developer edition, suitable for development and CI testing.

### Deferred decisions

- **CI workflow type**: Reusable workflow (`workflow_call`) vs. composite
  action. Composite action is likely the pragmatic winner because it runs in
  the caller's job (MQ containers share the runner's Docker network), while
  reusable workflows run as separate jobs. To be finalized during CI
  implementation.
- **Repo-specific seed overlays**: The seed script could accept an optional
  directory of additional MQSC files from consuming repos. Deferred until a
  consumer actually needs objects beyond the shared base.
- **Object naming prefix**: The current pymqrest seed uses `PYMQREST.*`
  prefixes. The shared base should use a repo-neutral prefix. To be decided
  during the migration from pymqrest.

### Action items

- Migrate Docker Compose file, mqwebuser.xml, lifecycle scripts, and MQSC
  seed files from pymqrest.
- Rename `PYMQREST.*` object prefixes to a shared convention.
- Update pymqrest to consume from
  `../mq-rest-admin-dev-environment` instead of bundling
  scripts directly.
- Implement CI workflow/composite action for GitHub Actions integration.
- Enable integration tests in pymqrest CI using the shared action.

## Reasoning

### Why a separate repository

#### Key constraints

- The dockerized MQ environment (container lifecycle, seed data, REST API
  configuration) is not specific to any one project. pymqrest, mq-rest-admin,
  and pymqpcf all need the same MQ infrastructure for integration testing.
- Duplicating Docker scripts and seed configuration across each repo creates
  maintenance burden and risks drift between environments.
- The consuming repos use fundamentally different build tools (Maven for Java,
  uv/pip for Python) -- embedding MQ setup in either build system would not
  help the other.

#### Evidence cited

- pymqrest already has the complete MQ environment implemented and tested:
  `scripts/dev/mq_start.sh`, `mq_seed.sh`, `mq_verify.sh`, `mq_stop.sh`,
  `mq_reset.sh`, plus `scripts/dev/mq/docker-compose.yml`,
  `mqwebuser.xml`, `seed-qm1.mqsc`, `seed-qm2.mqsc`.
- The pymqrest issue (wphillipmoore/pymqrest#211) documents the motivation
  and scope.
- mq-rest-admin's open-decisions.md lists "Integration test strategy: TBD
  (same local MQ container as pymqrest)" -- confirming the shared need.

### Consumption model: sibling directory + CI workflow

#### Key constraints

- Consuming repos have different build tools. The consumption mechanism must
  be build-tool-agnostic.
- For local development, the mechanism should be zero-friction -- developers
  should not need to run special setup commands or install plugins.
- For CI, the mechanism must work within GitHub Actions and provide MQ
  containers accessible to the test runner.

#### Evidence cited

- The sibling directory pattern (`../mq-rest-admin-dev-environment`) is already
  established in this ecosystem: `../standards-and-conventions` is consumed
  the same way by both pymqrest and mq-rest-admin.
- Shell scripts are callable from any build system. Maven can invoke them via
  `exec-maven-plugin` or a simple `mvn` profile. Python can invoke them via
  `subprocess` or a Makefile. Both can call them directly from a developer's
  terminal.
- GitHub Actions composite actions run in the calling job's environment,
  meaning Docker containers started by the action share the runner's network.
  This is critical -- the test runner needs `localhost:9443` to reach the MQ
  REST API.

#### Tradeoffs

- Sibling directory requires developers to clone both repos. This is a
  one-time setup cost, documented in the consuming repo's README.
- The CI workflow/action adds a cross-repo dependency. If the MQ environment
  changes in a breaking way, consuming repos' CI could fail. Mitigated by
  pinning to a specific ref (tag or SHA) in the workflow reference.

### Seed data: shared base

#### Key constraints

- pymqrest and mq-rest-admin are wrappers for the same MQ REST API. They
  need the same types of test objects: local queues, remote queues, alias
  queues, model queues, channels, topics, namelists, processes, listeners,
  and cross-QM plumbing.
- The seed data defines the test fixture contract. Every consuming repo's
  integration tests depend on specific objects existing with specific names.

#### Evidence cited

- Examining pymqrest's seed data (`seed-qm1.mqsc`, `seed-qm2.mqsc`), the
  objects cover all MQ object types that the REST API can manage. Both
  pymqrest and mq-rest-admin need to test display/define/alter/delete
  operations against each of these object types.
- pymqpcf (PCF API wrapper) will need the same object types but may access
  them via the binary PCF protocol rather than REST. The seed objects are
  still the same.

#### Tradeoffs

- A shared base means changes to seed data affect all consumers. If one
  consumer needs an incompatible change, it could break others. Mitigated
  by the deferred overlay mechanism -- consumers can add objects without
  modifying the shared base.
- The shared prefix choice matters. `PYMQREST.*` is pymqrest-specific.
  Something like `TEST.*` or `MQDEV.*` would be more appropriate for a
  shared environment.

## Options not chosen

### Consumption: git submodule

- **Description**: Add `mq-rest-admin-dev-environment` as a git submodule in each
  consuming repo.
- **Reason not chosen**: Submodules create friction (developers forgetting
  `--recurse-submodules`, detached HEAD confusion, extra steps in CI
  checkout). The sibling directory pattern is simpler and already
  established in this ecosystem.
- **Status**: Rejected.

### Consumption: published package

- **Description**: Publish the MQ environment as a package (PyPI, Maven
  Central, npm) and add it as a dev dependency.
- **Reason not chosen**: There is no code to compile or distribute. The
  repository contains shell scripts, MQSC files, and a Docker Compose
  configuration. Packaging this adds complexity with no benefit. Different
  consuming repos use different package managers, so there is no single
  registry that serves all consumers.
- **Status**: Rejected.

### Consumption: Makefile include

- **Description**: Provide a Makefile that consuming repos include via
  `include ../mq-rest-admin-dev-environment/Makefile`.
- **Reason not chosen**: Not all consuming repos use Make. mq-rest-admin
  uses Maven. Adding Make as a required tool for MQ lifecycle management
  is an unnecessary dependency. The shell scripts are directly callable
  from any context.
- **Status**: Rejected.

### Consumption: Docker Compose shared config

- **Description**: Consuming repos extend the shared Docker Compose file
  via `extends` or `include` directives in their own docker-compose.yml.
- **Reason not chosen**: Docker Compose `extends` has limitations
  (cannot extend services across files with `depends_on`, network
  definitions, etc.). The lifecycle scripts already abstract over Docker
  Compose, so consuming repos do not need to interact with Docker Compose
  directly.
- **Status**: Rejected.

### Seed data: each repo owns all its own seed data

- **Description**: The shared repo provides only the container
  infrastructure (Docker Compose, mqwebuser.xml). Each consuming repo
  provides its own complete MQSC seed files.
- **Reason not chosen**: The consuming repos (pymqrest, mq-rest-admin,
  pymqpcf) all need the same types of test objects. Duplicating seed data
  across repos recreates the original maintenance burden and drift risk
  that motivated extracting the environment in the first place.
- **Status**: Rejected.

### Seed data: per-repo overlays only (no shared base)

- **Description**: Each consuming repo provides its own MQSC seed files;
  the shared repo runs them all but owns none.
- **Reason not chosen**: Most seed objects are identical across consumers.
  Having each repo independently define the same queues, channels, and
  topics is redundant and error-prone.
- **Status**: Rejected.

### CI: service container in workflow YAML

- **Description**: Define the MQ container directly in the consuming repo's
  workflow YAML via `services:` rather than using a reusable workflow or
  composite action.
- **Reason not chosen**: The MQ setup requires multiple containers (QM1,
  QM2), a shared network, volume mounts for mqwebuser.xml, post-startup
  MQSC seeding, and a readiness check loop. This complexity does not fit
  cleanly in the `services:` block, which is designed for simple single-
  container services. The lifecycle scripts encapsulate this complexity
  properly.
- **Status**: Rejected.

## Dependencies and external constraints

- The `icr.io/ibm-messaging/mq:latest` image is IBM MQ for Developers. It
  is free for development and testing, including CI environments. The image
  license requires accepting the IBM license agreement via `LICENSE=accept`
  environment variable.
- Docker Compose v2 is required (the `docker compose` subcommand, not the
  legacy `docker-compose` binary). GitHub Actions ubuntu runners include
  Docker Compose v2.
- The MQ container image is ~1.5GB. First pull in CI will take time; GitHub
  Actions caching can mitigate this for subsequent runs.
- GitHub Actions has a 6-hour job timeout. MQ container startup + seed
  typically completes in under 60 seconds.

## References

- `wphillipmoore/pymqrest#211` -- original issue motivating extraction
- `../pymqrest/scripts/dev/mq_start.sh` -- existing container lifecycle
- `../pymqrest/scripts/dev/mq/docker-compose.yml` -- existing container config
- `../pymqrest/scripts/dev/mq/seed-qm1.mqsc` -- existing QM1 seed data
- `../pymqrest/scripts/dev/mq/seed-qm2.mqsc` -- existing QM2 seed data
- `../pymqrest/scripts/dev/mq/mqwebuser.xml` -- existing REST API config
- `../mq-rest-admin/docs/plans/open-decisions.md` -- integration test TBD
- `../standards-and-conventions/docs/foundation/summarize-decisions-protocol.md`
  -- protocol followed for this document
