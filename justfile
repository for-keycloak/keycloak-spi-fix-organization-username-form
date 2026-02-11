set quiet

# Default recipe to display help information
[private]
default:
  just --list --unsorted

# Build the docker image
[private]
[no-exit-message]
build-docker:
    docker build --file="infra/Dockerfile" --tag="keycloak-spi-plugin" .

# Build the project with default Keycloak version
[no-exit-message]
build: build-docker
    docker run --rm --volume="${PWD}:/opt/maven" keycloak-spi-plugin mvn -B clean package

# Build for a specific Keycloak version
build-version VERSION: build-docker
    docker run --rm --volume="${PWD}:/opt/maven" keycloak-spi-plugin mvn -B clean package -P keycloak-{{VERSION}}

# Start Keycloak with the authenticator
up:
    docker compose up

# Stop Keycloak and clean up
down:
    docker compose down

# Watch the Keycloak logs
logs:
    docker compose logs -f keycloak

# Start a shell in the Keycloak container
shell:
    docker compose exec keycloak bash

# Install pre-commit hooks
setup:
    pre-commit install
    pre-commit install --hook-type commit-msg

# List all available Keycloak versions
versions:
    @echo "Supported Keycloak versions:"
    @echo "- 26.5.3 (default)"
    @echo "- 26.4.7"
    @echo "- 26.3.5"
    @echo "- 26.2.5"

# Run E2E tests
[no-exit-message]
e2e: build
    docker compose -f e2e/compose.yaml run --rm playwright
    docker compose -f e2e/compose.yaml down -v

# Run E2E tests for a specific Keycloak version
[no-exit-message]
e2e-version VERSION: (build-version VERSION)
    KC_VERSION={{VERSION}} docker compose -f e2e/compose.yaml run --rm playwright
    KC_VERSION={{VERSION}} docker compose -f e2e/compose.yaml down -v

# Stop E2E environment and clean up
e2e-down:
    docker compose -f e2e/compose.yaml down -v

# Watch E2E environment logs
e2e-logs:
    docker compose -f e2e/compose.yaml logs -f
