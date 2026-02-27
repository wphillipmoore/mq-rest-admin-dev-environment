# Port Allocation

Each language library in the mq-rest-admin project is assigned a
dedicated block of ports to prevent conflicts when multiple environments
run concurrently — both locally and in CI matrix builds.

## Local defaults

The dev environment exposes four host ports per instance:

| Port | Default | Description |
| --- | --- | --- |
| QM1 MQ listener | `1414` | AMQP/MQI connections to QM1 |
| QM1 REST API | `9443` | HTTPS REST API for QM1 |
| QM2 MQ listener | `1415` | AMQP/MQI connections to QM2 |
| QM2 REST API | `9444` | HTTPS REST API for QM2 |

These defaults are used when running the environment directly from this
repository without port overrides.

## Per-language allocation

Each language library is assigned a block of 10 ports. The first four
ports in each block are used for the base allocation; the remaining
ports accommodate CI matrix offsets.

| Language | QM1 MQ | QM1 REST | QM2 MQ | QM2 REST | Block |
| --- | --- | --- | --- | --- | --- |
| Python | 11414 | 19443 | 11415 | 19444 | 11414–11423 / 19443–19452 |
| Java | 11424 | 19453 | 11425 | 19454 | 11424–11433 / 19453–19462 |
| Go | 11434 | 19463 | 11435 | 19464 | 11434–11443 / 19463–19472 |
| Ruby | 11444 | 19473 | 11445 | 19474 | 11444–11453 / 19473–19482 |
| Rust | 11454 | 19483 | 11455 | 19484 | 11454–11463 / 19483–19492 |

## CI port isolation

In CI matrix builds, each matrix entry needs its own set of ports to
avoid conflicts. Apply an offset of **+2** per matrix index to the MQ
ports and **+2** per matrix index to the REST ports:

```text
qm1-mq-port   = base_mq   + (matrix_index * 2)
qm2-mq-port   = base_mq   + (matrix_index * 2) + 1
qm1-rest-port  = base_rest + (matrix_index * 2)
qm2-rest-port  = base_rest + (matrix_index * 2) + 1
```

### Example: Python CI matrix

Python's base ports are MQ `11414` and REST `19443`.

| Matrix index | QM1 MQ | QM2 MQ | QM1 REST | QM2 REST |
| --- | --- | --- | --- | --- |
| 0 | 11414 | 11415 | 19443 | 19444 |
| 1 | 11416 | 11417 | 19445 | 19446 |
| 2 | 11418 | 11419 | 19447 | 19448 |
| 3 | 11420 | 11421 | 19449 | 19450 |

Each 10-port block supports up to 5 matrix entries.

## Adding a new language

1. Take the next available 10-port block after the last allocated
   language (currently Rust: MQ 11454–11463, REST 19483–19492)
2. The next block starts at MQ `11464` / REST `19493`
3. Add the allocation to the table above
4. Update your CI workflow to use the allocated ports
5. Update wrapper scripts with the correct `COMPOSE_PROJECT_NAME`
