# swift-environment-dependencies

![Development Status](https://img.shields.io/badge/status-active--development-orange.svg)

Foundation-free environment dependency state with an opt-in Foundation integration.
The package also retains the legacy `Environment Dependencies` product as a temporary,
deprecated compatibility facade.

> New consumers must select `Environment Dependencies Core` or
> `Environment Dependencies Foundation Integration` directly. The legacy product
> accepts no new consumers and contains no behavior.

## Overview

The package vends three products:

| Product | Import | Boundary |
|---------|--------|----------|
| `Environment Dependencies Core` | `Environment_Dependencies_Core` | `EnvVars`, scalar/dictionary behavior, process-only `live()`, and `\.envVars`; no Foundation API |
| `Environment Dependencies Foundation Integration` | `Environment_Dependencies_Foundation_Integration` | Core plus URL, file/dotenv overlay, `allowedInsecureHosts`, and `\.projectRoot` |
| `Environment Dependencies` | `Environment_Dependencies` | Deprecated compatibility facade re-exporting both products; zero behavior |

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-compositions/swift-environment-dependencies.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(
            name: "Environment Dependencies Core",
            package: "swift-environment-dependencies"
        )
    ]
)
```

## Quick Start

```swift
import Environment_Dependencies_Core

@Dependency(\.envVars) var envVars
let port = try envVars.port()
```

Consumers that need URL or dotenv behavior select the leaf instead:

```swift
import Environment_Dependencies_Foundation_Integration

let envVars = try EnvVars.live(localEnvFile: fixtureURL)
let url = try envVars.baseUrl()
```

## Migration Status

`Environment Dependencies` remains source-compatible for existing imports during this
release, but it is migration-only. See the `Migration` article in the `Environment Dependencies` documentation catalogue for the committed
consumer census, migration guidance, and exact facade retirement gate.

## License

Licensed under the [Apache License, Version 2.0](LICENSE.md).
