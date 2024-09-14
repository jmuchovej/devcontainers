#!/bin/bash
# This is a generic test since the primary difference in tests is across versions.
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -s https://api.github.com/repos/prefix-dev/pixi/releases | jq -r ".[0].tag_name")"
fi

VERSION_CHECK="${VERSION//v}"

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check \
    "validate pixi \`${VERSION_CHECK}\` is installed" \
    bash -c "pixi --version | grep \"${VERSION_CHECK}\""

check \
    "test that we can \`init\` a pixi project" \
    bash -c "pixi init -p linux-aarch64 -p linux-64 -c conda-forge"

check \
    "can add libraries?" \
    bash -c "pixi add scipy numpy pandas; pixi clean"

check \
    "install pixi environments" \
    bash -c "pixi install -a"

check \
    "run pixi tasks" \
    bash -c "pixi run python --version"

check \
    "did libraries install?"
    bash -c "pixi run python -c 'import pandas'"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults