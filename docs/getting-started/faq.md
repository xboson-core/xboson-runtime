# Troubleshooting

## Installation Script Fails

Check that Docker is installed and running:

```bash
docker version
```

Then check the containers:

```bash
docker ps
```

If the xBoson runtime is not running, check its logs:

```bash
docker logs xboson-rt
```

## Cannot Open the Web Interface

Make sure port `8080` is accessible from your browser and that the runtime container is running:

```bash
docker ps
```

You can also check the runtime logs:

```bash
docker logs xboson-rt
```

## License Request File Does Not Exist

Make sure the xBoson runtime has started successfully before running:

```bash
docker cp xboson-rt:/root/xBoson-config/license.req ./
```

If the file is still unavailable, check:

```bash
docker logs xboson-rt
```