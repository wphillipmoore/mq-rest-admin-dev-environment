# Seed Data

Seed data is defined as MQSC command files in the `seed/` directory.
The `mq_seed.sh` script runs these files against the respective
queue managers using `docker exec` and `runmqsc`.

## Seed files

| File | Target |
| --- | --- |
| `seed/base-qm1.mqsc` | QM1 |
| `seed/base-qm2.mqsc` | QM2 |

## QM1 objects

QM1 has the full set of development objects covering all major MQ
object types:

| Object | Type | Notes |
| --- | --- | --- |
| DEV.DEAD.LETTER | QLOCAL | Dead-letter queue (set on QMGR) |
| DEV.QLOCAL | QLOCAL | General-purpose local queue |
| DEV.XMITQ | QLOCAL (XMITQ) | Transmission queue |
| DEV.QREMOTE | QREMOTE | Routes to DEV.TARGET on QM1 |
| DEV.QALIAS | QALIAS | Alias for DEV.QLOCAL |
| DEV.QMODEL | QMODEL | Temporary-dynamic model queue |
| DEV.TOPIC | TOPIC | Topic string `dev/topic` |
| DEV.NAMELIST | NAMELIST | Contains DEV.QLOCAL |
| DEV.SVRCONN | SVRCONN | Server-connection channel |
| DEV.SDR | SDR | Sender channel |
| DEV.RCVR | RCVR | Receiver channel |
| DEV.LSTR | LISTENER | TCP listener on port 1415 |
| DEV.PROC | PROCESS | Process definition |

## QM2 objects

QM2 has a minimal subset of development objects:

| Object | Type | Notes |
| --- | --- | --- |
| DEV.DEAD.LETTER | QLOCAL | Dead-letter queue (set on QMGR) |
| DEV.QLOCAL | QLOCAL | General-purpose local queue |
| DEV.SVRCONN | SVRCONN | Server-connection channel |

## Cross-QM objects

Both queue managers define additional objects for bidirectional
message routing. See
[Cross-QM Routing](../architecture/cross-qm-routing.md) for
details.

## Security configuration

Both queue managers disable connection authentication and channel
authentication for containerized testing:

```text
ALTER QMGR CONNAUTH(' ') CHLAUTH(DISABLED)
REFRESH SECURITY TYPE(CONNAUTH)
```

!!! warning
    This configuration is for development and testing only. Never
    use these settings in production.
