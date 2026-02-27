# Lifecycle Scripts

All lifecycle scripts are located in the `scripts/` directory. They
manage the Docker container lifecycle for the MQ development
environment.

## Script reference

### mq_start.sh

Starts the QM1 and QM2 containers and waits for both REST APIs to
become ready.

```bash
scripts/mq_start.sh
```

The script:

1. Runs `docker compose up -d` using `config/docker-compose.yml`
2. Waits for container health checks to pass
3. Polls the REST API endpoints until they respond

### mq_seed.sh

Runs the MQSC seed scripts against both queue managers to create
all development objects.

```bash
scripts/mq_seed.sh
```

The script:

1. Copies `seed/base-qm1.mqsc` into the QM1 container
2. Runs `runmqsc QM1` with the seed file
3. Copies `seed/base-qm2.mqsc` into the QM2 container
4. Runs `runmqsc QM2` with the seed file

### mq_verify.sh

Verifies that all expected seed objects exist by querying the REST
API on both queue managers.

```bash
scripts/mq_verify.sh
```

The script checks each object type (queues, channels, topics, etc.)
and reports success or failure for each.

### mq_reset.sh

Stops containers, removes Docker volumes, and restarts the
environment cleanly.

```bash
scripts/mq_reset.sh
```

The script runs `docker compose down -v` to remove all container
data, then calls `mq_start.sh` and `mq_seed.sh` to rebuild the
environment from scratch.

!!! warning
    This removes all queue manager state including any messages
    in queues. Use `mq_stop.sh` if you want to preserve state.

### mq_stop.sh

Stops and removes the containers but preserves the named Docker
volumes.

```bash
scripts/mq_stop.sh
```

Queue manager state is retained in the `qm1data` and `qm2data`
volumes and will be available on the next `mq_start.sh`.

## Typical workflows

### First-time setup

```bash
scripts/mq_start.sh
scripts/mq_seed.sh
scripts/mq_verify.sh
```

### Daily restart

```bash
scripts/mq_start.sh    # Volumes preserved, no re-seed needed
```

### Clean reset

```bash
scripts/mq_reset.sh    # Removes volumes and re-seeds
```
