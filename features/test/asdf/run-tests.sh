#!/bin/bash
# This is a generic test since the primary difference in tests is across versions.
VERSION="$1"

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check \
    "validate asdf is installed" \
    bash -c ". ${ASDF_DIR}/asdf.sh && asdf version | grep \"${VERSION}\""

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults