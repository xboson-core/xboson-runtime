# xBoson Architecture

xBoson is a Java-based application runtime designed for online development and execution of JavaScript APIs and modern web applications.

The system combines a Java runtime, JavaScript execution environment, frontend rendering services, and optional infrastructure services into a unified runtime environment.

## Overview

At a high level, an xBoson application follows this architecture:

```text
                         Browser
                            │
                ┌───────────┴───────────┐
                │                       │
             API Request            UI Request
                │                       │
                └───────────┬───────────┘
                            │
                            ▼
                    xBoson Runtime
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        JavaScript       Java APIs      Services
          Engine         / Modules
             │              │
             ├──────────────┼───────────────┼─────────┐
             │              │               │         │
             ▼              ▼               ▼         │
          MySQL           MongoDB          Redis      │
                                                      │
                                                      │
                            ┌─────────────────────────┘
                            ▼
                       UI Render
                            │
                     Vue / React
                            │
                            ▼
                         Browser
```

The actual deployment can contain only the components required by an application.

---

# Core Components

An xBoson deployment consists of a core runtime and optional supporting services.

## xBoson Runtime

The **xBoson Runtime** is the core component of the platform.

It is responsible for:

* HTTP request processing
* JavaScript API execution
* JavaScript module management
* Java integration
* Database access
* Session management
* Communication with frontend rendering services
* Application-level services

The runtime is implemented primarily in Java.

```text
Browser
   │
   ▼
HTTP
   │
   ▼
xBoson Runtime
   │
   ▼
JavaScript Engine
   │
   ▼
Application Code
```

The runtime provides the execution environment while application logic can be implemented in JavaScript.

---

# JavaScript Execution

One of the key ideas behind xBoson is to use Java as the host runtime while allowing application logic to be written in JavaScript.

A simplified API request looks like:

```text
HTTP Request
     │
     ▼
Permission Check
     │
     ▼
Parameter Processing
     │
     ▼
JavaScript API
     │
     ▼
JavaScript Engine
     │
     ├── Java Modules
     ├── Database APIs
     ├── Runtime APIs
     └── External Services
     │
     ▼
JSON Response
```

This allows developers to write application APIs using JavaScript while retaining access to Java-based infrastructure and existing Java components.

---

# Java and JavaScript Integration

xBoson is not a JavaScript-only runtime.

Java remains the underlying platform and can provide capabilities that are difficult or inefficient to implement directly in JavaScript.

Java components can be exposed to JavaScript modules when required.

```text
JavaScript
    │
    │ require / module API
    ▼
xBoson Runtime
    │
    ▼
Java Component
    │
    ├── Business Logic
    ├── Existing Java Library
    ├── Algorithm
    └── External Integration
```

This makes it possible to reuse existing Java components while developing new application logic in JavaScript.

For example, an existing Java business algorithm can be exposed as a JavaScript module:

```javascript
const algorithm = require("java/algorithm");

module.exports = function(input) {
    return algorithm.process(input);
};
```

The exact module interface depends on the component being exposed.

---

# API Architecture

xBoson APIs are designed around a lightweight request/response model.

A typical request follows this flow:

```text
Client
  │
  ▼
HTTP Server
  │
  ▼
Authentication / Permission
  │
  ▼
Parameter Processing
  │
  ▼
API Module
  │
  ▼
JavaScript Execution
  │
  ├──── Database
  ├──── Java Module
  ├──── Redis
  ├──── MongoDB
  └──── External Service
  │
  ▼
JSON
  │
  ▼
Client
```

This architecture keeps the API execution model simple and makes APIs suitable for both traditional applications and programmatic clients.

---

# UI Rendering Architecture

xBoson separates frontend rendering from the core runtime.

The `UI Render` service is responsible for processing frontend resources such as Vue and React applications.

A simplified request flow is:

```text
Browser
   │
   │ Request frontend resource
   ▼
xBoson Runtime
   │
   ▼
UI Render
   │
   ├── Vue
   ├── React
   ├── TypeScript
   ├── JSX / TSX
   ├── Less
   └── Sass
   │
   ▼
Compiled JavaScript / CSS
   │
   ▼
Browser
```

This allows the core runtime to remain independent of the frontend compilation toolchain.

---

# UI Render Service

The UI Render service is provided by:

```text
xbosoncore/xboson-ui-ext
```

It provides frontend compilation and rendering capabilities for xBoson UI applications.

The renderer can process frontend source files and return browser-compatible resources.

Because the rendering protocol is designed to be stateless, multiple renderer instances can be deployed.

```text
                     xBoson Runtime
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
         UI Render 1   UI Render 2   UI Render 3
              │             │             │
              └─────────────┼─────────────┘
                            │
                         Browser
```

This allows UI rendering capacity to scale independently from the core runtime.

---

# Container Architecture

xBoson services are designed to run as separate Docker containers.

A typical deployment looks like:

```text
                         xboson-net
┌────────────────────────────────────────────────────┐
│                                                    │
│   ┌─────────────────┐                              │
│   │ xboson-runtime  │                              │
│   └────────┬────────┘                              │
│            │                                       │
│     ┌──────┼───────────┬─────────────┐             │
│     │      │           │             │             │
│     ▼      ▼           ▼             ▼             │
│   MySQL  Redis      MongoDB       UI Render        │
│                                                    │
└────────────────────────────────────────────────────┘
```

The services communicate using Docker's internal network.

For example:

```text
mysql-x:3306
redis-x:6379
mongo-x:27017
ui-render-x:7788
```

The container names act as network-level service names.

---

# Database Services

xBoson can use multiple types of data services.

## MySQL

MySQL can be used for relational data and traditional application databases.

```text
xBoson Runtime
      │
      ▼
   MySQL
```

## MongoDB

MongoDB provides document-oriented storage and is used by some xBoson services and applications.

```text
xBoson Runtime
      │
      ▼
   MongoDB
```

## Redis

Redis provides fast in-memory data storage and can be used for caching and runtime-related data.

```text
xBoson Runtime
      │
      ▼
    Redis
```

These services can be deployed independently and communicate with the runtime through the Docker network.

---

# MQTT and IoT

MQTT support is provided through an optional Apache ActiveMQ Artemis based service.

```text
IoT Device
    │
    │ MQTT
    ▼
xBoson MQTT / Artemis
    │
    ▼
xBoson Runtime
    │
    ▼
Application
```

The MQTT service includes xBoson-specific integration plugins and communication rules.

It uses MongoDB for its associated data storage.

MQTT is optional and is only required when an application needs MQTT or related IoT functionality.

---

# Stateless Services

Where possible, xBoson services use a stateless request/response architecture.

This is particularly important for the UI rendering service.

A stateless renderer does not need to maintain application session state between rendering requests.

This provides several advantages:

* Multiple renderer instances can run simultaneously.
* Requests can be distributed between instances.
* Renderer instances can be added or removed independently.
* Container failures have less impact on other renderer instances.

A simplified architecture is:

```text
                  Request
                    │
                    ▼
              Load Balancer
              /      |      \
             ▼       ▼       ▼
         Render 1 Render 2 Render 3
             │       │       │
             └───────┼───────┘
                     │
                   Result
```

---

# Service Communication

The default xBoson Docker deployment uses a shared network:

```text
xboson-net
```

Services can communicate using container names instead of fixed IP addresses.

For example:

```text
xboson-runtime
      │
      ├── mysql-x
      ├── redis-x
      ├── mongo-x
      └── ui-render-x
```

This also makes the deployment easier to move between hosts or recreate.

---

# URL Prefix

The runtime can optionally be deployed behind a URL prefix.

For example:

```text
URL_PREFIX=/xboson
```

The runtime can then be accessed through:

```text
http://localhost:8080/xboson/...
```

This makes it possible to deploy xBoson behind an existing web server or reverse proxy without requiring xBoson to occupy the root URL path.

---

# Security Model

Application code executes inside the xBoson runtime environment rather than directly as unrestricted operating-system processes.

The runtime provides the execution boundary between application code and the underlying host environment.

A simplified model is:

```text
Application Code
       │
       ▼
JavaScript Runtime
       │
       ▼
xBoson Runtime APIs
       │
       ▼
Java Runtime
       │
       ▼
Operating System
```

Access to system-level functionality can therefore be controlled by the runtime rather than being directly exposed to application code.

The exact security boundary depends on the deployment configuration and enabled runtime capabilities.

---

# Authorization

xBoson Runtime uses an authorization mechanism associated with the deployment environment.

The current Docker deployment requires access to `/dev/mem` during the authorization process:

```bash
--device=/dev/mem
--privileged
```

This requirement is temporary and is planned to be removed in a future version.

---

# Deployment Model

A minimal xBoson deployment can contain only the core runtime.

Additional services can be added when required:

```text
Minimal
┌─────────────────┐
│ xBoson Runtime  │
└─────────────────┘
```

A typical application deployment:

```text
┌─────────────────┐
│ xBoson Runtime  │
└───────┬─────────┘
        │
   ┌────┼────┬────────┐
   ▼    ▼    ▼        ▼
 MySQL Redis MongoDB UI Render
```

An IoT-enabled deployment can additionally include MQTT:

```text
                    xBoson Runtime
                     │    │    │
             ┌───────┘    │    └────────┐
             ▼            ▼             ▼
           MySQL        Redis       MongoDB
                                         ▲
                                         │
                                   MQTT / Artemis
```

The final architecture depends on the features required by the application.

---

# Design Principles

xBoson is built around several design principles.

## Java as the Host Platform

Java provides the underlying runtime, infrastructure, libraries, and integration capabilities.

## JavaScript for Application Development

JavaScript provides a familiar and flexible programming environment for application developers.

## Separate Frontend Rendering

Frontend compilation and rendering are separated from the core runtime.

## Independent Services

Database, messaging, and rendering services can be deployed independently.

## Stateless Communication

Stateless service communication makes horizontal scaling and container-based deployment easier.

## Reuse Existing Java Components

Existing Java libraries, algorithms, and business components can be integrated into JavaScript applications.

---

# Summary

The xBoson architecture combines a Java runtime with a JavaScript application environment and independent supporting services.

```text
                         xBoson
                            │
             ┌──────────────┴──────────────┐
             │                             │
      Application Runtime             UI Rendering
             │                             │
       Java + JavaScript             Vue / React / TS
             │
      ┌──────┼──────────────┐
      │      │              │
    MySQL  MongoDB        Redis
                             
             Optional
                │
                ▼
          MQTT / Artemis / Hadoop / neo4j
```

The result is a modular runtime where application logic can be developed in JavaScript while existing Java capabilities and infrastructure remain available underneath.

For installation and usage instructions, see the [Getting Started](./installation.md) documentation.
