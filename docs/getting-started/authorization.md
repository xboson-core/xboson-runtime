# Authorization-License

With the default authorization, you can:

Log in to the xBoson management interface
Explore the development environment
Review the available APIs and features
Evaluate the basic application development workflow


## Default Authorization

After installation, xBoson can be started and accessed immediately.

However, some features are locked by default until a valid license is installed.

This is intentional. It allows you to install and explore the system before requesting an evaluation or commercial license.


## Evaluation

You can request a **one-month free evaluation license** to evaluate xBoson in your environment.

See [Authorization](#authorization) for the license request procedure.

The evaluation is intended to give you enough time to deploy xBoson, integrate it with your existing environment, and evaluate its development workflow.

## Commercial Use

For commercial use, please contact us by email.

Please include:

* Company name
* Company information
* Intended use
* Number of installations or expected usage
* Preferred payment method

Contact:

`yanmingsohu@gmail.com`

We will provide the appropriate commercial licensing information and payment instructions.

## Authorization

xBoson requires a license for authorized use.

[Perform licensing using a script.](./adv_install.md)


## License Request Email Format

If the default license does not include the features you need, please send a license request email with the following information.

### Required Features

Mark the features you need with `[v]`:

```text
[v] Scheduled Tasks
[ ] Shell Script Execution
```

### License Period

Specify the required license period:

```text
start: 2000-01-01
end:   2999-01-01
```

### License Request File

Please include the complete contents of your `license.req` file in the email.

Example:

```text
appName: Evaluate.xBoson-runtime
...
```

**Do not modify the contents of `license.req`.** The license will be generated based on the information contained in this file.

### Example Email

```text
Subject: xBoson Runtime License Request

Required Features:

  [v] Scheduled Tasks
  [ ] Shell Script Execution
  [ ] MongoDB Driver
  [ ] Blockchain Driver / Blockchain Storage / Blockchain Management
  [ ] Cluster Management
  [ ] API Process Management
  [ ] WebService
  [ ] OPC Server Management
  [ ] IoT Infrastructure
  [ ] Graph Database Engine

License Period:

  start: 2000-01-01
  end:   2999-01-01

License Request:

appName: Evaluate.xBoson-runtime
company: your company name or your personal nickname
dns: fedora
email: example@example.com
...
```



## Next Steps

After installation, you can start exploring xBoson through the online development environment.

For more information, see:

* [**What is xBoson?**](./what-is.md) — Architecture and practical advantages
* [**API IDE**](../user-guides/api-ide.md) — Developing backend APIs
* [**UI IDE**](../user-guides/ui-ide.md) — Developing frontend applications

* **Java Integration** — Reusing existing Java components
* [**Docker Images**] — Individual xBoson container configuration
