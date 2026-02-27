# Development

## Local directory structure

The language-specific libraries reference this repo as a sibling
directory:

```text
~/dev/
  mq-rest-admin-dev-environment/     # this repo
  mq-rest-admin-python/              # language library
  mq-rest-admin-java/                # language library
  mq-rest-admin-go/                  # language library
```

## Starting the environment from a language library

From a language library repo, start the environment using relative
paths:

```bash
../mq-rest-admin-dev-environment/scripts/mq_start.sh
../mq-rest-admin-dev-environment/scripts/mq_seed.sh
```

## Reset workflow

To tear down the environment completely (including Docker volumes)
and start fresh:

```bash
scripts/mq_reset.sh
```

`mq_reset.sh` runs `docker compose down -v`, which removes all
container data. Use `mq_stop.sh` instead if you want to preserve
queue manager state across restarts.

## Adding seed objects

Seed data is defined as MQSC commands in the `seed/` directory:

- `seed/base-qm1.mqsc` — objects for QM1
- `seed/base-qm2.mqsc` — objects for QM2

To add a new object:

1. Add the MQSC `DEFINE` command to the appropriate seed file
2. Run `scripts/mq_reset.sh` to apply (or `mq_seed.sh` if using
   `REPLACE`)
3. Update `scripts/mq_verify.sh` if the new object should be
   verified
4. Update the seed data documentation

## Environment variables

See the [Environment Variables](reference/environment-variables.md)
reference for the complete list of Docker Compose, script, consumer,
and test gate variables.
