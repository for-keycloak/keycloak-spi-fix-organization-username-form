# 🔗 Keycloak Organization Username Form fix ![GitHub release (latest by date)](https://img.shields.io/github/v/release/for-keycloak/keycloak-spi-fix-organization-username-form)


> [!CAUTION]
> This SPI is not meant for public use.
>
> It solves a very specific issue mentionned below.
>
> Use at your own risk.


This fixes the issue when using a separate `username` and `password` form while organizations are enabled in keycloak.

See [keycloak/keycloak#42192](https://github.com/keycloak/keycloak/issues/42192) for more details.

## Installation

### Option 1: Using Docker

Add the following to your Dockerfile:

```dockerfile
# Download and install the authenticator
ARG ORG_USERNAME_FIX_VERSION="v1.1.2" # x-release-please-version
ARG ORG_USERNAME_FIX_KC_VERSION="26.5.2"
ADD https://github.com/for-keycloak/keycloak-spi-fix-organization-username-form/releases/download/${ORG_USERNAME_FIX_VERSION}/fix-organization-username-form-${ORG_USERNAME_FIX_VERSION}-kc-${ORG_USERNAME_FIX_KC_VERSION}.jar \
    /opt/keycloak/providers/fix-organization-username-form.jar
```

### Option 2: Manual Installation

1. Download the JAR file from the [releases page](https://github.com/for-keycloak/keycloak-spi-fix-organization-username-form/releases)
2. Copy it to the `providers` directory of your Keycloak installation


## Local Development

### Prerequisites

- [Just](https://github.com/casey/just)
- Docker & Docker Compose (optional, for testing)

### Building

Using just:
```bash
# Build for the default Keycloak version
just build

# Build for a specific Keycloak version
just build-version 26.4.7
```


### Testing with Docker Compose

A docker-compose configuration is provided for testing, which includes:

- Keycloak server with the spi installed (accessible at http://localhost:8080)

Start the environment:
```bash
just build # Builds the spi
just up    # Starts Keycloak with the spi
```

```bash
# You can use admin/admin as the default credentials
```

```bash
just down  # Stops the environment
```

Access:
- Keycloak: http://localhost:8080 (admin/admin)


## Supported Keycloak Versions

The authenticator is built and tested with multiple Keycloak versions:

| Keycloak Version |
|------------------|
| 26.5.2           |
| 26.4.7           |
| 26.3.5           |
| 26.2.5           |

Each release includes pre-built JARs for all supported versions. Download the JAR matching your Keycloak version from the [releases page](https://github.com/for-keycloak/keycloak-spi-fix-organization-username-form/releases).


### Running E2E Tests

The project includes Playwright-based E2E tests that verify the SPI fixes the organization username form bug.

```bash
# Run E2E tests with default Keycloak version
just e2e

# Run E2E tests for a specific Keycloak version
just e2e-version 26.4.7
```


## Development Notes

The project uses:

- Maven for building
- [just](https://github.com/casey/just) for common development tasks
- Docker & Docker Compose for testing
- Release Please for versioning and release management
- GitHub Actions for CI/CD

See the `justfile` for available commands and development shortcuts.
