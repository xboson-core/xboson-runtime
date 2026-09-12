# Additional `install.sh` Features

This guide explains the additional features provided by `install.sh`.

For convenience, you can download the script to an empty directory:

```bash
curl -fsSL https://raw.githubusercontent.com/xboson-core/xboson-runtime/refs/heads/main/install.sh -o install.sh
```

## Default Behavior

By default, the script:

* Pulls the required Docker images.
* Starts a single-node xBoson service.
* Makes the service immediately available.
* Provides a free license with limited features.

The script **cannot be run again in an existing installation directory**. This is intentional because reinstalling could overwrite files containing saved passwords. The script will detect the existing installation and exit with an error.

All passwords and other runtime configuration are stored in the `.env` file.

The generated `docker-compose.yml` file is used to manage the services with Docker Compose.

Run the following command to see all available commands:

```bash
install.sh --help
```

> **Warning:** Container data volumes are not exported or backed up automatically. If you remove the MySQL container and its associated volume, all MySQL data will be lost.

The features described below are supported only for containers created by `install.sh`.

## Data Backup

### Back up Web Files

```bash
install.sh --backup web
```

### Back up MySQL

```bash
install.sh --backup mysql
```

### Back up MongoDB

```bash
install.sh --backup mongo
```

## Data Restore

> **Warning:** Restoring data will overwrite the current data. Always create a backup before performing a restore.

### Restore Web Files

```bash
install.sh --restore web web.tar.gz
```

### Restore MySQL Data

```bash
install.sh --restore mysql data.sql
```

### Restore MongoDB Data

```bash
install.sh --restore mongo data.db
```

## License Authorization

To request and install an authorization license:

1. Run the following command to display the license request information:

   ```bash
   install.sh --license show
   ```

2. Copy the displayed content into an email and send it to `yanmingsohu@gmail.com`.

3. You will receive a reply containing a `license.txt` attachment.

4. Copy `license.txt` to the same directory as `install.sh`.

5. Install the license by running:

   ```bash
   install.sh --license install
   ```

For more information, see [About Authorization](./authorization.md).
