# REST API Users

REST API authentication is configured through the `mqwebuser.xml`
file located at `config/mqwebuser.xml`. This file is bind-mounted
into both containers at the Liberty web server configuration path.

## Users

| User | Password | Role | Access |
| --- | --- | --- | --- |
| `mqadmin` | `mqadmin` | MQWebAdmin | Full administrative access |
| `mqreader` | `mqreader` | MQWebAdminRO | Read-only access |

Both users also have the `MQWebUser` role, which grants access to
the MQ Console web UI.

## Security roles

The configuration defines roles for two Liberty applications:

### MQ Console (`com.ibm.mq.console`)

| Role | Users | Description |
| --- | --- | --- |
| MQWebAdmin | mqadmin | Full admin access to the console |
| MQWebAdminRO | mqreader | Read-only console access |
| MQWebUser | mqadmin, mqreader | General console access |

### MQ REST API (`com.ibm.mq.rest`)

| Role | Users | Description |
| --- | --- | --- |
| MQWebAdmin | mqadmin | Full admin access to REST endpoints |
| MQWebAdminRO | mqreader | Read-only REST access |
| MQWebUser | mqadmin, mqreader | General REST access |

## Configuration file

The `mqwebuser.xml` uses Liberty's basic registry:

```xml
<server>
  <basicRegistry id="basic" realm="defaultRealm">
    <user name="mqadmin" password="${env.MQ_ADMIN_PASSWORD}" />
    <user name="mqreader" password="${env.MQ_READER_PASSWORD}" />
  </basicRegistry>
  ...
</server>
```

Passwords are injected via environment variables set in the Docker
Compose configuration (`MQ_ADMIN_PASSWORD` and
`MQ_READER_PASSWORD`).
