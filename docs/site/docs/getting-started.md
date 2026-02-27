# Getting Started

## Prerequisites

- **Docker**: Docker Desktop or Docker Engine with Compose v2
- **curl**: For REST API health checks (pre-installed on macOS/Linux)

## Quick start

```bash
scripts/mq_start.sh    # Start QM1 + QM2, wait for REST API readiness
scripts/mq_seed.sh     # Run MQSC seed commands on both queue managers
scripts/mq_verify.sh   # Verify seed objects exist via REST API
```

Once the environment is running, the REST APIs are available at:

| Queue Manager | REST API URL |
| --- | --- |
| QM1 | `https://localhost:9443/ibmmq/rest/v2` |
| QM2 | `https://localhost:9444/ibmmq/rest/v2` |

Authenticate with `mqadmin` / `mqadmin` (full access) or
`mqreader` / `mqreader` (read-only access).

## Verify the environment

Run the verification script to confirm all seed objects were created
successfully:

```bash
scripts/mq_verify.sh
```

This queries the REST API on both queue managers and checks that
each expected object exists.

## Stop the environment

```bash
scripts/mq_stop.sh     # Stop and remove containers (preserves volumes)
```

To remove all container data and start fresh, use the reset workflow
instead:

```bash
scripts/mq_reset.sh    # Stop, remove volumes, restart, and re-seed
```

See [Lifecycle Scripts](lifecycle-scripts.md) for full details on
each script.
