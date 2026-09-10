# xBoson

Java-based runtime for online JavaScript API and UI development.

[Architecture diagram](./docs/getting-started/architecture.md)


## Features

- Java + JavaScript
- Online API development
- Online UI development
- Java component integration
- Multiple databases
- Docker deployment

## Quick Start

Quickly install a working system.

`curl -fsSL https://raw.githubusercontent.com/xboson-core/xboson-runtime/refs/heads/main/install.sh | bash`

## Documentation

- [What is xBoson?](./docs/getting-started/what-is.md)
- [Installation](./docs/getting-started/installation.md)
- [Architecture](./docs/getting-started/architecture.md)
- API-IDE

## Docker Images

xBoson provides a set of Docker images for different parts of the runtime environment.

| Image            | Description                            |
| ---------------- | -------------------------------------- |
| `xboson-runtime` | Core xBoson runtime                    |
| `xboson-ui-ext`  | Vue / React frontend rendering service |
| `xboson-mysql`   | MySQL database                         |
| `xboson-mongo`   | MongoDB database                       |
| `xboson-redis`   | Redis service                          |
| `xboson-artemis` | Optional MQTT / Artemis service        |

All official images are available on Docker Hub:

[xBoson on Docker Hub](https://hub.docker.com/u/xbosoncore)

For detailed configuration and usage of each image, see the corresponding Docker Hub page.

## Community

xBoson is an platform for building applications with Java and JavaScript.

We welcome developers, users, and contributors to share ideas, report problems, and improve the project.

* **Issues & Bug Reports** — Report bugs and technical problems through GitHub Issues.
* **Discussions** — Share ideas, questions, and use cases.
* **Contributions** — Pull requests and improvements are welcome.

[GitHub Repository](https://github.com/xboson-core/xboson-runtime)

If you are using xBoson, we would love to hear what you are building with it.
