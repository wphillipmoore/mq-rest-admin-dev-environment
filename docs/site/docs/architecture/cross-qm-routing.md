# Cross-QM Routing

Both queue managers define transmission queues, remote queue
definitions, and sender/receiver channel pairs for bidirectional
message routing between QM1 and QM2.

## QM1 to QM2

| Object | Type | Description |
| --- | --- | --- |
| DEV.QM2.XMITQ | QLOCAL (XMITQ) | Transmission queue to QM2 |
| DEV.REMOTE.TO.QM2 | QREMOTE | Routes to DEV.QLOCAL on QM2 |
| QM1.TO.QM2 | SDR | Sender channel to QM2 (`qm2:1414`) |
| QM2.TO.QM1 | RCVR | Receiver channel from QM2 |

## QM2 to QM1

| Object | Type | Description |
| --- | --- | --- |
| DEV.QM1.XMITQ | QLOCAL (XMITQ) | Transmission queue to QM1 |
| DEV.REMOTE.TO.QM1 | QREMOTE | Routes to DEV.QLOCAL on QM1 |
| QM2.TO.QM1 | SDR | Sender channel to QM1 (`qm1:1414`) |
| QM1.TO.QM2 | RCVR | Receiver channel from QM1 |

## Gateway routing

Each queue manager defines a QM alias that enables the REST API on
one queue manager to route MQSC commands to the other:

| Queue Manager | QM Alias | Routes To | Via |
| --- | --- | --- | --- |
| QM1 | QM2 | QM2 | DEV.QM2.XMITQ |
| QM2 | QM1 | QM1 | DEV.QM1.XMITQ |

The QM alias is defined as a QREMOTE with an empty `RNAME`:

```text
DEFINE QREMOTE(QM2) RNAME('') RQMNAME('QM2') XMITQ(DEV.QM2.XMITQ)
```

This allows the REST API's `runCommandJSON` endpoint on QM1 to
execute commands on QM2 by specifying `QM2` as the target queue
manager, and vice versa.

## Channel startup

The sender channels are started automatically during seeding:

```text
START CHANNEL(QM1.TO.QM2)   -- on QM1
START CHANNEL(QM2.TO.QM1)   -- on QM2
```

Both channels connect using the Docker network hostnames (`qm1`,
`qm2`) on port 1414.
