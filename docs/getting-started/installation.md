# Installation

Install a complete xBoson system with a single command.

## Requirements

Before installation, make sure the server has:

* Linux
* Docker
* Internet access
* Port `8080` available

The installation script will download the required Docker images and create the necessary Docker configuration.

## Quick Install

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/xboson-core/xboson-runtime/refs/heads/main/install.sh | bash
```

Wait for the installation to complete.

If the script finishes without errors, xBoson should be running.

## Open xBoson

Open the following URL in your browser:

```text
http://server-host:8080/xboson
```

Replace `server-host` with the hostname or IP address of your server.

### Default Login

```text
Username: admin-pl
Password: 66666666
```

Log in to the system and **change the default password before using xBoson in a production environment**.
